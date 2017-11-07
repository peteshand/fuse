// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package fuse.utils;

import flash.display3D.Context3DTextureFormat;
import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.utils.ByteArray;

/** A parser for the ATF data format. */
class AtfData
{
    public function new()
    {
		
	}
	
    public static function getInfo(data:ByteArray):AtfDataInfo
    {
		if (!validATF(data)) {
			return { valid:false, data:data };
		}
        
        if (data[6] == 255) data.position = 12; // new file version
        else                data.position =  6; // old file version
		
		var textureFormat:Context3DTextureFormat = null;
        var format:UInt = data.readUnsignedByte();
        switch (format & 0x7f)
        {
            case  0, 1: textureFormat = Context3DTextureFormat.BGRA;
            case 12, 2, 3: textureFormat = Context3DTextureFormat.COMPRESSED;
            case 13, 4, 5: textureFormat = Context3DTextureFormat.COMPRESSED_ALPHA;
            default: throw new Error("Invalid ATF format");
        }
        
        var width:Int = Std.int(Math.pow(2, data.readUnsignedByte())); 
        var height:Int = Std.int(Math.pow(2, data.readUnsignedByte()));
        var numTextures:Int = data.readUnsignedByte();
        var isCubeMap:Bool = (format & 0x80) != 0;
        
        // version 2 of the new file format contains information about
        // the "-e" and "-n" parameters of png2atf
        
        if (data[5] != 0 && data[6] == 255)
        {
            var emptyMipmaps:Bool = (data[5] & 0x01) == 1;
            var numTextures2:Int  = data[5] >> 1 & 0x7f;
            numTextures = emptyMipmaps ? 1 : numTextures2;
        }
		
		return { 
			valid:true, 
			data:data,
			format:textureFormat,
			width:width,
			height:height,
			numTextures:numTextures,
			isCubeMap:isCubeMap
		};
    }

    public static function validATF(data:ByteArray):Bool
    {
		var check:Array<String> = ["A", "T", "F"];
		data.position = 0;
		while (data.bytesAvailable > 0) 
		{
			if (check[data.position] != String.fromCharCode(data.readByte())) return false;
			if (data.position == 2) return true;
		}
		return false;
    }
}

typedef AtfDataInfo =
{
	data:ByteArray,
	valid:Bool,
    ?format:Context3DTextureFormat,
    ?width:Int,
    ?height:Int,
    ?numTextures:Int,
    ?isCubeMap:Bool
}