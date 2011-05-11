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
	import org.asaplibrary.util.FramePulse;

	import flash.events.*;
	import flash.utils.getQualifiedClassName;

	/**
	ConditionManager repeatedly runs through a list of {@link Condition Conditions} (on each {@link FramePulse} event, until all conditions are met).  
	 */
	public class ConditionManager extends EventDispatcher {
		protected var mConditions : Array;
		protected var mConditionsToDelete : Array;
		protected var mRegistered : Boolean;

		/**
		Creates a new ConditionManager.
		 */
		function ConditionManager() {
			super();
			mConditions = new Array();
			mConditionsToDelete = new Array();
			FramePulse.addEnterFrameListener(step);
		}

		/**
		@exclude
		 */
		override public function toString() : String {
			return getQualifiedClassName(this);
		}

		/**
		Registers a Condition to be evaluated on each frame pulse.
		@param inCondition: condition to be checked
		 */
		public function registerCondition(inCondition : Condition) : void {
			mConditions.push(inCondition);
			if (!mRegistered) registerFrameUpdate();
		}

		/**
		Unregisters a condition.
		@param inCondition: condition to be removed from checking
		 */
		public function unRegisterCondition(inCondition : Condition) : void {
			mConditionsToDelete.push(inCondition);
			deleteConditionsToDelete();
		}

		/**
		Clears the list of Conditions.
		 */
		public function reset() : void {
			mConditionsToDelete = mConditionsToDelete.concat(mConditions);
			deleteConditionsToDelete();
			mConditions = new Array();
			unRegisterFrameUpdate();
		}

		/**
		Calls {@link #deleteCondition} on each Condition on the 'to delete list'.
		 */
		protected function deleteConditionsToDelete() : void {
			mConditionsToDelete.forEach(deleteCondition);
		}

		/**
		Performs deletion of a condition from the 'to delete list'.
		@param inCondition: condition to delete
		 */
		protected function deleteCondition(inCondition : Condition, inIndex : int, inArr : Array) : void {
			var index : int = mConditions.indexOf(inCondition);
			if (index != -1) {
				mConditions.splice(index, 1);
			}
			if (mConditions.length == 0) {
				unRegisterFrameUpdate();
			}
		}

		/**
		Calls {@link #evaluate} on every stored Condition. Called on each FramePulse event.
		@param e: FramePulse event
		 */
		protected function step(e : Event = null) : void {
			mConditions.forEach(evaluate);
			mConditionsToDelete.forEach(deleteCondition);
		}

		/**
		Evaluates a particular Condition by calling {@link Condition#run} on it. If the condition is met (when the result is <code>true</code>), an update message is sent.
		@param inCondition: Condition to evaluate
		@sends ConditionEvent#CONDITION_MET
		 */
		protected function evaluate(inCondition : Condition, inIndex : int, inArr : Array) : void {
			var doesMeet : Boolean = inCondition.run();
			if (doesMeet) {
				dispatchEvent(new ConditionEvent(ConditionEvent.CONDITION_MET, inCondition));
				// mark for deletion
				mConditionsToDelete.push(inCondition);
			}
		}

		/**
		Registers with {@link FramePulse} to call {@link #step} on every frame pulse.
		 */
		protected function registerFrameUpdate() : void {
			FramePulse.addEnterFrameListener(step);
			mRegistered = true;
		}

		/**
		Unregisters with {@link FramePulse}.
		 */
		protected function unRegisterFrameUpdate() : void {
			FramePulse.removeEnterFrameListener(step);
			mRegistered = false;
		}
	}
}
