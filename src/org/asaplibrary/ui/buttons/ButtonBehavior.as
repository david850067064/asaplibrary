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
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	Delegate class to manage button states (mouse over, selected, enabled, etcetera) to free the button class from state management and let it just do the drawing of its mouse states.
	This also makes mouse behaviour pluggable - see for instance {@link DelayButtonBehavior} for a time-oriented delegate.
	@example
	This example shows how to set up a button class that receives its update changes from its delegate:
	<code>
	import flash.display.MovieClip;
	import org.asaplibrary.ui.buttons.*;
	
	public class MyButton extends MovieClip {
	
	private var mDelegate:ButtonBehavior;
		
	public var tBorder:MovieClip; // a border clip shows the button state

	public function MyButton () {
	mDelegate = new ButtonBehavior(this);
	// listen for changes
	// button updates will be redirected to method 'update':
	mDelegate.addEventListener(ButtonBehaviorEvent._EVENT, update);
	}
		
	// pass any button change setter state to the delegate
	public function select (inState:Boolean) : void {
	mDelegate.select(inState);
	}
		
	private function update (e:ButtonBehaviorEvent) : void {
	switch (e.state) {
	case ButtonStates.SELECTED:
	case ButtonStates.OVER:
	tBorder.visible = true;
	break;
	case ButtonStates.NORMAL:
	case ButtonStates.OUT:
	case ButtonStates.DESELECTED:
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
		protected var mButton : MovieClip;
		/**
		The selected button state. Usually this means the button will be highlighted and not clickable.
		 */
		protected var mSelected : Boolean = false;
		/**
		The enabled button state.
		 */
		protected var mEnabled : Boolean = true;
		/**
		The mouse over button state.
		 */
		protected var mMouseOver : Boolean = false;
		/**
		The pressed button state. This is a 'global' variable shared across instances of ButtonBehavior objects. If the mouse is pressed we don't want to register other mouse events on other buttons.
		 */
		protected static var sPressed : Boolean = false;
		/**
		The current state.
		 */
		protected var mState : uint;
		/**
		The target button that was initially clicked. Stored to check if a MOUSE_UP is done on the same button or outside.
		 */
		private var mMouseDownTarget : *;

		/**
		Creates a new delegate object.
		@param inButton: the owner button
		@todo Implement CLICK, DOUBLE_CLICK, MOUSE_WHEEL (if necessary)
		 */
		public function ButtonBehavior(inButton : MovieClip) {
			mButton = inButton;
			mButton.addEventListener(Event.ADDED, addedHandler);
			mButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			mButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			mButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			mButton.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			// mButton.addEventListener(MouseEvent.CLICK, clickHandler);
			// mButton.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			// mButton.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);

			setStageHandler();
		}

		/**
		Note: the stage listener may not be set in the constructor 
		because at that time the button's owner may not have
		added to the stage display list tree yet.
		 */
		protected function setStageHandler() : void {
			if (mButton.stage) {
				// Also listen for stage events to prevent buttons from firing button events if the mouse has been pressed.
				mButton.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownStageHandler);
				mButton.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpStageHandler);
			}
		}

		/**
		
		 */
		override public function toString() : String {
			return getQualifiedClassName(this);
		}

		/**
		Pass the selected state from the button to the delegate.
		@param inState: the selected button state
		 */
		public function select(inState : Boolean) : void {
			var changed : Boolean = mSelected != inState;
			mSelected = inState;
			if (changed) {
				update(null, mSelected ? ButtonStates.SELECTED : ButtonStates.DESELECTED);
			}
		}

		/**
		Pass the enabled state from the button to the delegate.
		@param inState: the enabled button state
		 */
		public function enable(inState : Boolean) : void {
			var changed : Boolean = mEnabled != inState;
			mEnabled = inState;
			if (changed) {
				update(null, mEnabled ? ButtonStates.ENABLED : ButtonStates.DISABLED);
			}
		}

		/**
		Called at Event.ADDED. Will be called once for the button.
		@param e: the event
		 */
		protected function addedHandler(e : Event) : void {
			// only call "added" once
			mButton.removeEventListener(Event.ADDED, addedHandler);
			update(null, ButtonStates.ADDED);
		}

		/**
		Called at MouseEvent.MOUSE_OUT.
		@param e: the mouse event
		 */
		protected function mouseOutHandler(e : MouseEvent) : void {
			if (sPressed) return;

			if (!mMouseOver) return;

			mMouseOver = false;
			if (mSelected || !mEnabled) return;

			update(e, ButtonStates.OUT);
		}

		/**
		Called at MouseEvent.MOUSE_OVER.
		@param e: the mouse event
		 */
		protected function mouseOverHandler(e : MouseEvent) : void {
			if (sPressed) return;
			mMouseOver = true;
			if (mSelected || !mEnabled) return;
			update(e, ButtonStates.OVER);
		}

		/**
		Called at MouseEvent.MOUSE_DOWN.
		@param e: the mouse event
		 */
		protected function mouseDownHandler(e : MouseEvent) : void {
			setStageHandler();
			if (!mMouseOver) return;
			mMouseDownTarget = e.currentTarget;
			if (mButton.stage) {
				// down, now check for global mouseUp
				mButton.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				// we also have mouseDownStageHandler
				// track for release outside the window
				mButton.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveStageHandler);
			}
			sPressed = true;
			mMouseOver = true;
			if (mSelected || !mEnabled) return;
			update(e, ButtonStates.DOWN);
		}

		/**
		Called at MouseEvent.MOUSE_UP.
		@param e: the mouse event
		 */
		protected function mouseUpHandler(e : MouseEvent) : void {
			if (!mMouseOver) return;

			if (mMouseDownTarget != mButton) return;

			sPressed = false;
			if (mSelected || !mEnabled) return;
			if (mMouseDownTarget != null && e.currentTarget != mMouseDownTarget) {
				// release outside
				releaseOutside(e);
				return;
			}
			mMouseDownTarget = null;
			update(e, ButtonStates.UP);
		}

		/**
		Registers if the mouse is pressed outside any button. This will set {@link #sPressed} to be true, thereby preventing buttons from firing mouse events.
		@param e: the mouse event
		 */
		protected function mouseDownStageHandler(e : MouseEvent) : void {
			sPressed = true;
		}

		/**
		Registers if the mouse is released outside any button.
		@param e: the mouse event
		@see #mouseDownStageHandler
		 */
		protected function mouseUpStageHandler(e : MouseEvent) : void {
			sPressed = false;
		}

		/**
		Called when the mouse has been pressed and subsequently released outside the stage.
		@param e: the event
		 */
		protected function mouseLeaveStageHandler(e : Event) : void {
			if (mSelected || !mEnabled) return;
			sPressed = false;
			mMouseOver = false;
			mMouseDownTarget = null;
			if (mButton.stage) {
				mButton.stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveStageHandler);
			}
			update(null, ButtonStates.UP | ButtonStates.OUT);
		}

		/**
		Called from {@link #mouseUpHandler} if the mouse has been released outside the button that was initally clicked or rolled over. This handler must be called after mouseUpHandler has called {@link #update} to send out the mouse events in the right order.
		@param e: the mouse event
		 */
		protected function releaseOutside(e : MouseEvent) : void {
			if (mButton.stage) {
				mButton.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				// but we keep mouseUpStageHandler
			}
			mMouseDownTarget = null;
			sPressed = false;
			mMouseOver = false;
			update(e, ButtonStates.UP | ButtonStates.OUT);
		}

		/**
		Sends out the updated state to listeners (the owner button). A change event is only sent at a change.
		@param e: (optional) the mouse event - will not always be present
		@param inState: (optional) the button state
		@sends ButtonBehaviorEvent#_EVENT - in case the new state differs from the previous one
		 */
		protected function update(e : MouseEvent = null, inState : uint = ButtonStates.NONE) : void {
			var drawState : uint = inState;
			if (drawState == ButtonStates.NONE) {
				drawState = ButtonStates.NORMAL;
			}

			if (mState == drawState) return;
			dispatchEvent(new ButtonBehaviorEvent(ButtonBehaviorEvent._EVENT, drawState, mSelected, mEnabled, sPressed, e));
			mState = drawState;
		}
	}
}