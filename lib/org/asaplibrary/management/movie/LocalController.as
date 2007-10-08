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
	
	import flash.display.MovieClip;
	import org.asaplibrary.management.movie.MovieManager;
	import org.asaplibrary.util.debug.Log;

	
	public class LocalController extends MovieClip implements ILocalController {
		private var mName : String;
		private var mIsStandalone : Boolean;


		public function LocalController () {
			// initialize standalone flag
			mIsStandalone = ((stage != null) && (parent == stage));
			
			// add to moviemanager if standalone
			if (isStandalone()) {
				MovieManager.getInstance().addLocalController(this);
			}
		}

		public function startMovie () : void {
			play();
		}

		public function stopMovie () : void {
			stop();
		}

		public function die () : void {
			//
		}

		public function getName () : String {
			return mName;
		}

		public function setName (inName:String) : void {
			mName = inName;
		}

		public function isStandalone () : Boolean {
			return mIsStandalone;
		}
	}
}
