package org.asaplibrary.util.actionqueue {
	
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	
	import asunit.framework.TestCase;
	import AsUnitTestRunner;
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.util.debug.Log;
	
	/**
	TODO: Conditions
	*/
	public class ActionRunnerTestCase extends TestCase {
		
		private static const TEST_DELAY:Number = 31;

		private static var sTestFuncCalled:uint = 0;
		private static const EXPECTED_TEST_FUNC_CALLED:uint = 1;
		
		private static var sPauseFuncCalled:uint = 0;
		private static const EXPECTED_PAUSE_FUNC_CALLED:uint = 1;
		
		private static var sStopFuncCalled:uint = 0;
		private static const EXPECTED_STOP_FUNC_CALLED:uint = 2;
		
		private static var sQuitFuncCalled:uint = 0;
		private static const EXPECTED_QUIT_FUNC_CALLED:uint = 1;
		
		private static var sSkipFuncCalled:uint = 0;
		private static const EXPECTED_SKIP_FUNC_CALLED:uint = 1;
		
		private static var sGotoStepFuncCalled:uint = 0;
		private static const EXPECTED_GOTOSTEP_FUNC_CALLED:uint = 1;
		
		private static var sClearFuncCalled:uint = 0;
		private static const EXPECTED_CLEAR_FUNC_CALLED:uint = 0;
		
		private static var sResetFuncCalled:uint = 0;
		private static const EXPECTED_RESET_FUNC_CALLED:uint = 1;
		
		private static var sEventSTARTEDCalled:uint = 0;
		private static const EXPECTED_EVENT_STARTED_CALLED:uint = 1;
		private static var sEventFINISHEDCalled:uint = 0;
		private static const EXPECTED_EVENT_FINISHED_CALLED:uint = 2;
		private static var sEventQUITCalled:uint = 0;
		private static const EXPECTED_EVENT_QUIT_CALLED:uint = 1;
		private static var sEventPAUSEDCalled:uint = 0;
		private static const EXPECTED_EVENT_PAUSED_CALLED:uint = 1;
		private static var sEventRESUMEDCalled:uint = 0;
		private static const EXPECTED_EVENT_RESUMED_CALLED:uint = 1;
		private static var sEventSTOPPEDCalled:uint = 0;
		private static const EXPECTED_EVENT_STOPPED_CALLED:uint = 1;
		
		private static var sEventMARKER_PASSEDCalled:uint = 0;
		private static const EXPECTED_EVENT_MARKER_PASSED_CALLED:uint = 0;
		
		public function ActionRunnerTestCase () {
			super();
		}
		
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {

			doTestConstructor();
			doTestRun();
			doTestSetActions();
			doTestPauseAndResume();
			doTestStop();
			doTestQuit();
			doTestIsFinished();
			doTestSkip();
			doTestGoToStep();
			doTestReset();
			doTestEvents();
			
			// TODO: insertAction
			
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertTrue("ActionRunner EXPECTED_TEST_FUNC_CALLED", (sTestFuncCalled == EXPECTED_TEST_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_PAUSE_FUNC_CALLED", (sPauseFuncCalled == EXPECTED_PAUSE_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_STOP_FUNC_CALLED", (sStopFuncCalled == EXPECTED_STOP_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_QUIT_FUNC_CALLED", (sQuitFuncCalled == EXPECTED_QUIT_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_SKIP_FUNC_CALLED", (sSkipFuncCalled == EXPECTED_SKIP_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_GOTOSTEP_FUNC_CALLED", (sGotoStepFuncCalled == EXPECTED_GOTOSTEP_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_CLEAR_FUNC_CALLED", (sClearFuncCalled == EXPECTED_CLEAR_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_RESET_FUNC_CALLED", (sResetFuncCalled == EXPECTED_RESET_FUNC_CALLED));
			
			// Events
			assertTrue("ActionRunner EXPECTED_EVENT_STARTED_CALLED", (sEventSTARTEDCalled == EXPECTED_EVENT_STARTED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_FINISHED_CALLED", (sEventFINISHEDCalled == EXPECTED_EVENT_FINISHED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_QUIT_CALLED", (sEventQUITCalled == EXPECTED_EVENT_QUIT_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_PAUSED_CALLED", (sEventPAUSEDCalled == EXPECTED_EVENT_PAUSED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_RESUMED_CALLED", (sEventRESUMEDCalled == EXPECTED_EVENT_RESUMED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_STOPPED_CALLED", (sEventSTOPPEDCalled == EXPECTED_EVENT_STOPPED_CALLED));
			
			assertTrue("ActionRunner EXPECTED_EVENT_MARKER_PASSED_CALLED", (sEventMARKER_PASSEDCalled == EXPECTED_EVENT_MARKER_PASSED_CALLED));
		}

		private function doTestConstructor () : void {
			var runner:ActionRunner = new ActionRunner();
			assertTrue("ActionRunner instantiated", runner);
		}
		
		private function doTestRun () : void {
			var runner:ActionRunner = new ActionRunner();
			assertFalse("doTestRun isRunning", runner.isRunning());
			runner.run();
			assertFalse("doTestRun after run isRunning", runner.isRunning());
			// feed an action
			var actions:Array = [];
			var action:Action = new Action(dummyFunc);
			actions.push(action);
			runner.setActions(actions);
			runner.run();
			runner.stop();
			assertFalse("doTestRun after stop", runner.isRunning());
		}
		
		private function doTestSetActions () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			var action:Action = new Action(testFunc);
			actions.push(action);
			runner.setActions(actions);
			runner.run();
		}
		
		private function doTestAddActions () : void {
			//
		}
		
		private function doTestPauseAndResume () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			var action:Action = new Action(pauseFunc);
			actions.push(action);
			runner.setActions(actions);
			assertFalse("doTestPauseAndResume paused", runner.isPaused());
			runner.pause();
			assertTrue("doTestPauseAndResume paused", runner.isPaused());
			// action should not be called
			runner.run();
			assertTrue("doTestPauseAndResume paused", runner.isPaused());
			runner.resume();
			assertFalse("doTestPauseAndResume paused", runner.isPaused());
			// action should be called now
		}
		
		private function doTestStop () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			actions.push(new Action(stopFunc));
			actions.push(new Action(stopFunc));
			runner.setActions(actions);
			runner.stop();
			assertFalse("doTestStop after stop", runner.isRunning());
			runner.setActions(actions);
			runner.run();
		}
		
		private function doTestQuit () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			actions.push(new Action(quitFunc));
			runner.setActions(actions);
			runner.quit();
			assertFalse("doTestQuit after stop", runner.isRunning());
			runner.setActions(actions); /* << should fail */
			runner.run();
		}
		
		private function doTestIsFinished () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			var action:Action = new Action(dummyFunc);
			actions.push(action);
			runner.setActions(actions);
			assertFalse("doTestIsFinished before run", runner.isFinished());
			runner.run();
			assertTrue("doTestIsFinished after run", runner.isFinished());
		}
		
		private function doTestSkip () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			actions.push(new Action(skipFunc));
			actions.push(new Action(skipFunc));
			runner.setActions(actions);
			runner.skip();
			runner.run();
		}
		
		private function doTestGoToStep () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			actions.push(new Action(gotoStepFunc));
			actions.push(new Action(gotoStepFunc));
			runner.setActions(actions);
			runner.gotoStep(1);
			runner.run();
		}
		
		private function doTestReset () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			actions.push(new Action(resetFunc));
			runner.setActions(actions);
			runner.run();
			runner.reset();
			runner.run();
		}
		
		private function doTestEvents () : void {
			var runner:ActionRunner = new ActionRunner();
			var actions:Array = [];
			actions.push(new Action(dummyFunc));
			runner.setActions(actions);
			runner.addEventListener(ActionEvent._EVENT, onActionEvent);
			runner.run();
			runner.pause();
			runner.resume();
			runner.stop();
			runner.quit();
		}
		
		private function onActionEvent (e:ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.STARTED: sEventSTARTEDCalled++;
					break;
				case ActionEvent.FINISHED: sEventFINISHEDCalled++; 
					break;
				case ActionEvent.QUIT: sEventQUITCalled++; 
					break;
				case ActionEvent.PAUSED: sEventPAUSEDCalled++; 
					break;
				case ActionEvent.RESUMED: sEventRESUMEDCalled++; 
					break;
				case ActionEvent.STOPPED: sEventSTOPPEDCalled++; 
					break;
				case ActionEvent.MARKER_VISITED: sEventMARKER_PASSEDCalled++; 
					break;
			}
		}
		
		private function testFunc () : void {
			sTestFuncCalled++;
		}
		
		private function pauseFunc () : void {
			sPauseFuncCalled++;
		}
		
		private function stopFunc () : void {
			sStopFuncCalled++;
		}
		
		private function quitFunc () : void {
			sQuitFuncCalled++;
		}
		
		private function skipFunc () : void {
			sSkipFuncCalled++;
		}
		
		private function gotoStepFunc () : void {
			sGotoStepFuncCalled++;
		}
		
		private function clearFunc () : void {
			sClearFuncCalled++;
		}
		
		private function resetFunc () : void {
			sResetFuncCalled++;
		}
		
		private function dummyFunc () : void {
			//
		}
		
	}
	
}

