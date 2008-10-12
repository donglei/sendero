module scripts.create_project;

import tango.io.Stdout;
import tango.io.Path;

void createFolder_(char[] name)
{
	if(!exists(name)) {
		Stdout.formatln("Creating folder {}", name);
		createFolder(name);
	}
}

void createFile_(char[] name)
{
	if(!exists(name)) {
		Stdout.formatln("Creating file {}", name);
		createFile(name);
	}
}

int create_project(char[][] args)
{
	if(args.length < 2) {
		Stdout.formatln("Please specify a project name");
		return -1;
	}
	
	auto projName = args[1];
	
	Stdout.formatln("Creating project {}", projName);
	
	createFile_("dsss.conf");
	createFile_("sendero.conf");
	createFile_("senderoxc.conf");
	createFile_("Rakefile");
	createFolder_(projName);
	createFile_(projName ~ "/Session.d");
	createFolder_(projName ~ "/ctlr");
	createFolder_(projName ~ "/model");
	createFolder_("public");
	createFolder_("public/css");
	createFolder_("public/images");
	createFolder_("public/js");	
	createFolder_("view");
	createFolder_("test");
	
	return 0;
}

int main(char[][] args)
{
	return create_project(args);
}

