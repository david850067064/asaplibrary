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

	import flash.events.Event;
	import org.asaplibrary.data.array.TraverseArrayEnumerator;
	
	/**
	Passes events for {@link TraverseArrayEnumerator}. Subscribe to type <code>_EVENT</code>.
	@example
	<code>
	var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(objects);
	enumerator.addEventListener(TraverseArrayEnumeratorEvent.UPDATE, handleTraverseUpdate);
	</code>
	Listen for traverse events:
	<code>
	private function handleTraverseUpdate (e:TraverseArrayEnumeratorEvent) : void {
		// retrieve object with e.value
	}
	</code>
	*/
	public class TraverseArrayEnumeratorEvent extends Event {
	
		public static var UPDATE:String = "onTraverseArrayEnumeratorUpdate";
		
		public var enumerator:TraverseArrayEnumerator;
		public var value:Object;
		
		/**
		@param inSubtype: name of event (and name of handler function when no Delegate is used)
		@param inObject: the object at the TraverseArrayEnumerator pointer position
		@param inEnumerator : the TraverseArrayEnumerator object
		*/
		public function TraverseArrayEnumeratorEvent (inSubtype:String, 	  		  
													  inValue:Object, inEnumerator:TraverseArrayEnumerator) {
			super(inSubtype);
			value = inValue;
			enumerator = inEnumerator;
		}
	
	}
}