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
	import org.asaplibrary.util.validation.IValidatable;	
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.asaplibrary.ui.buttons.BaseButton;
	import org.asaplibrary.util.validation.IHasError;	

	/**
	 * Very simple implementation of checkbox behaviour.
	 * This class expects one child with name "tV" on the timeline that will be set to visible or invisible depending on selection state. No animation is provided.
	 */
	public class SimpleCheckBox extends BaseButton implements ISelectable, IHasError, IValidatable {
		public var tV : DisplayObject;
		public var tError : MovieClip;
		
		private var mIsSelected:Boolean = false;

		public function SimpleCheckBox () {
			super();
			
			tV.visible = false;
			tError.visible = false;
			
			tabEnabled = false;
			
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		/**
		 * @return true if button is selected, otherwise false
		 */
		public function getIsSelected () : Boolean {
			return mIsSelected;
		}
		
		/**
		 * Set selection state
		 */
		public function setIsSelected (inSelected:Boolean) : void {
			mIsSelected = inSelected;
			
			tV.visible = mIsSelected;
		}
		
		/**
		 *
		 */
		public function setIsEnabled (inEnabled:Boolean) : void {
			mouseEnabled = inEnabled;
		}
		
		/**
		 *
		 */
		public function getIsEnabled () : Boolean {
			return mouseEnabled;
		}
		
		/**
		 * Add a handler for change of selection state. This in fact adds a listener to MouseEvent.CLICK.
		 */
		public function addSelectListener (inHandler:Function) : void {
			addEventListener(MouseEvent.CLICK, inHandler);
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
		public function getValue() : Object {
			return getIsSelected();
		}		

		private function handleClick(event : MouseEvent) : void {
			mIsSelected = !mIsSelected;
			
			tV.visible = mIsSelected;
		}

		override public function toString():String {
			return "; org.asaplibrary.ui.form.components.SimpleCheckBox ";
		}
	}
}
