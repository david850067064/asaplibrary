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
 /**
  * Array iteration/enumeration classes.
  */
package org.asaplibrary.data.array {
	import org.asaplibrary.data.BaseEnumerator;

	import flash.utils.getQualifiedClassName;

	/**
	Straightforward enumeration (iterator) class for arrays. ArrayEnumerator has one way of iterating: forward (using {@link #getNextObject}). For more options see {@link TraverseArrayEnumerator}.
	 */
	public class ArrayEnumerator extends BaseEnumerator {
		protected var mObjects : Array;
		/**< Pointer to external array. */
		protected var mLocation : int;

		/**
		Creates a new array enumerator. Optionally stores a pointer to array inArray.
		@param inArray : (optional) the array to enumerate
		 */
		public function ArrayEnumerator(inObjects : Array = null) {
			super();
			if (inObjects) {
				setObjects(inObjects);
			}
		}

		/**
		Stores a pointer to array inArray.
		@param inArray : the array to enumerate
		 */
		public function setObjects(inObjects : Array) : void {
			mObjects = inObjects;
			reset();
		}

		/**
		Retrieves the object from the array at the current pointer location.
		@return (Deliberately untyped) The object from the array at the current pointer location.
		 */
		public override function getCurrentObject() : * {
			if (mLocation == -1) {
				return null;
			}
			return mObjects[mLocation];
		}

		/**
		Increments the location pointer by one and returns the object from the array at that location.
		@return (Deliberately untyped) The object at the new location. Returns null if the location pointer has moved past the end of the array.
		@implementationNote Calls {@link #update}.
		 */
		public override function getNextObject() : * {
			if (mLocation < mObjects.length) {
				return update(mLocation + 1);
			}
			return null;
		}

		/**
		Retrieves all objects.
		@return The array as set in the constructor or in {@link #setObjects}.
		 */
		public override function getAllObjects() : Array {
			return mObjects;
		}

		/**
		Puts the enumerator just before the first array item. At this point calling {@link #getCurrentObject} will generate an error; you must first move the enumerator using {@link #getNextObject}.
		@implementationNote Calls {@link #update}.	
		 */
		public override function reset() : void {
			update(-1);
		}

		/**
		@return The current position of the array location pointer.
		 */
		public function getCurrentLocation() : int {
			return mLocation;
		}

		/**
		Sets the location pointer to a new position.
		@param inLocation : the new pointer location
		@implementationNote Calls {@link #update}.
		 */
		public function setCurrentLocation(inLocation : int) : void {
			update(inLocation);
		}

		/**
		Sets the location pointer to the location (in the array) of inObject.
		@param inObject : the object whose index the location pointer should point to
		@implementationNote Calls {@link #update}.
		 */
		public function setCurrentObject(inObject : Object) : void {
			var index : int = mObjects.indexOf(inObject);
			if (index != -1) {
				update(index);
			}
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this) + "; objects " + mObjects;
		}

		/**
		Updates the location pointer to a new index location.
		@param inLocation : the new index location
		@sends TraverseArrayEnumeratorEvent#UPDATE If the delegate validation method exists and only if the delegate method returns true.
		 */
		private function update(inLocation : int) : * {
			mLocation = inLocation;
			return getCurrentObject();
		}
	}
}