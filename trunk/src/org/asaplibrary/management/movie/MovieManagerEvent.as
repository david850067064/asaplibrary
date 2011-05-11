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
package org.asaplibrary.management.movie {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	Event object sent by {@link MovieManager}. Subscribe to type <code>_EVENT</code>.
	@example
	<code>
	MovieManager.getInstance().addEventListener( MovieManagerEvent._EVENT, onMovieEvent );
	</code>
	Listen for movie events:
	<code>
	protected function onMovieEvent (e:MovieManagerEvent) {
	if (e.subtype == MovieManagerEvent.MOVIE_READY) {
	showMovie(e.controller);
	}
	}
	
	protected function showMovie (inController:ILocalController) : void {
	var lc:LocalController = inController as LocalController;
	// etcetera
	}
	</code>
	 */
	public class MovieManagerEvent extends Event {
		/** Event type. */
		public static const _EVENT : String = "onMovieManagerEvent";
		/** Event subtype sent when the SWF asset has been loaded. */
		public static const MOVIE_LOADED : String = "movieLoaded";
		/** Event subtype sent when the LocalController has been registered to the MovieManager. */
		public static const CONTROLLER_INITIALIZED : String = "controllerInitialized";
		/** Event subtype sent when the LocalController is ready to start. */
		public static const MOVIE_READY : String = "movieReady";
		/** Event subtype sent on loading error. */
		public static const ERROR : String = "error";
		public var subtype : String;
		public var name : String;
		public var controller : ILocalController;
		public var container : DisplayObject;
		public var error : String;

		/**
		Creates a new MovieManagerEvent.
		@param inSubtype: either subtype; see above
		@param inName: name of the ILocalController
		@param inController: (optional) reference to the ILocalController (if any)
		@param inContainer: (optional) the hosting container (if any)
		@param inError: (optional) {@link AssetLoaderEvent} error (if any)
		 */
		public function MovieManagerEvent(inSubtype : String, inName : String, inController : ILocalController = null, inContainer : DisplayObject = null, inError : String = null) {
			super(_EVENT);
			subtype = inSubtype;
			name = inName;
			controller = inController;
			container = inContainer;
			error = inError;
		}

		public override function toString() : String {
			return getQualifiedClassName(this) + "; subtype=" + subtype + "; name=" + name + "; controller=" + controller + "; container=" + container + "; error=" + error;
		}

		/**
		Creates a copy of an existing MovieManagerEvent.
		 */
		public override function clone() : Event {
			return new MovieManagerEvent(subtype, name, controller, container, error);
		}
	}
}
