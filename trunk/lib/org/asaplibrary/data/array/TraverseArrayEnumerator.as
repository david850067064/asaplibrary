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

package org.asaplibrary.data.array {
	
	import org.asaplibrary.data.array.*;
	
	/**
	Enhanced array enumerator, with the option to loop. TraverseArrayEnumerator sends out traverse events of type {@link TraverseArrayEnumeratorEvent#UPDATE}.
	
	A TraverseArrayEnumerator can be used with a paging controller to navigate through a list of thumbs or search result pages.
	*/
	
	class TraverseArrayEnumerator extends ArrayEnumerator {
	
		private var mTraverseOptions:uint = TraverseArrayOptions.NONE;
		private var mDelegates:Array;
		
		/**
		Creates a new array enumerator. Optionally stores a pointer to array inArray.
		@param inObjects : (optional) the array to enumerate
		@param inDoLoop : if true, the enumerator will loop past the end of the array to the start (and back when traversing backwards)
		*/
		public function TraverseArrayEnumerator (inObjects:Array = null, 
												 inDoLoop:Boolean = false) {
			super(inObjects);
			mDelegates = new Array();
			setLoop(inDoLoop);
		}
		
		/**
		Sets the traversal options.
		@param inTraverseOptions: see {@link TraverseArrayOptions}
		*/
		public function setTraverseOptions (inTraverseOptions:uint) : void {
			mTraverseOptions = inTraverseOptions;
		}
		
		/**
		Set the looping property of the enumerator.
		@param inDoLoop : if true, the enumerator will loop past the end of the array to the start (and back when traversing backwards)
		@implementationNote Uses {@link TraverseArrayOptions#LOOP}.
		*/
		public function setLoop (inDoLoop:Boolean) : void {
			mTraverseOptions = (inDoLoop) ? TraverseArrayOptions.LOOP : TraverseArrayOptions.NONE;
		}
		
		/**
		Adds a delegate method to validate the current object. Each delegate method is called in {@link #update} when a delegate object is set. The delegate's validation method is called to evaluate the new node before it is set.
		@param inDelegateObject: the owner of the delegate method
		@param inDelegateMethod: validation method. This method should accept an Object as parameter and return a Boolean to indicate the item's validity.
		*/
		public function addDelegate (inDelegateObject:Object,
									 inDelegateMethod:Function) : void {
			var delegate:DelegateData = new DelegateData(inDelegateObject, inDelegateMethod);
			mDelegates.push(delegate);
		}
		
		/**
		Increments the location pointer by one and returns the object from the array at that location.
		@return (Deliberately untyped) The object at the new location. Returns null if the location pointer has moved past the end of the array and inTraverseOptions is not set to {@link TraverseArrayOptions#LOOP}.
		@implementationNote Calls {@link #update}.
		*/
		public override function getNextObject () : * {
			var nextLocation:int = indexOfNextObject();
			if (nextLocation != -1) {
				return update(nextLocation);
			}
			return null;
		}
		
		/**
		Decrements the location pointer by one and returns the object from the array at that location.
		@return (Deliberately untyped) The object at the new location. Returns null if the location pointer has moved past the end of the array and inTraverseOptions is not set to {@link TraverseArrayOptions#LOOP}.
		@implementationNote Calls {@link #update}.
		*/
		public function getPreviousObject () : * {
			var previousLocation:int = indexOfPreviousObject();
			if (previousLocation != -1) {
				return update(previousLocation);
			}
			return null;
		}
		
		/**
		Checks if there is an object after the current object.
		@return True: there is a next object; false: the current object is the last.
		*/
		public function hasNextObject () : Boolean {
			if (indexOfNextObject() != -1) {
				return true;
			}
			return false;
		}
		
		/**
		Checks if there is an object before the current object.
		@return True: there is a next object; false: the current object is the first.
		*/
		public function hasPreviousObject () : Boolean {
			if (indexOfPreviousObject() != -1) {
				return true;
			}
			return false;
		}
		
		/**
		@exclude
		*/
		public override function toString () : String {
			return "org.asaplibrary.data.array.TraverseArrayEnumerator; objects " + mObjects;
		}
		
		// PRIVATE METHODS
		
		/**
		@return The next location; -1 if the next location is not valid.
		*/
		private function indexOfNextObject () : int {
	
			var nextLocation:int = mLocation + 1;
			if (mTraverseOptions & TraverseArrayOptions.LOOP) {
				if (nextLocation == mObjects.length) {
					return 0;
				}
				return nextLocation;
			}
			if (mTraverseOptions & TraverseArrayOptions.NONE) {
				if (nextLocation < mObjects.length) {
					return nextLocation;
				}
			}
			return -1;
		}
		
		/**
		@return The previous location; -1 if the previous location is not valid.
		*/
		private function indexOfPreviousObject () : int {
			
			var previousLocation:int = mLocation - 1;
			if (mTraverseOptions & TraverseArrayOptions.LOOP) {
				if (previousLocation < 0) {
					return mObjects.length - 1;
				}
				return previousLocation;
			}
			if (mTraverseOptions & TraverseArrayOptions.NONE) {
				if (previousLocation >= 0) {
					return previousLocation;
				}
			}		
			return -1;
		}
		
		/**
		If a delegate object has been set, its validation method is called before setting the new node. If the validation method returns false, this method will return null
		@param inLocation: the new pointer position
		@return (Deliberately untyped) The object from the array at the new position.
		@sends TraverseArrayEnumeratorEvent#UPDATE If the delegate validation method exists and only if the delegate method returns true.
		*/
		private function update (inLocation:int) : * {
			
			var isValid:Boolean = true;
			
			var i:uint, ilen:uint = mDelegates.length;
			for (i=0; i<ilen; ++i) {
				var delegate:DelegateData = mDelegates[i] as DelegateData;
				var approved:Boolean =  Boolean(delegate.method.apply(delegate.object, [mObjects, inLocation]));
				if (!approved) {
					isValid = false;
				}
			}
			if (!isValid) {
				return null;
			}

			// else valid
			mLocation = inLocation;
			dispatchEvent(new TraverseArrayEnumeratorEvent(TraverseArrayEnumeratorEvent.UPDATE, getCurrentObject(), this));
			return getCurrentObject();
		}
	}
}

/**
Data holder for delegate object / method.
*/
class DelegateData {

	public var object:Object;
	public var method:Function;
	
	function DelegateData (inObject:Object, inMethod:Function) {
		object = inObject;
		method = inMethod;
	}
}