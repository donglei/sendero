/** 
 * Copyright: Copyright (C) 2007 Aaron Craelius.  All rights reserved.
 * License:   BSD Style
 * Authors:   Aaron Craelius
 */


module sendero.xml.IForwardNodeIterator;

enum XmlNodeType { Element, Data, CData, Comment, PI, Attribute };

interface IForwardNodeIterator(Ch)
{
	bool nextElement(ushort depth);
	bool nextElement(ushort depth, Ch[] name);
	bool nextNode(ushort depth);
	bool nextAttribute();
	XmlNodeType type();
	Ch[] prefix();
	Ch[] localName();
	Ch[] nodeName();
	Ch[] nodeValue();
	ushort depth();
}