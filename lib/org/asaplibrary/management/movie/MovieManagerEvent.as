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

package org.asaplibrary.management.movie {

	import flash.display.DisplayObject;
	import flash.events.Event;

	public class MovieManagerEvent extends Event {

		public static const _EVENT:String = "onMovieManagerEvent";
		
		public static const MOVIE_LOADED:String = "movieLoaded";
		public static const CONTROLLER_INITIALIZED:String = "controllerInitialized";
		public static const MOVIE_READY:String = "movieReady";
		public static const ERROR:String = "error";
		
		public var subtype:String;
		public var name:String;
		public var container:DisplayObject;
		public var controller:LocalController;
		public var error:String;
		
		public function MovieManagerEvent (inSubtype:String, inName:String) {
			super(_EVENT);
			subtype = inSubtype;
			name = inName;
		}
		
		public override function toString ():String {
			return "org.asaplibrary.management.movie.MovieManagerEvent; name=" + name + "; subtype=" + subtype + "; error=" + error + "; controller=" + controller + "; container=" + container;
		}
		
		public override function clone() : Event {
			return new MovieManagerEvent(subtype, name);
		} 
	}
	
}
