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
	import flash.events.MouseEvent;			

	/**
	 * @author stephan.bezoen
	 */
	public class RadioGroup {
		
		private var mButtons:Array = new Array();
		private var mCurrentSelectedButton : ISelectable;

		/**
		 *	Add a button to the group
		 */
		public function addButton (inButton : ISelectable) : void {
			mButtons.push(inButton);
			inButton.addSelectListener(handleButtonSelected);
		}
		
		/**
		 * Select the specified button (can be null to deselect current selection)
		 */
		public function selectButton (inButton : ISelectable) : void {
			if (mCurrentSelectedButton) mCurrentSelectedButton.setIsSelected(false);
			
			mCurrentSelectedButton = inButton;
			
			if (mCurrentSelectedButton) mCurrentSelectedButton.setIsSelected(true);
		}
		
		/**
		 *	Return the currently selected button
		 */
		public function getSelection() : ISelectable {
			return mCurrentSelectedButton;
		}

		private function handleButtonSelected(event : MouseEvent) : void {
			if (event.target == mCurrentSelectedButton) return;
			
			selectButton(event.target as ISelectable);
		}
		
		public function toString():String {
			return "; com.lostboys.form.RadioGroup ";
		}
	}
}
