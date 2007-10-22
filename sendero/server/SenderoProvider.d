/**
 * Copyright: Copyright (C) 2007 Rick Richardson.  All rights reserved.
 * License:   BSD Style
 * Authors:   Rick Richardson
 */

module sendero.server.SenderoProvider;

import sendero.util.http.HttpResponse;
import sendero.util.http.HttpProvider;
import sendero.util.http.HttpRequest;
import tango.net.http.HttpConst;
import tango.io.protocol.Writer;
import tango.io.Buffer;
import tango.io.Stdout;
import tango.util.log.Log;
import tango.util.log.Configurator;
import tango.text.convert.Sprint;
import tango.core.Thread;
import tango.io.FileConduit;

private static const int ResponseBufferSize = 20 * 1024;


class SenderoProvider : HttpProvider
{
	Buffer outbuf;
	Logger logger;
	Sprint!(char) sprint;
	this()
	{
		logger = Log.getLogger("SenderoProvider");
		outbuf = new Buffer(ResponseBufferSize);
		sprint = new Sprint!(char);
	}

	void service (HttpRequest request, HttpResponse response)
	{
		auto from = new FileConduit ("/home/rick/Desktop/testdata/Oscar_Wilde.html");
		//synchronized
		//{
		//outbuf("<HTML>\n<HEAD>\n<TITLE>Hello!</TITLE>\n"c)
    //	 		 ("<BODY>\n<H2>This is a test</H2>\n"c)
    //  		 ("</BODY>\n</HTML>\n"c);
		//}
		response.setContentType (HttpHeader.TextHtml.value);
		response.setContentLength(from.length());
		auto buf = response.getOutputBuffer();
		logger.info(sprint("Thread: {0}, buf: 0x{1:x}, outbuf: 0x{2:x}",
								Thread.getThis().name(),cast(uint)&buf,cast(uint)&outbuf));

		buf.copy(from);
		logger.info("flushing output buffer");
		response.flush();
		//response.sendError(HttpResponses.NotFound);
	}

}

class SenderoProviderFactory : ProviderFactory
{
	HttpProvider create()
	{
		return new SenderoProvider();
	}
}