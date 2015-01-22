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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	public class PseudoThread extends BasePseudoThread implements IEventDispatcher {
		
		private var m_eventDispatcher  : EventDispatcher;
		
		public function PseudoThread(runnable:IRunnable, targetFPS:int = 60) 
		{
			m_eventDispatcher = new EventDispatcher();
			super(runnable, targetFPS);
		}
		
		override protected function notifyProgress(progress:int, total:int):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, progress, total));
		}
		
		override protected function notifyCompletion(progress:int, total:int):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, progress, total));
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			m_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return m_eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return m_eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			return m_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return m_eventDispatcher.willTrigger(type);
		}
		
		override public function destroy():void 
		{
			m_eventDispatcher = null;
			super.destroy();
		}
	}
}