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
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.loader.AssetLoaderEvent;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	MovieManager handles administration, loading and retrieving of separate SWF movies.
	
	Start the loading process by calling {@link #loadMovie}.
	After this, three events of type {@link MovieManagerEvent} can be expected: when the movie has been {@link MovieManagerEvent#CONTROLLER_INITIALIZED initialized}, has been {@link MovieManagerEvent#MOVIE_LOADED loaded}, and is {@link MovieManagerEvent#MOVIE_READY ready}.
	Ready is defined as both initialized and loaded.

	Once a movie has been loaded, its {@link LocalController} reference is sent with the MovieManagerEvent, or can be retrieved by name.

	Naming of movies:
	- use a unique name for each movie
	- use publicly accessible constants for movie names. This makes it easier to change names throughout the application.
	- the name has to be given when loading the movie with MovieManager.getInstance().loadMovie(). 
	This means the local controller of a standalone running movie does not have a name. 
	This can be circumvented (if necessary) by giving the local controller its name locally when it is running standalone. 
	ILocalController has a function isStandalone() for checking this.
	
	@usage
	Subscribe to MovieManager events:
	<code>
	MovieManager.getInstance().addEventListener(MovieManagerEvent._EVENT, handleMovieManager);
	</code>
	Load SWF movie named "home.swf":
	<code>
	MovieManager.getInstance().loadMovie("home.swf", "home");
	</code>
	Handle the movie event and place the movie onto the stage:
	<code>
	private function handleMovieManager(e : MovieManagerEvent) : void {
	if (e.subtype != MovieManagerEvent.MOVIE_READY) return;
	addChild(e.container);
	}
	</code>
	 */
	public class MovieManager extends EventDispatcher {
		/**
		List of type {@link MovieData}.
		 */
		private var mMovies : Array = new Array();
		/**
		The {@link AssetLoader loader} for SWFs.
		 */
		private var mLoader : AssetLoader;
		private static var mInstance : MovieManager = null;

		/**
		Access point for the one instance of the MovieManager.
		 */
		public static function getInstance() : MovieManager {
			if (mInstance == null) {
				mInstance = new MovieManager();
			}

			return mInstance;
		}

		/**
		The {@link AssetLoader} loader class used by MovieManager.
		 */
		public function getLoader() : AssetLoader {
			return mLoader;
		}

		/**
		Start loading the movie with path inURL, and adds it to the list of movies under the name inName
		@param inName: unique identifying name for the movie to be loaded
		@param inURL: url where the swf can be found
		@return False if the loader cannot load the movie, or the movie could not be added to the list (usually because another or the same movie with the same name exists already); otherwise true.
		 */
		public function loadMovie(inURL : String, inName : String) : Boolean {
			// try adding
			if (!addMovie(inName)) {
				return false;
			}
			// start loading
			mLoader.loadAsset(inURL, inName);

			return true;
		}

		/**
		Find the movie with the specified name, container or controller, remove the object from the display list and remove the movie data from the list of movies
		After this action, a movie has to be loaded again using loadMovie()
		It is not checked whether a movie is being loaded, has been loaded or has been started, so this is tricky when a movie is in the loader
		@param inMovie either :String: the name used as identifier for the movie to be removed, :LocalController: the LocalController or :DisplayObject: the asset that was originally loaded
		@return : false if the movie wasn't found, true otherwise
		 */
		public function removeMovie(inMovie : *) : Boolean {
			// retrieve data block depending on type of inMovie
			var md : MovieData;

			if (inMovie is ILocalController) {
				md = getMovieDataByController(inMovie as ILocalController);
				if (md == null) {
					Log.error("removeMovie; data for controller '" + inMovie + "' not found", toString());
					return false;
				}
			} else if (inMovie is String) {
				md = getMovieDataByName(inMovie as String);
				if (md == null) {
					Log.error("removeMovie; data for movie with name '" + inMovie + "' not found", toString());
					return false;
				}
			} else if (inMovie is DisplayObject) {
				md = getMovieDataByContainer(inMovie as DisplayObject);
				if (md == null) {
					Log.error("removeMovie; data for movie for container '" + inMovie + "' not found", toString());
					return false;
				}
			} else {
				Log.error("removeMovie; no string or movieclip passed to function", toString());
				return false;
			}

			// tell the controller to cleanup after itself
			md.controller.die();

			// remove the asset from the display list
			// only if the parent node is not (still) the Loader
			if (md.container.parent && !(md.container.parent is Loader)) {
				md.container.parent.removeChild(md.container);
			}

			// remove from list of data objects
			mMovies.splice(mMovies.indexOf(md), 1);

			return true;
		}

		/**
		Finds a LocalController by name.
		@param inName: name of the LocalController
		@param inSuppressWarning: do not emit a Log warning if the movie is not found; default false (a warning is given)
		@return The controller for that movie, or null if no controller could be found.
		 */
		public function getLocalControllerByName(inName : String, inSuppressWarning : Boolean = false) : ILocalController {
			var md : MovieData = getMovieDataByName(inName);
			if (md == null) {
				if (!inSuppressWarning) {
					Log.warn("getLocalControllerByName; controller with name '" + inName + "' not found.", toString());
				}
				return null;
			}
			return md.controller;
		}

		/**
		Add a specific LocalController; used by standalone LocalControllers to notify its existence to the MovieManager.
		@param inController: the LocalController to add
		 */
		public function addLocalController(inController : ILocalController) : void {
			// check if movie has been added previously via loadMovie()
			var md : MovieData = getMovieDataByContainer(inController as DisplayObject);
			if (md == null) {
				// create new data for movie
				md = new MovieData("");
				mMovies.push(md);
			}
			// store controller only if not stored during handleMovieLoaded
			if (md.controller == null) {
				storeLocalController(inController, md);
			}
		}

		/**
		Adds a movie with specified properties to the list, after checking if a movie with the same name already exists.
		@param inURL: url where the swf can be found
		@param inName: unique identifying name for the movie to be loaded
		@return False if another movie with the same name exists in the list; otherwise true.
		 */
		private function addMovie(inName : String) : Boolean {
			var md : MovieData = getMovieDataByName(inName);
			if (md != null) {
				Log.error("addMovie; movie with name '" + inName + "' is already added to MovieManager", toString());
				return false;
			}

			// create & store data
			md = new MovieData(inName);
			mMovies.push(md);

			return true;
		}

		/**
		Find a MovieData object for specified name.
		@param inName: name of the LocalController
		@return MovieData with attribute name as inName; or null if none could be found.
		 */
		private function getMovieDataByName(inName : String) : MovieData {
			var len : int = mMovies.length;
			for (var i : int = 0; i < len; i++) {
				var md : MovieData = mMovies[i] as MovieData;
				if (md.name == inName) return md;
			}
			return null;
		}

		/**
		Find MovieData object for specified controller.
		@param inName: name of the LocalController
		@return MovieData object, or null if none could be found.
		 */
		private function getMovieDataByController(inController : ILocalController) : MovieData {
			var len : int = mMovies.length;
			for (var i : int = 0; i < len; i++) {
				var md : MovieData = mMovies[i] as MovieData;
				if (md.controller == inController) return md;
			}
			return null;
		}

		/**
		Find MovieData object for specified container
		@param inName: name of the LocalController
		@return MovieData object, or null if none could be found.
		 */
		private function getMovieDataByContainer(inObject : DisplayObject) : MovieData {
			var len : int = mMovies.length;
			for (var i : int = 0; i < len; i++) {
				var md : MovieData = mMovies[i] as MovieData;
				if (md.container == inObject) return md;
			}
			return null;
		}

		/**
		Handle AssetLoaderEvent from {@link AssetLoader}.
		@param e: event sent by AssetLoader
		 */
		private function handleLoaderEvent(e : AssetLoaderEvent) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.ERROR:
					handleLoaderError(e);
					break;
				case AssetLoaderEvent.COMPLETE:
					handleMovieLoaded(e);
					break;
			}
		}

		/**
		Handle errors during loading.
		@param e: event sent by AssetLoader
		@sends MovieManagerEvent#ERROR
		 */
		private function handleLoaderError(e : AssetLoaderEvent) : void {
			var evt : MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.ERROR, e.name);
			evt.error = e.error;
			dispatchEvent(evt);
		}

		/**
		Handle event that the movie has been loaded.
		@param e: event sent by AssetLoader
		@sends MovieManagerEvent#MOVIE_LOADED
		 */
		private function handleMovieLoaded(e : AssetLoaderEvent) : void {
			var md : MovieData = getMovieDataByName(e.name);

			if (md == null) {
				Log.error("handleMovieLoaded: MovieData for name = '" + e.name + "' not found", toString());
				return;
			}

			// store asset
			md.container = e.asset;

			// store controller if container is controller and controller hasn't been set by addLocalController
			if ((md.container is ILocalController) && (md.controller == null)) {
				storeLocalController(md.container as ILocalController, md);
			}

			// dispatch event
			var evt : MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.MOVIE_LOADED, e.name);
			evt.container = e.asset;
			dispatchEvent(evt);

			// check if all done
			checkLoadProgress(md);
		}

		/**
		Set LocalController for specified data object.
		@param inController: the LocalController to store
		@param inData: the corresponding MovieData
		@sends MovieManagerEvent#CONTROLLER_INITIALIZED
		 */
		private function storeLocalController(inController : ILocalController, inData : MovieData) : void {
			// set name of local controller
			if (inController.getName.length == 0) {
				inController.setName(inData.name);
			}
			// store local controller in data
			inData.controller = inController;

			// dispatch event
			var e : MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.CONTROLLER_INITIALIZED, inData.name);
			e.controller = inController;
			dispatchEvent(e);
		}

		/**
		Checks if the movie has been fully loaded and the LocalController is known.
		@sends MovieManagerEvent#MOVIE_READY
		 */
		private function checkLoadProgress(inData : MovieData) : void {
			if ((inData.controller != null) && (inData.container != null)) {
				var e : MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.MOVIE_READY, inData.name);
				e.controller = inData.controller;
				e.container = inData.container;
				dispatchEvent(e);
			}
		}

		/**
		Supposedly private constructor
		 */
		function MovieManager() {
			super();

			// create loader & listen to events
			mLoader = new AssetLoader();
			mLoader.addEventListener(AssetLoaderEvent._EVENT, handleLoaderEvent);
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import org.asaplibrary.management.movie.*;

import flash.display.DisplayObject;
import flash.utils.getQualifiedClassName;

/**
Helper data container.
 */
class MovieData {
	public var name : String;
	public var controller : ILocalController;
	public var container : DisplayObject;

	/**
	@param inName: name of the ILocalController
	 */
	public function MovieData(inName : String) {
		name = inName;
	}

	public function toString() : String {
		return getQualifiedClassName(this) + ": name=" + name + "; controller=" + controller + "; container=" + container;
	}
}
