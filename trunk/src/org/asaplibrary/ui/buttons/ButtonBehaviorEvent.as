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
package org.asaplibrary.ui.buttons {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	Passes events for {@link ButtonBehavior} (and subclasses thereof). 
	Subscribe to type <code>_EVENT</code>.
	@example
	<code>
	mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, handleUpdate);
	</code>
	Listen for delegate events:
	<code>
	private function handleUpdate (e:ButtonBehaviorEvent) : void {
	if (e.state & ButtonStates.OVER) grow();
	if (e.state & ButtonStates.OUT) shrink();
	}
	</code>
	 */
	public class ButtonBehaviorEvent extends Event {
		/** Event type. */
		public static const _EVENT : String = "buttonBehaviorEvent";
		/** Event subtype. */
		public static const UPDATE : String = "buttonUpdate";
		public var subtype : String;
		public var state : uint;
		public var selected : Boolean;
		public var enabled : Boolean;
		public var pressed : Boolean;
		public var mouseEvent : MouseEvent;

		/**
		Creates a new ButtonBehaviorEvent.
		@param inSubtype: "UPDATE"
		@param inState: one of the options in {@link ButtonStates}
		@param inSelected: the selected button state
		@param inEnabled: the enabled button state
		@param inPressed: the pressed button state
		@param inMouseEvent: the mouse event; might be null in case no mouse event has triggered the update
		 */
		public function ButtonBehaviorEvent(inSubtype : String, inState : uint, inSelected : Boolean, inEnabled : Boolean, inPressed : Boolean, inMouseEvent : MouseEvent) {
			super(_EVENT);
			subtype = inSubtype;
			state = inState;
			selected = inSelected;
			enabled = inEnabled;
			pressed = inPressed;
			mouseEvent = inMouseEvent;
		}

		public override function toString() : String {
			return getQualifiedClassName(this) + "; state=" + ButtonStates.stateToString(state) + "; selected=" + selected + "; enabled=" + enabled + "; pressed=" + pressed + "; mouseEvent=" + mouseEvent;
		}

		/**
		Creates a copy of an existing ButtonBehaviorEvent.
		 */
		public override function clone() : Event {
			return new ButtonBehaviorEvent(subtype, state, selected, enabled, pressed, mouseEvent);
		}
	}
}
