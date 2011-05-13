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
package org.asaplibrary.ui.form.components {
	import org.asaplibrary.util.validation.IHasError;
	import org.asaplibrary.util.validation.IValidatable;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * Class for implementing radio button groups.
	 * @example
	 * Assume 3 objects of type SimpleCheckBox are placed on the stage, with instance names "tRadio1", "tRadio2", "tRadio3"
	 * <code>
	// create new group, add radio buttons, select first button, listen to change event
	var rg:RadioGroup = new RadioGroup();
	rg.addButton(tRadio1, "1");
	rg.addButton(tRadio2, "2");
	rg.addButton(tRadio3, "3");
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
	To get the value of the currently selected button, use this:
	<code>
	var value:* = rg.getValue();
	</code>
	 */
	public class RadioGroup extends EventDispatcher implements IValidatable, IHasError, IResettable {
		/** objects of type Selection */
		protected var mButtons : Array = new Array();
		protected var mCurrentSelectedButton : ISelectable;

		/**
		 *	Add a button to the group
		 */
		public function addButton(inButton : ISelectable, inValue : *) : void {
			if (!inButton) throw new Error("Parameter 'inButton' not defined.");

			mButtons.push(new Selection(inButton, inValue));

			// listen to click events from button in capture mode, to disable deselection for selected buttons
			inButton.addEventListener(MouseEvent.CLICK, handleButtonSelected);
		}

		/**
		 * Select the specified button (can be null to deselect current selection)
		 */
		public function selectButton(inButton : ISelectable) : void {
			if (mCurrentSelectedButton) {
				mCurrentSelectedButton.setSelected(false);
				mCurrentSelectedButton.setEnabled(true);
			}

			mCurrentSelectedButton = inButton;

			if (mCurrentSelectedButton) {
				mCurrentSelectedButton.setSelected(true);
				mCurrentSelectedButton.setEnabled(false);
			}
		}

		/**
		 *	Return the currently selected button
		 */
		public function getSelection() : ISelectable {
			return mCurrentSelectedButton;
		}

		/**
		 * @return all buttons in this group; objects of type ISelectable
		 */
		public function getButtons() : Array {
			var a : Array = new Array();
			var leni : uint = mButtons.length;
			for (var i : uint = 0; i < leni; i++) {
				a.push((mButtons[i] as Selection).button);
			}

			return a;
		}

		/**
		 * @return the value of the currently selected button as provided during addition; returns null if no button is selected. 
		 */
		public function getValue() : * {
			var leni : uint = mButtons.length;
			for (var i : uint = 0; i < leni; i++) {
				var sel : Selection = mButtons[i];
				if (mCurrentSelectedButton == sel.button) return sel.value;
			}
			return null;
		}

		/**
		 * Show the error state
		 */
		public function showError() : void {
			var leni : uint = mButtons.length;
			for (var i : uint = 0; i < leni; i++) {
				var btn : IHasError = (mButtons[i] as Selection).button as IHasError;
				if (btn) btn.showError();
			}
		}

		/**
		 * Hide the error state
		 */
		public function hideError() : void {
			var leni : uint = mButtons.length;
			for (var i : uint = 0; i < leni; i++) {
				var btn : IHasError = (mButtons[i] as Selection).button as IHasError;
				if (btn) btn.hideError();
			}
		}

		/**
		 * Reset the group by calling reset on all buttons if they implement IResettable, or deselecting & enabling them 
		 */
		public function reset() : void {
			var leni : uint = mButtons.length;
			for (var i : uint = 0; i < leni; i++) {
				var sel : Selection = mButtons[i];
				if (sel.button is IResettable) (sel.button as IResettable).reset();
				else {
					var btn : ISelectable = sel.button;
					btn.setSelected(false);
					btn.setEnabled(true);
				}
			}
			mCurrentSelectedButton = null;
		}

		/**
		 * Handle click event from radio buttons
		 */
		protected function handleButtonSelected(e : MouseEvent) : void {
			selectButton(e.target as ISelectable);

			dispatchEvent(new Event(Event.CHANGE));
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import org.asaplibrary.ui.form.components.ISelectable;

class Selection {
	public var button : ISelectable;
	public var value : *;

	public function Selection(inButton : ISelectable, inValue : *) {
		button = inButton;
		value = inValue;
	}
}