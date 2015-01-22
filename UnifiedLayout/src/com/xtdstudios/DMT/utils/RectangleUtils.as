package com.xtdstudios.DMT.utils
{
	import flash.geom.Rectangle;

	public class RectangleUtils
	{
		public static function rectAsObj(rect:Rectangle):Object {
			return {
				x: Math.round( rect.x*1000 )/1000,
				y: Math.round( rect.y*1000 )/1000,
				w: Math.round( rect.width*1000 )/1000,
				h: Math.round( rect.height*1000 )/1000
			};
		}
	}
}