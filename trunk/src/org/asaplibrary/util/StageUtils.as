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
/**
Number utility functions.
 */
package org.asaplibrary.util {
	import flash.display.DisplayObject;

	public class StageUtils {
		/**
		Centers a DisplayObject to the stage. 
		@param inDO: DisplayObject to center
		@param inOffsetX: (optional) x offset
		@param inOffsetY: (optional) y offset
		@param inShouldCenter: (optional) whether the object should be centered itself, assuming a origin at the upper left; when set to true, the position of the object is moved left and up by half its width and height
		@example
		This example centers the DisplayObject on the stage, with an offset of 50 and 0:
		<code>
		StageUtils.centerOnStage( my_mc, false, 50, 0 );
		</code>
		 */
		public static function centerOnStage(inDO : DisplayObject, inOffsetX : Number = Number.NaN, inOffsetY : Number = Number.NaN, inShouldCenter : Boolean = false) : void {
			var x : Number = inDO.stage.stageWidth / 2;
			var y : Number = inDO.stage.stageHeight / 2;
			if (!(isNaN(inOffsetX))) x += inOffsetX;
			if (!(isNaN(inOffsetY))) y += inOffsetY;
			if (inShouldCenter) {
				x -= (inDO.width / 2);
				y -= (inDO.height / 2);
			}
			inDO.x = x;
			inDO.y = y;
		}
	}
}