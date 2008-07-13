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

	*/
	public class TimedActionTestCase extends TestCase {
		
		private static const TEST_DELAY:Number = 31;
		
		private var sTestRunFuncCalled:uint = 0;
		private static var EXPECTED_TEST_RUN_FUNC_CALLED:uint = 1;
		
		private var sTestResumeFuncCalled:uint = 0;
		private static var EXPECTED_TEST_RESUME_FUNC_CALLED:uint = 1;
		
		private var sTestStopFuncCalled:uint = 0;
		private static var EXPECTED_TEST_STOP_FUNC_CALLED:uint = 1;
		
		private var sTestFinishFuncCalled:uint = 0;
		private static var EXPECTED_TEST_FINISH_FUNC_CALLED:uint = 1;
		
		private static var sEventFINISHEDCalled:uint = 0;
		private static const EXPECTED_EVENT_FINISHED_CALLED:uint = 1;
		
		private static var sEventSTOPPEDCalled:uint = 0;
		private static const EXPECTED_EVENT_STOPPED_CALLED:uint = 1;
		
		private var sTestLoopedFuncCalled:uint = 0;
		private static var EXPECTED_TEST_LOOPED_FUNC_CALLED_MIN:uint = 1;
		private static var EXPECTED_TEST_LOOPED_FUNC_CALLED_MAX:uint = 5;
		
		public function TimedActionTestCase () {
			super();
		}
		
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {

			doTestRun();
			doTestPause();
			doTestStop();
			doTestFinish();
			doTestEvents();
			doTestLooped();
			
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertTrue("TimedAction EXPECTED_TEST_RUN_FUNC_CALLED", (sTestRunFuncCalled == EXPECTED_TEST_RUN_FUNC_CALLED));
			assertTrue("TimedAction EXPECTED_TEST_RESUME_FUNC_CALLED", (sTestResumeFuncCalled == EXPECTED_TEST_RESUME_FUNC_CALLED));
			assertTrue("ActionRunner EXPECTED_EVENT_FINISHED_CALLED", (sEventFINISHEDCalled == EXPECTED_EVENT_FINISHED_CALLED));
			assertTrue("ActionRunner EXPECTED_EVENT_STOPPED_CALLED", (sEventSTOPPEDCalled == EXPECTED_EVENT_STOPPED_CALLED));
			assertTrue("ActionRunner EXPECTED_TEST_LOOPED_FUNC_CALLED_MIN", (sTestLoopedFuncCalled > EXPECTED_TEST_LOOPED_FUNC_CALLED_MIN));
			assertTrue("ActionRunner EXPECTED_TEST_LOOPED_FUNC_CALLED_MAX", (sTestLoopedFuncCalled < EXPECTED_TEST_LOOPED_FUNC_CALLED_MAX));
		}
		
		public function testConstructor () : void {
			var action:TimedAction = new TimedAction(funcDummy, .2);
			assertTrue("TimedAction testConstructor", action);
		}
		
		public function doTestRun () : void {
			var action:TimedAction = new TimedAction(funcRun, .2);
			action.run();
			assertTrue("TimedAction isRunning", action.isRunning());
		}
		
		public function doTestPause () : void {
			var action:TimedAction = new TimedAction(funcResume, .2);
			action.pause();
			action.resume();
			action.run();
		}
		
		public function doTestStop () : void {
			var action:TimedAction = new TimedAction(funcStop, .2);
			action.run();
			action.stop();
		}
		
		public function doTestFinish () : void {
			var action:TimedAction = new TimedAction(funcFinish, .2);
			action.run();
			action.finish();
		}
		
		public function doTestEvents () : void {
			doTestEventFinished();
			doTestEventStopped();
		}
		
		public function doTestEventFinished () : void {
			var action:TimedAction = new TimedAction(funcFinishedEvent, .2);
			action.addEventListener(ActionEvent._EVENT, onActionEvent);
			action.run();
		}
		
		public function doTestEventStopped () : void {
			var action:TimedAction = new TimedAction(funcStoppedEvent, .2);
			action.addEventListener(ActionEvent._EVENT, onActionEvent);
			action.run();
			action.stop();
		}
		
		private function onActionEvent (e:ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.FINISHED: sEventFINISHEDCalled++; 
					break;
				case ActionEvent.STOPPED: sEventSTOPPEDCalled++; 
					break;
			}
		}
		
		public function doTestLooped () : void {
			var action:TimedAction = new TimedAction(funcLooped, .04);
			action.setLoopCount(1);
			action.run();
			assertTrue("TimedAction doesLoop", action.doesLoop());
		}
		
		public function funcDummy () : Boolean {
			return true;
		}
		
		public function funcRun (p:Number) : Boolean {
			sTestRunFuncCalled++;
			return false;
		}
		
		public function funcResume (p:Number) : Boolean {
			sTestResumeFuncCalled++;
			return false;
		}
		
		public function funcStop (p:Number) : Boolean {
			sTestStopFuncCalled++;
			return false;
		}
		
		public function funcFinish (p:Number) : Boolean {
			sTestFinishFuncCalled++;
			return false;
		}
		
		public function funcFinishedEvent (p:Number) : Boolean {
			return true;
		}
		
		public function funcStoppedEvent (p:Number) : Boolean {
			return true;
		}
		
		public function funcLooped (p:Number) : Boolean {
			sTestLoopedFuncCalled++;
			return true;
		}
		
	}
	
}

