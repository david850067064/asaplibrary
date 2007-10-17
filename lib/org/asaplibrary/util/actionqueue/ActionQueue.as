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
	import flash.utils.getTimer; // temp
	import org.asaplibrary.util.FramePulse;
	import org.asaplibrary.util.actionqueue.Action;
	
	public class ActionQueue extends EventDispatcher {

		private var mActionQueueController:ActionQueueController;
		private var mName:String;
  		private var mRegistered:Boolean = false;
  		private var mIsPaused:Boolean;
		private var mActionRunners:Array; // of type ActionRunner
		private var mActions:Array; // of type Action
  		private var mMarkerHash:Object; // quick lookup for occurrence of markers; objects of type Marker
  		private var mVisitedMarkerHash:Object; // quick lookup for occurrence of visited markers
  		private var mCurrentMarker:Marker;
  		private var mLoopHash:Object; // quick lookup for occurrence of loops; objects of type Loop
		private var mHasFinished:Boolean;
  		private var mIsWaitingForCondition:Boolean;

  		private var DEBUG:Boolean = false;
  		
  		/**
		Calculates the relative value between start and end of a function at moment inPercentage in time. For instance with a movieclip that is moved by a function from A to B, <code>relativeValue</code> calculates the position of the movieclip at moment inPercentage.
		@param inStart : the start value of the object that is changing, for instance the start x position
		@param inEnd : the end value of the object that is changing, for instance the end x position
		@param inPercentage: the current moment in time expressed as a percentage value
		@return The relative value between inStart and inEnd at moment inPercentage.
		@implementationNote: The used calculation is <code>inStart + (inPercentage * (inEnd - inStart))</code>
		@example
		<code>
		public function moveToActualPosition () : void {
			mStartIntroPosition = new Point(x, y);
			mStartIntroScale = scaleX;
			var duration:Number = 2.0;
			var queue:ActionQueue = new ActionQueue();
			queue.addAction( AQReturnValue.returnValue, this, "performMoveToActualPosition", duration, 0, 1);
			queue.run();
		}
		
		protected function performMoveToActualPosition (inPercentage:Number) : void {
			x = ActionQueue.relativeValue( mStartIntroPosition.x, mPosition.x, inPercentage );
			y = ActionQueue.relativeValue( mStartIntroPosition.y, mPosition.y, inPercentage );
			scaleX = scaleY = ActionQueue.relativeValue( mStartIntroScale, mScale, inPercentage );
		}
		</code>
		*/
		public static function relativeValue (inStart:Number, inEnd:Number, inPercentage:Number) : Number {
			return inStart + (inPercentage * (inEnd - inStart));
		}
		
		function ActionQueue (inName:String = "Anonymous ActionQueue",
							  inController:ActionQueueController = null ) {

			mName = inName;
			mActionQueueController = inController;			
			mActions = new Array();
			mActionRunners = new Array();
			mVisitedMarkerHash = new Object();
			mMarkerHash = new Object();
			mLoopHash = new Object();
			initActionRunners();
		}
		
		/**
		Should be set before run is called.
		*/
		public function setController (inController:ActionQueueController) : void {
			mActionQueueController = inController;	
		}
		
		/**
		
		*/
		public function addAction (...args:Array) : void {
	
			var action:Action = createAction(args);
			if (action != null) {
				mActions.push(action);
			}
		}
		
		/**
		
		*/
		protected function createAction (inArgs:Array) : Action {

			var action:Action;
			var firstParam:* = inArgs[0];
			if (firstParam is Action) {
				action = firstParam;
			} else if (firstParam is FrameAction) {
				action = firstParam;
			} else if (firstParam is Function) {
				action = createActionFromFunction(inArgs);
			} else if (firstParam is Object) {
				if (inArgs[1] is String) {
					action = createActionFromMethodName(inArgs);
				} else {
					inArgs.shift();
					action = createActionFromObjectMethod(firstParam, inArgs);
				}
			}
			return action;
		}
		
		/**
		
		*/
		public function addActionDoNotWaitForMe (...args:Array) : void {
			
			var action:Action = createAction(args);

			var f:Function = function () : void {
				var runner:ActionRunner = addActionRunner();
				runner.setActions(new Array(action));
			};
			addAction(f);
		}
		
		/**
		
		*/
		protected function initActionRunners () : void {
			mActionRunners = new Array();
			addActionRunner();
		}
		
		/**
		
		*/
		protected function addActionRunner () : ActionRunner {
			var runner:ActionRunner = new ActionRunner(mActionRunners.length + " " + mName);
			mActionRunners.push(runner);
			return runner;
		}
				
		/**
		
		*/
		public function isBusy () : Boolean {
			return mRegistered;
		}
		
		/**
		
		*/
		public function stop () : void {
			unRegister();
			dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_STOPPED, mName));
		}
		
		/**
		
		*/
		public function addWait (inDuration:Number) : void {
			addAction(this, doWait, this, inDuration);
		}
		
		/**
		
		*/
		public function addWaitForCondition () : void {
			addAction(doWaitForCondition);
		}
		
		public function continueAfterCondition () : void {
			mIsWaitingForCondition = false;
			play();
		}
		
		/**
		
		*/
		protected function doWait (inOwner:Object,
								 inDuration:Number) : FrameAction {
			return new FrameAction(inOwner, idle, inDuration);
		}
		
		/**
		
		*/
		protected function idle (p:Number) : Boolean {
			return true;
		}
		
		/**
		
		*/
		public function addPause () : void {
			addAction(doPause);
		}
		
		/**
		
		*/
		protected function doPause () : void {
			pause();
		}
		
		/**
		
		*/
		protected function doWaitForCondition () : void {
			pause();
			mIsWaitingForCondition = true;
		}
		
		/**
		
		*/
		public function play () : void {
			if (mIsWaitingForCondition) return;
			register();
			if (mIsPaused) {
				mIsPaused = false;
				resumeActionRunners();
				dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_RESUMED, mName));
			}
		}

		/**
		
		*/
		public function togglePlay () : void {
			if (!mIsPaused) {
				pause(true);
			} else {
				play();
			}
		}
		
		/**
		
		*/
		public function pause (inPreserveRemainingTime:Boolean = true) : void {
			unRegister();
			mIsPaused = true;
			pauseActionRunners(inPreserveRemainingTime);
			dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_PAUSED, mName));
		}
		
		/**
		
		*/
		public function quit () : void {
			unRegister();
			clear();
			dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_QUIT, mName));
		}
		
		/**
		
		*/
		protected function pauseActionRunners (inPreserveRemainingTime:Boolean) : void {
			var i:int, ilen:int = mActionRunners.length;
			for (i=0; i<ilen; ++i) {
				mActionRunners[i].pause(inPreserveRemainingTime);
			}
		}
		
		/**
		
		*/
		protected function resumeActionRunners () : void {
			var i:int, ilen:int = mActionRunners.length;
			for (i=0; i<ilen; ++i) {
				mActionRunners[i].resume();
			}
		}
		
		/**
		
		*/
		public function skip () : void {
			// also skips paused state
			if (mIsPaused) {
				play();
			}
			mainActionRunner().skip();
		}
		
		/**
		
		*/
		public function goToMarker (inMarkerName:String) : void {
			doGoToMarker(inMarkerName);
		}
		
		/**
		
		*/
		public function addGoToMarker (inMarkerName:String) : void {
			addAction(doGoToMarker, inMarkerName);
		}
		
		/**
		
		*/
		protected function doGoToMarker (inMarkerName:String) : void {
			var index:int = mMarkerHash[inMarkerName].index;
			mainActionRunner().setStep(index);
		}
		
		/**
		
		*/
		public function addMarker (inMarkerName:String) : void {
			// store current position in queue
			var index:int = mActions.length;
			var marker:Marker = new Marker(inMarkerName, index);
			mMarkerHash[inMarkerName] = marker;
			// create action to be called at runtime
			addAction(doAddVisitedMarker, marker);
		}
		
		/**
		
		*/
		public function addStartLoop (inLoopName:String) : void {
			var index:int = mActions.length;
			var loop:Loop = new Loop(inLoopName, index);
			mLoopHash[inLoopName] = loop;
		}

		/**
		
		*/
		public function addEndLoop (inLoopName:String) : void {
			// find stored Loop and set end index to it
			var loop:Loop = mLoopHash[inLoopName];
			loop.endIndex = mActions.length;
			addGoToLoopStart(inLoopName);
		}
		
		public function endLoop (inLoopName:String,
								 inFinishLoopFirst:Boolean = true) : void {
			var loop:Loop = mLoopHash[inLoopName];
			loop.isLooping = false;
			if (!inFinishLoopFirst) {
				var endIndex:int = mLoopHash[inLoopName].endIndex;
				mainActionRunner().setStep(endIndex);
			}
		}
		
		/**
		
		*/
		protected function addGoToLoopStart (inLoopName:String) : void {
			addAction(doGoToLoopStart, inLoopName);
		}
		
		/**
		TODO: clear passed markers
		*/
		protected function doGoToLoopStart (inLoopName:String) : void {
			var loop:Loop = mLoopHash[inLoopName];
			if (loop.isLooping) {
				mainActionRunner().setStep(loop.startIndex);
			}
		}
		
		/**
		Called at queue runtime
		*/
		protected function doAddVisitedMarker (inMarker:Marker) : void {
			mCurrentMarker = inMarker;
			if (mVisitedMarkerHash[inMarker.name] == null) {
				mVisitedMarkerHash[inMarker.name] = inMarker.index;
			}
			dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_MARKER_PASSED, mName, mCurrentMarker.name));
		}
		
		/**
		Name of the last visited marker.
		*/
		public function lastPassedMarker () : String {
			return mCurrentMarker.name;
		}
		
		/**
		@returns True if the marker action with name inMarkerName has been run.
		*/
		public function didPassMarker (inMarkerName:String) : Boolean {
			return mVisitedMarkerHash[inMarkerName] != null;
		}
		
		/**
		
		*/
		public function hasFinished () : Boolean {
			return mHasFinished;
		}
		
		/**
	
		*/
		public function clear () : void {
			initActionRunners();
			mActions = new Array();
			mVisitedMarkerHash = new Object();
			mCurrentMarker = null;
			mMarkerHash = new Object();
		}
		
		/**
		
		*/
		public function isPaused () : Boolean {
			return mIsPaused;
		}
		
		/**
		
		*/
		public override function toString () : String {
			return "ActionQueue: " + mName;
		}
		
		/**
		
		*/
		public function run () : void {
			register();
			mainActionRunner().setActions(mActions);
			mHasFinished = false;
			dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_STARTED, mName));
		}
		
		/**
		
		*/
		protected function mainActionRunner () : ActionRunner {
			return mActionRunners[0];
		}
		
		/**
		
		*/
		public function step (e:Event) : void {

			if (mIsPaused) return;
			
			var i:int, ilen:int = mActionRunners.length;
			for (i=0; i<ilen; ++i) {
				mActionRunners[i].step(e);
			}
			checkRunnersFinished();
		}
		
		/**
		
		*/
		protected function checkRunnersFinished () : void {
			var i:int, ilen:int = mActionRunners.length;
			var runningRunners:int = ilen;
			for (i=0; i<ilen; ++i) {
				if (mActionRunners[i].hasFinished()) {
					runningRunners--;
				}
			}
			if (runningRunners == 0) {
				finish();
			}
		}
		
		/**
		
		*/
		protected function finish () : void {
			unRegister();
			mHasFinished = true;
			dispatchEvent(new ActionQueueEvent(ActionQueueEvent.QUEUE_FINISHED, mName));
		}
		
		/**
		
		*/
		protected function register () : void {
			if (mRegistered) return;
			if (mActionQueueController) {
				mActionQueueController.register(this, step);
			} else {
				FramePulse.addEnterFrameListener(step);
			}
			mRegistered = true;
		}
		
		/**
		
		*/
		protected function unRegister () : void {
			if (mActionQueueController) {
				mActionQueueController.unRegister(this);
			} else {
				FramePulse.removeEnterFrameListener(step);
			}
			mRegistered = false;
		}
		
		/**
		
		*/
		protected function createActionFromFunction (inArgs:Array) : Action {
			var method:Function = inArgs.shift();
			var owner:Object = mainActionRunner();
			return new Action(owner, method, inArgs);
		}
		
		/**
		
		*/
		protected function createActionFromMethodName (inArgs:Array) : Action {
		
			var owner:Object = inArgs.shift();
			var methodName:String = inArgs.shift();
			
			var method:Function = owner[methodName];
			return new Action(owner, method, inArgs);
		}
				
		/**
		
		*/
		protected function createActionFromObjectMethod (inOwner:Object,
											inArgs:Array) : Action {
			var method:Function = inArgs.shift();
			return new Action(inOwner, method, inArgs);
		}
	}
}

/**
Data container for marker cue points.
*/
class Marker {

	public var name:String;
	/**
	Index position in Queue
	*/
	public var index:int;
	
	function Marker (inName:String,
					 inIndex:int) {
		name = inName;
		index = inIndex;
	}
}

/**
Data container for loop cue points.
*/
class Loop {

	public var name:String;
	/**
	Index position in Queue
	*/
	public var startIndex:int;
	/**
	Index position in Queue
	*/
	public var endIndex:int;
	public var isLooping:Boolean = true;
	
	function Loop (inName:String,
				   inStartIndex:int) {
		name = inName;
		startIndex = inStartIndex;
	}
}


import flash.events.Event;
import flash.utils.getTimer;
import org.asaplibrary.util.FramePulse;
import org.asaplibrary.util.actionqueue.*;

class ActionRunner {

	private var mName:String; // for debugging
	private var mFrameActionRunner:FrameActionRunner;
	private var mActions:Array;
	private var mStepCount:int;
	private var mCurrentStep:int;
	private var mFinished:Boolean;
	private var mIsPaused:Boolean = false;
	
	private var DEBUG:Boolean = false;

	/**
	
	*/
	function ActionRunner (inName:String) {
		mName = inName;
		mFrameActionRunner = new FrameActionRunner(mName); // TODO: defer?
		mCurrentStep = 0;
	}
	
	/**
	
	*/
	public function setActions(inActions:Array) : void {
		mActions = inActions;
		mStepCount = mActions.length;
		start();
	}
	
	/**
	
	*/
	public function step (e:Event) : void {
		mFrameActionRunner.step();
		if (mFrameActionRunner.isBusy()) return;
				
		if (mCurrentStep == mStepCount) {
			// no actions left
			stop();
			mFrameActionRunner.stop();
			return;
		}
		// else		
		var action:Action = mActions[mCurrentStep++];
		next(action);
	}

	/**
	
	*/
	public function hasFinished () : Boolean {
		return mFinished;
	}
	
	/**
	
	*/
	public function pause (inPreserveRemainingTime:Boolean) : void {
		mFrameActionRunner.pause(inPreserveRemainingTime);
		mIsPaused = true;
	}
	
	/**
	
	*/
	public function resume () : void {
		mFrameActionRunner.resume();
		mIsPaused = false;
	}
	
	/**
		
	*/
	public function toString () : String {
		return "ActionRunner " + mName;
	}
	
	/**
	
	*/
	public function skip () : void {
		mCurrentStep++;
	}
	
	public function setStep (inIndex:int) : void {
		mCurrentStep = inIndex;
	}
	
	/**
	Try to loop through the action list as long as possible
	*/
	protected function next (a:Action) : void {
		while ( (a != null) && (!applyAction(a)) ) {
			if (mStepCount != mCurrentStep && !mIsPaused) {
				a = mActions[mCurrentStep++];
			} else {
				break;
			}
		}
	}
	
	/**
	@return The called method's return value: in case of an AQMethod, the called function will return true if it has an onEnterFrame. If so, ActionQueue must pass an onEnterFrame itself.
	*/
	protected function applyAction (inAction:Action) : Boolean {
		var result:* = inAction.method.apply(inAction.owner, inAction.args);
		
		if (result && (result is FrameAction)) {
			mFrameActionRunner.startFrameAction(result);
			return true;
		}
		// function has not returned an FrameAction object so is not frame based
		return false;
	}
	
	/**
	
	*/
	protected function start () : void {
		mFinished = false;
	}
	
	/**
	
	*/
	protected function stop () : void {
		mFinished = true;
	}
	
}

class FrameActionRunner {
	
	private var mName:String; // for debugging
	private var mEndTime:Number;
	private var mFrameAction:FrameAction;
	private var mWaitDuration:Number;
	private var mIsActive:Boolean;
	private var mDurationLeft:Number;

	private var DEBUG:Boolean = false;
	
	/**
		
	*/
	function FrameActionRunner (inName:String) {
		mName = inName;
		setActive(false);
	}
	
	/**
		
	*/
	public function toString () : String {
		return "FrameActionRunner " + mName;
	}
	
	/**
		
	*/
	public function isBusy () : Boolean {
		return isActive();
	}
	
	/**
		
	*/
	public function stop () : void {
		setActive(false);
	}
	
	/**
		
	*/
	public function start () : void {
		setActive(true);
	}
	
	/**
	
	*/
	public function pause (inPreserveRemainingTime:Boolean) : void {
		if (inPreserveRemainingTime) {
			mDurationLeft = mEndTime - now();
		} else {
			// remove old value
			mDurationLeft = Number.NaN;
		}
	}
	
	/**
	
	*/
	public function resume () : void {
		if (!isNaN(mDurationLeft)) {
			mEndTime = now() + mDurationLeft;
		}
	}
	
	/**
		
	*/
	public function step () : void {

		if (!isActive()) return;

		if (mFrameAction.duration != 0) {
			// calculate percentage (1 to 0)
			var msNow:Number = now();
			if (msNow < mEndTime) {
				mFrameAction.percentage = (mEndTime - msNow) * (.001 / mFrameAction.duration);
			} else { 
				mFrameAction.percentage = 0;
			}
			if (mFrameAction.effect != null) {
				var params:Array = new Array(1 - mFrameAction.percentage, mFrameAction.start, mFrameAction.range, 1);
				mFrameAction.value = Number(mFrameAction.effect.apply(null, params));
			} else {
				mFrameAction.value = mFrameAction.end - (mFrameAction.percentage * mFrameAction.range);
			}
						
			if (msNow >= mEndTime) {
				mFrameAction.setActionDone();
				if (mFrameAction.doesLoop()) {
					startFrameAction(mFrameAction);
				} else {
					stop();
				}
			}
		}
		callFrameActionMethod();
	}
	
	/**
	
	*/
	protected function callFrameActionMethod () : void {
		var result:Boolean = mFrameAction.method.call(mFrameAction.owner, mFrameAction.value);
		if (!result) {
			stop();
		}
	}
	
	/**
	
	*/
	public function startFrameAction (inFrameAction:FrameAction) : void {
//		if (DEBUG) trace(getTimer() + " ; startFrameAction called; " + toString());
		mFrameAction = inFrameAction;	
		var duration:Number = mFrameAction.duration * 1000; // translate to milliseconds
		mEndTime = now() + duration;
		start();
	}
	
	/**
	
	*/
	protected function setActive(inState:Boolean) : void {
		mIsActive = inState;
	}
	
	/**
	
	*/
	public function isActive() : Boolean {
		return mIsActive;
	}
	
	/**
	
	*/
	protected function now () : Number {
		return getTimer();
	}
	
}
