package demo.ActionQueueAdvanced.controller {
	import demo.ActionQueueAdvanced.ui.Particle;

	import fl.motion.easing.*;

	import fl.controls.Button;

	import org.asaplibrary.util.actionqueue.*;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Controller extends MovieClip {
		// Synchronize markers
		public var pause_btn : Button;
		public var start_btn : Button;
		public var movable1_mc : MovieClip;
		public var movable2_mc : MovieClip;
		public var movable3_mc : MovieClip;
		public var bar1_mc : MovieClip;
		public var bar2_mc : MovieClip;
		public var bar3_mc : MovieClip;
		private var q1 : ActionQueue;
		private var q2 : ActionQueue;
		private var q3 : ActionQueue;
		private var fadeLinesQueue : ActionQueue;
		private var mFadeLinesQueuePaused : Boolean;
		// ---------------------------------
		// Loop
		public var pauseLoop_btn : Button;
		public var startLoop_btn : Button;
		public var quitLoop_btn : Button;
		public var finishLoop_btn : Button;
		public var loop_mc : MovieClip;
		public var marker1_mc : MovieClip;
		public var marker2_mc : MovieClip;
		public var marker3_mc : MovieClip;
		public var marker4_mc : MovieClip;
		public var num1_mc : MovieClip;
		public var num2_mc : MovieClip;
		public var num3_mc : MovieClip;
		private var loopQueue : ActionQueue;
		// ---------------------------------
		// Events
		public var event_mc : MovieClip;
		public var startEvent_btn : Button;
		public var pauseEvent_btn : Button;
		public var e_marker1_mc : MovieClip;
		public var e_marker2_mc : MovieClip;
		public var e_marker3_mc : MovieClip;
		public var e_marker4_mc : MovieClip;
		public var e_marker5_mc : MovieClip;
		public var num_e_1_mc : MovieClip;
		public var num_e_2_mc : MovieClip;
		public var num_e_3_mc : MovieClip;
		public var num_e_4_mc : MovieClip;
		public var num_e_5_mc : MovieClip;
		private var eventsQueue : ActionQueue;

		public function Controller() {
			
			pause_btn.addEventListener(MouseEvent.MOUSE_DOWN, handlePause);
			start_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStart);

			pauseLoop_btn.addEventListener(MouseEvent.MOUSE_DOWN, handlePauseLoop);
			startLoop_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartLoop);
			quitLoop_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleQuitLoop);
			finishLoop_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleFinishLoop);

			startEvent_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartEvents);
			pauseEvent_btn.addEventListener(MouseEvent.MOUSE_DOWN, handlePauseEvents);
			
		}

		private function initSynchronizeMarkers() : void {
			if (q1) q1.reset();
			if (q2) q2.reset();
			if (q3) q3.reset();
			if (fadeLinesQueue) fadeLinesQueue.reset();
			mFadeLinesQueuePaused = false;
			bar1_mc.alpha = bar2_mc.alpha = bar3_mc.alpha = 1;
			movable1_mc.x = movable2_mc.x = movable3_mc.x = 16;
			movable1_mc.alpha = movable2_mc.alpha = movable3_mc.alpha = 1;
		}

		private function startSynchronizeMarkers() : void {
			initSynchronizeMarkers();

			// var aqController:ActionQueueController = new ActionQueueController();

			var MAX_DURATION : Number = 1.0;

			var spriteWidth : Number = 12;

			var max1 : Number = bar1_mc.x - spriteWidth / 2;
			var max2 : Number = bar2_mc.x - spriteWidth / 2;
			var max3 : Number = bar3_mc.x - spriteWidth / 2;

			var CURRENT : Number = Number.NaN;
			var effect : Function = null;
			// Cubic.easeOut;

			q1 = new ActionQueue("movequeue1");
			q2 = new ActionQueue("movequeue2");
			q3 = new ActionQueue("movequeue3");

			var bar1Condition : Function = function() : Boolean {
				return (q1.didVisitMarker("BAR1") && q2.didVisitMarker("BAR1") && q3.didVisitMarker("BAR1"));
			};
			var condition1 : Condition = new Condition(bar1Condition, null);

			var bar2Condition : Function = function() : Boolean {
				return (q1.didVisitMarker("BAR2") && q2.didVisitMarker("BAR2") && q3.didVisitMarker("BAR2"));
			};
			var condition2 : Condition = new Condition(bar2Condition, null);

			var bar3Condition : Function = function() : Boolean {
				return (q1.didVisitMarker("BAR3") && q2.didVisitMarker("BAR3") && q3.didVisitMarker("BAR3"));
			};
			var condition3 : Condition = new Condition(bar3Condition, null);

			var duration1 : Number = .4 + Math.random() * MAX_DURATION;
			var duration2 : Number = .4 + Math.random() * MAX_DURATION;
			var duration3 : Number = .4 + Math.random() * MAX_DURATION;

			q1.addAction(new AQSet().setEnabled(movable1_mc, false));
			q1.addAction(new AQMove().move(movable1_mc, duration1, CURRENT, CURRENT, max1, CURRENT, effect));
			q1.addMarker("BAR1");
			q1.addCondition(condition1);
			// ---
			q1.addAction(new AQMove().move(movable1_mc, duration1, CURRENT, CURRENT, max2, CURRENT, effect));
			q1.addMarker("BAR2");
			q1.addCondition(condition2);
			// ---
			q1.addAction(new AQMove().move(movable1_mc, duration1, CURRENT, CURRENT, max3, CURRENT, effect));
			// ---
			q1.addMarker("BAR3");
			q1.addCondition(condition3);
			// ---
			q1.addAction(new AQFade().fade(movable1_mc, 1, CURRENT, 0));

			q2.addAction(new AQMove().move(movable2_mc, duration2, CURRENT, CURRENT, max1, CURRENT, effect));
			q2.addMarker("BAR1");
			q2.addCondition(condition1);
			// ---
			q2.addAction(new AQMove().move(movable2_mc, duration2, CURRENT, CURRENT, max2, CURRENT, effect));
			q2.addMarker("BAR2");
			q2.addCondition(condition2);
			// ---
			q2.addAction(new AQMove().move(movable2_mc, duration2, CURRENT, CURRENT, max3, CURRENT, effect));
			// ---
			q2.addMarker("BAR3");
			q2.addCondition(condition3);
			// ---
			q2.addAction(new AQFade().fade(movable2_mc, 1, CURRENT, 0));

			q3.addAction(new AQMove().move(movable3_mc, duration3, CURRENT, CURRENT, max1, CURRENT, effect));
			q3.addMarker("BAR1");
			q3.addCondition(condition1);
			// ---
			q3.addAction(new AQMove().move(movable3_mc, duration3, CURRENT, CURRENT, max2, CURRENT, effect));
			q3.addMarker("BAR2");
			q3.addCondition(condition2);
			// ---
			q3.addAction(new AQMove().move(movable3_mc, duration3, CURRENT, CURRENT, max3, CURRENT, effect));
			// ---
			q3.addMarker("BAR3");
			q3.addCondition(condition3);
			// ---
			q3.addAction(new AQFade().fade(movable3_mc, 1, CURRENT, 0));

			var fadeConditionCheck : Function = function() : Boolean {
				return (q1.isFinished() && q2.isFinished() && q3.isFinished());
			};
			var fadeCondition : Condition = new Condition(fadeConditionCheck);

			fadeLinesQueue = new ActionQueue("lines queue");
			fadeLinesQueue.addCondition(fadeCondition);
			var duration : Number = 2.0;

			fadeLinesQueue.addAsynchronousAction(new AQFade().fade(bar1_mc, duration, CURRENT, 0));
			fadeLinesQueue.addAsynchronousAction(new AQFade().fade(bar2_mc, duration, CURRENT, 0));
			fadeLinesQueue.addAsynchronousAction(new AQFade().fade(bar3_mc, duration, CURRENT, 0));

			q1.run();
			q2.run();
			q3.run();
			fadeLinesQueue.run();
		}

		private function initLoop() : void {
			if (loopQueue) loopQueue.reset();
			loop_mc.x = 16;
			loop_mc.y = 236;
			loop_mc.scaleX = loop_mc.scaleY = 1;
			loop_mc.alpha = num1_mc.alpha = num2_mc.alpha = num3_mc.alpha = 1;
		}

		private function startLoop() : void {
			initLoop();

			var duration : Number = .5;
			var numFadeDuration : Number = .5;

			var CURRENT : Number = Number.NaN;
			var effect : Function = Quadratic.easeInOut;

			loopQueue = new ActionQueue("loopQueue");
			loopQueue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker1_mc.x, marker1_mc.y, effect));
			loopQueue.addAsynchronousAction(new AQFade().fade(num1_mc, numFadeDuration, CURRENT, 0));
			loopQueue.addStartLoop("L", 4);
			loopQueue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker2_mc.x, marker2_mc.y, effect));
			loopQueue.addAsynchronousAction(new AQFade().fade(num2_mc, numFadeDuration, CURRENT, 0));
			loopQueue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker3_mc.x, marker3_mc.y, effect));
			loopQueue.addAsynchronousAction(new AQFade().fade(num3_mc, numFadeDuration, CURRENT, 0));
			loopQueue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker1_mc.x, marker1_mc.y, effect));
			loopQueue.addEndLoop("L");
			loopQueue.addAction(new AQMove().move(loop_mc, duration, CURRENT, CURRENT, marker4_mc.x, marker4_mc.y, effect));
			var fadeDuration : Number = 2;
			loopQueue.addAsynchronousAction(new AQScale().scale(loop_mc, fadeDuration, CURRENT, CURRENT, 4, 4, effect));
			loopQueue.addAction(new AQFade().fade(loop_mc, fadeDuration, CURRENT, 0, effect));

			loopQueue.run();
		}

		private function initEvents() : void {
			if (eventsQueue) eventsQueue.reset();
			event_mc.x = 16;
			event_mc.alpha = 100;
			num_e_1_mc.alpha = num_e_2_mc.alpha = num_e_3_mc.alpha = num_e_4_mc.alpha = num_e_5_mc.alpha = 1;
		}

		private function startEvents() : void {
			initEvents();

			var CURRENT : Number = Number.NaN;
			var duration : Number = .5;
			var numFadeDuration : Number = 1;

			eventsQueue = new ActionQueue("eventsQueue");
			eventsQueue.addStartLoop("L");
			eventsQueue.addAction(new AQMove().move(event_mc, duration, CURRENT, CURRENT, e_marker1_mc.x, e_marker1_mc.y));

			eventsQueue.addMarker("M1");
			eventsQueue.addAsynchronousAction(new AQFade().fade(num_e_1_mc, numFadeDuration, CURRENT, 0));
			eventsQueue.addAction(new AQMove().move(event_mc, duration, CURRENT, CURRENT, e_marker2_mc.x, e_marker2_mc.y));
			eventsQueue.addMarker("M2");
			eventsQueue.addAsynchronousAction(new AQFade().fade(num_e_2_mc, numFadeDuration, CURRENT, 0));
			eventsQueue.addAction(new AQMove().move(event_mc, duration, CURRENT, CURRENT, e_marker3_mc.x, e_marker3_mc.y));
			eventsQueue.addMarker("M3");
			eventsQueue.addAsynchronousAction(new AQFade().fade(num_e_3_mc, numFadeDuration, CURRENT, 0));
			eventsQueue.addAction(new AQMove().move(event_mc, duration, CURRENT, CURRENT, e_marker4_mc.x, e_marker4_mc.y));
			eventsQueue.addMarker("M4");
			eventsQueue.addAsynchronousAction(new AQFade().fade(num_e_4_mc, numFadeDuration, CURRENT, 0));
			eventsQueue.addAction(new AQMove().move(event_mc, duration, CURRENT, CURRENT, e_marker5_mc.x, e_marker5_mc.y));
			eventsQueue.addMarker("M5");
			eventsQueue.addAsynchronousAction(new AQFade().fade(num_e_5_mc, numFadeDuration, CURRENT, 0));
			eventsQueue.addAction(new AQSet().setLoc(event_mc, 16, CURRENT));
			eventsQueue.addEndLoop("L");

			eventsQueue.addEventListener(ActionEvent._EVENT, onActionEvent);

			eventsQueue.run();
		}

		public function onActionEvent(e : ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.MARKER_VISITED:
					handleMarkerPassed(e);
					break;
			}
		}

		public function handleMarkerPassed(e : ActionEvent) : void {
			createParticles(event_mc.x, event_mc.y);
		}

		private function createParticles(inX : Number, inY : Number) : void {
			var count : Number = Math.floor(1 + Math.random() * 4);
			var i : int;
			for (i = 0; i < count; ++i) {
				const COLOR:Number = 0xffffff;
				var particle : Particle = new Particle(inX, inY, COLOR);
				addChild(particle);
			}
		}

		public function handlePause(event : MouseEvent) : void {
			q1.togglePlay();
			q2.togglePlay();
			q3.togglePlay();
			fadeLinesQueue.togglePlay();
			mFadeLinesQueuePaused = !mFadeLinesQueuePaused;
		}

		public function handleStart(event : MouseEvent) : void {
			startSynchronizeMarkers();
		}

		public function handleStartLoop(event : MouseEvent) : void {
			startLoop();
		}

		public function handlePauseLoop(event : MouseEvent) : void {
			loopQueue.togglePlay();
		}

		public function handleQuitLoop(event : MouseEvent) : void {
			loopQueue.endLoop("L", true);
		}

		public function handleFinishLoop(event : MouseEvent) : void {
			loopQueue.endLoop("L");
		}

		public function handleStartEvents(event : MouseEvent) : void {
			startEvents();
		}

		public function handlePauseEvents(event : MouseEvent) : void {
			eventsQueue.togglePlay();
		}
	}
}
