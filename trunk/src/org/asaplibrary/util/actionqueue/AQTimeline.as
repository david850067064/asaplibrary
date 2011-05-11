/*
Copyright 2005-2006 by the authors of asapframework, http://asapframework.org

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
package org.asaplibrary.util.actionqueue {
	import flash.display.MovieClip;

	/**
	Action methods to control a MovieClip's timeline.
	 */
	public class AQTimeline {
		/**
		Moves the framehead to a frame number or label and plays.
		@param inMC : movieclip which timeline to control
		@param inFrame : (optional) frame number (Number) or frame label (String); default frame number 1
		 */
		public function gotoAndPlay(inMC : MovieClip, inFrame : Object = null) : Action {
			return new Action(doGotoAndPlay, [inMC, inFrame]);
		}

		protected function doGotoAndPlay(inMC : MovieClip, inFrame : Object = null) : void {
			var frame : Object = (inFrame != null) ? inFrame : Number(1);
			inMC.gotoAndPlay(frame);
		}

		/**
		Moves the framehead to a frame number or label and stops.
		@param inMC : movieclip which timeline to control
		@param inFrame : (optional) frame number (Number) or frame label (String); default frame number 1
		 */
		public function gotoAndStop(inMC : MovieClip, inFrame : Object = null) : Action {
			return new Action(doGotoAndStop, [inMC, inFrame]);
		}

		protected function doGotoAndStop(inMC : MovieClip, inFrame : Object = null) : void {
			var frame : Object = (inFrame != null) ? inFrame : Number(1);
			inMC.gotoAndStop(frame);
		}
	}
}