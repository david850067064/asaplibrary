/*
Copyright 2008 by the authors of asaplibrary, http://asaplibrary.org

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

package org.asaplibrary.ui.animation {
	import flash.events.Event;	

	/**
	 * Event class for sending animation related events
	 */
	public class AnimationEvent extends Event {
		/** generic event type */
		public static var _EVENT:String = "onAnimationEvent";
		
		/** subtype of event sent when in animation is started */
		public static var IN_ANIMATION_STARTED:String = "inAnimationStarted";
		/** subtype of event sent when in animation is done*/
		public static var IN_ANIMATION_DONE:String = "inAnimationDone";
		/** subtype of event sent when out animation is done*/
		public static var OUT_ANIMATION_STARTED:String = "outAnimationStarted";
		/** subtype of event sent when out animation is done*/
		public static var OUT_ANIMATION_DONE:String = "outAnimationDone";
		/** subtype of event sent when general animation is done*/
		public static var ANIMATION_DONE:String = "animationDone";
		
		/** Subtype of event */
		public var subtype:String;
		
		function AnimationEvent(inSubtype : String) {
			super(_EVENT);
			
			subtype = inSubtype;
		}
		
		override public function clone () : Event {
			return new AnimationEvent(subtype);
		}
	}
}