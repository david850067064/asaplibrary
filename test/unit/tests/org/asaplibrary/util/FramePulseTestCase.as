package org.asaplibrary.util {
	
	import asunit.framework.TestCase;
	import flash.events.Event;
	import org.asaplibrary.util.FramePulse;
		
	public class FramePulseTestCase extends TestCase {
	
		private static var ALL_METHODS_CALLED_COUNT:Number = 1;
		private static var sMethodsCalledCount:Number = 0;

		
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {
			doTestAddEnterFrameListener();
		}
		
		private function doTestAddEnterFrameListener () : void {
			FramePulse.addEnterFrameListener(callTest);
		}
		
		/**
		Resume test
		*/
		private function callTest (e:Event) : void {
			sMethodsCalledCount++;

			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertEquals(sMethodsCalledCount, ALL_METHODS_CALLED_COUNT);
			
			FramePulse.removeEnterFrameListener(callTest);
		}
	}
}