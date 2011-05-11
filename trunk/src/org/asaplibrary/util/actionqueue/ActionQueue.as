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
	import flash.events.*;
	import flash.utils.getQualifiedClassName;

	/**
	Creates a series of sequential animation/function calls, or "actions". Each action is performed one after the other.
	
	Actions are objects of type {@link Action}, {@link IAction}, {@link TimedAction} or {@link ITimedAction} or any subclass thereof.
	
	The actual function calling is done by {@link ActionRunner}. Use ActionQueue  to {@link #addAction create the action objects from input arguments}, and to add ready-made elements like {@link #addMarker markers}, {@link #addStartLoop loops} {@link #addPause pause} and {@link #addCondition condition} functions.
	
	<b>What's new compared to the previous version in ASAP Framework (AS2)?</b>
	<ul>
	<li>Total rewrite of the code</li>
	<li>ActionQueue now runs generic Action objects (Command pattern)</li>
	<li>ActionQueue actions can be ActionQueues in itself</li>
	<li>Because of a (relatively small) syntax change, any call to a ready-made animation class like AQFade is now compile checked</li>
	<li>Integrated looping from ExtendedActionQueue (now defunct)</li>
	<li>Added markers and events from markers</li>
	<li>Added conditions</li>
	<li>Markers and conditions combined make it possible to synchronize separate queues</li>
	<li>Method "addInAction" has been replaced with "addAsynchronousAction"; asynchronous actions still run in their own thread, but can be paused, stopped and quit by the main queue</li>
	</ul>
	@example
	This ActionQueue moves a MovieClip, then lets it fade out to alpha 0 in .5 seconds:
	<code>
	my_mc.alpha = 0;
	var queue:ActionQueue  = new ActionQueue();
	var CURRENT:Number = Number.NaN;
	queue.addAction(new AQMove().move(
	my_mc, 1.0, CURRENT, CURRENT, 800, CURRENT, Cubic.easeOut
	));
	queue.addAction(new AQFade().fade(
	my_mc, .5, CURRENT, 0
	));
	</code>
	 */
	public class ActionQueue extends EventDispatcher implements ITimedAction {
		private var mName : String;
		private var mMainActionRunner : ActionRunner;
		private var mActionRunners : Array;
		// of type ActionRunner
		private var mActions : Array;
		// of type Action
		private var mMarkerHash : Object;
		// quick lookup for occurrence of markers; objects of type Marker
		private var mVisitedMarkerHash : Object;
		// quick lookup for occurrence of visited markers
		private var mCurrentMarker : Marker;
		private var mLoopHash : Object;
		// quick lookup for occurrence of loops; objects of type Loop
		private var mPaused : Boolean;
		private var mLoopedCount : int;
		private var mMaxLoopCount : int;

		/**
		Creates a new ActionQueue.
		@param inName: (optional) identifier name of this queue - used for debugging
		 */
		function ActionQueue(inName : String = "Anonymous ActionQueue") {
			mName = inName;
			mActions = new Array();
			mVisitedMarkerHash = new Object();
			mMarkerHash = new Object();
			mLoopHash = new Object();
			initActionRunners();
		}

		/**
		Creates an Action from input arguments and adds it to the queue.
		This method accepts a number of argument configurations that are translated into an Action object. You can also directly add an {@link Action} or {@link TimedAction} object.

		<b>Adding an Action object</b>
		You can add any object of type {@link Action}, {@link IAction}, {@link TimedAction} and {@link ITimedAction} - including complete ActionQueues!
		<code>public function addAction (inAction:IAction) : void</code>
		
		Example:
		<code>
		var queue:ActionQueue = new ActionQueue();
		var action:Action = new Action(createShapes, 10);
		queue.addAction(action);	
		queue.run();
		</code>
		
		<b>Adding a local function</b>
		Will be called in local scope.
		<code>public function addAction (inFunction:Function, argument1, argument2, ...) : void</code>
	
		Example:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(createShapes, 10);	
		queue.run();
		</code>
		
		<b>Adding a object's method</b>
		Will be called in the object's scope.
		<code>public function addAction (inMethod:Function, argument1, argument2, ...) : void</code>
		
		Example:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(mShapeCreator.createShapes, 10);
		queue.run();
		</code>
		
		<b>Adding a object's method by name</b>
		Will be called in the object's scope. The method must have public access.
		<code>public function addAction (inMethodOwner:Object, inMethodName:String, argument1, argument2, ...) : void</code>
		
		Example:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(mShapeCreator, "createShapes", 10);	
		queue.run();
		</code>
		
		<b>Using ready-made animation methods</b>
		You can use any function that returns a {@link TimedAction}, or use one of the ready made class metods from these classes:
		{@link AQAddMove}
		{@link AQBlink}
		{@link AQFade}
		{@link AQFollowMouse}
		{@link AQMove}
		{@link AQPulse}
		{@link AQFunction}
		{@link AQScale}
		{@link AQSet}
		{@link AQTimeline}
		
		Example:
		This example will fade out a MovieClip from the current alpha to 0 in 0.5 seconds:
		<code>
		var queue:ActionQueue = new ActionQueue();
		var CURRENT:Number = Number.NaN;
		queue.addAction(new AQFade().fade(my_mc, .5, CURRENT, 0));
		queue.run();
		</code>
		
		<b>Custom timed actions</b>
		Similar to "Adding an Action": add a {@link TimedAction} object.
		
		Example:
		<code>
		var action:TimedAction = new TimedAction(doMoveAndScale, duration, effect);
		queue.addAction(action);
		</code>
		... where function <code>doMoveAndScale</code> performs the animation based on the percentage value it receives:
		<code>
		protected function doMoveAndScale (inValue:Number) : Boolean {
			
		var percentage:Number = 1-inValue; // end of animation: inValue == 0
			
		tClip.x = NumberUtils.percentageValue(initX, mClipData.endx, percentage);
		tClip.y = NumberUtils.percentageValue(initY, mClipData.endy, percentage);
		tClip.scaleX = tClip.scaleY = NumberUtils.percentageValue(1, mClipData.endscale, percentage);
			
		return true; // if false the action will stop
		}
		</code>
		@param args: argument list
		 */
		public function addAction(...args : Array) : void {
			var action : IAction = createAction(args);
			if (action != null) {
				mActions.push(action);
				mMainActionRunner.addAction(action);
			}
		}

		/**
		Creates an Action object from the argument list (see {@link #addAction}).
		 */
		protected function createAction(inArgs : Array) : IAction {
			var action : IAction = null;
			var firstParam : * = inArgs[0];
			if (firstParam is ITimedAction) {
				action = firstParam;
			} else if (firstParam is IAction) {
				action = firstParam;
			} else if (firstParam is Function) {
				action = createActionFromFunction(inArgs);
			} else if (firstParam is Object && inArgs[1] is String) {
				action = createActionFromMethodName(inArgs);
			}
			return action;
		}

		/**
		Adds an Action that is run asynchronously: other actions will follow right after and will not wait for this action to finish. Asynchronous actions can be paused and stopped with {@link #pause} and {@link #stop}.
		@param args: argument list; see {@link #addAction}
		 */
		public function addAsynchronousAction(...args : Array) : void {
			var action : IAction = createAction(args);

			var f : Function = function() : void {
				var runner : ActionRunner = addActionRunner();
				runner.setActions(new Array(action));
				runner.run();
			};
			addAction(f);
		}

		/**
		@return The list of queued actions (including already run actions).
		 */
		public function getActions() : Array {
			return mActions;
		}

		/**
		Creates a new list of ActionRunners.
		Creates the main {@link ActionRunner} and adds it to the list of ActionRunners.
		 */
		protected function initActionRunners() : void {
			mActionRunners = new Array();
			mMainActionRunner = createActionRunner();
			mMainActionRunner.addEventListener(ActionEvent._EVENT, onActionEvent);
			mActionRunners.push(mMainActionRunner);
		}

		/**
		Creates an ActionRunner and adds it to the list of ActionRunners.
		@return The newly added ActionRunner.
		 */
		protected function addActionRunner() : ActionRunner {
			var runner : ActionRunner = createActionRunner();
			mActionRunners.push(runner);
			return runner;
		}

		/**
		Creates an ActionRunner.
		@return The newly created ActionRunner.
		 */
		protected function createActionRunner() : ActionRunner {
			var runner : ActionRunner = new ActionRunner(mActionRunners.length + " " + mName);
			return runner;
		}

		/**
		@return True if the main ActionRunner is (still) running; false if it is stopped or finished. A paused but running queue will return true.
		 */
		public function isRunning() : Boolean {
			return mMainActionRunner.isRunning();
		}

		/**
		Stops the queue.
		@implementationNote Stops all {@link ActionRunner ActionRunners}.
		@sends ActionEvent#STOPPED
		 */
		public function stop() : void {
			stopActionRunners();
			dispatchEvent(new ActionEvent(ActionEvent.STOPPED, this));
		}

		/**
		Adds a {@link Condition} to the queue. A running queue is automatically halted as long as the condition is not met. The condition will be checked on each frame update (using {@link FramePulse} events.
		@param inCondition: the condition to add
		@implementationNote Conditions are run by {@link ConditionManager}.
		@example
		<code>
		var q1:ActionQueue = new ActionQueue();
		var q2:ActionQueue = new ActionQueue();
		var q3:ActionQueue = new ActionQueue();
		
		var condition:Function = function () : Boolean {
		return (q1.didVisitMarker("BAR1")
		&& q2.didVisitMarker("BAR1")
		&& q3.didVisitMarker("BAR1"));
		}
		var condition:Condition = new Condition (condition);

		var rightPos:Number = 800;
		var duration:Number = 4.0;
		var CURRENT:Number = Number.NaN;
		q1.addAction(new AQMove().move(my_mc1, duration1, CURRENT, CURRENT, rightPos, CURRENT));
		q1.addMarker("BAR1");
		q1.addCondition(condition1);
		// q1 will continue here as soon as the condition is met
		
		// ... (similar for other queues)
		
		q1.run();
		q2.run();
		q3.run();
		</code>
		 */
		public function addCondition(inCondition : Condition) : void {
			addAction(inCondition);
		}

		/**
		Internal function, called by {@link #doWait}.
		@param inValue: not used
		@return True.
		 */
		protected function idle(inValue : Number) : Boolean {
			inValue;
			return true;
		}

		/**
		Use pause() to add a paused state to the queue; when this action is run the queue is paused until {@link #resume} is called on it.
		Use pause(duration) to add a waiting action to the queue.
		@param inDuration: pause time in seconds; use 0 to pause indeterminately.
		 */
		public function addPause(inDuration : Number = Number.NaN) : void {
			if (isNaN(inDuration)) {
				addAction(pause, true);
			} else {
				addAction(doWait, inDuration);
			}
		}

		/**
		Internal function, called by {@link #addPause}.
		 */
		protected function doWait(inDuration : Number) : TimedAction {
			return new TimedAction(idle, inDuration);
		}

		/**
		Toggles the playing/paused state of the queue.
		 */
		public function togglePlay() : void {
			if (!mPaused) {
				pause(true);
			} else {
				resume();
			}
		}

		/**
		Pauses the current running action and all asynchronous actions.
		@param inContinueWhereLeftOff: (optional) whether the running Action should continue where it left off when the queue is resumed
		@sends ActionEvent#PAUSED
		 */
		public function pause(inContinueWhereLeftOff : Boolean = true) : void {
			mPaused = true;
			pauseActionRunners(inContinueWhereLeftOff);
			dispatchEvent(new ActionEvent(ActionEvent.PAUSED, this));
		}

		/**
		Resumes a paused queue.
		@sends ActionEvent#RESUMED
		 */
		public function resume() : void {
			mPaused = false;
			resumeActionRunners();
			dispatchEvent(new ActionEvent(ActionEvent.RESUMED, this));
		}

		/**
		Quits the queue.
		@sends ActionEvent#QUIT
		 */
		public function quit() : void {
			quitActionRunners();
			reset();
			dispatchEvent(new ActionEvent(ActionEvent.QUIT, this));
		}

		/**
		Pauses all ActionRunners.
		 */
		protected function pauseActionRunners(inContinueWhereLeftOff : Boolean) : void {
			callOnAllActionRunners("pause", [inContinueWhereLeftOff]);
		}

		protected function callOnAllActionRunners(inMethodName : String, inArgs : Array = null) : void {
			var i : uint, ilen : uint = mActionRunners.length;
			for (i = 0; i < ilen; ++i) {
				var method : Function = mActionRunners[i][inMethodName];
				method.apply(mActionRunners[i], inArgs);
			}
		}

		/**
		Resumes all ActionRunners.
		 */
		protected function resumeActionRunners() : void {
			callOnAllActionRunners("resume");
		}

		/**
		Quits all ActionRunners.
		 */
		protected function quitActionRunners() : void {
			callOnAllActionRunners("quit");
		}

		/**
		Skips all ActionRunners.
		 */
		protected function skipActionRunners() : void {
			callOnAllActionRunners("skip");
		}

		/**
		Resets all ActionRunners.
		 */
		protected function resetActionRunners() : void {
			callOnAllActionRunners("reset");
		}

		/**
		Stops all ActionRunners.
		 */
		protected function stopActionRunners() : void {
			callOnAllActionRunners("stop");
		}

		/**
		Skips to the next action (if any). If the queue is paused, skip will resume the queue. WIll also skip a paused state.
		 */
		public function skip() : void {
			skipActionRunners();
			if (mMainActionRunner.isPaused()) {
				resume();
			}
		}

		/**
		Jumps the action pointer to a marker.
		@param inMarkerName: name of the marker
		 */
		public function goToMarker(inMarkerName : String) : void {
			doGoToMarker(inMarkerName);
		}

		/**
		Adds a "go to marker" action to the queue.
		@param inMarkerName: name of the marker
		 */
		public function addGoToMarker(inMarkerName : String) : void {
			addAction(doGoToMarker, inMarkerName);
		}

		/**
		Used by {@link #addGoToMarker}.
		@param inMarkerName: name of the marker
		 */
		protected function doGoToMarker(inMarkerName : String) : void {
			var index : int = Marker(mMarkerHash[inMarkerName]).index;
			mMainActionRunner.gotoStep(index);
		}

		/**
		Adds a marker to the queue. Markers can be used to receive an event when the queue passes a marker, or to jump to a specific point in the queue.
		@param inMarkerName: name of the marker
		@example
		This example shows how to listen for marker events:
		<code>
		var queue:ActionQueue = new ActionQueue();
		var CURRENT:Number = Number.NaN;
		queue.addAction(new AQMove().move(my_mc, duration, CURRENT, CURRENT, marker1_mc.x, marker1_mc.y));
		queue.addMarker("MARKER_1");
		queue.addAction(new AQMove().move(my_mc, duration, CURRENT, CURRENT, marker2_mc.x, marker2_mc.y));
		queue.addMarker("MARKER_2");
		</code>
		Add a listener:
		<code>
		queue.addEventListener(ActionEvent._EVENT, onActionEvent);
		queue.run();
		</code>
		
		<code>
		public function onActionEvent (e:ActionEvent) : void {
		switch (e.subtype) {
		case ActionEvent.MARKER_VISITED:
		handleMarkerPassed(e);
		break;
		}
		}
		
		public function handleMarkerPassed (e:ActionEvent) : void {
		// do something
		}
		</code>
		 */
		public function addMarker(inMarkerName : String) : void {
			// store current position in queue
			var index : int = mActions.length;
			var marker : Marker = new Marker(inMarkerName, index);
			mMarkerHash[inMarkerName] = marker;
			// create action to be called at runtime
			addAction(doAddVisitedMarker, marker);
		}

		/**
		Adds a "start of loop" marker to the queue.
		@param inLoopName: name of the loop (should be unique for this queue)
		@param inLoopCount: (optional) the number of times the looped section should run; default 0 (infinite)
		@see #addEndLoop
		@example
		This example shows how to set loop markers to run a section 3 times:
		<code>
		var queue:ActionQueue = new ActionQueue();
		queue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker1_mc.x, marker1_mc.y));
		queue.addStartLoop("MY_LOOP", 3);
		queue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker2_mc.x, marker2_mc.y));
		queue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker3_mc.x, marker3_mc.y));
		queue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker1_mc.x, marker1_mc.y));
		queue.addEndLoop("MY_LOOP");
		queue.run();
		</code>
		 */
		public function addStartLoop(inLoopName : String, inLoopCount : int = 0) : void {
			var index : int = mActions.length;
			var loop : Loop = new Loop(inLoopName, index);
			mLoopHash[inLoopName] = loop;
			mMaxLoopCount = inLoopCount;
			mLoopedCount = 0;
		}

		/**
		Adds a "end of loop" marker to the queue.
		@param inLoopName: name of the loop (should be unique for this queue)
		@see #addStartLoop
		 */
		public function addEndLoop(inLoopName : String) : void {
			// find stored Loop and set end index to it
			var loop : Loop = mLoopHash[inLoopName];
			loop.endIndex = mActions.length;
			addGoToLoopStart(inLoopName);
		}

		/**
		Ends a current running loop.
		@param inLoopName: name of the loop (should be unique for this queue)
		@param inFinishLoopFirst: true if the loop should be run to the end; false if the loop should be aborted - the action pointer jumps to the first action after the "end of loop" marker; any currently running action will be finished first
		 */
		public function endLoop(inLoopName : String, inAbortLoop : Boolean = false) : void {
			var loop : Loop = mLoopHash[inLoopName];
			loop.isLooping = false;
			if (inAbortLoop) {
				var endIndex : int = Loop(mLoopHash[inLoopName]).endIndex;
				mMainActionRunner.gotoStep(endIndex);
			}
		}

		/**
		Used by {@link #addEndLoop}.
		 */
		protected function addGoToLoopStart(inLoopName : String) : void {
			addAction(doGoToLoopStart, inLoopName);
		}

		/**
		Used by {@link #addGoToLoopStart}.
		@todo Clear passed markers
		 */
		protected function doGoToLoopStart(inLoopName : String) : void {
			var loop : Loop = mLoopHash[inLoopName];
			if (loop.isLooping) {
				mLoopedCount++;
				if (mMaxLoopCount != 0 && mLoopedCount >= mMaxLoopCount) {
					endLoop(inLoopName);
					return;
				}
				mMainActionRunner.gotoStep(loop.startIndex);
			}
		}

		/**
		Called by {@link #addMarker} when the queue is running. Stored the visited marker for lookup by {@link #didVisitMarker}.
		@param inMarker: Marker
		@sends ActionEvent#MARKER_VISITED
		 */
		protected function doAddVisitedMarker(inMarker : Marker) : void {
			mCurrentMarker = inMarker;
			if (mVisitedMarkerHash[inMarker.name] == null) {
				mVisitedMarkerHash[inMarker.name] = inMarker.index;
			}
			dispatchEvent(new ActionEvent(ActionEvent.MARKER_VISITED, this, mCurrentMarker.name));
		}

		/**
		Name of the last visited marker.
		 */
		public function lastVisitedMarker() : String {
			return mCurrentMarker.name;
		}

		/**
		Check whether the queue did pass a marker. The marker has to be 'run' - any jumps over in-between markers will not mark it as 'passed'.
		@param inMarkerName: name of the marker
		@return True if the marker action with name was visited; otherwise false.
		 */
		public function didVisitMarker(inMarkerName : String) : Boolean {
			return mVisitedMarkerHash[inMarkerName] != null;
		}

		/**
		@return True when all Actions (including asynchronous actions) are finished.
		 */
		public function isFinished() : Boolean {
			return mMainActionRunner.isFinished();
		}

		/**
		Resets the queue: stops current ActionRunners, removes all actions, clears the "visited markers" history.
		 */
		public function reset() : void {
			resetActionRunners();
			initActionRunners();
			mActions = new Array();
			mVisitedMarkerHash = new Object();
			mCurrentMarker = null;
			mMarkerHash = new Object();
		}

		/**
		@return True when the main runner is paused.
		 */
		public function isPaused() : Boolean {
			return mMainActionRunner.isPaused();
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this) + ": " + mName;
		}

		/**
		Starts the queue.
		@sends ActionEvent#STARTED
		 */
		public function run() : * {
			dispatchEvent(new ActionEvent(ActionEvent.STARTED, this));
			mMainActionRunner.run();
			return null;
		}

		/**
		Received by ActionRunners. 
		@sends ActionEvent#FINISHED
		 */
		protected function onActionEvent(e : ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.FINISHED:
					dispatchEvent(new ActionEvent(ActionEvent.FINISHED, this));
					break;
			}
		}

		/**
		Creates an {@link Action} object from an argument list where the first item is a function.
		@param inArgs: arguments
		@return A new Action object.
		 */
		protected function createActionFromFunction(inArgs : Array) : Action {
			var method : Function = inArgs.shift();
			return new Action(method, inArgs);
		}

		/**
		Creates an {@link Action} object from an argument list where the first item is an object and the second a method name.
		@param inArgs: arguments
		@return A new Action object.
		 */
		protected function createActionFromMethodName(inArgs : Array) : Action {
			var owner : Object = inArgs.shift();
			var methodName : String = inArgs.shift();

			var method : Function = owner[methodName];
			return new Action(method, inArgs);
		}
	}
}
/**
Data container for marker cue points.
 */
class Marker {
	public var name : String;
	/**
	Index position in Queue
	 */
	public var index : int;

	function Marker(inName : String, inIndex : int) {
		name = inName;
		index = inIndex;
	}
}
/**
Data container for loop cue points.
 */
class Loop {
	public var name : String;
	/**
	Index position in Queue
	 */
	public var startIndex : int;
	/**
	Index position in Queue
	 */
	public var endIndex : int;
	public var isLooping : Boolean = true;

	function Loop(inName : String, inStartIndex : int) {
		name = inName;
		startIndex = inStartIndex;
	}
}

