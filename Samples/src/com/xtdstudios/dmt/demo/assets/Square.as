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
package com.xtdstudios.dmt.demo.assets
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	public class Square extends Sprite
	{
		public function Square(size:int, pivotX:int, pivotY:int, color1:int=0x126985, color2:int=0x29a3cF)
		{
			super();
			
			var mat : Matrix = new Matrix();
			mat.createGradientBox(size, size, Math.PI/2.75);
			mat.translate(pivotX, pivotY);
			
			graphics.lineStyle(1, 0x333333);
			graphics.beginGradientFill(GradientType.LINEAR, [color1, color2], [1, 1], [0, 0xff], mat);
			graphics.drawRect(pivotX, pivotY, size, size);
			graphics.endFill();
		}
	}
}