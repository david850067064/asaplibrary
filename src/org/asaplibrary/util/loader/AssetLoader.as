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
package org.asaplibrary.util.loader {
	import org.asaplibrary.util.debug.Log;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;

	/**
	Loads assets (SWF movies or supported image formats) into a clip. Multiple/subsequent added assets that are added are queued. AssetLoader can deal with multiple loading threads simultaneously (if passed to the constructor). The number of simultaneous loading processes is limited by the browser though.
	 */
	public class AssetLoader extends EventDispatcher {
		/** List of objects of type FileData. */
		private var mWaitingStack : Array = new Array();
		/** List of objects of type FileData. */
		private var mLoadingStack : Array = new Array();
		/** The number of simultaneous loader objects. */
		private var mLoaderCount : uint;

		/**
		Creates a new AssetLoader.
		@param inLoaderCount: number of parallel loaders
		 */
		public function AssetLoader(inLoaderCount : Number = 1) {
			mLoaderCount = inLoaderCount;
		}

		/**
		Loads an asset.
		@param inURL: source url of the file
		@param inName: (optional) unique identifying name
		@sends AssetLoaderEvent#ERROR
		 */
		public function loadAsset(inUrl : String, inName : String = "") : void {
			// Check if url is valid
			if ((inUrl == null) || (inUrl.length == 0)) {
				Log.error("loadXML: url is not valid", toString());
				// dispatch error event
				var e : AssetLoaderEvent = new AssetLoaderEvent(AssetLoaderEvent.ERROR, inName);
				e.error = "invalid url";
				dispatchEvent(e);

				return;
			}

			var fd : FileData = new FileData(inUrl, inName);
			mWaitingStack.push(fd);

			loadNext();
		}

		/**
		Stops loading of all loaders and clears the loading stack.
		 */
		public function stopLoadingAll() : void {
			var i : uint, ilen : uint = mLoadingStack.length;
			for (i = 0; i < ilen; ++i) {
				var loader : Loader = FileData(mLoadingStack[i]).loader;
				loader.close();
			}
			mLoadingStack = new Array();
		}

		/**
		Stops loading of asset with name inName.
		@param inName:	identifying name as passed to {@link #loadAsset}
		 */
		public function stopLoadingAsset(inName : String) : void {
			var i : uint, ilen : uint = mLoadingStack.length;
			for (i = 0; i < ilen; ++i) {
				if (FileData(mLoadingStack[i]).name == inName) {
					var loader : Loader = FileData(mLoadingStack[i]).loader;
					loader.close();
					mLoadingStack.splice(i, 1);
					return;
				}
			}
		}

		/**
		@return The total number of loaded bytes of all working Loader objects.
		 */
		public function getTotalBytesLoaded() : uint {
			return getTotalCount("bytesLoaded");
		}

		/**
		@return The total number of bytesTotal ("the compressed bytes in the entire media file") of all working Loader objects.
		 */
		public function getTotalBytesCount() : uint {
			return getTotalCount("bytesTotal");
		}

		/**
		@param inProperty: the LoaderInfo property; either "bytesLoaded" or "bytesTotal"
		@return The sum of numbers of this property.
		 */
		private function getTotalCount(inProperty : String) : uint {
			var count : uint = 0;
			var i : uint, ilen : uint = mLoadingStack.length;
			for (i = 0; i < ilen; ++i) {
				var loader : Loader = FileData(mLoadingStack[i]).loader;
				var info : LoaderInfo = loader.contentLoaderInfo;
				count += info[inProperty];
			}
			return count;
		}

		/**
		Load next asset if the waiting stack is not empty.
		@sends AssetLoaderEvent#ALL_LOADED
		 */
		private function loadNext() : void {
			// quit if all loaders taken
			if (mLoadingStack.length == mLoaderCount) return;

			// quit if no waiting data
			if (mWaitingStack.length == 0) {
				if (mLoadingStack.length == 0) {
					dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ALL_LOADED));
				}
				return;
			}

			// get next object to load
			var fd : FileData = mWaitingStack.shift() as FileData;

			// create loader object
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaderEvent);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, handleLoadStarted);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoaderProgressEvent);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderEvent);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderEvent);

			// store loader in data
			fd.loader = loader;

			// store object in loading list
			mLoadingStack.push(fd);

			// load object
			loader.load(new URLRequest(fd.url));
		}

		/**
		@sends AssetLoaderEvent#START
		 */
		private function handleLoadStarted(e : Event) : void {
			// get loader
			var info : LoaderInfo = e.target as LoaderInfo;

			// get data for loader
			var fd : FileData = getDataForLoaderInfo(info);
			if (fd == null) {
				Log.error("handleLoaderEvent: data for loader not found", toString());
				return;
			}

			// dispatch event we've started loading
			var evt : AssetLoaderEvent = new AssetLoaderEvent(AssetLoaderEvent.START, fd.name);
			evt.loader = fd.loader;
			evt.loadedBytesCount = 0;
			evt.totalBytesCount = 0;
			dispatchEvent(evt);
		}

		/**
		@sends AssetLoaderEvent#ERROR
		@sends AssetLoaderEvent#COMPLETE
		 */
		private function handleLoaderEvent(e : Event) : void {
			// get loader
			var info : LoaderInfo = e.target as LoaderInfo;

			// get data for loader
			var fd : FileData = getDataForLoaderInfo(info);
			if (fd == null) {
				Log.error("handleLoaderEvent: data for loader not found", toString());
				return;
			}

			// check if an IOError occurred
			var evt : AssetLoaderEvent;
			if (e is ErrorEvent) {
				// fill error event
				var errorEvent : ErrorEvent = e as ErrorEvent;
				evt = new AssetLoaderEvent(AssetLoaderEvent.ERROR, fd.name);
				evt.error = errorEvent.text;
			} else {
				// notify we're done loading this file
				evt = new AssetLoaderEvent(AssetLoaderEvent.COMPLETE, fd.name);
				evt.loader = fd.loader;
				evt.loaderInfo = info;
				evt.url = fd.url;
				// test url to see if this is an SWF
				var reSWF : RegExp = /^.*\.swf$/i;
				evt.asset = reSWF.test(evt.url) ? fd.loader.content : fd.loader;
			}
			dispatchEvent(evt);

			// remove data from stack
			mLoadingStack.splice(mLoadingStack.indexOf(fd), 1);

			// continue loading
			loadNext();
		}

		/**
		Handle ProgressEvent from Loader.
		@param e: ProgressEvent sent
		@sends AssetLoaderEvent#PROGRESS
		 */
		private function handleLoaderProgressEvent(e : ProgressEvent) : void {
			// get loader
			var info : LoaderInfo = e.target as LoaderInfo;

			// get data for loader
			var fd : FileData = getDataForLoaderInfo(info);
			if (fd == null) {
				Log.error("handleLoaderProgressEvent: data for loader not found", toString());
				return;
			}

			// create & dispatch event with relevant data
			var evt : AssetLoaderEvent = new AssetLoaderEvent(AssetLoaderEvent.PROGRESS, fd.name);
			evt.loader = fd.loader;
			evt.loadedBytesCount = e.bytesLoaded;
			evt.totalBytesCount = e.bytesTotal;
			dispatchEvent(evt);
		}

		/**
		Get the data block in the loading stack for the specified LoaderInfo
		@param inInfo: LoaderInfo
		@return The data, or null if none was found.
		 */
		private function getDataForLoaderInfo(inInfo : LoaderInfo) : FileData {
			var len : uint = mLoadingStack.length;
			for (var i : uint = 0; i < len; i++) {
				var fd : FileData = mLoadingStack[i] as FileData;
				if (fd.loader.contentLoaderInfo == inInfo) return fd;
			}
			return null;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import flash.display.Loader;

/**
Data object for AssetLoader.
 */
class FileData {
	public var loader : Loader;
	public var url : String;
	public var name : String;
	public var bytesTotal : Number;
	public var bytesLoaded : Number;

	public function FileData(inURL : String, inName : String) {
		url = inURL;
		name = inName;
	}
}