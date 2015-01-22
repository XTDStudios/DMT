/*
Copyright 2013 XTD Studios Ltd.

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
package com.xtdstudios.cache
{
	import com.xtdstudios.logger.Logger;
	import com.xtdstudios.logger.LoggerFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	dynamic public class CacheManager extends Proxy implements IEventDispatcher
	{
		private static var log: Logger = LoggerFactory.getLogger(CacheManager);
		
		protected var eventDispatcher:EventDispatcher;
		protected var m_hash			: Dictionary;
		protected var m_list			: Array;

		private var cachePolicy:CachePolicy;
		
		public function CacheManager(cachePolicy: CachePolicy)
		{
			eventDispatcher = new EventDispatcher(this);
			m_hash = new Dictionary();
			m_list = new Array();
			this.cachePolicy = cachePolicy;
		}
		
		public function store(key: Object, value: *): void
		{
			log.debug("store: key=" + key + " , value=" + value);
			if (cachePolicy.beforeStore(this, key, value))
			{
				var oldValue : * = remove(key);
				m_hash[key] = value;
				m_list.push(key);
				cachePolicy.afterStore(this, key, value, oldValue)
				dispatchEvent(new CacheManagerEvent(CacheManagerEvent.ITEM_ADDED, key, value));
			}
		}
		
		public function fetch(key: Object): *
		{
			log.debug("fetch: key=" + key);
			return m_hash[key];
		}
		
		public function remove(key: Object): *
		{
			var value : * = m_hash[key];
			log.debug("remove: key=" + key + " , value=" + value);
			if (cachePolicy.beforeRemove(this, key, value))
			{
				delete m_hash[key];
				m_list.splice(m_list.indexOf(key), 1);
				cachePolicy.afterRemove(this, key, value)
				dispatchEvent(new CacheManagerEvent(CacheManagerEvent.ITEM_REMOVED, key, value));
			}
			return value;
		}
		
		public function removeOldest(): *
		{
			log.debug("store: Cache full - deleting old items.");
			return remove(m_list[0]);
		}
		
		public function exist(key: Object): *
		{
			return m_hash[key] != null;
		}
		
		public function clear(): void
		{
			while (m_list.length > 0)
			{
				remove(m_list[0]);
			}
		}
		
		public function get length():uint
		{
			return m_list.length;
		}
		

		
		
		flash_proxy override function getProperty(name:*):*
		{
			return fetch(name);
		}
		
		flash_proxy override function setProperty(name:*, value:*):void
		{
			store(name, value);
		}

		flash_proxy override function hasProperty(name:*):Boolean
		{
			return exist(name);
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean
		{
			var value : * = remove(name);
			return value != null;
		}
		
		override flash_proxy function nextNameIndex (index:int):int {
			if (index < m_list.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextValue(index:int):* {
			return m_hash[m_list[index - 1]];
		}
		
		override flash_proxy function nextName(index:int):String {
			return m_list[index - 1];
		}
		
		
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}

	}
	
}

