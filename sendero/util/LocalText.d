module sendero.util.LocalText;

import sendero.util.ExecutionContext;

import mango.icu.UMessageFormat;
import mango.icu.UCalendar;
import mango.icu.UString;
import mango.icu.UNumberFormat;
import sendero.util.StringCharIterator;
import Integer = tango.text.convert.Integer;

import tango.core.Traits;

const ubyte FORMAT_TIME = 0;
const ubyte FORMAT_DATE= 1;
const ubyte FORMAT_NUMBER = 2;
const ubyte FORMAT_CHOICE = 3;
const ubyte FORMAT_SPELLOUT = 4;
const ubyte FORMAT_ORDINAL = 5;
const ubyte FORMAT_DURATION = 6;
const ubyte FORMAT_STRING = 7;
//const ubyte FORMAT_UNKNOWN = 8;

const ubyte DATE_STYLE_SHORT = 0;
const ubyte DATE_STYLE_MEDIUM = 1;
const ubyte DATE_STYLE_LONG = 2;
const ubyte DATE_STYLE_FULL = 3;
const ubyte DATE_STYLE_CUSTOM = 4;

const ubyte NUMBER_STYLE_CURRENCY = 0;
const ubyte NUMBER_STYLE_PERCENT = 1;
const ubyte NUMBER_STYLE_INTEGER = 2;
const ubyte NUMBER_STYLE_SCIENTIFIC = 3;
const ubyte NUMBER_STYLE_CUSTOM = 4;



package class Param
{
	ushort offset;
	ushort index;
	VarPath varPath;
	ubyte elementFormat;
	ubyte secondaryFormat;
	char[] formatString;
}

interface IMessage
{
	bool plural();
	char[] exec(ExecutionContext ctxt);
}

package class Message : IMessage
{
	char[] msg;
	Param[] params;
	bool plural() {return false;}
	
	char[] exec(ExecutionContext ctxt)
	{
		uint idx = 0;
		char[] o;
		foreach(p; params)
		{
			o ~= msg[idx .. p.offset];
			idx = p.offset;
			
			auto var = ctxt.getVar(p.varPath);
			auto lcl = ctxt.locale;
			
			switch(var.type)
			{
			case(VarT.Bool):
				auto x = var.data.get!(bool);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.Byte):
				auto x = var.data.get!(byte);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.Short):
				auto x = var.data.get!(short);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.Int):
				auto x = var.data.get!(int);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.Long):
				auto x = var.data.get!(long);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.UByte):
				auto x = var.data.get!(ubyte);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.UShort):
				auto x = var.data.get!(ushort);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.UInt):
				auto x = var.data.get!(uint);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.ULong):
				auto x = var.data.get!(ulong);
				o ~= renderLong(x, p, lcl);
				break;
			case(VarT.Float):
				auto x = var.data.get!(float);
				o ~= renderDouble(x, p, lcl);
				break;
			case(VarT.Double):
				auto x = var.data.get!(float);
				o ~= renderDouble(x, p, lcl);
				break;
			case(VarT.String):
				auto x = var.data.get!(char[]);
				o ~= x;
				break;
			/*case(VarT.DateTime):
				var.data = *cast(bool*)ptr;
				break;
			case(VarT.Date):
				var.data = *cast(bool*)ptr;
				break;
			case(VarT.Time):
				var.data = *cast(bool*)ptr;
				break;*/
			default:
				break;
			}
			
			
		}
		if(idx < msg.length) o ~= msg[idx .. $];
		return o;
	}
	
	static char[] renderLong(long x, Param p, ULocale lcl = ULocale.US)
	{
		UNumberFormat fmt;
		
		switch(p.elementFormat)
		{
		case FORMAT_SPELLOUT:
			fmt = new USpelloutFormat(lcl);
			break;
		case FORMAT_ORDINAL:
		//	fmt = new UNumberFormat(UNumberFormat.Style.Ordinal, null, lcl);
			break;
		case FORMAT_DURATION:
			fmt = new UDurationFormat(lcl);
			break;
		case FORMAT_NUMBER:
			switch(p.secondaryFormat)
			{
			case NUMBER_STYLE_PERCENT:
				fmt = new UPercentFormat(lcl);
				break;
			case NUMBER_STYLE_SCIENTIFIC:
				fmt = new UScientificFormat(lcl);
				break;
			case NUMBER_STYLE_INTEGER:
				fmt = new UDecimalFormat(lcl);
				break;
			}
			break;
		default:
			fmt = new UDecimalFormat(lcl);
			break;
		}
		
		auto dst = new UString(100);
		fmt.format(dst, x);
		return dst.toUtf8;
	}
	
	static char[] renderDouble(double x, Param p, ULocale lcl = ULocale.US)
	{
		UNumberFormat fmt;
		
		if(p.secondaryFormat == NUMBER_STYLE_SCIENTIFIC) {
			fmt = new UScientificFormat(lcl);
		}
		else {
			fmt = new UDecimalFormat(lcl);
		}
		
		auto dst = new UString(100);
		fmt.format(dst, x);
		return dst.toUtf8;
	}
}

package class PluralMessage : IMessage
{
	Message[] pluralForms;
	char[] pluralVariable;
	bool plural() {return true;}
	
	char[] exec(ExecutionContext ctxt)
	{
		auto v = ctxt.getVar(pluralVariable);
		
		assert(false, "PluralMessage not implemented yet");
		
		return null;
	}
}


/*
 * {$varName}
 * {$varName, elementFormat}
 * 
 *  elementFormat := "time" { "," datetimeStyle }
                      | "date" { "," datetimeStyle }
                      | "number" { "," numberStyle }
                      | "choice" "," choiceStyle
                      | "spellout"
                      | "ordinal"
                      | "duration"

       datetimeStyle := "short"
                      | "medium"
                      | "long"
                      | "full"
                      | dateFormatPattern

       numberStyle :=   "currency"
                      | "percent"
                      | "integer"
                      | numberFormatPattern

       choiceStyle :=   choiceFormatPattern
 */

class MessageParserException : Exception
{
	this(char[] msg)
	{
		super(msg);
	}
} 

public Message parseMessage(char[] msg)
{
	auto itr = new StringCharIterator!(char)(msg);
	
	Param parseParam(uint offset)
	{
		Param unexpectedFormat() {
			throw new MessageParserException("Unexpected ElementFormat in message format string"); //TODO throw exception here?
			return null;
		}
		
		auto p = new Param;
		
		p.offset = offset;
		
		char[] var;
		if(itr[0] != '$') throw new MessageParserException("Expected $ before variable name"); //TODO throw exception here?
		++itr;
		while(itr.good && itr[0] != ',' && itr[0] != '}')
		{
			var ~= itr[0];
			++itr;
		}
		//ushort idx = Integer.toInt!(char, ushort)(num);
		//p.idx = idx;
		p.varPath = VarPath(var);
		
		if(!itr.good)
			return null;
		else if(itr[0] == '}') {
			++itr;
			p.elementFormat = FORMAT_STRING;
			return p;
		}
		
		++itr;
		
		if(itr[0] == ' ') ++itr;
				
		switch(itr[0])
		{
		case 't':
			if(itr[0 .. 4] == "time") {
				itr += 4;
				p.elementFormat = FORMAT_TIME;
			}
			else return unexpectedFormat();
			break;
		case 'd':
			if(itr[0 .. 4] == "data") {
				itr += 4;
				p.elementFormat = FORMAT_TIME;
			}
			else if(itr[0 .. 7] == "duration") {
				itr += 7;
				p.elementFormat = FORMAT_DURATION;
			}
			else return unexpectedFormat();
			break;
		case 'n':
			if(itr[0 .. 6] == "number") {
				itr += 6;
				p.elementFormat = FORMAT_NUMBER;
			}
			else return unexpectedFormat();
			break;
		case 'c':
			if(itr[0 .. 5] == "choice") {
				itr += 5;
				p.elementFormat = FORMAT_CHOICE;
			}
			else return unexpectedFormat();
			break;
		case 's':
			if(itr[0 .. 8] == "spellout") {
				itr += 8;
				p.elementFormat = FORMAT_SPELLOUT;
			}
			else return unexpectedFormat();
			break;
		case 'o':
			if(itr[0 .. 7] == "ordinal") {
				itr += 7;
				p.elementFormat = FORMAT_ORDINAL;
			}
			else return unexpectedFormat();
			break;
		default:
			return unexpectedFormat();
			break;
		}
		
		Param parseStyle() {
			while(itr.good) {
				if(itr[0] == '}') {
					++itr;
					return p;
				}
				p.formatString ~= itr[0];
				++itr;
			}
			return null;
		}
		
		Param parseEnd() {
			if(itr[0] == ' ') ++itr;
			if(itr[0] != '}')
				return null;
			else {
				++itr;
				return p;
			}
		}
		
		Param parseDateStyle() {	
			switch(itr[0]) {
			case 's':
				if(itr[0 .. 5] == "short") {
					itr += 5;
					p.elementFormat = DATE_STYLE_SHORT;
				}
				else return unexpectedFormat();
				break;
			case 'm':
				if(itr[0 .. 6] == "medium") {
					itr += 6;
					p.elementFormat = DATE_STYLE_MEDIUM;
				}
				else return unexpectedFormat();
				break;
			case 'l':
				if(itr[0 .. 4] == "long") {
					itr += 4;
					p.elementFormat = DATE_STYLE_LONG;
				}
				else return unexpectedFormat();
				break;
			case 'f':
				if(itr[0 .. 4] == "full") {
					itr += 4;
					p.elementFormat = DATE_STYLE_FULL;
				}
				else return unexpectedFormat();
				break;
			default:
				p.secondaryFormat = DATE_STYLE_CUSTOM;
				return parseStyle();
			}
			return parseEnd();
		}
		
		Param parseNumberStyle() {
			switch(itr[0]) {
			case 'c':
				if(itr[0 .. 8] == "currency") {
					itr += 8;
					p.elementFormat = NUMBER_STYLE_CURRENCY;
				}
				else return unexpectedFormat();
				break;
			case 'p':
				if(itr[0 .. 7] == "percent") {
					itr += 7;
					p.elementFormat = NUMBER_STYLE_PERCENT;
				}
				else return unexpectedFormat();
				break;
			case 'i':
				if(itr[0 .. 7] == "integer") {
					itr += 7;
					p.elementFormat = NUMBER_STYLE_INTEGER;
				}
				else return unexpectedFormat();
				break;
			default:
				p.secondaryFormat = NUMBER_STYLE_CUSTOM;
				return parseStyle();
			}
			return parseEnd();
		}
		
		switch(itr[0]) {			
		case ',':
			++itr;
			if(itr[0] == ' ') ++itr;
			switch(p.elementFormat) {
			case FORMAT_DATE:
				return parseDateStyle();
			case FORMAT_NUMBER:
				return parseNumberStyle();
			default:
				return parseStyle();
			}
			break;
		case '}':
			++itr;
			return p;
		default:
			return unexpectedFormat();
		}
	}
	
	char[] res;
	Param[] params;
	
	while(itr.good)
	{
		switch(itr[0])
		{
		case '{':
			if(itr[1] == '{') {
				itr += 2;
				res ~= '{';
			}
			else {
				++itr;
				auto p = parseParam(res.length);
				params ~= p;
			}
			break;
		default:
			res ~= itr[0];
			++itr;
			break;
		}		
	}
	
	auto m = new Message;
	m.msg = res;
	m.params = params;
	return m;
}

class LocalText
{
	
}

version(Unittest)
{
	import tango.io.Stdout;
}

unittest
{
	auto m = parseMessage("{{Hello {$word} world, the only {$num, spellout}}!");
	assert(m.msg == "{Hello  world, the only }!");
	assert(m.params.length == 2);
	assert(m.params[0].elementFormat == FORMAT_STRING);
	assert(m.params[0].varPath[0] == "word", m.params[0].varPath[0]);
	assert(m.params[1].elementFormat == FORMAT_SPELLOUT);
	assert(m.params[1].varPath[0] == "num", m.params[0].varPath[0]);
	
	auto ctxt = new ExecutionContext;
	int x = 1;
	ctxt.addVar("num", x);
	ctxt.addVar("word", "beautiful");
	Stdout(m.exec(ctxt)).newline;
}