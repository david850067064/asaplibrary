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

	/**
	Button state options used by {@link ButtonStateDelegate}. The state options use bitwise operators to allow combinations of values.
	
	Bitwise operators are AND (&), OR (|) and XOR (^).
	@example
	Assigment:
	<code>
	var state:uint = 0;
	state |= ButtonStates.OVER; // state is now OVER
	state |= ButtonStates.PRESSED; // state is now OVER and PRESSED
	</code>
	Retrieval:
	<code>
	var isOver:Boolean;
	isOver = (state & ButtonStates.UP); // false
	isOver = (state & ButtonStates.OVER); // true
	isOver = (state & ButtonStates.PRESSED); // true
	</code>			
	*/
	public class ButtonStates {
		
		public static const NONE:uint =             0;
		public static const NORMAL:uint =       (1<<1);
		public static const OVER:uint =         (1<<2);
		public static const OUT:uint =          (1<<3);
		public static const ENABLED:uint =      (1<<4);
		public static const DISABLED:uint =     (1<<5);
		public static const SELECTED:uint =     (1<<6);
		public static const DESELECTED:uint =   (1<<7);
		
		// not used yet
		public static const UP:uint =           (1<<8);
		public static const PRESSED:uint =      (1<<9);
		public static const CLICK:uint =        (1<<10);
		public static const DOUBLE_CLICK:uint = (1<<11);
		public static const MOUSE_WHEEL:uint =  (1<<12);

	}
}