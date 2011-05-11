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
package org.asaplibrary.data {
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	Base class for enumerator objects.
	 */
	public class BaseEnumerator extends EventDispatcher {
		/**
		Retrieves the object at the current pointer position.
		 */
		public function getCurrentObject() : * {
			return null;
		}

		/**
		Moves the pointer forward and returns the object at that position.
		 */
		public function getNextObject() : * {
			return null;
		}

		/**
		Creates an array of all objects. Original input order may not be preserved.
		 */
		public function getAllObjects() : Array {
			return null;
		}

		/**
		Sets pointer position before the beginning of the first item.
		 */
		public function reset() : void {
			//
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}