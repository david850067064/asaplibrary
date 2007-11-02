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
	
	import flash.events.*;
	import org.asaplibrary.util.actionqueue.ConditionManager;
	
	/**
	Sequentially calls a list of Action objects. Each action is performed one after the other.
	
	ActionRunner is used by {@link ActionQueue}, but can be used on its own.
	
	Actions are objects of type {@link Action}, {@link IAction}, {@link TimedAction} or {@link ITimedAction} or any subclass thereof.
	*/
	public class ActionRunner extends EventDispatcher implements IAction {
	
		private var mName:String; // for debugging
		private var mActions:Array;
		private var mCurrentStep:int;
		private var mRegistered:Boolean = false;
		private var mFinished:Boolean = false;
		private var mPaused:Boolean = false;
		private var mRunning:Boolean = false;		
		private var mCurrentAction:IAction;
  		private var mWaitingForCondition:Boolean;
  		private var mConditionManager:ConditionManager;

		/**
		Creates a new ActionRunner.
		@param inName: (optional) identifier name of this ActionRunner - used for debugging
		*/
		function ActionRunner (inName:String = "Anonymous ActionRunner") {
			mName = inName;
			mActions = new Array();
			mCurrentStep = 0;
		}
		
		/**
		@return True is the ActionRunner is running actions; false if it is stopped or finished. A paused but running runner will return true.
		*/
		public function isRunning() : Boolean {
			return mRunning;
		}
		
		/**
		Sets the list of actions.
		@param inAction: the list of Actions to set
		*/
		public function setActions(inActions:Array) : void {
			mActions = inActions;
			mCurrentStep = 0;
		}
		
		/**
		Adds a list of actions to the existing list.
		*/
		public function addActions(inActions:Array) : void {
			if (inActions == null) return;
			mActions = mActions.concat(inActions);
		}
		
		/**
		Add an Action to the existing list of actions.
		*/
		public function addAction(inAction:IAction) : void {
			if (inAction == null) return;
			mActions.push(inAction);
		}
		
		/**
		Inserts an Action at a specific position in the list of actions.
		*/
		public function insertActionAtIndex(inIndex:uint, inAction:IAction) : void {
			mActions.splice(inIndex, 0, inAction);
		}

		/**
		Starts running the actions.
		@return null
		@sends ActionEvent#STARTED
		*/
		public function run () : * {
			if (mActions.length == 0) return null;
			mFinished = false;
			mRunning = true;
			dispatchEvent(new ActionEvent(ActionEvent.STARTED, this, mName));
			step();
			return null;
		}
		
		/**
		Pauses the runner.
		@param inContinueWhereLeftOff: (optional) whether the Action should continue where it left off when the runner is resumed
		@sends ActionEvent#PAUSED
		*/
		public function pause (inContinueWhereLeftOff:Boolean = true) : void {
			mPaused = true;
			if (mCurrentAction is ITimedAction) {
				ITimedAction(mCurrentAction).pause(inContinueWhereLeftOff);
			}
			dispatchEvent(new ActionEvent(ActionEvent.PAUSED, this, mName));
		}
		
		/**
		Stops the runner, but does not clear the action list.
		@sends ActionEvent#STOPPED
		*/
		public function stop () : void {
			mRunning = false;
			if (mCurrentAction is ITimedAction) ITimedAction(mCurrentAction).stop();
			dispatchEvent(new ActionEvent(ActionEvent.STOPPED, this, mName));
		}
	
		/**
		@return True if the runner has run through all actions; otherwise false.
		*/
		public function isFinished () : Boolean {
			return mFinished;
		}

		/**
		@return True if the runner has been paused; otherwise false.
		*/
		public function isPaused () : Boolean {
			return mPaused;
		}
		
		/**
		The list of actions.
		*/
		public function getActions () : Array {
			return mActions;
		}
		
		/**
		Quits the runner and clears the list of actions.
		@sends ActionEvent#QUIT
		*/
		public function quit () : void {
			reset();
			dispatchEvent(new ActionEvent(ActionEvent.QUIT, this, mName));
		}
		
		/**
		Clears the action list.
		*/
		public function reset () : void {
			if (mCurrentAction is ITimedAction) ITimedAction(mCurrentAction).stop();
			mRunning = false;
			mActions = new Array();
			if (mConditionManager != null) mConditionManager.reset();
			mCurrentStep = 0;
		}
		
		/**
		Resumes a paused runner.
		@sends ActionEvent#RESUMED
		*/
		public function resume () : void {
			mPaused = false;
			mRunning = true;
			dispatchEvent(new ActionEvent(ActionEvent.RESUMED, this, mName));
			if (mCurrentAction is ITimedAction) {
				ITimedAction(mCurrentAction).resume();
				return;
			}
			if (mCurrentAction == null && !mWaitingForCondition) {
				step();
			}
		}
		
		/**
		The name of this runner.
		*/
		public function getName () : String {
			return mName;
		}
		
		/**
		Called when a Condition has been met and this runner may continue.
		*/
		protected function resumeAfterCondition () : void {
			mWaitingForCondition = false;
			step();
		}
		
		/**
		@exclude
		*/
		override public function toString () : String {
			return "ActionRunner " + getName();
		}
		
		/**
		Skips the pointer to the action by one.
		*/
		public function skip () : void {
			mCurrentStep++;
		}
		
		/**
		Sets the index of the current step. The index is zero-based, so the first action has step index 0.
		*/
		public function gotoStep (inIndex:int) : void {
			mCurrentStep = inIndex;
		}
		
		/**
		Tries to loop through the action list as long as possible.
		*/
		protected function nextAction (inAction:IAction) : void {
			if (!inAction) return;
			while ( !applyAction(inAction) ) {
				if (mPaused) break;
				if (mWaitingForCondition) break;
				if (mActions.length != mCurrentStep) {
					inAction = mActions[mCurrentStep++];
				} else {
					finish();
					break;
				}
			}
		}
		
		/**
		Called with Action updates.
		*/
		protected function onActionEvent (e:ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.FINISHED:
					mCurrentAction = null;
					if (mCurrentStep >= mActions.length) {
						finish();
						return;
					} else {
						step();
					}
					break;
			}
		}
		
		/**
		Called with Condition updates.
		*/
		protected function onConditionEvent (e:ConditionEvent) : void {
			resumeAfterCondition();
		}
		
		/**
		Runs the next action in the list.
		*/
		protected function step () : void {
			nextAction( mActions[mCurrentStep++] );
		}
		
		/**
		Processes an action.
		@param inAction: the {@link IAction} to process.
		@return True when the called action is of type {@link ITimedAction} or {@link Condition}; otherwise false.
		*/
		protected function applyAction (inAction:IAction) : Boolean {

			if (!inAction) return false;

			if (inAction is Condition) {
				handleCondition(Condition(inAction));
				// consider this a timed action
				// (ConditionManager is updated per frame)
				return true;
			}
			
			if (inAction is ITimedAction) {
				runTimedAction(ITimedAction(inAction));
				return true;
			}
			// else
			var result:* = inAction.run();
			mCurrentAction = inAction;
			
			if (result is ITimedAction) {
				runTimedAction(ITimedAction(result));
				return true;
			}

			// function has not returned an object of type ITimedAction so is not frame based
			return false;
		}
		
		/**
		Processes a {@link ITimedAction} object.
		*/
		protected function runTimedAction (inAction:ITimedAction) : void {
			mCurrentAction = inAction;
			inAction.addEventListener(ActionEvent._EVENT, onActionEvent);
			inAction.run();
		}
		
		/**
		Processes a {@link Condition} object.
		*/
		protected function handleCondition (inCondition:Condition) : void {
			if (!mConditionManager) {
				mConditionManager = new ConditionManager();
			}
			mConditionManager.registerCondition(inCondition);
			mConditionManager.addEventListener(ConditionEvent._EVENT, onConditionEvent);
			mWaitingForCondition = true;
		}
		
		/**
		Finishes this runner.
		@sends ActionEvent#FINISHED
		*/
		protected function finish () : void {
			mFinished = true;
			mRunning = false;
			dispatchEvent(new ActionEvent(ActionEvent.FINISHED, this, mName));
		}
		
	}
	
}
