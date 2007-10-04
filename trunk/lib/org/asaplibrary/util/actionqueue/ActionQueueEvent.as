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
	Event objects that are dispatched by {@link ActionQueue}.
	*/
	
	public class ActionQueueEvent extends Event {
	
		public static var QUEUE_STARTED:String = "onActionQueueStarted";
		public static var QUEUE_FINISHED:String = "onActionQueueFinished";
		public static var QUEUE_QUIT:String = "onActionQueueQuit";
		public static var QUEUE_PAUSED:String = "onActionQueuePaused";
		public static var QUEUE_RESUMED:String = "onActionQueueResumed";
		public static var QUEUE_STOPPED:String = "onActionQueueStopped";
		public static var QUEUE_MARKER_PASSED:String = "onActionQueueMarkerPassed";
	
		public var name:String;
		public var markerName:String;
	
		/**
		@param inName : name of the ActionQueue
		@param inMarkerName : (optional) the marker name
		*/
		public function ActionQueueEvent (inType:String,
										  inName:String,
										  inMarkerName:String = null) {
			super(inType);
			name = inName;
			markerName = inMarkerName;
		}
	}
}