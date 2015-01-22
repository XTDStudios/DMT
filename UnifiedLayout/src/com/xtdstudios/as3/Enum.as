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
package com.xtdstudios.as3
{
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;

	public /*abstract*/ class Enum
	{
		public function get Name()  :String { return _name; }
		public function get Index() :int    { return _index; }
		
		public /*override*/ function toString() :String { return Name; }
		
		public static function GetConstants(i_type :Class) :Array
		{
			var constants :EnumConstants = _enumDb[getQualifiedClassName(i_type)];
			if (constants == null)
				return null;
			
			// return a copy to prevent caller modifications
			return constants.ByIndex.slice();
		}
		
		public static function valueOf(
			i_type          :Class,
			i_constantName  :String,
			i_caseSensitive :Boolean = false) :Enum
		{
			var constants :EnumConstants = _enumDb[getQualifiedClassName(i_type)];
			if (constants == null)
				return null;
			
			var constant :Enum = constants.ByName[i_constantName.toLowerCase()];
			if (i_caseSensitive && (constant != null) && (i_constantName != constant.Name))
				return null;
			
			return constant;
		}
		
		/*-----------------------------------------------------------------*/
		
		/*protected*/ function Enum()
		{
			var typeName :String = getQualifiedClassName(this);
			
			// discourage people new'ing up constants on their own instead
			// of using the class constants
			if (_enumDb[typeName] != null)
			{
				throw new Error(
					"Enum constants can only be constructed as static consts " +
					"in their own enum class " + "(bad type='" + typeName + "')");
			}
			
			// if opening up a new type, alloc an array for its constants
			var constants :Array = _pendingDb[typeName];
			if (constants == null)
				_pendingDb[typeName] = constants = [];
			
			// record
			_index = constants.length;
			constants.push(this);
		}
		
		protected static function initEnum(i_type :Class) :void
		{
			var typeName :String = getQualifiedClassName(i_type);
			
			// can't call initEnum twice on same type (likely copy-paste bug)
			if (_enumDb[typeName] != null)
			{
				throw new Error(
					"Can't initialize enum twice (type='" + typeName + "')");
			}
			
			// no constant is technically ok, but it's probably a copy-paste bug
			var constants :Array = _pendingDb[typeName];
			if (constants == null)
			{
				throw new Error(
					"Can't have an enum without any constants (type='" +
					typeName + "')");
			}
			
			// process constants
			var type :XML = flash.utils.describeType(i_type);
			for each (var constant :XML in type.constant)
			{
				// this will fail to coerce if the type isn't inherited from Enum
				var enumConstant :Enum = i_type[constant.@name];
				
				// if the types don't match then probably have a copy-paste error.
				// this is really common so it's good to catch it here.
				var enumConstantType :* = Object(enumConstant).constructor;
				if (enumConstantType != i_type)
				{
					throw new Error(
						"Constant type '" + enumConstantType + "' " +
						"does not match its enum class '" + i_type + "'");
				}
				
				enumConstant._name = constant.@name;
			}
			
			// now seal it
			_pendingDb[typeName] = null;
			_enumDb[typeName] = new EnumConstants(constants);
		}
		
		private var _name :String = null;
		private var _index :int = -1;
		
		private static var _pendingDb :Object = {}; // typename -> [constants]
		private static var _enumDb    :Object = {}; // typename -> EnumConstants
	}

	
	
//	public class Enum
//	{
//		private static var s_lastDefinedOrdinal: int = -1;
//		private var m_name :String;
//		private var m_ordinal: int;
//		
//		public function Enum(ordinal: int = -1)
//		{
//			m_ordinal = ordinal;
//			if (ordinal > s_lastDefinedOrdinal) {
//				s_lastDefinedOrdinal = ordinal;
//			}
//		}
//		
//		public function get ordinal(): int {
//			return m_ordinal;
//		}
//		
//		public function get Name() :String { 
//			return m_name; 
//		}
//		
//		public function toString() :String {
//			return Name; 
//		}
//		
//		
//		
//		public static function valueOf(enumType: Class, name: String): Enum {
//			if (hasEnum(enumType, name)) {
//				var describeType2:XML = describeType(enumType);
//				return enumType[name];
//			} else {
//				throw new IllegalOperationError;
//			}
//		}
//		
//		protected static function hasEnum(enumType: Class, name: String): Boolean {
//			return enumType.hasOwnProperty(name);
//		}
//		
//		
//		protected static function initEnum(i_type :*) :void
//		{
//			var c: int = s_lastDefinedOrdinal;
//			var type :XML = flash.utils.describeType(i_type);
//			for each (var constant :XML in type.constant)
//			{
//				var enumConstant :Enum = i_type[constant.@name];
//				
//				// if 'text' is already initialized, then we're probably
//				// calling initEnum() on the same type twice by accident,
//				// likely a copy-paste bonehead mistake.
//				if (enumConstant.Name != null)
//				{
//					throw new Error("Can't initialize '" + i_type + "' twice");
//				}
//				
//				// if the types don't match then probably have another
//				// copy-paste error.
//				var enumConstantObj :* = enumConstant;
//				if (enumConstantObj.constructor != i_type)
//				{
//					throw new Error(
//						"Constant type '" + enumConstantObj.constructor + "' " +
//						"does not match its enum class '" + i_type + "'");
//				}
//				
//				enumConstant.m_ordinal = ++c;
//				enumConstant.m_name = constant.@name;
//			}
//		}
//	}
}
import com.xtdstudios.as3.Enum;

// private support class
class EnumConstants
{
	public function EnumConstants(i_byIndex :Array)
	{
		ByIndex = i_byIndex;
		
		for (var i :int = 0; i < ByIndex.length; ++i)
		{
			var enumConstant :Enum = ByIndex[i];
			ByName[enumConstant.Name.toLowerCase()] = enumConstant;
		}
	}
	
	public var ByIndex :Array;
	public var ByName :Object = {};
}
