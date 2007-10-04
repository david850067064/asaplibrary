package org.asaplibrary.util {
	
	import asunit.framework.TestCase;
	import flash.events.Event;
	import org.asaplibrary.util.FramePulse;
		
	public class FramePulseTestCase extends TestCase {
	
		private static var ALL_METHODS_CALLED_COUNT:Number = 1;
		private static var sMethodsCalledCount:Number = 0;

		
		/**
		Override run to pause test
		*/
		public override function run() : void {
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