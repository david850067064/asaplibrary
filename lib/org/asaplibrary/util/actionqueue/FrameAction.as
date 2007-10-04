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

package org.asaplibrary.util.actionqueue {

	public class FrameAction extends Action {
	
		public var duration:Number; /**< Duration of the animation in seconds. */
		public var effect:Function; /**< An effect function, for instance one of the fl.motion.easing methods. */ 
		
		// Optionally set properties
		public var start:Number = 1; /**< Percentage start value to get returned to {@link #method}. */
		public var end:Number = 0; /**< Percentage end value to get returned to {@link #method}. */
		
		// Values set at calculation
		public var range:Number;
		public var percentage:Number;
		public var value:Number;
		
		public var loop:Boolean;
		public var loopCount:int;
		protected var loopCounter:int = 0;
		
		public function FrameAction (inOwner:Object,
									 inMethod:Function,
									 inDuration:Number = Number.NaN,
									 inEffect:Function = null) {
			
			super(inOwner, inMethod, null);

			duration = inDuration;
			range = end - start;
			effect = inEffect;
		}
		
		public function toString () : String {
			return "; ActionData; owner=" + owner + "; duration=" + duration + "; start=" + start + "; end=" + end;
		}
		
		public function setActionDone () : void {
			if (loop) {
				loopCounter++;
			}
		}
		
		public function doesLoop () : Boolean {
			if (loop) {
				if (loopCount == 0) return true;
				if (loopCounter <= loopCount) return true;
				return false;
			}
			return false;
		}
		
	}
}