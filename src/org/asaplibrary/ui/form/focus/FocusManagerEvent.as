/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org
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
package org.asaplibrary.ui.form.focus {
	import flash.events.Event;

	/**
	 * Event sent by FocusManager when a new item gets focus.
	 */
	public class FocusManagerEvent extends Event {
		public static const FOCUS_CHANGE : String = "focusChange";
		public var previous : IFocusable;
		public var current : IFocusable;

		public function FocusManagerEvent(inPrevious : IFocusable, inCurrent : IFocusable) {
			super(FOCUS_CHANGE);

			previous = inPrevious;
			current = inCurrent;
		}

		override public function clone() : Event {
			return new FocusManagerEvent(previous, current);
		}
	}
}
