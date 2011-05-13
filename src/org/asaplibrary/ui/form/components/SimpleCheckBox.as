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
	import org.asaplibrary.ui.buttons.BaseButton;
	import org.asaplibrary.util.validation.IHasError;
	import org.asaplibrary.util.validation.IValidatable;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * Very simple implementation of checkbox behaviour.
	 * This class expects one child with name "tV" on the timeline that will be set to visible or invisible depending on selection state. No animation is provided.
	 */
	public class SimpleCheckBox extends BaseButton implements ISelectable, IHasError, IValidatable, IResettable {
		public var tV : DisplayObject;
		public var tError : MovieClip;
		protected var mIsSelected : Boolean = false;

		public function SimpleCheckBox() {
			super();

			tV.visible = false;
			if (tError) tError.visible = false;

			tabEnabled = false;

			addEventListener(MouseEvent.CLICK, handleClick);
		}

		/**
		 * @return true if button is selected, otherwise false
		 */
		public function isSelected() : Boolean {
			return mIsSelected;
		}

		/**
		 * Set selection state
		 */
		public function setSelected(inSelected : Boolean) : void {
			mIsSelected = inSelected;

			tV.visible = mIsSelected;
		}

		/**
		 *
		 */
		public function setEnabled(inEnabled : Boolean) : void {
			mouseEnabled = inEnabled;
		}

		/**
		 *
		 */
		public function isEnabled() : Boolean {
			return mouseEnabled;
		}

		/**
		 * Show the error state
		 */
		public function showError() : void {
			tError.visible = true;
		}

		/**
		 * Hide the error state
		 */
		public function hideError() : void {
			tError.visible = false;
		}

		/**
		 * Return the value to be validated
		 */
		public function getValue() : * {
			return isSelected();
		}

		/**
		 * Reset the checkbox by deselecting & enabling it
		 */
		public function reset() : void {
			setEnabled(true);
			setSelected(false);
		}

		protected function handleClick(event : MouseEvent) : void {
			mIsSelected = !mIsSelected;

			tV.visible = mIsSelected;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
