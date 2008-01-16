module sendero.routing.Common;

public import sendero.util.HTTPRequest;
public import sendero.util.UrlStack;

enum HttpMethod { Get, Post };

interface IFunctionWrapper(Ret, Req)
{
	Ret exec(Req routeParams, void* ptr = null);
}