/*
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

package org.asaplibrary.data {

	import org.asaplibrary.data.xml.IParsable;

	/**
	DataValueObject class to hold information about urls.
	Can get its information through the {@link Parser} since it implements {@link IParsable}.
	*/

	public class URLData implements IParsable {
		// the names of the urls in the file settings.xml

		/** unique identifying name of url */
		public var name:String;
		/** actual url to be opened */
		public var url:String;
		/** target of getURL function */
		public var target:String;
		
		/**
		*	Constructor
		*	NB: This will be called without parameters by the Parser
		*/
		public function URLData (inName:String = null, inURL:String = null, inTarget:String = null) {
			if (inName) name = inName;
			if (inURL) url = inURL;
			if (inTarget) target = inTarget;
		}
		
		/**
		*	Parse XML
		*	@return true if parsing went ok, otherwise false: name & url are mandatory for this type of node
		*/
		public function parseXML (inXML:XML) : Boolean {
			name   = inXML.@name;
			url    = inXML.@url;
			target = inXML.@target;
			
			return ((name != null) && (url != null));
		}
	}
}