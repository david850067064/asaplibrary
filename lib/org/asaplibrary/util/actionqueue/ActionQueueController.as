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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.asaplibrary.util.FramePulse;
	import org.asaplibrary.util.actionqueue.*;

	/**
		
	*/
	public class ActionQueueController extends EventDispatcher {
		
		/**
		List of ActionQueueData objects
		*/
		private var mQueues:Array = new Array();
		private var mConditions:Array = new Array();
		private var mConditionsToDelete:Array = new Array();
		
		private var DEBUG:Boolean = false;
		
		/**
		
		*/
		function ActionQueueContoller() {
			FramePulse.addEnterFrameListener(step);
		}
		
		/**
		
		*/
		public function register (inActionQueue:ActionQueue,
								  inUpdateMethod:Function) : void {
			var data:ActionQueueData = new ActionQueueData(inActionQueue, inUpdateMethod);
			mQueues.push(data);
		}
		
		/**
		
		*/
		public function unRegister (inActionQueue:ActionQueue) : void {
			var index:int = getQueueArrayIndex(inActionQueue);
			if (index != -1) {
				mQueues.splice(index, 1);
			}
		}
		
		/**
		
		*/
		private function getQueueArrayIndex (inActionQueue:ActionQueue) : int {
			var i:int, size:int = mQueues.length;
			for (i=0; i<size; i++) {
				if (mQueues[i].queue == inActionQueue) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		
		*/
		public function addCondition (inCondition:Condition) : void {
			mConditions.push(inCondition);
		}
		
		/**
		
		*/
		public function removeCondition (inCondition:Condition) : void {
			// do not delete immediately or we get problems in loops
			mConditionsToDelete.push(inCondition);
		}
		
		/**
		
		*/
		private function doMaintenance () : void {
			mConditionsToDelete.forEach(deleteCondition);
		}
		
		/**
		
		*/
		public function deleteCondition (inCondition:Condition, index:int, arr:Array) : void {
			var index:int = mConditions.indexOf(inCondition);
			if (index != -1) {
				mConditions.splice(index, 1);
			}
		}
		
		/**
		
		*/
		public function step (e:Event) : void {
			doMaintenance();
			
			var i:int, size:int = mQueues.length;
			handleConditions();
			for (i=0; i<size; ++i) {
				var ad:ActionQueueData = mQueues[i];
				// check existence; may have been deleted in the meantime
				if (ad != null) {
					ad.updateMethod.call(ad.queue, e);
				}
			}
			
		}
		
		/**
		
		*/
		private function handleConditions () : void {
			mConditions.forEach(handleConditionEquals);
		}
		
		/**
		
		*/
		private function handleConditionEquals(inCondition:Condition,
										 	   index:int,
											   arr:Array) : void {
			
			var conditionMet:Boolean = inCondition.evaluate();
			if (conditionMet) {	
				removeCondition(inCondition);
				inCondition.onConditionMet();			
			}
        }
        
	}
}

import org.asaplibrary.util.actionqueue.*;

/**
		
*/
class ActionQueueData {

	public var queue:ActionQueue;
	public var updateMethod:Function;
	
	function ActionQueueData (inActionQueue:ActionQueue,
							  inUpdateMethod:Function) {
		queue = inActionQueue;
		updateMethod = inUpdateMethod;
	}
}
