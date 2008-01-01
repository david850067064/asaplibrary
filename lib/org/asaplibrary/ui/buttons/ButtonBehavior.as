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

package org.asaplibrary.ui.buttons {
	
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.ui.buttons.ButtonBehaviorEvent;
	import org.asaplibrary.ui.buttons.ButtonStates;
	
	/**
	Delegate class to manage button states (mouse over, selected, enabled, etcetera) to free the button class from state management and let it just do the drawing of its mouse states.
	This also makes mouse behaviour pluggable - see for instance {@link DelayButtonBehavior} for a time-oriented delegate.
	@example
	This example shows how to set up a button class that receives its update changes from its delegate:
	<code>
	import flash.display.MovieClip;
	import org.asaplibrary.ui.buttons.*;
	
	public class MyButton extends MovieClip {
	
		private static const S:Class = ButtonStates; // shorthand
		private var mDelegate:DelayButtonBehavior;
		
		public var tBorder:MovieClip; // a border clip shows the button state

		public function MyButton () {
			mDelegate = new DelayButtonBehavior(this);
			// listen for changes
			// button updates will be redirected to method 'update':
			mDelegate.addEventListener(ButtonBehaviorEvent.UPDATE, update);
		}
		
		// pass any button change setter state to the delegate
		public function select (inState:Boolean) : void {
			mDelegate.select(inState);
		}
		
		private function update (e:ButtonBehaviorEvent) : void {
			switch (e.state) {
				case S.SELECTED:
				case S.OVER:
					tBorder.visible = true;
					break;
				case S.NORMAL:
				case S.OUT:
				case S.DESELECTED:
					tBorder.visible = false;
					break;
				default:
					tBorder.visible = false;
			}
			buttonMode = e.enabled;
		}
	}
	</code>
	*/
	public class ButtonBehavior extends EventDispatcher {
		
		protected var mButton:MovieClip;
		
		/**
		The selected button state. Usually this means the button will be highlighted and not clickable.
		*/
		protected var mSelected:Boolean = false;
		
		/**
		The enabled button state.
		*/
		protected var mEnabled:Boolean = true;
		
		
		/**
		The mouse over button state.
		*/
		protected var mMouseOver:Boolean = false;
		
		/**
		The pressed button state.
		*/
		protected var mPressed:Boolean = false;
		
		/**
		The current state.
		*/
		protected var mState:uint;
		
		/**
		Creates a new delegate object.
		@param inButton: the owner button
		@todo Implement CLICK, DOUBLE_CLICK, MOUSE_WHEEL (if necessary)
		*/
		public function ButtonBehavior (inButton:MovieClip) {
			mButton = inButton;
			mButton.addEventListener(Event.ADDED, addedHandler);
			mButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			mButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			mButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			mButton.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//mButton.addEventListener(MouseEvent.CLICK, clickHandler);
			//mButton.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			//mButton.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
	
		/**
		
		*/
		override public function toString () : String {
			return ";org.asaplibrary.ui.buttons.ButtonBehavior";
		}
		
		/**
		Pass the selected state from the button to the delegate.
		@param inState: the selected button state
		*/
		public function select (inState:Boolean) : void {
			var changed:Boolean = mSelected != inState;
			mSelected = inState;
			if (changed) {
				update(null, mSelected ? ButtonStates.SELECTED : ButtonStates.DESELECTED);
			}
		}

		/**
		Pass the enabled state from the button to the delegate.
		@param inState: the enabled button state
		*/
		public function enable (inState:Boolean) : void {
			var changed:Boolean = mEnabled != inState;
			mEnabled = inState;
			if (changed) {
				update(null, mEnabled ? ButtonStates.ENABLED : ButtonStates.DISABLED);
			}
		}

		/**
		Called at Event.ADDED. Will be called once for the button.
		@param e: the event
		*/
		protected function addedHandler (e:Event) : void {
			// only call "added" once
			mButton.removeEventListener(Event.ADDED, addedHandler);
			update(null, ButtonStates.ADDED);
		}
		
		/**
		Called at MouseEvent.MOUSE_DOWN.
		@param e: the mouse event
		*/
		protected function mouseDownHandler (e:MouseEvent) : void {
			mPressed = true;
			mMouseOver = true;
			if (mSelected || !mEnabled) return;
			update(e, ButtonStates.OVER);
		}
		
		/**
		Called at MouseEvent.MOUSE_OUT.
		@param e: the mouse event
		*/
		protected function mouseOutHandler (e:MouseEvent) : void {
			mPressed = false;
			mMouseOver = false;
			if (mSelected || !mEnabled) return;
			update(e, ButtonStates.OUT);
		}
		
		/**
		Called at MouseEvent.MOUSE_OVER.
		@param e: the mouse event
		*/
		protected function mouseOverHandler (e:MouseEvent) : void {
			mMouseOver = true;
			if (mSelected || !mEnabled) return;
			update(e, ButtonStates.OVER);
		}
		
		/**
		Called at MouseEvent.MOUSE_UP.
		@param e: the mouse event
		*/
		protected function mouseUpHandler (e:MouseEvent) : void {
			mPressed = false;
			if (mSelected || !mEnabled) return;
			update(e, ButtonStates.OVER);
		}
		
		/**
		Sends out the updated state to listeners (the owner button). A change event is only sent at a change.
		@param e: (optional) the mouse event - will not always be present
		@param inState: (optional) the button state
		@sends ButtonBehaviorEvent#_EVENT - in case the new state differs from the previous one
		*/
		protected function update (e:MouseEvent = null, inState:uint = ButtonStates.NONE) : void {
			var drawState:uint = inState;
			if (drawState == ButtonStates.NONE) {
				drawState = ButtonStates.NORMAL;
			}
			
			if (mState == drawState) return;
		
			dispatchEvent(new ButtonBehaviorEvent(
				ButtonBehaviorEvent._EVENT, drawState, mSelected, mEnabled, mPressed, e));			
			mState = drawState;
		}
	}
}