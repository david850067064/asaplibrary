﻿/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

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

package org.asaplibrary.data.xml {

	/**
	Class for parsing XML data into DataValueObject classes.
	The class provides static functions for calling {@link IParsable#parseObject} on newly created objects of a specified type, either for single data blocks or for an array of similar data.
	The Parser removes the tedious for-loop from the location where the XML data is loaded, and moves the parsing of the XML data to the location where it's used for the first time: the DataValueObject class. Your application can use this data, that contains typed variables, without ever caring about the original source of the data.
	When the XML structure is changed, only the parsing function in the DataValueObject class has to be changed, thereby facilitating maintenance and development.

	@use
	Consider an XML file with the following content:
	<code>
	<?xml version="1.0" encoding="UTF-8"?>
		<settings>
			<urls>
				<url name="addressform" url="../xml/address.xml" />
				<url name="entries" url="../xml/entries.xml" />
			</urls>
		</settings>
	</code>
	Once the XML has been loaded, it can be converted into an Array of URLData objects with the following code:
	<code>
	// objects of type URLData
	private var mURLs:Array;
	
	// parse XML
	// @param inXml: XML
	// @return true if parsing went ok, otherwise false
	private function handleSettingsLoaded (inXml:XML) : Boolean {
		var xmlList:XMLList = XMLList(inXml);
		mURLs = Parser.parseList(xmlList.urls.url, URLData, false);
		return (mURLs != null);
	}
	</code>
	After calling this function, the member variable <code>mURLs</code> contains a list of objects of type {@link URLData}, filled with the content of the XML file.

	Notes to this code:
	<ul>
	<li>The first parameter to {@link #parseList} is a (can be a) repeating node where each node contains similar data to be parsed into </li>
	<li>Conversion of nodes to an Array is not necessary. If the {@code <urls>}-node in the aforementioned XML file would contain only one {@code <url>}-node, the parser still returns an Array, with one object of type URLData.</li>
	<li>Since the last parameter to the call to {@link #parseList} is false, an error in the xml data will result in mURLs being null. The parsing class determines if the data is valid or not, by returning true or false from parseObject().</li>
	</ul> 
	*/
	public class Parser {
	
		/**
		*	Parse an XMLList into an array of the specified class instance by calling its parseXML function
		*	@param inXMLList: list of XML nodes
		*	@param inClass: classname to be instanced; class must implement IParsable
		*	@param ignoreError: if true, the return value of {@link #parseXML} is always added to the array, and the array itself is returned. Otherwise, an error in parsing will return null.
		*	@return Array of new objects of the specified type, cast to IParsable, or null if parsing returned false.
		*/
		public static function parseList (inList:XMLList,
										  inClass:Class,
										  inIgnoreError:Boolean = false) : Array {
			var a:Array = new Array();
			
			var len:Number = inList.length();
			for (var i : Number = 0; i < len; i++) {
				var ipa:IParsable = parseXML(inList[i], inClass, inIgnoreError);
				if ((ipa == null) && !inIgnoreError) return null;
				else a.push(ipa);
			}
			
			return a;
		}
		
		/**
		*	Parse XML into the specified class instance by calling its parseXML function
		*	@param inXML: XML document or node
		*	@param inClass: classname to be instanced; class must implement IParsable
		*	@param ignoreError: if true, the return value of {@link IParsable#parseXML} is ignored, and the newly created object is always returned
		*	@return a new object of the specified type, cast to {@link IParsable}, or null if parsing returned false.
		*/
		public static function parseXML (inXML:XML,
										 inClass:Class,
										 inIgnoreError:Boolean = false) : IParsable {
			var ipa:IParsable = new inClass();
			if (ipa.parseXML(inXML) || inIgnoreError) {
				return ipa;
			} else {
				return null;
			}
		}
	}
}
