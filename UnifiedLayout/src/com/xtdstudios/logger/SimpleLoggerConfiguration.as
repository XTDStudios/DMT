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
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class SimpleLoggerConfiguration implements LoggerConfiguration
	{
		private static var s_loggerConfiguration: LoggerConfiguration = null;
		
		
		public static function instance(): LoggerConfiguration
		{
			if (!s_loggerConfiguration)
			{
				s_loggerConfiguration = new SimpleLoggerConfiguration();
			}
			return s_loggerConfiguration;
		}

		private var defaultLoggerLevel: LoggerLevel = LoggerLevel.DEBUG;
		private var logFilters: Dictionary = new Dictionary();
		private var implicitLogFilters: Dictionary = new Dictionary();
		
		public function SimpleLoggerConfiguration()
		{
		}
		
		public function get LogLevel(): LoggerLevel
		{
			return this.defaultLoggerLevel
		}
		public function set LogLevel(loggerLevel: LoggerLevel):void
		{
			this.defaultLoggerLevel = loggerLevel;
		}
		
		public function addFilterClass(classToLog: *, loggerLevel: LoggerLevel): void
		{
			addFilter(getQualifiedClassName(classToLog), loggerLevel);
		}
		
		public function addFilter(classToLog: String, loggerLevel: LoggerLevel): void
		{
			logFilters[classToLog] = loggerLevel;
		}
		
		protected function getFilter(classToLog: String): LoggerLevel
		{
			var logLevel : LoggerLevel = logFilters[classToLog];
			if (! logLevel)
			{
				var classPackagePath: String = classToLog;
				var lastIndex: int = classToLog.lastIndexOf("::");
				while (! logLevel && lastIndex > 0)
				{
					classPackagePath = classPackagePath.substring(0,lastIndex);
					logLevel = logFilters[classPackagePath];
					lastIndex = classPackagePath.lastIndexOf(".");
				}
				
				if (! logLevel)
				{
					logLevel = defaultLoggerLevel;
				}
			}
			
			return logLevel;
		}
		
		public function shouldLog(classNameToLog: String, loggerLevel: LoggerLevel): Boolean
		{
			if (getFilter(classNameToLog).Index >= loggerLevel.Index)
			{
				return true;
			}
			return false; 
		}
	}
}