module senderoxc.data.mapper.Delete;

import senderoxc.data.mapper.IMapper;

class DeleteResponder : IMapperResponder
{
	this(IMapper m)
	{
		m.addMethod(new FunctionDeclaration("destroy", "void"));
		this.mapper = mapper;
	}
	
	private IMapper mapper;
	
	void write(IPrint wr)
	{
		wr("private static char[] deleteSql;\n");
		
		wr("public void destroy()\n");
		wr("{\n");
		wr.indent;
		wr.fln("if(!deleteSql.length) deleteSql = db.sqlGen.makeDeleteSql({}, [{}]);",
			DQuote(mapper.schema.tablename), makeQuotedList(mapper.schema.getPrimaryKeyCols()));
		wr("scope st = db.prepare(deleteSql);\n");
		wr.fln("st.execute({});", makeList(mapper.getPrimaryKeyFields));
		wr.dedent;
		wr("}\n");
		wr("\n");
	}
}