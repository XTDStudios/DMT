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
package com.xtdstudios.common
{
	public class MemoryTracer
	{
		public static var m_currentMem		: Number;
		public static var m_totalMem		: Number;
		
		public static function start():void
		{
			m_currentMem = Memory.getUsedMemeory();
			m_totalMem = 0;
			trace("\n\n======== Starting Mem Tracing ========");
		}
		
		public static function action(action:String):void
		{
			var changeInMem : Number  = Memory.getUsedMemeory() - m_currentMem;
			m_totalMem += changeInMem;
			m_currentMem = Memory.getUsedMemeory();
			trace(action + " -> " + Memory.toString(changeInMem));
		}
		
		public static function total():void
		{
			trace("=== Total so far: " + Memory.toString(m_totalMem) + " ===\n\n");
		}
	}
}