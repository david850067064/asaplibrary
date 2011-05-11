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
package org.asaplibrary.data.array {
	/**
	Delegate interface contract for {@link TraverseArrayEnumerator} delegate objects - see {@link TraverseArrayEnumerator#addDelegate}.
	 */
	public interface ITraverseArrayDelegate {
		/**
		Validates if the {@link TraverseArrayEnumerator} may update its state to the object at location inLocation in list inObjects.
		@param inObjects: list of enumerated objects
		@param inLocation: pointer location of the to be updated state
		@return True if the update is allowed; false if it is prohibited.
		@use
		<code>
		public function mayUpdateToObject (inObjects:Array, inLocation:Number) : Boolean {
		return (inObjects[inLocation] == "A");
		}
		</code>
		 */
		function mayUpdateToObject(inObjects : Array, inLocation : Number) : Boolean;
	}
}