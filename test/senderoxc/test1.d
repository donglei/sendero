module test.senderoxc.test1;
/*DO NOT EDIT THIS FILE!*/

import sendero.routing.Router, sendero.http.Response, sendero.http.Request, sendero.routing.IRoute, sendero.view.View;
import sendero_base.Core, sendero.db.Bind, sendero.vm.bind.Bind, sendero.validation.Validations;
import sendero.http.Request, sendero.routing.Convert;
import sendero.core.Memory;
import sendero.util.collection.StaticBitArray;



import test.senderoxc.test2;

/+@controller+/ class MainCtlr
{
	/+@GET+/
	static Res index()
	{
	
	}

	/+@POST+/
	static Res login(char[] username, char[] password)
	{

	}
	
	/+@GET+/
	static Res logout()
	{
	
	}
	
	/+@POST+/
	static Res signup(char[] firstname, char[] lastname, char[] email,
						char[] pswd, char[] pswdConfirm)
	{
		
	}
	
	/+@POST+/
	static Res resetPswd(char[] email)
	{
	
	}
	
	static IIController getInstance(Req req)
	{
		
	}

static const TypeSafeRouter!(Res,Req) r, ir;
static this()
{
	r = TypeSafeRouter!(Response,Request)();
	ir = TypeSafeRouter!(Response,Request)();
	r.map!(Res function())(GET,"", &MainCtlr.index, []);
	r.map!(Res function(char[],char[]))(POST,"login", &MainCtlr.login, ["username", "password"]);
	r.map!(Res function())(GET,"logout", &MainCtlr.logout, []);
	r.map!(Res function(char[],char[],char[],char[],char[]))(POST,"signup", &MainCtlr.signup, ["firstname", "lastname", "email", "pswd", "pswdConfirm"]);
	r.map!(Res function(char[]))(POST,"resetPswd", &MainCtlr.resetPswd, ["email"]);
}

static Res route(Req req)
{ return r.route(req); }
Res iroute(Req req)
{ return r.route(req); }

}

/+@controller+/ class UserCtlr
{
	/+@POST+/
	Res changePswd(char[] curPswd, char[] newPswd, char[] newPswdConfirm)
	{
	
	}

static const TypeSafeRouter!(Res,Req) r, ir;
static this()
{
	r = TypeSafeRouter!(Response,Request)();
	ir = TypeSafeRouter!(Response,Request)();
	ir.map!(Res function(char[],char[],char[]))(POST,"changePswd", &UserCtlr.changePswd, ["curPswd", "newPswd", "newPswdConfirm"]);
}

static Res route(Req req)
{ return r.route(req); }
Res iroute(Req req)
{ return r.route(req); }

}

/+@controller+/ class GroupCtlr
{
	/+@GET+/
	static Res create()
	{
	
	}
	
	/+@POST+/
	static Res create()
	{
	
	}

static const TypeSafeRouter!(Res,Req) r, ir;
static this()
{
	r = TypeSafeRouter!(Response,Request)();
	ir = TypeSafeRouter!(Response,Request)();
	r.map!(Res function())(GET,"create", &GroupCtlr.create, []);
	r.map!(Res function())(POST,"create", &GroupCtlr.create, []);
}

static Res route(Req req)
{ return r.route(req); }
Res iroute(Req req)
{ return r.route(req); }

}


/+@data+/ class User
: IObject, IHttpSet

{
	/+@primaryKey+/ /+@autoIncrement+/ /+@UInt("id")+/;
	/+@required+/ /+@String("email")+/;
	/+@minLength(8)+/ /+@maxLength(40)+/ /+@String("username")+/; 
	/+@String("firstname")+/;
	/+@String("lastname")+/;
	/+@Time("last_login")+/;

Var opIndex(char[] key)
{
	Var res;
	switch(key)
	{
		case "id": bind(res, id()); break;
		case "email": bind(res, email()); break;
		case "username": bind(res, username()); break;
		case "firstname": bind(res, firstname()); break;
		case "lastname": bind(res, lastname()); break;
		case "last_login": bind(res, last_login()); break;
		default: return Var();
	}
	return res;
}
int opApply (int delegate (inout char[] key, inout Var val) dg) { return 0; }
void opIndexAssign(Var val, char[] key) {}
Var opCall(Var[] params, IExecContext ctxt) { return Var(); }
void toString(IExecContext ctxt, void delegate(char[]) utf8Writer, char[] flags = null) {}


private StaticBitArray!(1,6) __touched__;


void httpSet(IObject obj, Request req)
{
	foreach(key, val; obj)
	{
		switch(key)
		{
			case "id": id = convertParam2!(uint, Req)(val); break;
			case "email": email = convertParam2!(char[], Req)(val); break;
			case "username": username = convertParam2!(char[], Req)(val); break;
			case "firstname": firstname = convertParam2!(char[], Req)(val); break;
			case "lastname": lastname = convertParam2!(char[], Req)(val); break;
			case "last_login": last_login = convertParam2!(Time, Req)(val); break;
			default: break;
		}
	}
}

static this()
{
	username_MinLengthValidation = new MinLengthValidation(8);
	username_MaxLengthValidation = new MaxLengthValidation(40);
}

private static MinLengthValidation username_MinLengthValidation;
private static MaxLengthValidation username_MaxLengthValidation;

bool validate()
{
	bool succeed = true;

	void fail(char[] field, Error err)	{
		succeed = false;
		__errors__.add(field, err);
	}

	if(!ExistenceValidation!(String).validate(email_)) fail("email_", ExistenceValidation!(String).error);
	if(!username_MinLengthValidation.validate(username_)) fail("username_", username_MinLengthValidation.error);
	if(!username_MaxLengthValidation.validate(username_)) fail("username_", username_MaxLengthValidation.error);

	return succeed;
}


mixin SessionAllocate!();

ErrorMap errors()
{
	return __errors__;
}
void clearErrors()
{
	__errors__.reset;
}
private ErrorMap __errors__;
public uint id() { return id_;}
public void id(uint val) {__touched__[0] = true; id_ = val;}
private uint id_;

public char[] email() { return email_;}
public void email(char[] val) {__touched__[1] = true; email_ = val;}
private char[] email_;

public char[] username() { return username_;}
public void username(char[] val) {__touched__[2] = true; username_ = val;}
private char[] username_;

public char[] firstname() { return firstname_;}
public void firstname(char[] val) {__touched__[3] = true; firstname_ = val;}
private char[] firstname_;

public char[] lastname() { return lastname_;}
public void lastname(char[] val) {__touched__[4] = true; lastname_ = val;}
private char[] lastname_;

public Time last_login() { return last_login_;}
public void last_login(Time val) {__touched__[5] = true; last_login_ = val;}
private Time last_login_;


}
