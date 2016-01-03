/*
Copyright 2012 XTD Studios Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.xtdstudios.DMT.starlingConverter
{
import flash.geom.Point;
import flash.geom.Rectangle;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class StarlingMovieClipProxy extends MovieClip
	{
		public var originalPosRectangle : Rectangle;
		private var m_pivots : Vector.<Point>;

		public function StarlingMovieClipProxy(textures:Vector.<Texture>, pivots:Vector.<Point>, fps:Number=30)
		{
			m_pivots = pivots;
			super(textures, fps);
		}
		
		override public function set texture(value:Texture):void
		{
			super.texture = value;
			this.pivotX = m_pivots[this.currentFrame].x;
			this.pivotY = m_pivots[this.currentFrame].y;
			readjustSize();
		}
	}
}