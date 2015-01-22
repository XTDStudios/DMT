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
	import flash.events.Event;
	
	public class CacheManagerEvent extends Event
	{
		public static const ITEM_ADDED	: String = "CACHE_MANAGER_ITEM_ADDED";
		public static const ITEM_REMOVED	: String = "CACHE_MANAGER_ITEM_REMOVED";
		
		private var m_key: Object;
		private var m_value: *;
		
		public function CacheManagerEvent(type:String, key: Object, value: * = null)
		{
			super(type, false, false);
			this.m_key = key;
			this.m_value = value;
		}
		
		public function get key():Object
		{
			return m_key;
		}

		public function get value():*
		{
			return m_value;
		}

		public override function clone():Event {
			return new CacheManagerEvent(type, m_key, m_value);
		}


	}
}