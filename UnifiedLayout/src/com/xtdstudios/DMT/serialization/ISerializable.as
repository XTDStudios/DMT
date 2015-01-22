package com.xtdstudios.DMT.serialization
{
	public interface ISerializable
	{
		function toJson():Object;
		function fromJson(jsonData:Object):void;
	}
}