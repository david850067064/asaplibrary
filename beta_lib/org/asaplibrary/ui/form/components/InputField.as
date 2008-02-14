/*
Copyright 2008 by the authors of asaplibrary, http://asaplibrary.org
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

package org.asaplibrary.ui.form.components {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import org.asaplibrary.ui.form.focus.IFocusable;
	import org.asaplibrary.util.validation.IHasError;
	import org.asaplibrary.util.validation.IValidatable;		

	/**
	 * UI Component class for text input.
	 * This class provides text input with validation through Validator, focus through FocusManager, and has an error state.
	 * The following requirements must be met to use this class:
	 * <ul>
	 * 		<li>This class must be linked to a library item of type MovieClip</li>
	 * 		<li>The library item has a TextField child set to input, with the instance name "tInput"</li>
	 * 		<li>Optionally, the library item has a MovieClip child with instance name "tError", to be used for displaying an error state</li>
	 * 	</ul>
	 */
	public class InputField extends MovieClip implements IFocusable, IValidatable, IHasError {
		public var tInput : TextField;
		public var tError : Sprite;
		
		private var mHasFocus : Boolean;

		/**
		 * Constructor
		 */
		public function InputField() {
			// catch events for focus management
			tInput.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleMouseFocusChange);
			tInput.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
			tInput.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			tInput.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			
			if (tError) tError.visible = false;
		}
		
		/**
		 * The text in the contained input field
		 */
		public function get text () : String {
			return tInput.text;
		}
		
		/**
		 * The text in the contained input field
		 */
		public function set text (inText:String) : void {
			tInput.text = inText;
		}

		/**
		 * Enable or disable input
		 */		
		public function enable (inEnable:Boolean) : void {
			tInput.mouseEnabled = inEnable;
		}
		
		/**
		 * Give focus to this component
		 */		
		public function setFocus () : void {
			mHasFocus = true;
			
			tInput.setSelection(0, tInput.text.length);
			
			stage.focus = tInput;
		}
		
		/**
		 *	Clear focus flag
		 */
		public function clearFocus () : void {
			mHasFocus = false;
		}
		
		/**
		 * Return true if this element has focus
		 */
		public function hasFocus() : Boolean {
			return mHasFocus;
		}

		/**
		 * Return the value to be validated
		 */
		public function getValue() : Object {
			return tInput.text;
		}

		public function showError() : void {
			if (tError) tError.visible = true;
		}
		
		public function hideError() : void {
			if (tError) tError.visible = false;
		}

		/**
		 * Handle FOCUS_IN event from input field
		 */
		private function handleFocusIn(event : FocusEvent) : void {
			mHasFocus = true;
		}

		/**
		 * Handle FOCUS_OUT event from input field
		 */
		private function handleFocusOut(event : FocusEvent) : void {
			clearFocus();
		}

		/**
		 * Handle KEY_FOCUS_CHANGE event from input field
		 */
		private function handleKeyFocusChange(event : FocusEvent) : void {
			// prevent default selecting behaviour
			event.preventDefault();
		}

		/**
		 * Handle MOUSE_FOCUS_CHANGE event from input field
		 */
		private function handleMouseFocusChange(event : FocusEvent) : void {
			setFocus();
		}

		override public function toString():String {
			return "; com.lostboys.form.components.InputField - " + name;
		}
		
	}
}