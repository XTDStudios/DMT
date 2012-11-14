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
	import flash.display.Sprite;
	
	public class Circle extends Sprite
	{
		private var m_size:int;
		public function Circle(size: int = 100)
		{
			super();
			m_size = size;
			
			init();
		}
		
		private function init(): void {
			this.graphics.lineStyle(1, 0x000000);
			
			this.graphics.beginFill(0x990000);
			this.graphics.drawCircle(m_size / 2, m_size / 2, m_size / 2);
			this.graphics.endFill();
			this.x = 10;
			this.y = 10;
			
		}
	}
}