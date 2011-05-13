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
	import org.asaplibrary.data.URLData;
	import org.asaplibrary.util.debug.Log;

	import flash.events.EventDispatcher;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	Base class for loading XML data, with or without parameters. Extend this class to create a proper service for use in a MVCS-patterned application.
	The base class provides functionality for transferring an Object with parameters to the request, loading the XML, a virtual function for parsing the result, parsing a list, and error handling on response & parsing.
	When extending this class, the function <code>protected function processData (inData:XML, inName:String) : void;</code> has to be overridden & implemented to handle a successful load. When parsing a list of XMl nodes into an array of objects of one class, the <code>parseList()</code> function can be used.
	 */
	public class Service extends EventDispatcher {
		private var mLoader : XMLLoader;

		public function Service() {
			super();

			mLoader = new XMLLoader();
			mLoader.addEventListener(XMLLoaderEvent._EVENT, handleLoaderEvent);
		}

		/**
		 *	Load from specified location, optionally with specified parameters
		 *	@param inURLData: url of xml data to be loaded
		 *	@param inPostData: optional object containing parameters to be posted
		 *	@param inShowLog: if true, a Log.info message is produced containing url & name
		 *	@param inDoPost: if true, a POST is used as request method, otherwise GET
		 */
		public function load(inURLData : URLData, inSendData : Object = null, inShowLog : Boolean = false, inDoPost : Boolean = false) : void {
			// copy input object to URLVariables object
			var vars : URLVariables;
			if (inSendData) {
				vars = new URLVariables();
				for (var s : String in inSendData) {
					vars[s] = inSendData[s];
				}
			}

			if (inShowLog) Log.info("load: '" + inURLData.name + "' from " + inURLData.url, toString());

			mLoader.loadXML(inURLData.url, inURLData.name, vars, inDoPost ? URLRequestMethod.POST : URLRequestMethod.GET);
		}

		/**
		 * Set the number of parallel loaders
		 */
		public function setLoaderCount(inLoaderCount : int) : void {
			mLoader.setLoaderCount(inLoaderCount);
		}

		private function handleLoaderEvent(event : XMLLoaderEvent) : void {
			switch (event.subtype) {
				case XMLLoaderEvent.ERROR:
					handleLoadError(event);
					break;
				case XMLLoaderEvent.COMPLETE:
					processData(event.data, event.name);
					break;
				case XMLLoaderEvent.ALL_COMPLETE:
					dispatchEvent(new ServiceEvent(ServiceEvent.ALL_COMPLETE, event.name));
					break;
			}
		}

		/**
		 *	Override this function to perform specific xml parsing
		 */
		protected function processData(inData : XML, inName : String) : void {
			Log.warn("processData: override this function", toString());
		}

		/**
		 *	Handle load error event
		 */
		private function handleLoadError(event : XMLLoaderEvent) : void {
			Log.error("handleLoadError: " + event.error, toString());

			dispatchEvent(new ServiceEvent(ServiceEvent.LOAD_ERROR, event.name, null, null, event.error));
		}

		/**
		 *  Helper function
		 *	Parse a list into a vo class
		 *	If an error occurs, handleDataParseError() is called
		 *	@param o: the repeatable xml node
		 *	@param inClass: the class to use to parse the data
		 *	@param inName: the name of the loaded data
		 *	@param inSendEvent: if true, a ServiceEvent is sent when parsing is successful
		 *	@return the list of objects of specified class, or null if an error occurred
		 */
		protected function parseList(inList : XMLList, inClass : Class, inName : String, inSendEvent : Boolean = true) : Array {
			var a : Array = Parser.parseList(inList, inClass);

			if (a == null) {
				handleDataParseError(inName);
				return null;
			}

			// send event we're done
			if (inSendEvent) dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, inName, a, null));

			return a;
		}

		/**
		 *	Handle error occurred during parsing of data
		 */
		protected function handleDataParseError(inName : String) : void {
			Log.error("handleDataParseError: error parsing xml with name '" + inName + "'", toString());

			var error : String = "The XML was well-formed but incomplete. Be so kind and check it. It goes by the name of " + inName;
			var e : ServiceEvent = new ServiceEvent(ServiceEvent.PARSE_ERROR, inName, null, null, error);
			dispatchEvent(e);
		}
	}
}
