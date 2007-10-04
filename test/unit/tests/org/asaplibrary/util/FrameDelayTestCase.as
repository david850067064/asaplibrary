package org.asaplibrary.util {
	
	import asunit.framework.TestCase;
	
	import org.asaplibrary.util.FrameDelay;
	
	import org.asaplibrary.util.debug.Log;
	
	
	public class FrameDelayTestCase extends TestCase {
	
		private static var sMethodsCalledCount:Number = 0;
		private static var EXPECTED_METHODS_CALLED_COUNT:Number = 1;
		private static var sCallTestCalled:Boolean = false;
		
		public override function run () : void {
			Log.debug("run", toString());
			
			var fd:FrameDelay = new FrameDelay(callTest, 2);
		}
		
		public function testEvaluateResult () : void {
			Log.debug("testEvaluateResult: ", toString());
			assertTrue("FrameDelayTest testResult", sMethodsCalledCount == EXPECTED_METHODS_CALLED_COUNT);
		}
		
		// PRIVATE METHODS
		
		private function callTest () : void {
			Log.debug("callTest ", toString());
			sMethodsCalledCount++;
			sCallTestCalled = true;
			super.run();
		}
		
		public override function toString () : String {
			return ";org.asaplibrary.util.FrameDelayTestCase";
		}
		
	}
}