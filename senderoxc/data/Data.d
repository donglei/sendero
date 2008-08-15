module senderoxc.data.Data;

import decorated_d.core.Decoration;

//import senderoxc.data.Schema;
import senderoxc.data.IObjectReflector;
import senderoxc.data.Validations;

/*
 * TODO:
 * 
 * IObject
 * IHttpSet, (IHttpGet)
 * IBindable
 * validate(), (reflection)
 * errors(), (other error message handling, reflection...)
 * save (update & create), destroy, static byId (read) (if has id & type == integral)
 * SessionObject
 */

class DataContext : IDecoratorContext
{
	this()
	{
		iobj = new IObjectContext;
		
	}
	
	IObjectContext iobj;
	
	private bool touched = false;
	
	void writeImports(IDeclarationWriter wr)
	{
		if(touched)
			wr.prepend("import sendero_base.Core, sendero.db.Bind, sendero.vm.bind.Bind, sendero.validation.Validations;\n");
	}
	
	IDecoratorResponder init(DeclarationInfo decl, IContextBinder binder, Var[] params = null)
	{
		touched = true;
		
		auto res = new DataResponder(decl);
		res.iobj = cast(IObjectResponder)iobj.init(decl, binder, params);
		debug assert(res.iobj);
		/+binder.bindDecorator(DeclType.Field, "required", new TempInstValidCtxt(res, "ExistenceValidation"));
		binder.bindDecorator(DeclType.Field, "minLength", new InstValidCtxt(res, "MinLengthValidation"));
		binder.bindDecorator(DeclType.Field, "maxLength", new InstValidCtxt(res, "MaxLengthValidation"));
		binder.bindDecorator(DeclType.Field, "regex", new InstValidCtxt(res, "FormatValidation")); // value = a string literal, class = an identifier
		binder.bindDecorator(DeclType.Field, "minValue", new TempInstValidCtxt(res, "MinValueValidation"));
		binder.bindDecorator(DeclType.Field, "maxValue", new TempInstValidCtxt(res, "MaxValueValidation"));+/
		//binder.bindDecorator(DeclType.Field, "xmlEntityFilter");
		//binder.bindDecorator(DeclType.Field, "htmlXSSFilter");
		//binder.bindDecorator(DeclType.Field, "fixedDateTimeParser");
		//binder.bindDecorator(DeclType.Field, "localDateTimeParser");
		//binder.bindDecorator(DeclType.Field, "beforeSave"); // can cancel save
		//binder.bindDecorator(DeclType.Field, "afterSave");
		//binder.bindDecorator(DeclType.Field, "beforeConvertInput"); // can cancel convert
		//binder.bindDecorator(DeclType.Field, "customConvertInput");
		//binder.bindDecorator(DeclType.Field, "afterConvertInput");
		//binder.bindDecorator(DeclType.Field, "customValidate");
		//binder.bindDecorator(DeclType.Field, "beforeRender");
		//binder.bindDecorator(DeclType.Field, "hideRender");
		//binder.bindDecorator(DeclType.Field, "humanize");
		
		foreach(type; DataResponder.Schema.fieldTypes)
		{
			binder.bindStandaloneDecorator(type, new FieldCtxt(res, type));
		}
		
		binder.bindStandaloneDecorator("hasOne", new HasOneCtxt(res));
		
		
		return res;
	}
}

class DataResponder : IDecoratorResponder, IDataResponder
{
	this(DeclarationInfo decl)
	{
		this.decl = decl;
		schema = new Schema;
		createFieldInfo;
	}
	
	Schema schema;
	
	void createFieldInfo()
	{
		foreach(cd; decl.declarations)
		{
			if(cd.type == DeclType.Field)
			{
				auto fdecl = cast(FieldDeclaration)cd;
				if(fdecl) fieldInfo[fdecl.name] = new FieldInfo(fdecl);
			}
		}
	}
	
	class FieldInfo
	{
		this(FieldDeclaration fdecl)
		{ this.fdecl = fdecl; }
		FieldDeclaration fdecl;
	}
	
	FieldInfo[char[]] fieldInfo;
	
	DeclarationInfo decl;
	IObjectResponder iobj;
	IValidationResponder[] validations;
	
	void addValidation(IValidationResponder v)
	{
		validations ~= v;
	}
	
	Getter[] getters;
	
	Setter[] setters;
	
	void finish(IDeclarationWriter wr)
	{
		//iobj.finish(wr); wr ~= "\n";
		schema.write(wr); wr ~= "\n";
		writeIObject(wr); wr ~= "\n";
		writeIHttpSet(wr); wr ~= "\n";
		writeValidations(wr);  wr ~= "\n";
		writeSessionObject(wr); wr ~= "\n";
		writeErrorSource(wr); wr ~= "\n";
		writeCRUD(wr); wr ~= "\n";
		/+wr.addBaseType("IBindable");
		
		wr ~= "static Binder createBinder(char[][] fieldNames = null)\n";
		wr ~= "{\n";
		foreach(cd; decl.declarations)
		{
			
		}
		wr ~= "}\n";+/
	}
	
	void writeIObject(IDeclarationWriter wr)
	{
		wr.addBaseType("IObject");
		
		wr ~= "Var opIndex(char[] key)\n";
		wr ~= "{\n";
		wr ~= "\tVar res;\n";
		wr ~= "\tswitch(key)\n";
		wr ~= "\t{\n";
		
		foreach(getter; getters)
		{
			wr ~= "\t\tcase \"" ~ getter.name ~ "\": ";
			wr ~= "bind(var, " ~ getter.name ~ "()); ";
			wr ~= "break;\n";
		}
		
		wr ~= "\t\tdefault: return Var();\n";
		wr ~= "\t}\n";
		wr ~= "\treturn res;\n";
		
		wr ~= "}\n";
		
		wr ~= "int opApply (int delegate (inout char[] key, inout Var val) dg) {}\n";
		
		wr ~= "void opIndexAssign(Var val, char[] key) {}\n";
		
		wr ~= "Var opCall(Var[] params, IExecContext ctxt) {}\n";
		
		wr ~= "void toString(IExecContext ctxt, void delegate(char[]) utf8Writer, char[] flags = null) {}\n";
		
		wr ~= "\n";
	}
	
	void writeIHttpSet(IDeclarationWriter wr)
	{
		wr.addBaseType("IHttpSet");
		
		wr ~= "void httpSet(IObject obj, Request req)\n";
		wr ~= "{\n";
		wr ~= "\tforeach(key, val; obj)\n";
		wr ~= "\t{\n";
		wr ~= "\t\tswitch(key)\n";
		wr ~= "\t\t{\n";
		foreach(cd; decl.declarations)
		{
			if(cd.type == DeclType.Field)
			{
				wr ~= "\t\t\tcase \"" ~ cd.name ~ "\": ";
				wr ~= "convertParam2!(typeof(" ~ cd.name ~ "), Req)(" ~ cd.name ~ ", val); ";
				wr ~= "break;\n";
			}
		}
		wr ~= "\t\t\tdefault: break;\n";
		wr ~= "\t\t}\n";
		wr ~= "\t}\n";
		wr ~= "}\n";
	}
	
	void writeValidations(IDeclarationWriter wr)
	{
		wr ~= "static this()\n";
		wr ~= "{\n";
		foreach(v; validations)
		{
			v.atStaticThis(wr);
		}
		wr ~= "}\n\n";
		
		foreach(v; validations)
		{
			v.atBody(wr);
		}
		wr ~= "\n";
		
		wr ~= "bool validate()\n";
		wr ~= "{\n";
		wr ~= "\tbool succeed = true;\n\n";
		wr ~= "\tvoid fail(char[] field, Error err)";
		wr ~= "\t{\n";
		wr ~= "\t\tsucceed = false;\n";
		wr ~= "\t\terrors_.add(field, err)\n";
		wr ~= "\t}\n\n";
		
		foreach(v; validations)
		{
			v.atOnValidate(wr);
		}
		
		wr ~= "\n\treturn succeed;";
		
		wr ~= "\n}\n\n";
	}
	
	void writeSessionObject(IDeclarationWriter wr)
	{
		wr ~= "mixin SessionAllocate!();\n";
	}
	
	void writeErrorSource(IDeclarationWriter wr)
	{
		wr ~= "ErrorMap errors()\n";
		wr ~= "{\n";
		wr ~= "\treturn errors_;\n";
		wr ~= "}\n";
		
		wr ~= "void clearErrors()\n";
		wr ~= "{\n";
		wr ~= "\terrors_.reset;\n";
		wr ~= "}\n";
		
		wr ~= "private ErrorMap errors_;";
	}
	
	void writeCRUD(IDeclarationWriter wr)
	{
		char[] quoteList(char[][] list, char[] prefix = null)
		{
			char[] res; bool first = true;
			foreach(item; list)
			{
				if(!first) res ~= ", ";
				res ~= `"`;
				if(prefix.length) res ~= prefix ~ "." ~ item;
				else res ~= item;
				res ~= `"`;
				first = false;
			}
			return res;
		}
		
		char[] unquoteList(char[][] list, char[] prefix = null)
		{
			char[] res; bool first = true;
			foreach(item; list)
			{
				if(!first) res ~= ", ";
				if(prefix.length) res ~= prefix ~ "." ~ item;
				else res ~= item;
				first = false;
			}
			return res;
		}
		
		wr ~= "\n";
		
		wr ~= "public uint id() { return id_; }\n";
		wr ~= "private uint id_;\n";
		wr ~= "\n";
		
		wr ~= "static this()\n";
		wr ~= "{\n";
		wr ~= "\tauto sqlGen = db.getSqlGenerator;\n";
		
		
		/+char[] insertFields = "[";
 		foreach(cd; decl.declarations)
		{
			if(cd.name == "id")
				continue;
			
			insertFields ~= `"` ~ cd.name ~ `",`;
		}
 		insertFields ~= "\"id\"];";+/
		char[][] insertFields;
		foreach(cd; decl.declarations)
		{
			if(cd.type == DeclType.Field)
				insertFields ~= cd.name;
		}
		
		char[][] fetchFields = insertFields ~ ["id_"];
 		
 		//wr ~= "\tinsertBinder = createBinder(" ~ insertFields ~ ");\n";
		wr ~= "\tauto quote = sqlGen.getIdentifierQuoteCharacter; char[] idQuoted = quote ~ \"id\" ~ quote;\n";
		wr ~= "\tinsertSql = sqlGen.makeInsertSql(\"" ~ decl.name ~ "\",[" ~ quoteList(insertFields) ~ "]);\n";
		wr ~= "\tupdateSql = sqlGen.makeUpdateSql(\"WHERE \" ~ idQuoted ~ \" = ?\", \"" ~ decl.name ~ "\",[" ~ quoteList(insertFields) ~ "]);\n";
		wr ~= "\tselectByIDSq = \"SELECT \" ~ sqlGen.makeFieldList([" ~ quoteList(fetchFields) ~ "]) ~ \" FROM " ~ decl.name ~ " WHERE \" ~ idQuoted ~ \" = ?\");\n";
		wr ~= "\tdeleteSql = \"DELETE FROM " ~ decl.name ~ " WHERE \" ~ idQuoted ~ \" = ?\");\n";
		
		wr ~= "}\n";
		wr ~= "\n";
		
		// Write Save;
		//wr ~= "static Binder insertBinder, updateBinder, fetchBinder;\n";
		wr ~= "const static char[] insertSql, updateSql, selectByIDSql, deleteSql;\n";
		wr ~= "\n";
		
		wr ~= "public bool save()\n";
		wr ~= "{\n";
		wr ~= "\tif(id_) {\n";
		wr ~= "\t\tscope st = db.prepare(updateSql);\n";
		wr ~= "\t\tst.execute(" ~ unquoteList(insertFields) ~ ", id_);\n";
		wr ~= "\t}\n";
		wr ~= "\telse {\n";
		wr ~= "\t\tscope st = db.prepare(insertSql);\n";
		wr ~= "\t\tst.execute(" ~ unquoteList(insertFields) ~ ");\n";
		wr ~= "\t\tid_ = st.getLastInsertID;\n";
		wr ~= "\t}\n";
		wr ~= "\treturn true;";
		wr ~= "}\n";
		wr ~= "\n";
		
		wr ~= "public static " ~ decl.name ~ " getByID(uint id)\n";
		wr ~= "{\n";
		wr ~= "\tscope st = db.prepare(selectByIDSql);\n";
		wr ~= "\tst.execute(id_);\n";
		wr ~= "\tauto res = new " ~ decl.name ~ ";\n";
		wr ~= "\tif(st.fetch(";
		wr ~= unquoteList(fetchFields, "res");
		wr ~= ")) return res;\n";
		wr ~= "\telse return null;\n";
		wr ~= "}\n";
		wr ~= "\n";
		
		wr ~= "public bool destroy()\n";
		wr ~= "{\n";
		wr ~= "\tscope st = db.prepare(deleteSql);\n";
		wr ~= "\tst.execute(id_);\n";
		wr ~= "\treturn true;\n";
		wr ~= "}\n";
	}
	
	class Schema
	{
		Column[char[]] columns;
		
		const static char[][] fieldTypes = 
			[
			 "bool",
			 "ubyte",
			 "byte",
			 "ushort",
			 "short",
			 "uint",
			 "int",
			 "ulong",
			 "long",
			 "float",
			 "double",
			 //"real",
			 //"text",
			 "string",
			 "blob",
			 "DateTime",
			 "Time",
			 //"Date",
			 //"TimeOfDay"
			 ];
		
		Column newColumn(char[] type, char[] name, StandaloneDecorator decorator)
		{
			return new Column(type, name, decorator);
		}
		
		class Column
		{
			this(char[] type, char[] name, StandaloneDecorator decorator)
			{
				this.type = type;
				this.name = name;
				this.decorator = decorator;
				char[] pname = name ~ "_";
				foreach(dec; decorator.decorators)
				{
					switch(dec.name)
					{
					case "required": addValidation(new RequiredRes(type, pname)); break;
					case "minLength": addValidation(new InstanceValidationRes("MinLengthValidation", pname, toParamString(dec.params))); break;
					case "maxLength": addValidation(new InstanceValidationRes("MaxLengthValidation", pname, toParamString(dec.params))); break;
					case "regex": addValidation(new InstanceValidationRes("FormatValidation", pname, toParamString(dec.params))); break;// value = a string literal, class = an identifier
					case "minValue": addValidation(new InstanceValidationRes("MinValueValidation", pname, toParamString(dec.params), type)); break;
					case "maxValue": addValidation(new InstanceValidationRes("MaxValueValidation", pname, toParamString(dec.params), type)); break;
					default:
						break;
					// validations
					// filters
					// convertors
					}
				}
			}
			
			char[] type, name;
			StandaloneDecorator decorator;
			
			//ColumnInfo info;
		}
		
		void write(IDeclarationWriter wr)
		{
			foreach(name, col; columns)
			{
				wr ~= "public " ~ col.type ~ " " ~  name ~ "() { return " ~  name ~ "_;}\n";
				wr ~= "public void " ~  name ~ "(" ~ col.type ~ " val) {" ~ name ~ "_ = val;}\n";
				wr ~= "private " ~ col.type ~ " " ~  name ~ "_;\n\n";
			}
		}
	}
}



class FieldCtxt : IStandaloneDecoratorContext
{
	this(DataResponder resp, char[] type)
	{
		this.resp = resp;
		this.type = type;
	}
	DataResponder resp;
	char[] type;
	
	IDecoratorResponder init(StandaloneDecorator decorator, DeclarationInfo parentDecl)
	{
		if(resp.decl == parentDecl) {
			if(decorator.params.length && decorator.params[0].type == VarT.String) {
				auto name = decorator.params[0].string_;
				resp.schema.columns[name] = resp.schema.newColumn(type, name, decorator);
				resp.getters ~= Getter(name);
				resp.setters ~= Setter(name, type);
			}
		}
		
		return null;
	}
}

struct Getter
{
	char[] name;
}

struct Setter
{
	char[] type;
	char[] name;
}

class HasOneCtxt : IStandaloneDecoratorContext
{	
	this(DataResponder resp)
	{
		this.resp = resp;
	}
	DataResponder resp;
	
	IDecoratorResponder init(StandaloneDecorator decorator, DeclarationInfo parentDecl)
	{
		if(resp.decl == parentDecl) {
			if(decorator.params.length > 1 &&
					decorator.params[0].type == VarT.String &&
					decorator.params[1].type == VarT.String) {
				auto type = decorator.params[0].string_;
				auto name = decorator.params[1].string_;
				resp.getters ~= Getter(name);
				resp.setters ~= Setter(name, type);
				return new HasOneResponder(type, name);
			}
		}
		
		return null;
	}
}

class HasOneResponder : IDecoratorResponder
{
	this(char[] type, char[] name)
	{
		this.type = type;
		this.name = name;
	}
	char[] type, name;
	
	void finish(IDeclarationWriter wr)
	{
		wr ~= "public " ~ type ~ " " ~ name ~ "() {return " ~ name ~ "_;}\n";
		wr ~= "public void " ~  name ~ "(" ~ type ~ " val) {" ~ name ~ "_ = val;}\n";
		wr ~= "private HasOne!(" ~ type ~ ") " ~ name ~ "_.get;\n\n";
	}
}