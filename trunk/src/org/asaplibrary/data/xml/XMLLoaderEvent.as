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
package org.asaplibrary.data.xml {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	Passes events for {@link XMLLoader}. Subscribe to type <code>_EVENT</code>.
	@example
	<code>
	xmlLoader.addEventListener(XMLLoaderEvent._EVENT, handleXMLLoaded);
	</code>
	Listen for loader events:
	<code>
	private function handleXMLLoaded (e:XMLLoaderEvent) : void {
	switch (e.subtype) {
	case XMLLoaderEvent.COMPLETE: handleXmlComplete(); break;
	case XMLLoaderEvent.ERROR: handleXmlError(); break;
	}
	}
	</code>
	 */
	public class XMLLoaderEvent extends Event {
		/** Event type. */
		public static const _EVENT : String = "onXMLLoaderEvent";
		/** Subtype of event sent when loading of a single XML is complete */
		public static const COMPLETE : String = "complete";
		/** Subtype of event sent when the stack of loading XMLs is empty */
		public static const ALL_COMPLETE : String = "allComplete";
		/** Subtype of event sent when an error has occurred */
		public static const ERROR : String = "error";
		/** Subtype of event sent during loading of XML */
		public static const PROGRESS : String = "progress";
		public var name : String;
		public var subtype : String;
		public var data : XML;
		public var error : String;
		public var bytesLoaded : uint;
		public var bytesTotal : uint;

		/**
		Creates a new XMLLoaderEvent.
		@param inSubtype: either subtype; see above
		@param inName: identifier name
		@param inData: the XML data object (only at COMPLETE)
		 */
		public function XMLLoaderEvent(inSubtype : String, inName : String, inData : XML = null) {
			super(_EVENT);

			subtype = inSubtype;
			name = inName;
			data = inData;
		}

		public override function toString() : String {
			return getQualifiedClassName(this) + "; name=" + name + "; subtype=" + subtype + "; error=" + error + "; bytesLoaded=" + bytesLoaded + "; bytesTotal=" + bytesTotal;
		}

		/**
		Creates a copy of an existing XMLLoaderEvent.
		 */
		public override function clone() : Event {
			return new XMLLoaderEvent(subtype, name, data);
		}
	}
}
