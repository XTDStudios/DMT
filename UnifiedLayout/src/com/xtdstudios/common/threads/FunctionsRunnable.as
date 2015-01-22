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
package com.xtdstudios.common.threads
{
	public class FunctionsRunnable implements IRunnable
	{
		private var m_functions		: Vector.<Function>;
		private var m_functionIdx	: int;
		
		public function FunctionsRunnable(functions:Vector.<Function>)
		{
			m_functions = functions;
			m_functionIdx = 0;
		}
		
		public function process():void
		{
			if (isComplete==false)
			{
				m_functions[m_functionIdx]();
				m_functionIdx++;
			}
		}
		
		public function get isComplete():Boolean
		{
			return m_functions.length<=m_functionIdx;
		}
		
		public function get total():int
		{
			return m_functions.length;
		}
		
		public function get progress():int
		{
			return m_functionIdx;
		}
	}
}