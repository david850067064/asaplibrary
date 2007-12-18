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
	public class ConditionTestCase extends TestCase {
		
		private var mCanvas : Sprite;

		private var sConditionMetCallFunctionCalled:uint = 0;
		private static var EXPECTED_CONDITION_MET_FUNC_CALLED:uint = 1;
		
		private var sConditionNotMetCallFunctionCalled:uint = 0;
		private static var EXPECTED_NOT_CONDITION_MET_FUNC_CALLED:uint = 1;
		
		public function ConditionTestCase () {
			super();
		}
		
		public function testConstructor () : void {
			var condition:Condition = new Condition(evaluateTestTrue);
			assertTrue("ConditionTestCase testConstructor", condition);
		}
		
		public function testRun () : void {
			var condition1:Condition = new Condition(evaluateTest2, [-1]);
			var result1:Boolean = condition1.run();
			assertFalse("ConditionTestCase testRun 1", result1);
			
			var condition2:Condition = new Condition(evaluateTest2, [1]);
			var result2:Boolean = condition2.run();
			assertTrue("ConditionTestCase testRun 2", result2);
			
			var condition3:Condition = new Condition(evaluateTestTrue);
			condition3.run();
			assertTrue("ConditionTestCase testRun 3", condition3.isMet());
			
			var condition4:Condition = new Condition(evaluateTestFalse);
			condition4.run();
			assertFalse("ConditionTestCase testRun 4", condition4.isMet());
		}
		
		public function testConditionMetCallFunctions () : void {
			var condition:Condition = new Condition(evaluateTestTrue, null, [conditionMetCallFunction]);
			condition.run();
			assertTrue("ConditionTestCase testConditionMetCallFunctions", (sConditionMetCallFunctionCalled == EXPECTED_CONDITION_MET_FUNC_CALLED));
		}
		
		public function testConditionNotMetCallFunctions () : void {
			var condition:Condition = new Condition(evaluateTestFalse, null, null, [conditionNotMetCallFunction]);
			condition.run();
			assertTrue("ConditionTestCase testConditionNotMetCallFunctions", (sConditionNotMetCallFunctionCalled == EXPECTED_NOT_CONDITION_MET_FUNC_CALLED));
		}
		
		private function evaluateTestTrue () : Boolean {
			return true;
		}
		
		private function evaluateTestFalse () : Boolean {
			return false;
		}
		
		private function evaluateTest2 (inParam:int) : Boolean {
			return (inParam > 0) ? true : false;
		}
		
		private function conditionMetCallFunction () : void {
			sConditionMetCallFunctionCalled++;
		}
		
		private function conditionNotMetCallFunction () : void {
			sConditionNotMetCallFunctionCalled++;
		}
	}
	
}

