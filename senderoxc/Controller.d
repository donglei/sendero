module senderoxc.Controller;

import decorated_d.core.Decoration;

import sendero.routing.Router;

import tango.util.log.Log;

Logger log;

static this()
{
	log = Log.lookup("senderoxc.SenderoExt");
}

class ControllerContext : IDecoratorContext
{
	private bool touched = false;
	
	void writeImports(IDeclarationWriter wr)
	{
		if(touched) {
			wr.prepend("import sendero.routing.Router, sendero.http.Request, sendero.routing.IRoute, sendero.view.View;\n");
		}
	}
	
	IDecoratorResponder init(DeclarationInfo decl, IContextBinder binder, Var[] Params = null)
	{
		touched = true;
		
		log.info("ControllerContext.init");
		
		auto res = new ControllerResponder(decl);
		
		binder.bindDecorator(DeclType.Function, "GET", new HTTPMethodContext!(GET)(res));
		binder.bindDecorator(DeclType.Function, "POST", new HTTPMethodContext!(POST)(res));
		binder.bindDecorator(DeclType.Function, "PUT", new HTTPMethodContext!(PUT)(res));
		binder.bindDecorator(DeclType.Function, "DELETE", new HTTPMethodContext!(DELETE)(res));
		binder.bindDecorator(DeclType.Function, "ALL", new HTTPMethodContext!(ALL)(res));
		
		//binder.bindStandalone("GET");
		//binder.bindStandalone("POST");
		//binder.bindStandalone("PUT");
		//binder.bindStandalone("DELETE");
		//binder.bindStandalone("pass");
		
		binder.bindStandaloneDecorator("pass", new HTTPContinueContext(res));
		
		return res;
	}
}

class HTTPMethodContext(ubyte Method) : IDecoratorContext
{
	this(ControllerResponder resp)
	{
		this.resp = resp;
	}
	
	ControllerResponder resp;
	
	IDecoratorResponder init(DeclarationInfo decl, IContextBinder binder, Var[] params = null)
	{
		char[][] actionNames;
		if(params.length) {
			switch(params[0].type)
			{
			case VarT.String: actionNames ~= params[0].string_; break;
			case VarT.Array:
				foreach(var; params[0].array_)
				{
					if(var.type == VarT.String)
						actionNames ~= var.string_;
				}
			default: break;
			}
		}
		resp.addAction(Method, decl, actionNames);
		return null;
	}
}

class HTTPContinueContext : IStandaloneDecoratorContext
{
	this(ControllerResponder resp)
	{
		this.resp = resp;
	}
	
	ControllerResponder resp;
	
	IDecoratorResponder init(StandaloneDecorator decorator, DeclarationInfo parentDecl, IContextBinder binder)
	{
		if(resp.decl != parentDecl)
			return null;
		
		if(!decorator.params.length >= 2
				|| decorator.params[0].type != VarT.String
				|| decorator.params[1].type != VarT.String)
			return null;
		
		auto name = decorator.params[0].string_;
		auto clsName = decorator.params[1].string_;
			
		auto continueDecls = parentDecl.findSymbol(clsName);
		if(!continueDecls.length || continueDecls[0].type != DeclType.Class)
			return null;
				
		resp.addContinue(name, continueDecls[0]);					
		
		return null;
	}
}

class ControllerResponder : IDecoratorResponder
{
	this(DeclarationInfo decl)
	{
		this.decl = decl;
	}
	
	DeclarationInfo decl;
	
	void addAction(ubyte method, DeclarationInfo fDecl, char[][] actionNames)
	{
		auto func = cast(FunctionDeclaration)fDecl;
		if(!func)
			return;
		log.info("ControllerResponder.addAction({},{})", method, func.name);
		actions ~= Action(method, func, actionNames);
	}
	
	void addContinue(char[] name, DeclarationInfo cDecl)
	{
		auto cls = cast(ClassDeclaration)cDecl;
		if(!cls)
			return;
		
		continues ~= Continue(name, cls);
	}
	
	struct Action
	{
		ubyte method;
		FunctionDeclaration func;
		char[][] actionNames;
	}
	
	struct Continue
	{
		char[] name;
		ClassDeclaration cls; 
	}
	
	Action[] actions;
	Continue[] continues;
	
	void finish(IDeclarationWriter writer)
	{
		writer.addBaseType("IIController");
		
		writer ~= "static const TypeSafeRouter!(Req) r;\n";
		writer ~= "static const TypeSafeInstanceRouter!(Req) ir;\n";
		writer ~= "static this()\n";
		writer ~= "{\n";
		writer ~= "\tr = TypeSafeRouter!(Req)();\n";
		writer ~= "\tir = TypeSafeInstanceRouter!(Req)();\n";
		
		foreach(action; actions)
		{
			char[] method;
			switch(action.method)
			{
			case POST: method = "POST"; break;
			case GET: method = "GET"; break;
			case PUT: method = "PUT"; break;
			case DELETE: method = "DELETE"; break;
			case ALL: method = "ALL"; break;
			default:
				debug assert(false, "Unknown HTTP Method");
				continue;
			}
			
			char[] i;
			if(!action.func.isStatic) i = "i";
			
			auto sig = action.func.retType ~ " function(";
			bool first = true;
			foreach(p; action.func.params)
			{
				if(!first) sig ~= ",";
				sig ~= p.type;
				first = false;
			}
			sig ~= ")";
			
			auto fname = decl.name ~ "." ~ action.func.name;
			
			foreach(ref name; action.actionNames)
				if(name == "/") name = "";
			
			if(!action.actionNames.length) {
				auto rname = action.func.name;
				switch(rname)
				{
				case "index":
				case "__index__":
				case "__default__":
				case "__show__":
				case "__this__":
				case "_":
					rname = "";
					break;
				case "__wildcard__": rname = "*";
				break;
				default: break;
				}
				action.actionNames ~= rname;
			}
			
			//writer ~= "\t" ~ i ~ "r.map!(typeof(&" ~ fname ~ `))(` ~ method ~ `,"` ~ action.func.name ~ `", &` ~ fname ~ ", [";
			foreach(rname; action.actionNames)
			{
				writer ~= "\t" ~ i ~ "r.map!(" ~ sig ~ `)(` ~ method ~ `,"` ~ rname ~ `", &` ~ fname ~ ", [";
				first = true;
				foreach(p; action.func.params)
				{
					if(!first) writer ~= ", ";
					if(p.decorators.length && p.decorators[0].name == "root")
						writer ~= "null";
					else
						writer ~= '"' ~ p.name ~ '"';
					first = false;
				}
				writer ~= "]);\n";
			}
		}
		
		auto print = writer.after;
		
		print.indent;
			foreach(cont; continues)
			{
				print.fln(`r.mapContinue("{}",&{}.route);`, cont.name, cont.cls.name);
			}
		
		
			auto getInstance = decl.findSymbol("getInstance");
			if(getInstance.length &&
				getInstance[0].type == DeclType.Class &&
				getInstance[0].isStatic) {
				print.fln(`r.mapWildcardContinue(&getInstance);`);
			}
		
		print.dedent;
		
		writer ~= "}\n\n";
		
		
		writer ~= "static void route(Req req)\n";
		writer ~= "{ ";
		writer ~= "static if(is(typeof(beforeRoute))) if(!beforeRoute(req)) return;\n";
		writer ~= "r.route(req);";
		writer ~= "static if(is(typeof(afterRoute))) afterRoute(req);\n";
		writer ~= " }\n";
		
		writer ~= "void iroute(Req req)\n";
		writer ~= "{ ";
		writer ~= "static if(is(typeof(beforeIRoute))) if(!beforeIRoute(req)) return;\n";
		writer ~= "ir.route(req, cast(void*)this);";
		writer ~= "static if(is(typeof(afterIRoute))) afterIRoute(req);\n";
		writer ~= " }\n";
	}
}