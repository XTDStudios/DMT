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
	import flash.system.System;

	public class Memory
	{
		public static function toString(bytes:Number):String
		{
			return Number(bytes / 1024 / 1024).toFixed( 2 ) + "Mb";
		}
		
		public static function getUsedMemeory():Number
		{
			return flash.system.System.totalMemory + flash.system.System.privateMemory;
		}
		
		public static function getUsedMemeoryStr():String
		{
			return toString(getUsedMemeory());
		}
	}
}