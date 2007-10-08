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

package org.asaplibrary.data.xml {
	
	import flash.events.Event;
	
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
	
		public static const _EVENT:String = "onXMLLoaderEvent";
		
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		public static const PROGRESS:String = "progress";
		
		public var source:XMLLoader;
		public var name:String;
		public var subtype:String;
		public var data:XML;
		public var error:String;
		public var bytesLoaded:uint;
		public var bytesTotal:uint;

		/**
		@param inSubtype: either <code>_EVENT</code>, <code>COMPLETE</code>, <code>ERROR</code> or <code>PROGRESS</code>
		@param inName: identifier name
		@param inData: the XML data object (only at COMPLETE)
		@param inSource: the sending XMLLoader
		*/
		public function XMLLoaderEvent (inSubtype:String,
										inName:String,
										inData:XML,
										inSource:XMLLoader) {
			super(_EVENT);
			
			subtype = inSubtype;
			name = inName;
			data = inData;
			source = inSource;
		}
		
		public override function toString ():String {
			return "org.asaplibrary.data.xml.XMLLoaderEvent; name=" + name + "; subtype=" + subtype + "; error=" + error + "; bytesLoaded=" + bytesLoaded + "; bytesTotal=" + bytesTotal;
		}
	}	
}
