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

package org.asaplibrary.ui.buttons {
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ButtonStateDelegateEvent extends Event {
	
		public static const UPDATE:String = "update";
		
		public var state:uint;
		public var selected:Boolean;
		public var enabled:Boolean;
		public var pressed:Boolean;
		public var mouseEvent:MouseEvent;

		public function ButtonStateDelegateEvent (inSubtype:String,
												  inState:uint,
												  inSelected:Boolean,
												  inEnabled:Boolean,
												  inPressed:Boolean,
												  inMouseEvent:MouseEvent) {
			super(inSubtype);
			state = inState;
			selected = inSelected;
			enabled = inEnabled;
			pressed = inPressed;
			mouseEvent = inMouseEvent;
		}
		
		public override function toString ():String {
			return "org.asaplibrary.ui.buttons.ButtonStateDelegateEvent; state=" + state + "; selected=" + selected + "; enabled=" + enabled + "; pressed=" + pressed + "; mouseEvent=" + mouseEvent;
		}
	}	
}
