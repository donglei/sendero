/** 
 * Copyright: Copyright (C) 2007 Aaron Craelius.  All rights reserved.
 * License:   BSD Style
 * Authors:   Aaron Craelius
 */

module sendero.data.backends.Sqlite;

import sendero.data.model.IDBConnection;
import sendero.util.Reflection;
import sendero.data.backends.imp.sqlite;
import sendero.data.DB;

import Regex = tango.text.Regex;
import tango.stdc.stringz;

import tango.util.log.Log;
import Integer = tango.text.convert.Integer;

/**
 * Sqlite connection class that exposes interface for creating SqlitePreparedStatement's.
 */
class SqliteDB : IDBConnection
{
	static Logger log;
	static this()
	{
		log = Log.getLogger("sendero.data.backends.Sqlite.SqliteDB");
	}
	
	static SqliteDB connect(char[] file)
	{
		auto db = new SqliteDB;
		if(sqlite3_open(toUtf8z(file), &db.db_) != SQLITE_OK) {
			return null;
		}
		return db;
	}
	
	IPreparedStatement createStatement(char[] statement, ColumnInfo[] paramCols, ColumnInfo[] resultCols)
	{
		sqlite3_stmt* stmt;
		char* pzTail;
		int res;
		if((res = sqlite3_prepare_v2(db_, toUtf8z(statement), statement.length, &stmt, &pzTail)) != SQLITE_OK) {
			char* errmsg = sqlite3_errmsg(db_);
			log.error("sqlite3_prepare_v2 for statement: \"" ~ statement ~ "\" returned: " ~ Integer.toUtf8(res) ~ ", errmsg: " ~ fromUtf8z(errmsg));
			//log.error("sqlite3_prepare_v2 errmsg:" ~ fromUtf8z(errormessage));
			return null;
		}
		return new SqlitePreparedStatement(stmt, db_);
	}
	
	static char[] createColumnDef(char[] name, ColumnInfo info)
	{		
		char[] q = "`" ~ name ~ "` ";
		
		switch(info.type)
		{
		case(ColT.Bool):
		case(ColT.Short):
		case(ColT.Int):
		case(ColT.Long):
		case(ColT.UShort):
		case(ColT.UInt):
		case(ColT.ULong):
			q ~= "INTEGER";
			break;
		case(ColT.Float):
		case(ColT.Double):
			q ~= "REAL";
			break;
		case(ColT.VarChar):
		case(ColT.Text):
		case(ColT.LongText):
		case(ColT.Date):
		case(ColT.TimeStamp):
			q ~= "TEXT";
			break;
		case(ColT.Blob):
		case(ColT.LongBlob):
			q ~= "BLOB";
			break;
		case(ColT.DateTime):
		case(ColT.HasOne):
			q ~= "INTEGER";
			break;
		case(ColT.HABTM):
		default:
			assert(false);
		}
		
		if(info.primaryKey) {
			q ~= " NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE";
		}
		
		return q;
	}
	
	bool configTable(char[] tablename, ColumnInfo[] cols, FieldInfo[] fields)
	{
		if(!tableExists(tablename)) {
			char[] create = createCreateSql(tablename, cols, fields);
			scope st = createStatement(create, null, null);
			if(!st)
				return false;
			auto res = st.execute;
			if(res < 0) {
				return false;
			}
			return true;
		}
		else {
			if(!updateTable(tablename, cols, fields)) {
				return false;
			}
			return true;
		}
	}	
	
	char[] createCreateSql(char[] tablename, ColumnInfo[] cols, FieldInfo[] fields)
	{
		char[] q = "CREATE TABLE `" ~ tablename ~ "` (";
		bool first = true;
		assert(cols.length == fields.length, tablename);
		for(uint i = 0; i < cols.length; ++i)
		{
			if(cols[i].skip)
				continue;
			
			if(!first)
				q ~= ", ";
			
			q ~= createColumnDef(fields[i].name, cols[i]);
			
			first = false;
		}
		
		q ~= ");";
		
		return q;
	}
	
	bool tableExists(char[] table)
	{
		char[] q = "SELECT name FROM sqlite_master WHERE type='table' AND name='" ~ table ~ "'";
		scope st = createStatement(q, null, null);
		if(!st)
			return false;
		auto res = st.execute;
		st.reset;
		return (res == SQLRESULT_ROW);
	}
	
	bool updateTable(char[] tablename, ColumnInfo[] cols, FieldInfo[] fields)
	{
		char[] q = "SELECT sql FROM sqlite_master WHERE type='table' AND name='" ~ tablename ~ "'";
		scope st = createStatement(q, null, null);
		if(!st)
			return false;
		auto res = st.execute;
		if(res != SQLRESULT_ROW)
			return false;
		char[] sql;
		if(!st.getString(sql, 0))
			return false;
		
		assert(cols.length == fields.length, tablename);
		for(uint i = 0; i < cols.length; ++i)
		{
			if(cols[i].skip)
				continue;
			
			auto rgx = Regex.Regex("(\\s|\\()`?" ~ fields[i].name ~ "`?\\s");
			if(rgx.find(sql) < 0) {
				char[] q1 = "ALTER TABLE `" ~ tablename ~ "` ADD " ~ createColumnDef(fields[i].name, cols[i]);
				scope st1 = createStatement(q1, null, null);
				if(!st1)
					return false;
				auto res1 = st1.execute;
				if(res1 < 0) {
					return false;
				}
			}
		}
		return true;
	}
	
	IPreparedStatement createInsertStatement(char[] tablename, ColumnInfo[] cols, FieldInfo[] fields)
	{
		auto q = DBHelper.createInsertSql(tablename, cols, fields);
		return createStatement(q, null, null);
	}
	
	IPreparedStatement createUpdateStatement(char[] tablename, ColumnInfo[] cols, FieldInfo[] fields)
	{
		auto q = DBHelper.createUpdateSql(tablename, cols, fields);
		return createStatement(q, null, null);
	}
	
	IPreparedStatement createFindWhereStatement(char[] tablename, char[] where, ColumnInfo[] cols, FieldInfo[] fields, ColumnInfo[] paramCols)
	{
		auto q = DBHelper.createFindWhereStatement(tablename, where, cols, fields);
		return createStatement(q, null, null);
	}
	
	~this()
	{
		if(db_) {
			sqlite3_close(db_);
		}
	}
	
	private sqlite3* db_;
}

class SqlitePreparedStatement : IPreparedStatement
{
	static Logger log;
	static this()
	{
		log = Log.getLogger("sendero.data.backends.Sqlite.SqlitePreparedStatement");
	}
	
	private this(sqlite3_stmt* stmt, sqlite3* db)
	{
		this.stmt = stmt;
		this.db = db;
	}
	
	~this()
	{
		sqlite3_finalize(stmt);
	}
	
	
	private sqlite3_stmt* stmt;
	private sqlite3* db;
	
	int fetch()
	{
		return SQLRESULT_SUCCESS;
	}
	
	int initRetrieve(uint numFields)
	{
		return SQLRESULT_SUCCESS;
	}
	
	int execute()
	{
		int ret = sqlite3_step(stmt);
		wasReset = false;
		switch(ret)
		{
			case SQLITE_BUSY:
				return SQLRESULT_FAIL;
			case SQLITE_ROW:
				return SQLRESULT_ROW;
			case SQLITE_DONE:
				reset;
				return SQLRESULT_SUCCESS;
			default:
				return SQLRESULT_FAIL;
		}
	}
	
	bool wasReset = false;
	
	void reset()
	{
		if(!wasReset) {
			sqlite3_reset(stmt);
			wasReset = true;
		}
	}
	
	ulong getLastInsertID()
	{
		long id = sqlite3_last_insert_rowid(db);
		if(id == 0)
			return 0;
		else return cast(ulong)id;
	}
	
	bool bindShort(short x, uint index)
	{
		if(sqlite3_bind_int(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindUShort(ushort x, uint index)
	{
		if(sqlite3_bind_int(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindInt(int x, uint index)
	{
		if(sqlite3_bind_int(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindUInt(uint x, uint index)
	{
		if(sqlite3_bind_int(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindLong(long x, uint index)
	{
		if(sqlite3_bind_int64(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindULong(ulong x, uint index)
	{
		if(sqlite3_bind_int64(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindBool(bool x, uint index)
	{
		if(sqlite3_bind_int(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindFloat(float x, uint index)
	{
		if(sqlite3_bind_double(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindDouble(double x, uint index)
	{
		if(sqlite3_bind_double(stmt, index + 1, x) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindString(char[] x, uint index)
	{
		if(sqlite3_bind_text(stmt, index + 1, toUtf8z(x), x.length, null) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindWString(wchar[] x, uint index)
	{
		if(sqlite3_bind_text16(stmt, index + 1, toUtf16z(x), x.length, null) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindBlob(void[] x, uint index)
	{
		if(sqlite3_bind_blob(stmt, index + 1, x.ptr, x.length, null) != SQLITE_OK)
			return false;
		return true;
	}
	
	bool bindDate(Date d, uint index)
	{
		assert(false);
	}
	
	bool bindTime(Time t, uint index)
	{
		assert(false);
	}
	
	bool bindDateTime(DateTime dt, uint index)
	{
		return bindLong(dt.ticks, index + 1);
	}
	
	bool getShort(inout short x, uint index)
	{
		int z = sqlite3_column_int(stmt, index);
		x = cast(short)z;
		return true;
	}
	
	bool getUShort(inout ushort x, uint index)
	{
		int z = sqlite3_column_int(stmt, index);
		x = cast(ushort)z;
		return true;
	}
	
	bool getInt(inout int x, uint index)
	{
		x = sqlite3_column_int(stmt, index);
		return true;
	}
	
	bool getUInt(inout uint x, uint index)
	{
		long z = sqlite3_column_int64(stmt, index);
		x = cast(uint)z;
		return true;
	}
	
	bool getLong(inout long x, uint index)
	{
		x = sqlite3_column_int64(stmt, index);
		return true;
	}
	
	bool getULong(inout ulong x, uint index)
	{
		long z = sqlite3_column_int64(stmt, index);
		x = cast(ulong)z;
		return true;
	}
	
	bool getBool(inout bool x, uint index)
	{
		int z = sqlite3_column_int(stmt, index);
		x = cast(bool)z;
		return true;
	}
	
	bool getFloat(inout float x, uint index)
	{
		double z = sqlite3_column_int(stmt, index);
		x = cast(float)z;
		return true;
	}
	
	bool getDouble(inout double x, uint index)
	{
		x = sqlite3_column_double(stmt, index);
		return true;
	}
	
	bool getString(inout char[] x, uint index)
	{
		x = fromUtf8z(sqlite3_column_text(stmt, index));
		
		return true;
	}
	
	bool getBlob(inout void[] x, uint index)
	{
		void* res = sqlite3_column_blob(stmt, index);
		int size = sqlite3_column_bytes(stmt, index);
		x = size ? res[0 .. size] : null;
		return true;
	}
	
	bool getDate(inout Date dt, uint index)
	{
		assert(false);
	}
	
	bool getTime(inout Time dt, uint index)
	{
		assert(false);
	}
	
	bool getDateTime(inout DateTime dt, uint index)
	{
		long ticks;
		auto res = getLong(ticks, index);
		dt.ticks = ticks;
		return res;
	}
}

version(Unittest)
{
	import sendero.data.test.Tests;
}

unittest
{	
	auto db = SqliteDB.connect("sendero_test.db");
	runTests(db);
}