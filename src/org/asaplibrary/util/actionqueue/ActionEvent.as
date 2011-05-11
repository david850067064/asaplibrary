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
package org.asaplibrary.util.actionqueue {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	Event object sent by {@link Action} and {@link TimedAction} classes. Subscribe to type <code>_EVENT</code>.
	 */
	public class ActionEvent extends Event {
		/** Event type. */
		public static const _EVENT : String = "onActionEvent";
		/** Event subtype sent when the Action has started. */
		public static const STARTED : String = "onActionStarted";
		/** Event subtype sent when the Action has finished. */
		public static const FINISHED : String = "onActionFinished";
		/** Event subtype sent when the Action has been quit (from outside). */
		public static const QUIT : String = "onActionQuit";
		/** Event subtype sent when the Action has been paused. */
		public static const PAUSED : String = "onActionPaused";
		/** Event subtype sent when the paused Action has been resumed. */
		public static const RESUMED : String = "onActionResumed";
		/** Event subtype sent when the Action has been stopped (from outside). */
		public static const STOPPED : String = "onActionStopped";
		/** Event subtype when sent when a marker has been passed (currently only with {@link ActionQueue}. */
		public static const MARKER_VISITED : String = "onActionMarkerVisited";
		/** Event subtype sent when a {@link Condition} has been met. */
		public static const CONDITION_MARKER : String = "onActionConditionMarker";
		public var name : String;
		public var subtype : String;
		public var action : IAction;
		public var markerName : String;

		/**
		Creates a new ActionEvent.
		@param inSubtype: either subtype; see above
		@param inAction: (optional) the performing Action object (presumably {@link ActionRunner} or {@link ActionQueue}
		@param inMarkerName: (optional) name of the Marker (currently only used by {@link ActionQueue})
		 */
		public function ActionEvent(inSubtype : String, inAction : IAction = null, inMarkerName : String = null) {
			super(_EVENT);

			subtype = inSubtype;
			action = inAction;
			markerName = inMarkerName;
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this) + ": subtype=" + subtype + "; action=" + action;
		}

		/**
		Creates a copy of an existing ActionEvent.
		 */
		public override function clone() : Event {
			return new ActionEvent(subtype, action, markerName);
		}
	}
}