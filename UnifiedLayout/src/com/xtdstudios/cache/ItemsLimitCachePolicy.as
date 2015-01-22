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
	public class ItemsLimitCachePolicy implements CachePolicy
	{
		private var m_maxItems			: uint;
		
		public function ItemsLimitCachePolicy(maxItems : uint = uint.MAX_VALUE)
		{
			m_maxItems = maxItems;
		}
		
		public function get maxItems():uint
		{
			return m_maxItems;
		}
		
		
		public function beforeStore(m: CacheManager, key: Object, value: *): Boolean
		{
			if (m.fetch(key) == value)
				return false;
			if (m.length >= m_maxItems)
			{
				m.removeOldest();
			}
			return true;
		}
		
		public function afterStore(cacheManager: CacheManager, key: Object, value: *, oldValue : *): void
		{
			
		}
		
		public function beforeRemove(cacheManager: CacheManager, key: Object, value: *): Boolean
		{
			return true;
		}
		
		public function afterRemove(cacheManager: CacheManager, key: Object, value: *): void
		{
			
		}
	}
}