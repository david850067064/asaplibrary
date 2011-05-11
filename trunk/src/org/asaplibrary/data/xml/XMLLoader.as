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
	import org.asaplibrary.util.debug.Log;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;

	/**
	Loads XML data.
	@example
	<code>
	var xmlLoader:XMLLoader = new XMLLoader();
	xmlLoader.addEventListener(XMLLoaderEvent._EVENT, handleXMLLoaded);
	xmlLoader.loadXML("data.xml");
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
	public class XMLLoader extends EventDispatcher {
		private var mWaitingStack : Array = new Array();
		private var mLoadingStack : Array = new Array();
		private var mLoaderCount : int;

		/**
		 * @param	inLoaderCount: number of parallel loaders
		 */
		public function XMLLoader(inLoaderCount : int = 1) {
			mLoaderCount = inLoaderCount;
		}

		public function setLoaderCount(inLoaderCount : Number) : void {
			mLoaderCount = inLoaderCount;
		}

		/**
		 * Load XML
		 * @param	inURL: source url of the XML
		 * @param	inName: (optional) unique identifying name
		 * @param	inVariables: (optional) <code>URLVariables</code> object to be sent to the server
		 * @param inRequestMethod: (optional) <code>URLRequestMethod</code> POST or GET; default: GET
		 */
		public function loadXML(inURL : String, inName : String = "", inVariables : URLVariables = null, inRequestMethod : String = URLRequestMethod.GET) : void {
			// Check if url is valid
			if ((inURL == null) || (inURL.length == 0)) {
				Log.error("loadXML: url is not valid", toString());
				// dispatch error event
				var event : XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.ERROR, inName);
				event.error = "invalid url";
				dispatchEvent(event);

				return;
			}

			var xld : XMLLoaderData = new XMLLoaderData(inURL, inName, inVariables, inRequestMethod);
			mWaitingStack.push(xld);

			loadNext();
		}

		/**
		 * Load next xml while the waiting stack is not empty.
		 */
		private function loadNext() : void {
			// quit if all loaders taken
			if (mLoadingStack.length == mLoaderCount) return;

			// quit if no waiting data
			if (mWaitingStack.length == 0) return;

			// get the data
			var xld : XMLLoaderData = mWaitingStack.shift() as XMLLoaderData;

			// create loader
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleURLLoaderEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleURLLoaderEvent);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderEvent);
			loader.addEventListener(ProgressEvent.PROGRESS, handleURLLoaderProgressEvent);

			// create request
			var request : URLRequest = new URLRequest(xld.url);
			if (xld.variables != null) request.data = xld.variables;
			request.method = xld.requestMethod;

			// store loader in data
			xld.loader = loader;

			// store data in loading stack
			mLoadingStack.push(xld);

			// start loading
			loader.load(request);
		}

		/**
		 * Handle events from URLLoader
		 * @param	inEvent: Event sent 
		 */
		private function handleURLLoaderEvent(inEvent : Event) : void {
			// get loader
			var loader : URLLoader = inEvent.target as URLLoader;

			// get data for loader
			var xld : XMLLoaderData = getDataForLoader(loader);
			if (xld == null) {
				Log.error("handleURLLoaderEvent: data for loader not found", toString());
				event = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name);
				dispatchEvent(event);
				return;
			}

			// check if an IOError occurred
			var event : XMLLoaderEvent;
			if (inEvent is ErrorEvent) {
				// fill error event
				var errorEvent : ErrorEvent = inEvent as ErrorEvent;
				event = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name);
				event.error = errorEvent.text;
			} else {
				try {
					// notify we're done loading this xml
					event = new XMLLoaderEvent(XMLLoaderEvent.COMPLETE, xld.name, new XML(loader.data));
				} catch (error : Error) {
					Log.error("An error has occurred : " + error.message, toString());
					event = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name, null);
					event.error = error.message;
				}
			}
			dispatchEvent(event);

			// remove data from stack
			mLoadingStack.splice(mLoadingStack.indexOf(xld), 1);

			// continue loading
			loadNext();

			// check if we're done loading
			if ((mWaitingStack.length == 0) && (mLoadingStack.length == 0)) {
				dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.ALL_COMPLETE, xld.name));
			}
		}

		/**
		 * Handle ProgressEvent from URLLoader
		 * @param	inEvent: ProgressEvent sent
		 */
		private function handleURLLoaderProgressEvent(inEvent : ProgressEvent) : void {
			// get loader
			var loader : URLLoader = inEvent.target as URLLoader;

			// get data for loader
			var xld : XMLLoaderData = getDataForLoader(loader);
			if (xld == null) {
				Log.error("handleURLLoaderProgressEvent: data for loader not found", toString());
				return;
			}

			// create & dispatch event with relevant data
			var event : XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.PROGRESS, xld.name);
			event.bytesLoaded = inEvent.bytesLoaded;
			event.bytesTotal = inEvent.bytesTotal;
			dispatchEvent(event);
		}

		/**
		 * Get the data block in the loading stack for the specified URLLoader
		 * @param	inLoader: URLLoader
		 * @return the data, or null if none was found
		 */
		private function getDataForLoader(inLoader : URLLoader) : XMLLoaderData {
			var len : int = mLoadingStack.length;
			for (var i : int = 0; i < len; i++) {
				var xld : XMLLoaderData = mLoadingStack[i] as XMLLoaderData;
				if (xld.loader == inLoader) return xld;
			}
			return null;
		}

		public override function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import flash.net.URLLoader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

class XMLLoaderData {
	public var url : String;
	public var name : String;
	public var variables : URLVariables;
	public var loader : URLLoader;
	public var requestMethod : String;

	public function XMLLoaderData(inURL : String, inName : String, inVariables : URLVariables = null, inRequestMethod : String = URLRequestMethod.GET) {
		url = inURL;
		name = inName;
		variables = inVariables;
		requestMethod = inRequestMethod;
	}
}