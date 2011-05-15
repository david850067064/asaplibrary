/*
Copyright 2007-2011 by the authors of asaplibrary, http://asaplibrary.org
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
package org.asaplibrary.management.lang {
	import org.asaplibrary.data.xml.IParsable;

	import flash.utils.getQualifiedClassName;

	/**
	ValueObject class that holds data for a text item. 
	Classes that implement {@link IMultiLanguageTextContainer} get this type of data from the LanguageManager.
	Basic info contained in this class is the text and the id by which it is referenced.
	 */
	public class TextItemData implements IParsable {
		public var text : String;
		public var id : String;
		public var isHTML : Boolean = true;

		/**
		Constructor
		@param inID: unique id of item
		@param inText: text for item
		 */
		public function TextItemData(inID : String = null, inText : String = null) {
			id = inID;
			text = inText;
		}

		/**
		 * Parse specified XML data into member variables
		 * @param	o: XML object to be parsed
		 * @return true if parsing went ok, otherwise false
		 */
		public function parseXML(o : XML) : Boolean {
			id = o.@id;
			isHTML = o.@html != "false";
			text = o.toString();

			return true;
		}

		public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
