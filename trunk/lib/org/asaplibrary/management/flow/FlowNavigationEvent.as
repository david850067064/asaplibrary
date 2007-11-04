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

package org.asaplibrary.management.flow {
	
	import flash.events.Event;
	
	/**
	Event objects that are dispatched by {@link FlowManager}.
	*/
	
	public class FlowNavigationEvent extends Event {
	
		public static const _EVENT:String = "navigationEvent";
		
		public static const WILL_UPDATE:String = "willUpdate";
		public static const UPDATE:String = "update";
		
		public static const WILL_LOAD:String = "willLoad";
		public static const LOADED:String = "loaded";
		
		public var subtype:String;
		public var id:String;
		public var sender:Object
	
		/**
		Creates a new FlowNavigationEvent.
		*/
		public function FlowNavigationEvent (inSubtype:String, inId:String, inSender:Object) {
			super(_EVENT, true, true);
			
			subtype = inSubtype;
			id = inId;
			sender = inSender;
		}
		
		public override function toString () : String {
			return ";FlowNavigationEvent: subtype=" + subtype + "; id=" + id + "; sender=" + sender;
		}
		
		public override function clone() : Event {
			return new FlowNavigationEvent(subtype, id, sender);
		} 
	}
}