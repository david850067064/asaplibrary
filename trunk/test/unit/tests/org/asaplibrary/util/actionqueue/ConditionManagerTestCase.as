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
	public class ConditionManagerTestCase extends TestCase {
		
		private static const TEST_DELAY:Number = 31;
		
		private var sTestRegisterFuncCalled:uint = 0;
		private static var EXPECTED_TEST_REGISTER_FUNC_CALLED:uint = 1;
		
		private var sTestUnRegisterFuncCalled:uint = 0;
		private static var EXPECTED_TEST_UNREGISTER_FUNC_CALLED:uint = 0;
		
		private var sTestResetFuncCalled:uint = 0;
		private static var EXPECTED_TEST_RESET_FUNC_CALLED:uint = 0;
		
		public function ConditionManagerTestCase () {
			super();
		}
		
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {

			doTestConstructor();
			doTestRegisterCondition();
			doTestUnRegisterCondition();
			doTestReset();
			
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertTrue("ConditionManager EXPECTED_TEST_REGISTER_FUNC_CALLED", (sTestRegisterFuncCalled == EXPECTED_TEST_REGISTER_FUNC_CALLED));
			assertTrue("ConditionManager EXPECTED_TEST_UNREGISTER_FUNC_CALLED", (sTestUnRegisterFuncCalled == EXPECTED_TEST_UNREGISTER_FUNC_CALLED));
			assertTrue("ConditionManager EXPECTED_TEST_RESET_FUNC_CALLED", (sTestResetFuncCalled == EXPECTED_TEST_RESET_FUNC_CALLED));
		}
		
		public function doTestConstructor () : void {
			var manager:ConditionManager = new ConditionManager();
			assertTrue("ConditionManagerTestCase testConstructor", manager);
		}
		
		public function doTestRegisterCondition () : void {
			var manager:ConditionManager = new ConditionManager();
			var condition:Condition = new Condition(funcTestRegisterCondition);
			manager.registerCondition(condition);
		}
		
		public function doTestUnRegisterCondition () : void {
			var manager:ConditionManager = new ConditionManager();
			var condition:Condition = new Condition(funcTestUnRegisterCondition);
			manager.registerCondition(condition);
			manager.unRegisterCondition(condition);
		}
		
		public function doTestReset () : void {
			var manager:ConditionManager = new ConditionManager();
			var condition:Condition = new Condition(funcTestUnRegisterCondition);
			manager.registerCondition(condition);
			manager.reset();
		}
				
		private function funcTestRegisterCondition () : Boolean {
			sTestRegisterFuncCalled++;
			return true;
		}
		
		private function funcTestUnRegisterCondition () : Boolean {
			sTestUnRegisterFuncCalled++;
			return true;
		}
		
		private function funcTestReset () : Boolean {
			sTestResetFuncCalled++;
			return true;
		}

		
	}
	
}

