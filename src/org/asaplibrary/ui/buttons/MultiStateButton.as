/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org
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
package org.asaplibrary.ui.buttons {
	import org.asaplibrary.util.FramePulse;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.*;

	/** 
	 * MultiStateButton is a flexible button class that gives the designer
	 * the freedom to create timeline states and animations for buttons.
	 * The animation is driven by labeled keyframes in the timeline.
	 * 
	 * <p>The button may start out without any keyframes and later be enhanced
	 * with up to nine labeled keyframes. There should be NO scripts that
	 * affect the position of the playhead (stops, gotoAnd...) in the button's 
	 * timeline.
	 * After that, the designer may decide what other states need to be 
	 * visualized in the animation chain: <br />
	 * {@img multistatebutton_all.png}</p>
	 *
	 * <P>If any of these keyframes are missing, the flow will skip over them
	 * to the next possible keyframe. So it would be possible to have just
	 * a simple setup like this: <br />
	 * {@img multistatebutton_simple.png}</p>
	 *
	 * <p>A bit more advanced is a button with 1 transition label plus an intro label:<br />
	 * {@img multistatebutton_transitionlabel.png}</p>
	 *
	 * <p>Or one with a hard down state, but with an animated in and out sequence: <br />
	 * {@img multistatebutton_animatedinout.png}</p>
	 *
	 * Mouse activity is stacked, in order to maintain a fluid experience of 
	 * the button's animation flow. In lengthy animated buttons this may very
	 * soon become irritating. 
	 */
	public class MultiStateButton extends MovieClip {
		private var mBehavior : ButtonBehavior;
		private static const LABEL_INTRO : String = "intro";
		private static const LABEL_UP : String = "up";
		private static const LABEL_IN : String = "in";
		private static const LABEL_OVER : String = "over";
		private static const LABEL_PRESS : String = "press";
		private static const LABEL_DOWN : String = "down";
		private static const LABEL_RELEASE : String = "release";
		private static const LABEL_OUT : String = "out";
		// private static const LABEL_OUTTRO:String = "outtro";
		/**
		Dummy label to reset the queues.
		 */
		private static const LABEL_NONE : String = "NONE";
		private static const STOP_LABEL_HASH : Object = {up:1, over:1, down:1};
		/**
		Storage for mouse states in chronological order, so 
		the states are always animated through correctly.
		 */
		private var mMouseStates : Array;
		private var mDestinations : Array;
		/**
		Quick look-up hash: 'FrameLabel.frame' (int) => FrameLabel and 'FrameLabel.name' (String) => FrameLabel
		 */
		private var mLabelHash : Object;
		/**
		The current mouse state (see {@link ButtonStates}.
		 */
		private var mCurrentMouseState : uint;
		/**
		The current label when doing a transition.
		 */
		private var mPlayingLabel : String;
		/**
		Name of the destination label.
		 */
		private var mDestination : String;
		/**
		Hitarea MovieClip.
		 */
		public var tHitArea : MovieClip;

		/**
		Creates a new MultiStateButton.
		 */
		public function MultiStateButton() {
			super();
			addEventListener(Event.ADDED, init);
		}

		/**
		Initializes the button.
		 */
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED, init);

			mBehavior = new ButtonBehavior(this);
			mBehavior.addEventListener(ButtonBehaviorEvent._EVENT, update);

			mLabelHash = new Object();
			currentScene.labels.map(addLabelHashEntry);

			initQueues();
			setEnabled(true);
			continueTo(LABEL_INTRO);
		}

		/**
		Initializes the mouse state queue and the frame label destination queue.
		 */
		private function initQueues() : void {
			mMouseStates = new Array();
			mDestinations = new Array();
		}

		/**
		Adds 2 lookup keys for each FrameLabel in the current MovieClip button:
		'FrameLabel.frame' (int) => FrameLabel
		'FrameLabel.name' (String) => FrameLabel
		 */
		private function addLabelHashEntry(item : FrameLabel, index : int, array : Array) : void {
			var frameLabel : FrameLabel = FrameLabel(item);
			mLabelHash[frameLabel.frame] = frameLabel;
			mLabelHash[frameLabel.name] = frameLabel;
		}

		/**
		Enables/disables the button. When switching the enabled state the button will always jump to label "up".
		@param inState: state of the button
		 */
		public function setEnabled(inState : Boolean) : void {
			if (inState) {
				// don't handle mouse events on children
				mouseChildren = false;
				// set the hitarea and hide it
				hitArea = tHitArea;
			} else {
				enabled = false;
			}
			buttonMode = true;
			// By default go to label "up"
			setDestination(LABEL_UP);
		}

		/**
		Updates the mouse state as received from Behaviour helper object.
		Initialize on ButtonStates.ADDED.
		Otherwise store mouse state in queue to be processed in order.		
		 */
		private function update(e : ButtonBehaviorEvent) : void {
			if (e.state & ButtonStates.ADDED) {
				return;
			}
			queueMouseState(e.state);
		}

		/**
		Jumps to and stops the playhead at frame inLabel.
		@param inLabel: name of the label to jump to
		 */
		private function stopAt(inLabel : String) : void {
			mPlayingLabel = null;
			setDestination(null);
			unRegisterFramePulse();
			gotoAndStop(inLabel);
			processDestinations();
			processMouseStates();
		}

		/**
		Continues the playhead to play from label inLabel.
		@param inLabel: name of the label to start playing
		 */
		private function continueTo(inLabel : String) : void {
			mPlayingLabel = inLabel;
			registerFramePulse();

			// the combination of gotoAndStop() and play() ensures that the
			// first frame of the is actually drawn to the stage.
			gotoAndStop(inLabel);
			play();
		}

		/**
		Adds a destination to the queue.
		@param inDestination: name of the destination label
		 */
		private function queueDestination(inDestination : String) : void {
			var index : int = mDestinations.indexOf(inDestination);
			if (index == -1) {
				mDestinations.push(inDestination);
				processDestinations();
			}
		}

		/**
		Takes the first item from the destination queue and calls {@link #continueTo} with the new destination.
		 */
		private function processDestinations() : void {
			if (mDestinations.length == 0) {
				return;
			}
			if (mDestination != null) {
				// only process the next destination if we have reached the current one
				return;
			}
			var destination : String = String(mDestinations.shift());
			if (destination == LABEL_NONE) {
				;
				initQueues();
				return;
			}
			if (destination == currentLabel) {
				// no need to proceed
				return;
			}
			setDestination(destination);
			continueTo(destination);
		}

		/**
		Sets the destination label.
		@param inLabel: name of the label
		 */
		private function setDestination(inLabel : String) : void {
			mDestination = inLabel;
		}

		/**
		Adds the mouse state (as received from the Behaviour Object) to the queue. Mouse state are processed in chronological order, so 
		the states are always animated through correctly.
		@param inState: the mouse state as received from the Behaviour Object
		 */
		private function queueMouseState(inState : uint) : void {
			mCurrentMouseState = inState;
			var index : int = mMouseStates.indexOf(inState);
			if (index == -1) {
				mMouseStates.push(inState);
				processMouseStates();
			}
		}

		/**
		Takes the first item from the mouse state queue and calculates which destination path is needed for that state.
		 */
		private function processMouseStates() : void {
			if (mMouseStates.length == 0) {
				return;
			}
			if (mPlayingLabel != null) {
				return;
			}

			var state : uint = mMouseStates.shift();
			if (state == mCurrentMouseState && mMouseStates[0] != state) {
				// clear the rest of the queue if the current processed state
				// is where we need to end up anyway.
				mMouseStates = new Array();
			}

			ButtonStates.stateToString(state);

			if (state & ButtonStates.UP) {
				if (mLabelHash[LABEL_RELEASE]) {
					queueDestination(LABEL_RELEASE);
				}
				queueDestination(LABEL_OVER);
			}
			if (state & ButtonStates.OVER) {
				if (mLabelHash[LABEL_IN]) {
					queueDestination(LABEL_IN);
				}
				queueDestination(LABEL_OVER);
			}
			if (state & ButtonStates.DOWN) {
				if (mLabelHash[LABEL_PRESS]) {
					queueDestination(LABEL_PRESS);
				}
				queueDestination(LABEL_DOWN);
			}
			if (state & ButtonStates.OUT) {
				if (mLabelHash[LABEL_OUT]) {
					queueDestination(LABEL_OUT);
				}
				queueDestination(LABEL_UP);
			}
			if (state & ButtonStates.NORMAL) {
				queueDestination(LABEL_NONE);
			}
		}

		/**
		Checks for changes in the labels on each frame pulse.
		If we encounter a stop frame (as defined in STOP_LABEL_HASH) we stop here.
		Otherwise if we will pass the destination frame (the next frame is not the destination), the current destination is reset and {@link #processDestinations} is called next.
		 */
		private function checkFrame(e : Event) : void {
			if (STOP_LABEL_HASH[currentLabel]) {
				// this is a stop frame, so stop now
				stopAt(currentLabel);
				return;
			}

			// check the label on the next frame
			var frameLabel : FrameLabel = mLabelHash[currentFrame + 1];
			if (frameLabel != null && frameLabel.name != mDestination) {
				// next destination frame is off course
				// need to jump
				setDestination(null);
				processDestinations();
				return;
			}
		}

		/**
		Registers to listen for {@link FramePulse} events.
		 */
		protected function registerFramePulse() : void {
			FramePulse.addEnterFrameListener(checkFrame);
		}

		/**
		Unregisters for {@link FramePulse} events.
		 */
		protected function unRegisterFramePulse() : void {
			FramePulse.removeEnterFrameListener(checkFrame);
		}
	}
}
