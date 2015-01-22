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
	import flash.utils.getTimer;

	public class TimeCounter
	{
		private var m_startTime : int;
		private var m_pauseTime : int;
		private var m_isStarted	: Boolean;
		private var m_isPaused	: Boolean;
		private var m_wasRunningBeforeDeactivate:Boolean;
		
		public function TimeCounter()
		{
			m_isStarted = false;
			m_isPaused = false;
			m_wasRunningBeforeDeactivate = false;
		}
		
		public function get isPaused():Boolean
		{
			return m_isPaused;
		}
		
		public function get isStarted():Boolean
		{
			return m_isStarted;
		}
		
		public function activate():void
		{
			if (m_wasRunningBeforeDeactivate==true)
				resume();
		}
		
		public function deactivate():void
		{
			m_wasRunningBeforeDeactivate = (m_isStarted==true && m_isPaused==false)
			pause();
		}
		
		public function restart():void
		{
			start();
		}
		
		public function start():void
		{
			m_isStarted = true;
			m_isPaused = false;
			m_startTime = getTimer();
		}
		
		public function stop():void
		{
			m_isStarted = false;
			m_isPaused = false;
		}
		
		public function pause():void
		{
			if (m_isStarted==true && m_isPaused==false)
			{
				m_isPaused = true;
				
				m_pauseTime = getTimer();
			}
		}
		
		public function resume():void
		{
			if (m_isStarted==true && m_isPaused==true)
			{
				m_isPaused = false;
				
				m_startTime = m_startTime + (getTimer()-m_pauseTime);
			}
		}
		
		public function timePassed():int
		{
			if (m_isStarted==true)
			{
				var now : int = getTimer();
				if (m_isPaused==true)
				{
					m_startTime = m_startTime + (now-m_pauseTime);
					m_pauseTime = now;					
				}
				
				return now-m_startTime;
			}
			else
			{
				return 0;
			}
		}
	}
}