/** 
 * Copyright: Copyright (C) 2007-2008 Aaron Craelius.  All rights reserved.
 * Authors:   Aaron Craelius
 */

module sendero.session.Session;

public import sendero.http.Request;

import tango.core.Thread;
public import tango.net.http.HttpCookies;

version(SenderoSessionGC)
{
	public import sendero.session.GC;
}

interface ISessionData 
{
	void reset();
	void sleep();
}

class BasicSessionData
{
	this()
	{
		req = new Request;
	}
	
	alias Request RequestT;
	
	Request req;
	
	Cookie[] cookies;
	
	void setCookie(char[] name, char[] value)
	{
		cookies ~= new Cookie(name, value);
	}
	
	void setCookie(Cookie cookie)
	{
		cookies ~= cookie;
	}
	
	void reset()
	{
		cookies.length = 0;
		version(SenderoSessionGC)
		{
			SessionGC.reset;
		}
	}
	
	void reset(Request req)
	{
		reset;
		this.req = req;
	}
	
	void sleep()
	{
		
	}
}

class SessionGlobal(SessionImpT)
{
	alias SessionImpT.RequestT RequestT;
	
	static ThreadLocal!(SessionImpT) data;
	static this()
	{
		data = new ThreadLocal!(SessionImpT);
	}
	
	static SessionImpT cur()
	{
		auto session = data.val;
		if(!session) {
			session = new SessionImpT;
			data.val = session;
		}
		return session;
	}
	alias cur get;
	alias cur opCall;
	
	static BasicSessionData swap(BasicSessionData session)
	{
		
	}
	
	static BasicSessionData newSession()
	{
		
	}
}

version(Unittest)
{

alias SessionGlobal!(BasicSessionData) Session;
	
unittest
{
	
}
}