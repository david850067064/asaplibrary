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
	import flash.utils.getQualifiedClassName;

	/**
	A Condition is an {@link Action} that runs an evaluation method and returns its result: true or false. 
	
	Conditions may be used in {@link ActionQueue ActionQueues} or {@link ActionRunner ActionRunners} - see {@link ActionQueue#addCondition}.
	@use
	<code>
	var condition:Condition = new Condition(evaluateInput, [1]);
	condition.run();
	trace(condition.isMet()); // true
			
	private function evaluateInput (inParam:int) : Boolean {
	return (inParam > 0) ? true : false;
	}
	</code>
	 */
	public class Condition extends Action {
		protected var mOnConditionMetCallFunctions : Array;
		protected var mOnConditionNotMetCallFunctions : Array;
		protected var mMet : Boolean;
		protected var mRegisteredObjects : Object;

		/**< Asociative array */
		/**
		Creates a new Condition. Optionally add parameters to the evaluating method; optionally add a list of functions that should be called when the condition is met; or another list of functions that should be called when the condition is not met.
		@param inEvaluationMethod: evaluation method; this method will be called each frame pulse
		@param inArgs: (optional) arguments that are passed to the evaluation method
		@param inOnConditionMetCallFunctions: (optional) a list of functions to be called when the condition is met; NOTE: pausing and resuming ActionQueues and ActionRunners are dealt with automatically
		@param inOnConditionNotMetCallFunctions: (optional) a list of functions to be called when the condition is NOT met
		 */
		function Condition(inEvaluationMethod : Function, inArgs : Array = null, inOnConditionMetCallFunctions : Array = null, inOnConditionNotMetCallFunctions : Array = null) {
			super(inEvaluationMethod, inArgs);
			mOnConditionMetCallFunctions = inOnConditionMetCallFunctions;
			mOnConditionNotMetCallFunctions = inOnConditionNotMetCallFunctions;
			mRegisteredObjects = {};
			mMet = false;
		}

		/**
		@exclude
		 */
		override public function toString() : String {
			return getQualifiedClassName(this);
		}

		/**
		@return True if the condition is met; otherwise false.
		 */
		public function isMet() : Boolean {
			return mMet;
		}

		/**
		Calls the evaluation method.
		@return True when the condition is met; otherwise false.
		 */
		public override function run() : * {
			if (mMet) return true;
			var conditionMet : Boolean = mMethod.apply(null, mArgs);
			if (conditionMet) {
				mMet = true;
				if (mOnConditionMetCallFunctions) {
					mOnConditionMetCallFunctions.forEach(callMethodMet);
				}
			} else {
				if (mOnConditionNotMetCallFunctions) {
					mOnConditionNotMetCallFunctions.forEach(callMethodNotMet);
				}
			}
			return conditionMet;
		}

		/**
		Executes a "evaluation met" function (as passed to {@link #Condition}.
		 */
		protected function callMethodMet(inMethod : Function, inIndex : int, inArr : Array) : void {
			inMethod();
		}

		/**
		Executes a "evaluation not met" function (as passed to {@link #Condition}.
		 */
		protected function callMethodNotMet(inMethod : Function, inIndex : int, inArr : Array) : void {
			inMethod();
		}
	}
}
