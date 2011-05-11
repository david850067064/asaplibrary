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
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.getQualifiedClassName;

	/**
	(Virtual) base class for controlling movies locally, either independently or embedded.
	Extend this class for each separate movie in your project that requires certain complex controlled functionality.
	The base class takes care of communication with the MovieManager, so the movie is known to other movies.
	
	The LocalController functions as controller for everything that happens locally.
	For other movies, it functions as a Facade, hiding implementation of details.
	The preferred mode of communication with the LocalController is through events, to avoid having to know the actual specific interface.
	 */
	public class LocalController extends MovieClip implements ILocalController {
		/** Provide global access to the one and only stage */
		public static var globalStage : Stage;
		private var mName : String = "";
		private var mIsStandalone : Boolean;

		/**
		Creates a new LocalController.
		@param inName: (optional) unique identifying name
		 */
		public function LocalController() {
			// initialize standalone flag
			mIsStandalone = ((stage != null) && (parent == stage));

			// put the stage property into global space once if defined
			if ((stage != null) && (globalStage == null)) globalStage = stage;

			// add to moviemanager if standalone
			if (isStandalone()) {
				MovieManager.getInstance().addLocalController(this);
			}
		}

		/**

		 */
		public function startMovie() : void {
			play();
		}

		public function stopMovie() : void {
			stop();
		}

		/**
		To be implemented by subclasses.
		 */
		public function die() : void {
			//
		}

		/**
		@return The name of the LocalController.
		 */
		public function getName() : String {
			return mName;
		}

		/**
		Sets the name of the LocalController
		@param inName: new name of the controller
		 */
		public function setName(inName : String) : void {
			if (inName == null) return;
			mName = inName;
		}

		/**
		@return True if the LocalController is the Document class.
		 */
		public function isStandalone() : Boolean {
			return mIsStandalone;
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this) + ": " + getName();
		}
	}
}
