package com.xtdstudios.DMT.starlingConverter
{
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.textures.Texture;
	
	public final class StarlingButtonProxy extends Button
	{
		public var originalPosRectangle : Rectangle;
		
		public function StarlingButtonProxy(upState:Texture, text:String="", downState:Texture=null, overState:Texture=null, disabledState:Texture=null)
		{
			super(upState, text, downState, overState, disabledState);
		}
	}
}