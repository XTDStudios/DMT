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
	public class LoggerFactory
	{
		private static var m_loggerFactory: LoggerFactory;

		public static function get instance(): LoggerFactory
		{
			if (! m_loggerFactory) 
			{
				m_loggerFactory = new LoggerFactory();
			}
			return m_loggerFactory;
		}
		
		public static function getLogger(classToLog: *): Logger
		{
			return instance.getLogger(classToLog);
		}
		
		private var m_factoryMethod: Function;
//		private var m_loggerClass: Class;
		private var m_loggerConfiguration : LoggerConfiguration = SimpleLoggerConfiguration.instance();
		private var m_logPattern: LogPattern = new SimpleLogPattern();
		
		public function LoggerFactory()
		{
			m_factoryMethod = defaultFactoryMethod;
		}
		
		public function getLogger(classToLog: *): Logger
		{
			return m_factoryMethod(classToLog);
		}
		
//		public function set loggerClass(loggerClass: Class): void
//		{
//			m_loggerClass = loggerClass;
//		}
//		
		public function set factoryMethod(factory: Function): void
		{
			m_factoryMethod = factory;
		}
		
		private function defaultFactoryMethod(classToLog: *): Logger
		{
			return new TraceLogger(classToLog);
		}
		
		public function get loggerConfiguration():LoggerConfiguration
		{
			return m_loggerConfiguration;
		}
		
		public function set loggerConfiguration(value:LoggerConfiguration):void
		{
			m_loggerConfiguration = value;
		}

		public function get logPattern():LogPattern
		{
			return m_logPattern;
		}
		
		public function set logPattern(value:LogPattern):void
		{
			m_logPattern = value;
		}
		
	}
}