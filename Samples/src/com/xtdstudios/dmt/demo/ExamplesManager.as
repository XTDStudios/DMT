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
package com.xtdstudios.dmt.demo
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class ExamplesManager extends starling.display.Sprite
	{
		private var m_examplesClasses	: Array = [HelloDMT, PivotExample, HierarchyExample, MovieClipDMT/*, CoreAPI */];
		private var m_currentExample 	: Sprite;
		private var m_exampleTitle 		: TextField;
		private var m_exampleIdx		: int = 0;
		
		public function ExamplesManager()
		{
			super();

			Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, onClick);
			m_exampleTitle = Starling.current.nativeStage.getChildByName("exampleTitle") as TextField;
			
			m_exampleIdx = -1;
			nextExample();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			nextExample();
		}
		
		private function nextExample():void
		{
			m_exampleIdx++;
			if (m_exampleIdx>=m_examplesClasses.length)
				m_exampleIdx = 0;
			
			if (m_currentExample)
			{
				m_currentExample.dispose();
				removeChild(m_currentExample);
			}
			
			m_currentExample = new m_examplesClasses[m_exampleIdx];
			addChild(m_currentExample);
			
			m_exampleTitle.text = m_currentExample.name;
		}
	}
}