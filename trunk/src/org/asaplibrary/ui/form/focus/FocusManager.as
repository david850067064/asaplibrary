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
	import org.asaplibrary.util.debug.Log;

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;

	/**
	 * Class for managing focus on UI components that implement IFocusable.
	 * Use of this class overrides default tab button behaviour. Only UI components added to an instance of this class can get focus through use of the tab key. Consecutive presses on the TAB key will cycle through the list of items in order of addition, unless a specific tab index has been set on any of them. With SHIFT-TAB the list is cycled in reversed order.
	 * @example
	 * Suppose two objects of type InputField have been defined on the timeline, with instance names "tName" & "tEmail". Use the following code to allow focus management on them:
	 * <code>
	mFocusManager = new FocusManager(LocalController.globalStage);
	mFocusManager.addElement(tName);
	mFocusManager.addElement(tEmail);
	</code>
	 * Note that a valid stage object must be passed to the FocusManager constructor in order for the tab key to be detected.
	 * To set focus to the email field, use the following code:
	 * <code>
	mFocusManager.setFocus(tEmail);
	</code>
	 */
	public class FocusManager extends EventDispatcher {
		private var mFocusIndex : Number;
		private var mFocusList : Array;

		/**
		 * Constructor
		 * @param inStage: a valid Stage object. Use LocalController.globalStage for a Stage object that is always valid. 
		 */
		public function FocusManager(inStage : Stage) {
			super();

			clear();

			// check if stage exists, we need this for key handling
			if (!inStage) {
				Log.error("FocusManager: stage is not defined", toString());
				throw new Error("stage is not defined.");
			}

			// listen to key events & key focus events
			inStage.addEventListener(KeyboardEvent.KEY_UP, handleKey);
			inStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
		}

		/**
		 *	Clear list of focus elements
		 */
		public function clear() : void {
			mFocusIndex = -1;
			mFocusList = new Array();
		}

		/**
		Sets the focus to a specific element.
		@param inItem: previously added item
		 */
		public function setFocus(inItem : IFocusable) : void {
			var index : Number = mFocusList.indexOf(inItem);
			if (index != -1) changeFocus(mFocusIndex, index);
		}

		/**
		Add an item for focus management; optionally set the tab index for the item.
		@param inItem: item to be used in focus management
		@param inPosition: zero-based, optional. If ommitted (or set to -1), it will be added to the end of the list. If an element was already found at the position specifed, it will be inserted prior to the existing element
		@return Boolean indicating if addition was successfull.
		 */
		public function addElement(inItem : IFocusable, inPosition : int = -1) : Boolean {
			// check if element exists
			if (inItem == null) {
				Log.error("addElement: No element specified for addition", toString());
				throw new Error("No element specified for addition");
			}

			// check if already added
			if (mFocusList.indexOf(inItem) != -1) {
				Log.warn("addElement: Element already in list: " + inItem, toString());
				return false;
			}

			// add element depending on value of position
			if (inPosition == -1) {
				mFocusList.push(inItem);
			} else {
				mFocusList.splice(inPosition, 0, inItem);
			}

			return true;
		}

		/**
		 * Handle KEY_FOCUS_CHANGE event from Stage
		 */
		private function handleKeyFocusChange(event : FocusEvent) : void {
			event.preventDefault();
		}

		/**
		 * Handle key event
		 */
		private function handleKey(event : KeyboardEvent) : void {
			if (event.keyCode != Keyboard.TAB) return;

			if (event.shiftKey) focusPreviousItem();
			else focusNextItem();
		}

		/**
		Set focus to next item in list.
		 */
		private function focusNextItem() : void {
			// check if focus is in current list
			var index : Number = getCurrentFocusIndex();
			if (index == -1) {
				mFocusIndex = -1;
				return;
			}

			// store previous focus
			var prev : Number = index;

			// increment & check limit
			index++;
			if (index > mFocusList.length - 1) index = 0;

			// update
			changeFocus(prev, index);
		}

		/**
		Set focus to previous item in list.
		 */
		private function focusPreviousItem() : void {
			// check if focus is in current list
			var index : Number = getCurrentFocusIndex();
			if (index == -1) {
				mFocusIndex = -1;
				return;
			}

			// store previous focus
			var prev : Number = index;

			// decrement & check limit
			index--;
			if (index < 0) index = mFocusList.length - 1;

			changeFocus(prev, index);
		}

		/**
		Change the focus to the item with the 'index' passed
		@sends FocusManagerEvent#FOCUS_CHANGE
		 */
		private function changeFocus(inPrevFocus : Number, inNewFocus : Number) : void {
			// store new focus
			mFocusIndex = inNewFocus;

			// set focus on new item
			IFocusable(mFocusList[mFocusIndex]).setFocus();

			// dispatch onChangeFocus event
			dispatchEvent(new FocusManagerEvent(mFocusList[inPrevFocus], mFocusList[mFocusIndex]));
		}

		/**
		Checks if any of our elements has focus and returns its index
		 * @return the index of the current item, or -1 if none was found
		 */
		private function getCurrentFocusIndex() : int {
			var len : uint = mFocusList.length;
			for (var i : int = 0; i < len; ++i) {
				if (IFocusable(mFocusList[i]).hasFocus()) return i;
			}
			return -1;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
