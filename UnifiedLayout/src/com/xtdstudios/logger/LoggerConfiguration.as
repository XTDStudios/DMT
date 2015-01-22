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
	public interface LoggerConfiguration
	{
		function get LogLevel(): LoggerLevel
		function set LogLevel(loggerLevel: LoggerLevel): void
		function shouldLog(classNameToLog: String, loggerLevel: LoggerLevel): Boolean
		function addFilterClass(classToLog: *, loggerLevel: LoggerLevel): void
		function addFilter(classToLog: String, loggerLevel: LoggerLevel): void
	}
}