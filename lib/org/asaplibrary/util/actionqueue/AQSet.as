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

package org.asaplibrary.util.actionqueue {
	
	import flash.display.*;
		
	public class AQSet {
		
		/**
		
		*/
		public function setLoc (inDO:DisplayObject,
								inX:Number = Number.NaN,
								inY:Number = Number.NaN) : void {
			var x:Number = (!isNaN(inX)) ? inX : inDO.x;
			var y:Number = (!isNaN(inY)) ? inY : inDO.y;
			inDO.x = x;
			inDO.y = y;
		}

		/**
		
		*/
		public function setVisible (inDO:DisplayObject,
									inFlag:Boolean) : void {
			inDO.visible = inFlag;
		}
		
		/**
		
		*/
		public function setAlpha (inDO:DisplayObject,
								  inAlpha:Number) : void {
			inDO.alpha = inAlpha;
		}
		
		/**
		
		*/
		public function setScale (inDO:DisplayObject,
								  inScaleX:Number,
								  inScaleY:Number) : void {
			var scaleX:Number = (!isNaN(inScaleX)) ? inScaleX : inDO.scaleX;
			var scaleY:Number = (!isNaN(inScaleY)) ? inScaleY : inDO.scaleY;
			inDO.scaleX = scaleX;
			inDO.scaleY = scaleY;
		}
		
		/**
		
		*/
		public function setToMouse (inDO:DisplayObject) : void {
			inDO.x = inDO.parent.mouseX;
			inDO.y = inDO.parent.mouseY;
		}			
		
		/**
		
		*/
		public function centerOnStage (inDO:DisplayObject,
								  	   inOffsetX:Number = Number.NaN,
								   	   inOffsetY:Number = Number.NaN) : void {
			var x:Number = inDO.stage.stageWidth / 2;
			var y:Number = inDO.stage.stageHeight / 2;
			
			x += (!isNaN(inOffsetX)) ? inOffsetX : 0;
			y += (!isNaN(inOffsetY)) ? inOffsetY : 0;

			inDO.x = x;
			inDO.y = y;
		}
		
		/**
		
		*/
		public function setEnabled (inMC:MovieClip,
									inState:Boolean) : void {
			inMC.enabled = inState;
		}
		
		/*
		public function setActive (inMC:MovieClip,
							   	   inState:Boolean) : Action {
			MovieClipUtils.setActive( inMC, inFlag );
		}
		*/
				
	}
}