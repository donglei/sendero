/** 
 * Copyright: Copyright (C) 2007-2008 Aaron Craelius.  All rights reserved.
 * Authors:   Aaron Craelius
 */

module sendero.util.Base64;

import tango.math.Math;

debug import Integer = tango.text.convert.Integer;

debug import tango.io.Stdout;

const char[64] lookupBase64Encode = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

/**
 *
 * Encodes a binary sequence in Base64 encoding using - _ for the MIME characters + / respectively
 * so that the sequence came be used in URLs.  If the template parameter MIME is set to true, then
 * the data will be encoded using the MIME characters + and / instead with line breaks after every
 * 76 characters. 
 *
 */
char[] base64Encode(bool MIME = false)(ubyte[] src, char[] dest = null)
{
	static if(MIME) {
		const char[64] lookupBase64Encode = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";		
	}
	
	uint srcLen = src.length;
	static if(MIME) {
		uint destLen = cast(uint)(ceil(cast(double)srcLen / 3) * 4);
		uint breaks = cast(uint)ceil(cast(double)destLen / 76);
		destLen += breaks * 2;
	}
	else {
		uint destLen = cast(uint)(ceil(cast(double)srcLen / 3) * 4);
	}
	if(dest) {
		debug assert(dest.length >= destLen, "If a dest array is passed it should be at least 4/3 as big as the source array.");
		if(dest.length < destLen) dest.length = destLen;
	}
	else dest.length = destLen;
	
	uint i, j;
	
	static if(MIME) {
		uint seqCount = 0;
		void doEOL()
		{
			if(seqCount % 19 == 0) {
				debug assert(j + 1 < dest.length);
				dest[j .. j + 2] = "\r\n";
				j += 2;
			}
			++seqCount;
		}
	}
	for(i = 0, j = 0; i + 2 < srcLen; i += 3, j += 4)
	{
		static if(MIME) { doEOL; }
		
		debug assert(j + 3 < dest.length);
		
		uint n = src[i];    n <<= 8;
		n += src[i+1];      n <<= 8;
		n += src[i+2];
		
		dest[j] = lookupBase64Encode[ n >>> 18 & 63 ];
		dest[j + 1] = lookupBase64Encode[ n >>> 12 & 63 ];
		dest[j + 2] = lookupBase64Encode[ n >>> 6 & 63 ];
		dest[j + 3] = lookupBase64Encode[ n & 63 ];
		
		//debug Stdout.formatln("{},{},{}:{}\t\t{},{},{},{}", src[i], src[i+1], src[i+2], n, n >>> 18 & 63, n >>> 12 & 63, n >>> 6 & 63, n & 63);
	}
	
	if(i + 1 < srcLen) {
		static if(MIME) { doEOL; }
		
		uint n = src[i];    n <<= 8;
		n += src[i+1];      n <<= 8;
		debug assert(j + 3 < destLen, Integer.toString(src.length) ~ ":" ~ Integer.toString(destLen));
		
		dest[j] = lookupBase64Encode[ n >>> 18 & 63 ];
		dest[j + 1] = lookupBase64Encode[ n >>> 12 & 63 ];
		dest[j + 2] = lookupBase64Encode[ n >>> 6 & 63 ];
		
		static if(MIME) {
			dest[j + 3] = '=';
			j += 4;
		}
		else j += 3;
		
		//debug Stdout.formatln("{},{}:{}\t\t{},{},{}", src[i], src[i+1], n, n >>> 18 & 63, n >>> 12 & 63, n >>> 6 & 63);
		
	}
	else if(i < srcLen) {
		static if(MIME) { doEOL; }
		
		uint n = src[i];    n <<= 16;
		debug assert(j + 3 < destLen);
		
		dest[j] = lookupBase64Encode[ n >>> 18 & 63 ];
		dest[j + 1] = lookupBase64Encode[ n >>> 12 & 63 ];
		static if(MIME) {
			dest[j + 2] = '=';
			dest[j + 3] = '=';
			j += 4;
		}
		else j += 2;
		
		//debug Stdout.formatln("{}:{}\t\t{},{},{}", src[i], n, n >>> 18 & 63, n >>> 12 & 63);
	}
	else debug assert(i == srcLen);
	
	return dest[0 .. j];
}

const ubyte lookupBase64Decode[128] = 
    [
      // 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
         255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  // 0
         255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  // 1
         255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 62,  255, 62,  255, 63,   // 2
         52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  255, 255, 255, 101, 255, 255,  // 3
         255, 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,  13,  14,   // 4
         15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  255, 255, 255, 255, 63,   // 5
         1,   26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,   // 6
         41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  255, 255, 255, 255, 255   // 7
    ];


/**
*
* Decodes a Base64 sequence that was encoded using Sendero's default encoder (which uses
* - and _ instead of + and / respectively or any MIME compatible encoder.
* 
*/
ubyte[] base64Decode(char[] src, ubyte[] dest = null)
{
	ubyte[4] buf;
	ubyte[] data = cast(ubyte[])src;
	uint srcLen = data.length;
	
	uint destLen = cast(uint)ceil(cast(double)srcLen/ 4) * 3;
	if(dest) {
		debug assert(dest.length >= destLen, "If a dest array is passed it should be at least 3/4 as big as the source array.");
		if(dest.length < destLen) dest.length = destLen;
	}
	else dest.length = destLen;
	uint j = 0;
	
	void decode3()
	{
		debug assert(j + 2 < destLen);
		uint n = 0;
		n = buf[0];    n <<= 6;
		n += buf[1];   n <<= 6;
		n += buf[2];   n <<= 6;
		n += buf[3];
		
		dest[j + 2] = n & 0xFF;    n >>>= 8;
		dest[j + 1] = n & 0xFF;    n >>>= 8;
		dest[j]     = n & 0xFF;
		
		
		//debug Stdout.formatln("{},{},{}:{}\t{},{},{},{}", dest[j], dest[j+1], dest[j+2], n, buf[0], buf[1], buf[2], buf[3]);
		
		j += 3;
	}
	
	void decode2()
	{
		debug assert(j + 1 < destLen);
		uint n = 0;
		n = buf[0];    n <<= 6;
		n += buf[1];   n <<= 6;
		n += buf[2];   n <<= 6;
		
		n >>>= 8;
		dest[j + 1] = n & 0xFF;    n >>>= 8;
		dest[j]     = n & 0xFF;
		
		//debug Stdout.formatln("{},{}:{}\t{},{},{}", dest[j], dest[j+1], n, buf[0], buf[1], buf[2]);
		
		j += 2;
	}
	
	void decode1()
	{
		debug assert(j < destLen);
		uint n = 0;
		n = buf[0];    n <<= 6;
		n += buf[1];   n <<= 6;
		n <<= 6;
		
		n >>>= 16;
		dest[j] = n & 0xFF;
		
		//debug Stdout.formatln("{}:{}\t{},{}", dest[j], n, buf[0], buf[1]);
		
		j += 1;
	}
	
	uint i = 0;
	while(i < srcLen) {
		ubyte c;
		for(c = 0; c < 4 && i < srcLen; ++c)
		{
			ubyte x = 255;
			while(x == 255 && i < srcLen) {
				auto ch = data[i];
				if(ch > 127) { ++i; continue;}
				x = lookupBase64Decode[ ch ];
				++i;
			}
			if(x == 255 || x == 101) break;
			debug assert(c < 4, Integer.toString(c));
			buf[c] = x;
		}
		
		switch(c)
		{
		case 4:
			decode3;
			break;
		case 3:
			decode2;
			break;
		case 2:
			decode1;
			break;
		case 0:
			break;
		default:
			throw new Exception("Unexpected number of characters in Base64 sequence.");
		}
	}
	
	return dest[0 .. j];
}

/**
 * 
 * Utility function for converting integers to base64 strings - useful for encoding
 * integers in URLs.
 * 
 */
char[] intToBase64(X)(X x, char[] dest = null)
{	
	static if(X.sizeof == 2) const ubyte n = 3;
	else static if(X.sizeof == 4) const ubyte n = 6;
	else static if(X.sizeof == 8) const ubyte n = 11;
	else assert(false, "Unhandled type " ~ X.stringof);
	
	if(dest) {
		debug assert(dest.length >= n, "If a dest array is passed it should be at least 4/3 as big as the source type.");
		if(dest.length < n) dest.length = n;
	}
	else dest.length = n;
	
	for(int i = n - 1; i >= 0; --i)
	{
		debug assert(i < n, Integer.toString(n) ~ ":" ~ Integer.toString(i));
		//debug Stdout.formatln("{},{},{}", i, x, x & 63);
		dest[i] = lookupBase64Encode[x & 63];
		x >>>= 6;
	}
	
	return dest[0 .. n];
}

/**
 * 
 * Utility function for converting base64 strings that have been created using
 * intToBase64 back into integers.
 * 
 */
bool base64ToInt(X)(char[] src, inout X x)
{
	static if(X.sizeof == 2) {
		const ubyte n = 3;
		const ubyte tail = 2;
	}
	else static if(X.sizeof == 4) {
		const ubyte n = 6;
		const ubyte tail = 4;
	}
	else static if(X.sizeof == 8) {
		const ubyte n = 11;
		const ubyte tail = 2;
	}
	else static if(X.sizeof == 10) {
		const ubyte n = 14;
		const ubyte tail = 2;
	}
	else assert(false, "Unhandled type " ~ X.stringof);
	
	if(src.length < n) {
		debug throw new Exception("Source array is too small for type " ~ X.stringof);
		x = X.init;
		return false;
	}
	
	for(ubyte i = 0; i < n; ++i)
	{
		ubyte ch = src[i];
		if(ch > 127) {
			debug assert(false, "Invalid character in Base64 sequence");
			return false;
		}
		ubyte z = lookupBase64Decode[ch];
		if(z > 63) {
			debug assert(false, "Invalid character in Base64 sequence");
			return false;
		}
		x += z;
		
		//debug Stdout.formatln("{}, {}", x, z);
		
		if(i < n - 1) {
			x <<= 6;
		}
		
	}
	return true;
}

version(Unittest)
{
	
import Integer = tango.text.convert.Integer;
import tango.io.Stdout;

unittest
{
	ubyte[] src1 = [0x8b, 0xc3, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x84, 0xc0, 0x75, 0x0a, 0xb8, 0x29, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x57, 0xff, 0x35, 0x7c, 0x03, 0x00, 0x00, 0xff, 0x35, 0x78, 0x03, 0x00, 0x00, 0xff, 0x73, 0x24, 0xff, 0x73, 0x20, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x83, 0xc4, 0x14, 0x85, 0xc0, 0x75, 0x0a, 0xb8, 0x2a, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x57, 0xff, 0x35, 0x8c, 0x03, 0x00, 0x00, 0xff, 0x35, 0x88, 0x03, 0x00, 0x00, 0xff, 0x73, 0x2c, 0xff, 0x73, 0x28, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x83, 0xc4, 0x14, 0x85, 0xc0, 0x75, 0x0a, 0xb8, 0x2b, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x8b, 0xc3, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x84, 0xc0, 0x75, 0x0a, 0xb8, 0x2c, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0xb9, 0x03, 0x00, 0x00, 0x00, 0x39, 0x4b, 0x3c, 0x74, 0x0a, 0xb8, 0x2d, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x8b, 0xc3, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x84, 0xc0, 0x75, 0x0a, 0xb8, 0x2e, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x57, 0xff, 0x35, 0x9c, 0x03, 0x00, 0x00, 0xff, 0x35, 0x98, 0x03, 0x00, 0x00, 0xff, 0x73, 0x2c, 0xff, 0x73, 0x28, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x83, 0xc4, 0x14, 0x85, 0xc0, 0x75, 0x0a, 0xb8, 0x2f, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x83, 0x7b, 0x38, 0x01, 0x74, 0x0a, 0xb8, 0x30, 0x02, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x8b, 0xc3, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x84, 0xc0, 0x75, 0x0a, 0xb8, 0x31, 0x02, 0x00, 0x00, 0x9d, 0xe1, 0x01, 0xa4, 0x5c, 0x16, 0x01, 0x6f, 0xe4, 0x89, 0x16, 0x01, 0x6d, 0xa4, 0xa4, 0x16, 0x01, 0x6b, 0xe4, 0xdf, 0x16, 0x01, 0x6d, 0xa4, 0xf7, 0x16, 0x01, 0x6b, 0xe5, 0x42, 0x16, 0x01, 0x6d, 0xa5, 0x5a, 0x16, 0x01, 0x6b, 0xe5, 0x70, 0x16, 0x01, 0x6d, 0xa5, 0x8b, 0x16, 0x01, 0x6b, 0xa5, 0xe0, 0x16, 0x01, 0x6e, 0xa5, 0xe7, 0x16, 0x01, 0x6c, 0xe5, 0xec, 0x16, 0x01, 0x6d, 0xa6, 0x04, 0x16, 0x01, 0x6b, 0xa6, 0x30, 0x16, 0x01, 0x6b, 0xa6, 0x71, 0x16, 0x01, 0x6b, 0xa6, 0xaf, 0x16, 0x01, 0x6b, 0xa6, 0xdb, 0x16, 0x01, 0x6b, 0xa7, 0x01, 0x16, 0x01, 0x6c, 0xa7, 0x2e, 0x16, 0x01, 0x6b, 0xa7, 0x57, 0x16, 0x01, 0x6b, 0xa7, 0xbe, 0x16, 0x01, 0x6b, 0xa4, 0x84, 0x16, 0x01, 0x5e, 0xa4, 0xb5, 0x16, 0x01, 0x5e, 0xa4, 0xc5, 0x16, 0x01, 0x5e, 0xa4, 0xda, 0x16, 0x01, 0x5e, 0xa5, 0x08, 0x16, 0x01, 0x5e, 0xa5, 0x18, 0x16, 0x01, 0x5e, 0xa5, 0x28, 0x16, 0x01, 0x5e, 0xa5, 0x3d, 0x16, 0x01, 0x5e, 0xa5, 0x6b, 0x16, 0x01, 0x5e, 0xa5, 0x9c, 0x16, 0x01, 0x5e, 0xa5, 0xb1, 0x16, 0x01, 0x5e, 0xa6, 0x15, 0x16, 0x01, 0x5e, 0xa6, 0x41, 0x16, 0x01, 0x5e, 0xa6, 0x56, 0x16, 0x01, 0x5e];
	auto res1 = base64Encode(src1);
	auto decode1 = base64Decode(res1);
	assert(src1 == decode1);
	
	ubyte[] src2 = [0x65, 0x36, 0x34, 0x20, 0x73, 0x65, 0x71, 0x75, 0x65, 0x6e, 0x63, 0x65, 0x2e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x33, 0x00, 0x00, 0x00, 0xb8, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x73, 0x65, 0x6e, 0x64, 0x65, 0x72, 0x6f, 0x2e, 0x75, 0x74, 0x69, 0x6c, 0x2e, 0x42, 0x61, 0x73, 0x65, 0x36, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00, 0xfc, 0x01, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x40, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x9d, 0x42, 0x00, 0xe5, 0xf8, 0x16, 0x01, 0x15, 0xe6, 0x10, 0x16, 0x01, 0x11, 0xe6, 0x40, 0x16, 0x01, 0x10, 0xe6, 0x44, 0x16, 0x01, 0x0f, 0xe6, 0x48, 0x16, 0x01, 0x0d, 0xe6, 0x3c, 0x16, 0x01, 0x0a, 0xe6, 0x24, 0x14, 0x01, 0x02, 0xe6, 0x1c, 0x14, 0x01, 0x02, 0xe5, 0xf4, 0x14, 0x01, 0x02, 0xe5, 0xb4, 0x14, 0x01, 0x02, 0xe4, 0xc4, 0x14, 0x01, 0x02, 0xe4, 0xb4, 0x14, 0x01, 0x02, 0xe4, 0x5c, 0x14, 0x01, 0x02, 0x00, 0xc3, 0xfe, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0a, 0xc8, 0x4c, 0x00, 0x00, 0x53, 0x56, 0x57, 0x8b, 0x45, 0x10, 0x89, 0x45, 0xe4, 0x89, 0x45, 0xdc, 0x31, 0xc9, 0x89, 0x4d, 0xe0, 0xdf, 0x6d, 0xdc, 0xdc, 0x35, 0xc8, 0x00, 0x00, 0x00, 0x83, 0xec, 0x0c, 0xdb, 0x3c, 0x24, 0xe8, 0x00, 0x00, 0x00, 0x00, 0xdb, 0x2d, 0xd0, 0x00, 0x00, 0x00, 0xde, 0xc9, 0xdd, 0x5d, 0xdc, 0x8b, 0x55, 0xe0, 0x8b, 0x45, 0xdc, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x89, 0x45, 0xe8, 0x8b, 0x5d, 0x0c, 0x0b, 0x5d, 0x08, 0x74, 0x42, 0x8b, 0x75, 0xe8, 0x39, 0x75, 0x08, 0x73, 0x1f, 0x6a, 0x12, 0xff, 0x35, 0x5c, 0x00, 0x00, 0x00, 0xff, 0x35, 0x58, 0x00, 0x00, 0x00, 0xff, 0x35, 0xb4, 0x00, 0x00, 0x00, 0xff, 0x35, 0xb0, 0x00, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x39, 0x75, 0x08, 0x73, 0x2a, 0x8d, 0x7d, 0x08, 0x57, 0xff, 0x75, 0xe8, 0x68, 0x00, 0x00, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x83, 0xc4, 0x0c, 0xeb, 0x14, 0x8d, 0x4d, 0x08, 0x51, 0xff, 0x75, 0xe8, 0x68, 0x00, 0x00, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x83, 0xc4, 0x0c, 0x31, 0xc0, 0x89, 0x45, 0xec, 0x89, 0x45, 0xf0, 0x89, 0x45, 0xec, 0x89, 0x45, 0xf0, 0x8b, 0x55, 0xec, 0x83, 0xc2, 0x02, 0x3b, 0x55, 0xe4, 0x0f, 0x83, 0xc0, 0x01, 0x00, 0x00, 0x8b, 0x5d, 0x08, 0x83, 0xc3, 0x03, 0x3b, 0x5d, 0xf0, 0x77, 0x0a, 0xb8, 0x1b, 0x00, 0x00, 0x00, 0xe8, 0x00, 0x00, 0x00, 0x00, 0x8b, 0x4d, 0xec, 0x3b, 0x4d, 0x10, 0x72, 0x0a, 0xb8, 0x1d, 0x00];
	auto res2 = base64Encode(src2);
	auto decode2 = base64Decode(res2);
	assert(src2 == decode2);
	
	ubyte[] src3 = [0x65, 0x36, 0x34, 0x20, 0x73, 0x65];
	auto res3 = base64Encode(src3);
	auto decode3 = base64Decode(res3);
	assert(src3 == decode3);
	
	ubyte[] src4 = [0x6e, 0x63, 0x65, 0x2e, 0x00, 0x00, 0x00, 0x00];
	auto res4 = base64Encode(src4);
	auto decode4 = base64Decode(res4);
	assert(src4 == decode4);
	
	auto res1MIME = base64Encode!(true)(src1);
	auto decode1MIME = base64Decode(res1MIME);
	assert(src1 == decode1MIME);
	
	ulong ul = 2938576174325948;
	auto ulB64 = intToBase64(ul);
	ulong ul2;
	assert(base64ToInt(ulB64, ul2));
	assert(ul == ul2, Integer.toString(ul2));
	
	uint ui = 4007639867;
	auto uiB64 = intToBase64(ui);
	uint ui2;
	assert(base64ToInt(uiB64, ui2));
	assert(ui == ui2, Integer.toString(ui2));
	
	ushort us = 17689;
	auto usB64 = intToBase64(us);
	ushort us2;
	assert(base64ToInt(usB64, us2));
	assert(us == us2, Integer.toString(us2));
	
	int i = -46389236;
	auto iB64 = intToBase64(i);
	int i2;
	assert(base64ToInt(iB64, i2));
	assert(i == i2, Integer.toString(i2));
	
	char[] b64 = "c2RsZ2toS0hES1NKR0Jqa2RmZ2gyOTM4NTZrc2pnaEtKR0dramZkc2c=";
	ubyte[] src = cast(ubyte[])"sdlgkhKHDKSJGBjkdfgh293856ksjghKJGGkjfdsg";
	assert(base64Decode(b64) == src);
	
	char[] b64WithoutSuffix = "c2RsZ2toS0hES1NKR0Jqa2RmZ2gyOTM4NTZrc2pnaEtKR0dramZkc2c";
	assert(base64Decode(b64WithoutSuffix) == src);
}
}