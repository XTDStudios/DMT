package com.xtdstudios.DMT
{
	import flash.display.DisplayObject;

	public class ItemToRaster
	{
		public var displayObject	: DisplayObject;
		public var uniqueID			: String;
		
		public function ItemToRaster(displayObject:DisplayObject, uniqueID:String)
		{
			this.displayObject = displayObject;
			this.uniqueID = uniqueID;
		}
	}
}