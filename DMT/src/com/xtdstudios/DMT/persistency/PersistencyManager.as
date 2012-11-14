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
package com.xtdstudios.DMT.persistency
{
	
	public interface PersistencyManager
	{
		/** Should me add here if and when generic will be avaiable...
		function saveData(fileName: String, data: T):void;
		function loadData(fileName: String): T;
		*/
		function saveData(fileName: String, data: Object):void;
		function loadData(fileName: String): Object;
			
		function isExist(groupName:String): Boolean;
		function deleteData(groupName:String): void;
		function list(): Array;
		function dispose():void;
	}
}