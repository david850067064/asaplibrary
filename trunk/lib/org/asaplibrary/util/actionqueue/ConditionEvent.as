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
	
	import flash.events.Event;
	
	/**
	Event objects that are dispatched by {@link ConditionManager}.
	*/
	
	public class ConditionEvent extends Event {
	
		public static const _EVENT:String = "onConditionEvent";
		
		public static const CONDITION_MET:String = "onConditionMet";
		
		public var condition:Condition;
		public var subtype:String;
	
		/**
		Creates a new ConditionEvent.
		@param inSubtype: <code>CONDITION_MET</code>
		@param inCondition: Condition that is met
		*/
		public function ConditionEvent (inSubtype:String, inCondition:Condition) {
			super(_EVENT);
			
			subtype = inSubtype;
			condition = inCondition;
		}
		
		public override function toString () : String {
			return ";ConditionEvent: subtype=" + subtype + "; condition=" + condition;
		}
		
		public override function clone() : Event {
			return new ConditionEvent(subtype, condition);
		} 
	}
}