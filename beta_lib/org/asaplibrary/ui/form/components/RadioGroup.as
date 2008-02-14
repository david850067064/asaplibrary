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
	import flash.events.Event;	
	import flash.events.EventDispatcher;	
	import flash.events.MouseEvent;
	
	import org.asaplibrary.util.validation.IHasError;
	import org.asaplibrary.util.validation.IValidatable;		

	/**
	 * Class for implementing radio button groups.
	 * @example
	 * Assume 3 objects of type SimpleCheckBox are placed on the stage, with instance names "tRadio1", "tRadio2", "tRadio3"
	 * <code>
	 		// create new group, add radio buttons, select first button, listen to change event
	 		var rg:RadioGroup = new RadioGroup();
	 		rg.addButton(tRadio1);
	 		rg.addButton(tRadio2);
	 		rg.addButton(tRadio3);
	 		rg.selectButton(tRadio1);
	 		rg.addEventListener(Event.CHANGE, handleRadioGroupChanged);
	 		 
	 		// create validator, add group for not null validation
	 		mValidator = new Validator();
	 		mValidator.addValidationRule(new NullValidationRule(rg));
	   </code>
	   To get the currently selected button, use this:
	   <code>
	   		var currentButton:SimpleCheckBox = rg.getSelection() as SimpleCheckBox;
	   </code>
	 */
	public class RadioGroup extends EventDispatcher implements IValidatable, IHasError {

		private var mButtons:Array = new Array();
		private var mCurrentSelectedButton : ISelectable;

		/**
		 *	Add a button to the group
		 */
		public function addButton (inButton : ISelectable) : void {
			if (!inButton) throw new Error("Parameter 'inButton' not defined.");
			
			mButtons.push(inButton);
			// listen to click events from button in capture mode, to disable deselection for selected buttons
			inButton.addSelectListener(handleButtonSelected);
		}
		
		/**
		 * Select the specified button (can be null to deselect current selection)
		 */
		public function selectButton (inButton : ISelectable) : void {
			if (mCurrentSelectedButton) {
				mCurrentSelectedButton.setIsSelected(false);
				mCurrentSelectedButton.setIsEnabled(true);
			}
			
			mCurrentSelectedButton = inButton;
			
			if (mCurrentSelectedButton) {
				mCurrentSelectedButton.setIsSelected(true);
				mCurrentSelectedButton.setIsEnabled(false);
			}
		}
		
		/**
		 *	Return the currently selected button
		 */
		public function getSelection() : ISelectable {
			return mCurrentSelectedButton;
		}

		/**
		 * Return the selection for validation
		 */
		public function getValue() : Object {
			return getSelection();
		}

		/**
		 * Show the error state
		 */
		public function showError() : void {
			var leni : uint = mButtons.length;
			for (var i:uint = 0; i < leni; i++) {
				var btn : IHasError = mButtons[i] as IHasError;
				if (btn) btn.showError(); 
			}
		}
		
		/**
		 * Hide the error state
		 */
		public function hideError() : void {
			var leni : uint = mButtons.length;
			for (var i:uint = 0; i < leni; i++) {
				var btn : IHasError = mButtons[i] as IHasError;
				if (btn) btn.hideError(); 
			}
		}

		/**
		 * Handle click event from radio buttons
		 */
		private function handleButtonSelected(e : MouseEvent) : void {
			selectButton(e.target as ISelectable);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function toString():String {
			return "; com.lostboys.form.RadioGroup ";
		}
	}
}
