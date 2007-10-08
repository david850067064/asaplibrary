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

package org.asaplibrary.util.loader {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	
	public class AssetLoaderEvent extends Event {
		/** Generic event type */
		public static var _EVENT:String = "onLoaderStackEvent";
	
		/** event sent when a single object starts being loaded */
		public static var START:String = "loadStart";
		/** event sent during loading */
		public static var PROGRESS:String = "loadProgress";
		/** event sent when loading is done */
		public static var COMPLETE:String = "loadDone";
		/** event sent when all objects have been loaded */
		public static var ALL_LOADED:String = "allLoadFinished";
		/** event sent when there's an error */
		public static var ERROR:String = "loadError";

		public var subtype : String;
		public var name : String;
		public var totalBytesCount : uint;
		public var loadedBytesCount : uint;
		public var error:String;
		public var loader:Loader;
		public var asset:DisplayObject;
	
		public function AssetLoaderEvent (inSubtype:String, inName:String = "") {
			super(_EVENT);
			
			subtype = inSubtype;
			name = inName;
		}
		
		public override function toString ():String {
			return "org.asaplibrary.util.loader.AssetLoaderEvent; name=" + name + "; subtype=" + subtype + "; error=" + error + "; totalBytesCount=" + totalBytesCount + "; loadedBytesCount=" + loadedBytesCount;
		}
	}
}