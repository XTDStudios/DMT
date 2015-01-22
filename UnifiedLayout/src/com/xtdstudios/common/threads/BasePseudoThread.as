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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class BasePseudoThread
	{
		private var m_timer				: Timer;
		private var m_targetFPS			: int;
		private var m_timeToSpend		: Number;
		private var m_avgTimeSpent		: Number;
		private var m_countExecutions	: int;
		private var m_isRunning			: Boolean;
		private var m_runnable			: IRunnable;
		
		public function BasePseudoThread(runnable:IRunnable, targetFPS:int = 60)
		{
			m_isRunning = false;
			m_runnable = runnable;
			m_targetFPS = targetFPS;
			m_timeToSpend = 1000/m_targetFPS;
			m_avgTimeSpent = 0;
			m_countExecutions = 0;
			m_timer = new Timer(m_timeToSpend);
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			var maxTime		: Number = getTimer()+m_timeToSpend-(m_avgTimeSpent*2);
			var startTime 	: Number;
			var endTime 	: Number;
			var timeTaken 	: Number;
			var completed	: Boolean;
			
			do {
				startTime = getTimer();
				m_runnable.process();
				m_countExecutions++;
				endTime = getTimer();
				timeTaken = endTime - startTime;
				if (m_countExecutions>1)
					m_avgTimeSpent = (m_avgTimeSpent + timeTaken)/2;
				else
					m_avgTimeSpent = timeTaken;
				
				completed = m_runnable.isComplete;
			} while (completed==false && endTime<maxTime);
			
			if (completed) 
			{
				forceStop();
				notifyCompletion(m_runnable.progress, m_runnable.total);
			} 
			else
			{
				notifyProgress(m_runnable.progress, m_runnable.total);
			}
		}
		
		protected function notifyProgress(progress:int, total:int):void
		{
			new IllegalOperationError("You must implement the 'notifyProgress' function");
		}
		
		protected function notifyCompletion(progress:int, total:int):void
		{
			new IllegalOperationError("You must implement the 'notifyCompletion' function");
		}
		
		public function start():void 
		{
			if (m_isRunning)
				return;
			
			m_isRunning = true;
			m_timer.addEventListener(TimerEvent.TIMER,onTimer);
			m_timer.start(); 
		}
		
		public function forceStop():void 
		{
			if (m_isRunning==false)
				return;
			
			m_isRunning = false;
			m_timer.stop();
			m_timer.removeEventListener(TimerEvent.TIMER,onTimer);
		}
		
		public function destroy():void 
		{
			forceStop();
			m_runnable = null;
			m_timer = null;
		}
	}
}