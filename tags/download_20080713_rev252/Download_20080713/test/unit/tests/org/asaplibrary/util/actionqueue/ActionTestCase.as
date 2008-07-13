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

		public function ActionTestCase () {
			super();
		}
		
		public function testConstructor () : void {
			var action:Action = new Action(_testMethod);
			assertTrue("ActionTestCase testConstructor", action);
		}
		
		public function testRun () : void {
			var action:Action = new Action(_testMethod);
			var result:Boolean = action.run();
			assertTrue("ActionTestCase testRun", result);
		}
		
		public function testRunWithArguments () : void {
			var action:Action = new Action(_testAddition, [10, 20]);
			var result:int = action.run();
			assertTrue("ActionTestCase testRun", result == 30);
		}
		
		public function testIsRunning () : void {
			var action:Action = new Action(_testMethod);
			assertFalse("ActionTestCase testIsRunning", action.isRunning());
		}
		
		private function _testMethod () : Boolean {
			return true;
		}
		
		private function _testAddition (a:int, b:int) : int {
			return a+b;
		}
		
		public function testScope () : void {
			var someObject = new AnotherClass();
			var action:Action;
			var result:Number;
			action = new Action(someObject.someMethod, [10]);
			result = action.run();
			assertTrue("ActionTestCase testScope", result = 10);
			action = new Action(someObject.someMethod, [1]);
			result = action.run();
			assertTrue("ActionTestCase testScope", result = 11);
		}
		
	}
	
}

class AnotherClass {

	var mCount:Number = 0;
	
	public function someMethod (inNumber:Number) : Number {
		mCount += inNumber;
		return getTotalCount();
	}
	
	public function getTotalCount () : Number {
		return mCount;
	}
}
