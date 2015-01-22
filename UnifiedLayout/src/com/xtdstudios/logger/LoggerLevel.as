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
package com.xtdstudios.logger
{
	import com.xtdstudios.as3.Enum;

	public final class LoggerLevel extends Enum
	{
		{initEnum(LoggerLevel);} // static ctor
		
		public static const ERROR	: LoggerLevel = new LoggerLevel();
		public static const WARN	: LoggerLevel = new LoggerLevel();
		public static const INFO	: LoggerLevel = new LoggerLevel();
		public static const DEBUG	: LoggerLevel = new LoggerLevel();
	}
}