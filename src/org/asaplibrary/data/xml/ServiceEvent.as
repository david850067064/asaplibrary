/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org

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
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	Event class for use with the Service class. Listen to the generic event type to receive these events.
	The event has room for both a list of objects as result of a load operation, or a single object. It is left to the implementation of an extension of Service to determine which of these are used.
	@example 
	<code>myService.addEventListener(ServiceEvent._EVENT, handleServiceEvent);</code>
	 */
	public class ServiceEvent extends Event {
		/** Generic type of event */
		public static const _EVENT : String = "onServiceEvent";
		/** subtype of event sent when loading and parsing went ok */
		public static const COMPLETE : String = "loadComplete";
		/** subtype of event sent when all requests have completed; does not check for errors */
		public static const ALL_COMPLETE : String = "allLoadComplete";
		/** subtype of event sent when there was an error loading the data */
		public static var LOAD_ERROR : String = "loadError";
		/** subtype of event sent when there was an error parsing the data */
		public static var PARSE_ERROR : String = "parseError";
		/** subtype of event */
		public var subtype : String;
		/** name of original request*/
		public var name : String;
		/** if applicable, a single array of typed data objects */
		public var list : Array;
		/** if applicable, a single object */
		public var object : Object;
		/** if applicable, a string describing the error */
		public var error : String;

		public function ServiceEvent(inSubtype : String, inName : String = null, inList : Array = null, inObject : Object = null, inError : String = null) {
			super(_EVENT);

			subtype = inSubtype;
			name = inName;
			list = inList;
			object = inObject;
			error = inError;
		}

		override public function clone() : Event {
			return new ServiceEvent(subtype, name, list, object, error);
		}

		override public function toString() : String {
			return getQualifiedClassName(this) + ": subtype = " + subtype + ", name = " + name;
		}
	}
}
