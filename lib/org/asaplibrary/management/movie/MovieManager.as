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
	import flash.events.EventDispatcher;
	import org.asaplibrary.util.loader.AssetLoader;
	import org.asaplibrary.util.loader.AssetLoaderEvent;
	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.util.debug.Log;

	public class MovieManager extends EventDispatcher {
	
		/** MovieData */
		private var mMovies:Array = new Array();
		private var mLoader:AssetLoader;
		
		private static var mInstance:MovieManager = null;

		
		/**
		Access point for the one instance of the MovieManager
		*/
		public static function getInstance () : MovieManager {
			if (mInstance == null) {
				mInstance = new MovieManager();
			}

			return mInstance;
		}

		/**
		The {@link org.asaplibrary.util.loader.AssetLoader} loader class used by MovieManager.
		*/
		public function getLoader () : AssetLoader {
			return mLoader;
		}
		
		/**
		Start loading the movie with path inSource.url, and adds it to the list of movies under the name inSource.name
		@param inName: unique identifying name for the movie to be loaded
		@param inURL: url where the swf can be found
		@param inIsVisible: visibility of movie when loaded, default = true
		@return: false if the loader cannot load the movie, or the movie could not be added to the list (usually because another or the same movie with the same name exists already), otherwise true
		*/
		public function loadMovie (inURL:String,
								   inName:String,
								   inIsVisible:Boolean = true) : Boolean {
			// try adding
			if (!addMovie(inURL, inName)) {
				return false;
			}

			// start loading
			mLoader.loadAsset(inURL, inName, inIsVisible);

			return true;
		}

		/**
		Find the movie with the specified name, container or controller, remove the object from the display list and remove the movie data from the list of movies
		After this action, a movie has to be loaded again using loadMovie()
		It is not checked whether a movie is being loaded, has been loaded or has been started, so this is tricky when a movie is in the loader
		@param inMovie either :String: the name used as identifier for the movie to be removed, :LocalController: the LocalController or :DisplayObject: the asset that was originally loaded
		@return : false if the movie wasn't found, true otherwise
		*/
		public function removeMovie (inMovie:*) : Boolean {
			// retrieve data block depending on type of inMovie
			var md:MovieData;

			if (inMovie is LocalController) {
				md = getMovieDataByController(inMovie as LocalController);
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
			md.container.parent.removeChild(md.container);
			
			// remove from list of data objects
			mMovies.splice(mMovies.indexOf(md), 1);
			
			return true;
		}
		
		/**
		Finds a local controller by name
		@param inName: unique identifier for the loaded movie
		@returns The controller for that movie, or null if none was found
		*/
		public function getLocalControllerByName (inName:String) : LocalController {
			var md:MovieData = getMovieDataByName(inName);
			if (md == null) {
				Log.warn("getLocalControllerByName; controller with name '" + inName + "' not found.", toString());
				return null;
			}

			return md.controller;
		}
		
		/**
		* Add a specific controller; used by standalone LocalController to notify its existence to the MovieManager
		* @param	inController
		*/
		public function addLocalController (inController:LocalController) : void {
			// check if movie has been added previously via loadMovie() 
			var md:MovieData = getMovieDataByContainer(inController as DisplayObject);
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
		Adds a movie with specified properties to the list, after checking if a movie with the same name exists already
		@param inName: unique identifying name for the movie to be loaded
		@param inURL: url where the swf can be found
		@return : false if another movie with the same name exists in the list, otherwise true
		*/
		private function addMovie (inURL:String, inName:String) : Boolean {
			var md:MovieData = getMovieDataByName(inName);
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
		* Find MovieData object for specified name
		* @param	inName
		* @return data object, or null if none was found
		*/
		private function getMovieDataByName (inName:String) : MovieData {
			var len:int = mMovies.length;
			for (var i:int = 0; i < len; i++) {
				var md:MovieData = mMovies[i] as MovieData;
				if (md.name == inName) return md;
			}
			return null;
		}

		/**
		* Find MovieData object for specified controller
		* @param	inName
		* @return data object, or null if none was found
		*/
		private function getMovieDataByController (inController:LocalController) : MovieData {
			var len:int = mMovies.length;
			for (var i:int = 0; i < len; i++) {
				var md:MovieData = mMovies[i] as MovieData;
				if (md.controller == inController) return md;
			}
			return null;
		}

		/**
		* Find MovieData object for specified container
		* @param	inName
		* @return data object, or null if none was found
		*/
		private function getMovieDataByContainer (inObject:DisplayObject) : MovieData {
			var len:int = mMovies.length;
			for (var i:int = 0; i < len; i++) {
				var md:MovieData = mMovies[i] as MovieData;
				if (md.container == inObject) return md;
			}
			return null;
		}

		/**
		* Handle AssetLoaderEvent from AssetLoader
		* @param	e
		*/
		private function handleLoaderEvent (e:AssetLoaderEvent) : void {
			switch (e.subtype) {
				case AssetLoaderEvent.ERROR: handleLoaderError(e); break;
				case AssetLoaderEvent.COMPLETE: handleMovieLoaded(e); break;
			}
		}
		
		/**
		* Handle error during loading
		* @param	e
		* @return
		*/
		private function handleLoaderError (e:AssetLoaderEvent) : void {
			var evt:MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.ERROR, e.name);
			evt.error = e.error;
			dispatchEvent(evt);
		}
		
		private function handleMovieLoadingStarted (e:AssetLoaderEvent) : void {
		}
		
		/**
		* Handle event that movie has been loaded
		* @param	e
		* @return
		*/
		private function handleMovieLoaded (e:AssetLoaderEvent) : void {
			var md:MovieData = getMovieDataByName(e.name);
			if (md == null) {
				Log.error("handleMovieLoaded: MovieData for name = '" + e.name + "' not found", toString());
				return;
			}
			
			// store asset
			md.container = e.asset;
			
			// store controller if container is controller and controller hasn't been set by addLocalController
			if ((md.container is LocalController) && (md.controller == null)) {
				storeLocalController(md.container as LocalController, md);
			}

			// dispatch event
			var evt:MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.MOVIE_LOADED, e.name);
			evt.container = e.asset;
			dispatchEvent(evt);
			
			// check if all done
			checkLoadProgress(md);
		}
		
		/**
		* Set local controller for specified data object
		* @param	inController
		* @param	inData
		*/
		private function storeLocalController (inController:LocalController, 
											   inData:MovieData) : void {
			// set name of local controller
			inController.setName(inData.name);

			// store local controller in data
			inData.controller = inController;
			
			// dispatch event 
			var e:MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.CONTROLLER_INITIALIZED, inData.name);
			e.controller = inController;
			dispatchEvent(e);
		}
		
		private function checkLoadProgress (inData:MovieData) : void {
			if ((inData.controller != null) && (inData.container != null)) {
				var e:MovieManagerEvent = new MovieManagerEvent(MovieManagerEvent.MOVIE_READY, inData.name);
				e.controller = inData.controller;
				e.container = inData.container;
				dispatchEvent(e);
			}
		}

		/**
		Supposedly private constructor
		*/
		function MovieManager () {
			super();

			// create loader & listen to events
			mLoader = new AssetLoader();
			mLoader.addEventListener(AssetLoaderEvent._EVENT, handleLoaderEvent);
		}
		
		override public function toString () : String {
			return ";org.asaplibrary.management.movie.MovieManager";
		}
	}
	
}

import org.asaplibrary.management.movie.LocalController;
import flash.display.DisplayObject;

class MovieData {
	public var name : String;
	public var controller : LocalController;
	public var container : DisplayObject;
	
	public function MovieData (inName:String) {
		name = inName;
	}
}