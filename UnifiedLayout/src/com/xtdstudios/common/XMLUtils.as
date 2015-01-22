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
	
	public final class XMLUtils
	{
		
		public static function setPercentFromXML(xml:XML, xmlAttr:String, obj:Object, objField:String = null):void
		{
			if (objField==null)
				objField = xmlAttr;
			
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue)
				obj[objField] = parseFloat(attrValue.substr(0, attrValue.length-1))/100;
		}
		
		public static function setNumberFromXML(xml:XML, xmlAttr:String, obj:Object, objField:String = null):void
		{
			if (objField==null)
				objField = xmlAttr;
			
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue)
				obj[objField] = parseFloat(attrValue);
		}
		
		public static function setIntFromXML(xml:XML, xmlAttr:String, obj:Object, objField:String = null):void
		{
			if (objField==null)
				objField = xmlAttr;
			
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue)
				obj[objField] = parseInt(attrValue);
		}
		
		public static function setBoolFromXML(xml:XML, xmlAttr:String, obj:Object, objField:String = null):void
		{
			if (objField==null)
				objField = xmlAttr;
			
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue!=null && attrValue!="")
				obj[objField] = attrValue.toLowerCase()=="true";
		}
		
		public static function setStrFromXML(xml:XML, xmlAttr:String, obj:Object, objField:String = null):void
		{
			if (objField==null)
				objField = xmlAttr;
			
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue!=null && attrValue!="")
				obj[objField] = attrValue;
		}
		
		public static function setDicFromXML(xml:XML, xmlAttr:String, obj:Object, objField:String = null):void
		{
			if (objField==null)
				objField = xmlAttr;
			
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue!=null && attrValue!="")
			{
				obj[objField] = getDicFromXML(xml, xmlAttr);
			}
		}
		
		public static function getDicFromXML(xml:XML, xmlAttr:String): Dictionary
		{
			var dic: Dictionary = new Dictionary;
			var attrValue 	: String = xml.attribute(xmlAttr);
			if (attrValue!=null && attrValue!="")
			{
				//TODO:  Fix to support spaces 
				//var trimArrayElements:String = StringUtil.trimArrayElements(attrValue,",");
				//var split:Array = trimArrayElements.split(",");
				var split:Array = attrValue.split(",");
				for each (var item: String in split) 
				{
					dic[item] = [item];
				}
			}
			
			return dic;
		}
		
	}
}