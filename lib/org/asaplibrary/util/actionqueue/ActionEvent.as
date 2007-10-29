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
	Event objects that are dispatched by {@link Action} objects.
	*/
	
	public class ActionEvent extends Event {
	
		public static const _EVENT:String = "onActionEvent";
		
		public static const STARTED:String = "onActionStarted";
		public static const FINISHED:String = "onActionFinished";
		public static const QUIT:String = "onActionQuit";
		public static const PAUSED:String = "onActionPaused";
		public static const RESUMED:String = "onActionResumed";
		public static const STOPPED:String = "onActionStopped";
		public static const MARKER_VISITED:String = "onActionMarkerVisited";
		public static const CONDITION_MARKER:String = "onActionConditionMarker";
		
		public var name:String;
		public var subtype:String;
		public var action:IAction;
		public var markerName:String;
	
		/**

		*/
		public function ActionEvent (inSubtype:String,
									 inAction:IAction = null,
									 inName:String = null,
									 inMarkerName:String = null) {
			super(_EVENT);
			
			subtype = inSubtype;
			action = inAction;
			name = inName;
			markerName = inMarkerName;
		}
		
		/**
		@exclude
		*/
		public override function toString () : String {
			return ";ActionEvent: subtype=" + subtype + "; name=" + name + "; action=" + action;
		}
		
		public override function clone() : Event {
			return new ActionEvent(subtype, action, name, markerName);
		} 
	}
}