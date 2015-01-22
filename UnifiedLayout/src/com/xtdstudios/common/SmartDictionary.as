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
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class SmartDictionary extends Dictionary
	{
//		private var m_dic : Dictionary;
		private var length : int;
		
		public function SmartDictionary(weakKeys:Boolean=false)
		{
//			length = 0;
//			m_dic = new Dictionary(weakKeys);
			super(weakKeys);
		}
		
		
		public function toVector():Vector
		{
			var result : Vector = new Vector;
			for each(var o:Object in this)
			{
				result.push(o);
			}
			
			return result;
		}
		
		public function dispose():void
		{
			for (var name:String in this)
			{
				var o : Object = this[name];
				o.dispose();
			}
		}
		
		
//		public function setProperty(name:*, value:*):void
//		{
//			if (super[name]) {
//				length++;
//			}
//			super[name]=value;
//		}
//		
//		public function getProperty(name:*):*
//		{
//			return super[name];
//		}
	}
}