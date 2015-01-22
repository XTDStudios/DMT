package com.xtdstudios.common.assetsFactory
{
	public interface IAssetsFactory
	{
		function hasAsset(symbol:String):Boolean;
		function createAsset(symbol:String):Object;
		function getAssetClass(className:String):Class;
		function dispose():void;
		
	}
}