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
	import flash.utils.getQualifiedClassName;

	public class TraceLogger implements Logger
	{
		private var classNameToLog: String = "";
		
		
		public function TraceLogger(classToLog: *)
		{
			classNameToLog = getQualifiedClassName(classToLog);
		}

		public function log(level: LoggerLevel, message: String): Boolean
		{
			if (LoggerFactory.instance.loggerConfiguration.shouldLog(classNameToLog, level))
			{
//				var date: Date = new Date();
//				var dateStr : String =  date.getDate()+"/"+date.getMonth()+"/"+date.getFullYear() + " " +  date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+"."+date.getMilliseconds();
////				var messageStr:String = "{0} [{1}] {2} - {3}";
////				trace(StringUtil.substitute(messageStr, dateStr, level, classNameToLog, message));
//				trace(dateStr,"[",level,"]",classNameToLog,"-",message);
				trace(LoggerFactory.instance.logPattern.formatLogMessage(classNameToLog, level, message));
				return true;
			}
			return false
		}
		
		public function get loggerName(): String
		{
			return classNameToLog;
		}
		
		public function debug(message: String): void
		{
			log(LoggerLevel.DEBUG, message);
		}
		
		public function info(message: String): void
		{
			log(LoggerLevel.INFO, message);
		}
		
		public function warn(message: String): void
		{
			log(LoggerLevel.WARN, message);
		}
		
		public function error(message: String): void
		{
			log(LoggerLevel.ERROR, message);
		}
	}
}