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
	public class ActionTestCase extends TestCase {
		
		private var mInstance:ActionTestCase = this as ActionTestCase;

		public function ActionTestCase () {
			super();
		}
		
		public function testConstructor () : void {
			var action:Action = new Action(this, testMethod);
			assertTrue("ActionTestCase testConstructor", action);
		}
		
		public function testRun () : void {
			var action:Action = new Action(this, testMethod);
			var result:Boolean = action.run();
			assertTrue("ActionTestCase testRun", result);
		}
		
		public function testRunWithArguments () : void {
			var action:Action = new Action(this, testAddition, [10, 20]);
			var result:int = action.run();
			assertTrue("ActionTestCase testRun", result == 30);
		}
		
		public function testIsRunning () : void {
			var action:Action = new Action(this, testMethod);
			assertFalse("ActionTestCase testIsRunning", action.isRunning());
		}
		
		private function testMethod () : Boolean {
			return true;
		}
		
		private function testAddition (a:int, b:int) : int {
			return a+b;
		}
		
		
	}
	
}

