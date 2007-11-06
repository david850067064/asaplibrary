﻿/*
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
	Event objects that are dispatched by {@link FlowManager}. Subscribe to type <code>_EVENT</code>.
	@example
	<code>
	FlowManager.getInstance().addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
	</code>
	*/
	public class FlowNavigationEvent extends Event {
	
		/**
		Event type.
		*/
		public static const _EVENT:String = "navigationEvent";
		
		/**
		Event subtype sent before changing state.
		*/
		public static const WILL_UPDATE:String = "willUpdate";
		/**
		Event subtype sent after changing state.
		*/
		public static const UPDATE:String = "update";
		/**
		Event subtype sent before trying to load a section movie.
		*/
		public static const WILL_LOAD:String = "willLoad";
		/**
		Event subtype sent after successfully loading a section movie.
		*/
		public static const LOADED:String = "loaded";
		/**
		Event subtype sent when an error occurred loading a section movie.
		*/
		public static const LOADING_ERROR:String = "loadError";
		
		public var subtype:String;
		public var name:String;
		public var sender:Object;
		public var destination:String;
		
		/**
		Creates a new FlowNavigationEvent. This event bubbles through and is cancelable.
		@param inSubtype: either subtype, see above
		@param inName: name of the {@link FlowSection}
		@param inSender: sender of the event
		@param inDestination: name of destination FlowSection
		*/
		public function FlowNavigationEvent (inSubtype:String, inName:String, inSender:Object, inDestination:String = null) {
			super(_EVENT, true, true);
			
			subtype = inSubtype;
			name = inName;
			sender = inSender;
			destination = inDestination;
		}
		
		public override function toString () : String {
			return ";org.asaplibrary.management.flow.FlowNavigationEvent: subtype=" + subtype + "; name=" + name + "; sender=" + sender + "; destination=" + destination;
		}
		
		/**
		Creates a copy of an existing FlowNavigationEvent.
		*/
		public override function clone() : Event {
			return new FlowNavigationEvent(subtype, name, sender, destination);
		} 
	}
}