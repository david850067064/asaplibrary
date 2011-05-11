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
package org.asaplibrary.util.actionqueue {
	import flash.display.*;

	/**
	Action methods to set the properties of a DisplayObject or MovieClip.
	 */
	public class AQSet {
		/**
		Sets the location of a DisplayObject
		@param inDO: DisplayObject to set
		@param inX: (optional) x position; default the current x position
		@param inY: (optional) y position; default the current y position
		@return The performing Action.
		 */
		public function setLoc(inDO : DisplayObject, inX : Number = Number.NaN, inY : Number = Number.NaN) : Action {
			return new Action(doSetLoc, [inDO, inX, inY]);
		}

		protected function doSetLoc(inDO : DisplayObject, inX : Number = Number.NaN, inY : Number = Number.NaN) : void {
			var x : Number = (!isNaN(inX)) ? inX : inDO.x;
			var y : Number = (!isNaN(inY)) ? inY : inDO.y;
			inDO.x = x;
			inDO.y = y;
		}

		/**
		Sets the visible flag of a DisplayObject.
		@param inDO: DisplayObject to set
		@param inFlag: visibility flag
		@return The performing Action.
		 */
		public function setVisible(inDO : DisplayObject, inFlag : Boolean) : Action {
			return new Action(doSetVisible, [inDO, inFlag]);
		}

		protected function doSetVisible(inDO : DisplayObject, inFlag : Boolean) : void {
			inDO.visible = inFlag;
		}

		/**
		Sets the alpha value of a DisplayObject.
		@param inDO: DisplayObject to set
		@param inAlpha: alpha value between 0 and 1
		@return The performing Action.
		 */
		public function setAlpha(inDO : DisplayObject, inAlpha : Number) : Action {
			return new Action(doSetAlpha, [inDO, inAlpha]);
		}

		protected function doSetAlpha(inDO : DisplayObject, inAlpha : Number) : void {
			inDO.alpha = inAlpha;
		}

		/**
		Sets the scale of a DisplayObject.
		@param inDO: DisplayObject to set
		@param inScaleX: (optional) x scale; default the current x scale
		@param inScaleY: (optional) y scale; default the current y scale
		@return The performing Action.
		 */
		public function setScale(inDO : DisplayObject, inScaleX : Number = Number.NaN, inScaleY : Number = Number.NaN) : Action {
			return new Action(doSetScale, [inDO, inScaleX, inScaleY]);
		}

		protected function doSetScale(inDO : DisplayObject, inScaleX : Number, inScaleY : Number) : void {
			var scaleX : Number = (!isNaN(inScaleX)) ? inScaleX : inDO.scaleX;
			var scaleY : Number = (!isNaN(inScaleY)) ? inScaleY : inDO.scaleY;
			inDO.scaleX = scaleX;
			inDO.scaleY = scaleY;
		}

		/**
		Sets a DisplayObject to the mouse position.
		@param inDO: DisplayObject to set
		@return The performing Action.
		 */
		public function setToMouse(inDO : DisplayObject) : Action {
			return new Action(doSetToMouse, [inDO]);
		}

		protected function doSetToMouse(inDO : DisplayObject) : void {
			inDO.x = inDO.parent.mouseX;
			inDO.y = inDO.parent.mouseY;
		}

		/**
		Sets a DisplayObject to the center of the stage.
		@param inOffsetX: (optional) x offset; default 0
		@param inOffsetY: (optional) y offset; default 0
		@return The performing Action.
		 */
		public function centerOnStage(inDO : DisplayObject, inOffsetX : Number = Number.NaN, inOffsetY : Number = Number.NaN) : Action {
			return new Action(doCenterOnStage, [inDO, inOffsetX, inOffsetY]);
		}

		protected function doCenterOnStage(inDO : DisplayObject, inOffsetX : Number = Number.NaN, inOffsetY : Number = Number.NaN) : void {
			var x : Number = inDO.stage.stageWidth / 2;
			var y : Number = inDO.stage.stageHeight / 2;

			x += (!isNaN(inOffsetX)) ? inOffsetX : 0;
			y += (!isNaN(inOffsetY)) ? inOffsetY : 0;

			inDO.x = x;
			inDO.y = y;
		}

		/**
		Sets the enabled flag of a MovieClip
		@param inOffsetX: (optional) x offset; default 0
		@param inOffsetY: (optional) y offset; default 0
		@return The performing Action.
		 */
		public function setEnabled(inMC : MovieClip, inState : Boolean) : Action {
			return new Action(doSetEnabled, [inMC, inState]);
		}

		protected function doSetEnabled(inMC : MovieClip, inState : Boolean) : void {
			inMC.enabled = inState;
		}
		/*
		public function setActive (inMC:MovieClip, inState:Boolean) : Action {
		MovieClipUtils.setActive( inMC, inFlag );
		}
		 */
	}
}