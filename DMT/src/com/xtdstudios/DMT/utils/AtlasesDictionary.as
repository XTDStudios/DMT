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
package com.xtdstudios.DMT.utils
{
	import com.xtdstudios.DMT.atlas.Atlas;
	
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class AtlasesDictionary implements IExternalizable
	{
		private var m_dictionary		: Dictionary;
		private var m_length			: int;
		
		public function AtlasesDictionary()
		{
			m_length = 0;
			m_dictionary = new Dictionary();
		}
		
		
		public function writeExternal(output:IDataOutput): void {
			output.writeObject(m_dictionary);
		}
		
		public function readExternal(input:IDataInput): void {
			m_dictionary = input.readObject();
			m_length = toArray().length;
		}
		public function get length():int
		{
			return m_length;
		}

		public function addAtlas(atlas:Atlas, name:String, overrideExisting:Boolean=true):void
		{
			if (m_dictionary[name]==null)
			{
				m_dictionary[name] = atlas;
				m_length++;
			}
			else
			{
				if (overrideExisting==true)
				{
					m_dictionary[name] = atlas;
				}
			}
		}
		
		public function removeAtlas(name:String, autoDispose:Boolean=true):void
		{
			if (m_dictionary[name]!=null)
			{
				var atlas : Atlas = m_dictionary[name];
				delete m_dictionary[name];
				m_length--;
				
				if (autoDispose==true)
					atlas.dispose();
			}
		}
		
		public function nameExist(name:String):Boolean
		{
			return m_dictionary[name]!=null;
		}
		
		public function toArray():Array
		{
			var result : Array = new Array;
			for each(var atlas:Atlas in m_dictionary)
			{
				result.push(atlas);
			}
			
			return result;
		}
		
		public function dispose():void
		{
			for (var name:String in m_dictionary)
			{
				var atlas : Atlas = m_dictionary[name];
				atlas.dispose();
			}
			
			m_length = 0;
		}
		
	}
}