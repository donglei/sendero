module test1;
/*DO NOT EDIT THIS FILE!*/

import sendero.routing.Router, sendero.http.Response, sendero.http.Request, sendero.routing.IRoute, sendero.view.View;
import sendero_base.Core, sendero.data.Bind, sendero.vm.bind.Bind, sendero.validation.Validations;



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
	/+@primary_key+/ uint id;
	/+@required+/ char[] email;
	/+@minLength(8)+/ char[] username; 
	char[] firstname;
	char[] lastname;

Var opIndex(char[] key)
{
	Var res;
	switch(key)
	{
		case "id": bind(var, id); break;
		case "email": bind(var, email); break;
		case "username": bind(var, username); break;
		case "firstname": bind(var, firstname); break;
		case "lastname": bind(var, lastname); break;
		default: return Var();
	}
	return res;
}
int opApply (int delegate (inout char[] key, inout Var val) dg) {}
void opIndexAssign(Var val, char[] key) {}
Var opCall(Var[] params, IExecContext ctxt) {}
void toString(IExecContext ctxt, void delegate(char[]) utf8Writer, char[] flags = null) {}

void httpSet(IObject obj, Request req)
{
	foreach(key, val; obj)
	{
		switch(key)
		{
			case "id": convertParam2!(typeof(id), Req)(id, val); break;
			case "email": convertParam2!(typeof(email), Req)(email, val); break;
			case "username": convertParam2!(typeof(username), Req)(username, val); break;
			case "firstname": convertParam2!(typeof(firstname), Req)(firstname, val); break;
			case "lastname": convertParam2!(typeof(lastname), Req)(lastname, val); break;
			default: break;
		}
	}
}

public uint id() { return id_; }
private uint id_;

static this()
{
	auto sqlGen = db.getSqlGenerator;
	insertBinder = createBinder(["email","username","firstname","lastname","id"];);
	insertSql = sqlGen.makeInsertSql("User",["email","username","firstname","lastname","id"];);
}

static Binder insertBinder, updateBinder, fetchBinder;
static char[] insertSql, updateSql, selectByIDSql, deleteSql;

public bool save()
{
	if(id_) {
		scope st = db.prepare(updateSql);
		st.execute(updateBinder(this));
	}
	else {
		scope st = db.prepare(insertSql);
		st.execute(insertBinder(this));
		id_ = st.getLastInsertID;
	}
	return true;}

public static User getByID(uint id)
{
	scope st = db.prepare(selectByIDSql);
	st.execute(id);
	auto res = new User;
	if(st.fetch(fetchBinder(res))) return res;
	else return null;
}

public bool destroy()
{
	scope st = db.prepare(deleteSql);
	st.execute(id_);
	return true;
}

static this()
{
usernameMinLengthValidation = new MinLengthValidation(0);
}

static MinLengthValidation usernameMinLengthValidation;

bool validate()
{
	if(!ExistenceValidation!(char[]).validate(email)) fail(ExistenceValidation!(char[]).error);
	if(!usernameMinLengthValidation.validate(username)) fail(usernameMinLengthValidation.error);

}


}
