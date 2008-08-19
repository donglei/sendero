module IUser;
/*DO NOT EDIT THIS FILE!*/




/+@dataInterface("User")+/;
interface IUser : IObject, IHttpSet
{
	void destroy();
	bool save();
	uint id();
	char[] email();
	void email(char[]);
	char[] username();
	void username(char[]);
	char[] firstname();
	void firstname(char[]);
	char[] lastname();
	void lastname(char[]);
	Time last_login();
	void last_login(Time);
}