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
	import flash.errors.IllegalOperationError;

	public class RunnablesList implements IRunnable
	{
		private var m_runnables 		: Vector.<IRunnable>;
		private var m_currentRunnable 	: IRunnable;
		private var m_countCompleted	: int;
		private var m_preCalcTotals		: Boolean;
		private var m_calculatedTotals	: int;
		
		public function RunnablesList(runnables:Vector.<IRunnable>, preCalcTotals:Boolean = true)
		{
			m_runnables = runnables;
			if (runnables==null || runnables.length<=1)
				new IllegalOperationError("runnables must contain at least one IRunnable");
			
			m_preCalcTotals = preCalcTotals;
			m_currentRunnable = m_runnables[0];
			m_countCompleted = 0;
			
			if (m_preCalcTotals)
				m_calculatedTotals = countTotals();
		}
		
		private function countTotals():int
		{
			var result : int = 0;
			for each(var runnable:IRunnable in m_runnables)
				result += runnable.total;
				
			return result;
		}
		
		public function process():void
		{
			if (m_currentRunnable.isComplete)
			{
				m_countCompleted++;
				if (m_countCompleted<m_runnables.length)
					m_currentRunnable = m_runnables[m_countCompleted];
				else
					m_currentRunnable = null;
			}
			else
			{
				m_currentRunnable.process();
			}
		}
		
		public function get isComplete():Boolean
		{
			return m_countCompleted==m_runnables.length;
		}
		
		public function get total():int
		{
			if (m_preCalcTotals)
				return m_calculatedTotals;
			else
				return countTotals();
		}
		
		public function get progress():int
		{
			var result : int = 0;
			for each(var runnable:IRunnable in m_runnables)
				result += runnable.progress;
			
			return result;
		}
	}
}