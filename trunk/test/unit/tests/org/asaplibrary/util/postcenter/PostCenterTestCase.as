package org.asaplibrary.util.postcenter {
	
	import flash.system.*;
	import flash.external.*;
	import asunit.framework.TestCase;
	import org.asaplibrary.util.postcenter.*;
	import org.asaplibrary.util.FrameDelay;
	
	/**
	This test assumes a html page with the following javascript:
	<code>
	window.name = "TesterWindow";
	function sayHello1 (num) {
		alert("hello1: " + num);
	}
	function sayHello2 (num) {
		alert("hello2: " + num);
	}
	</code>
	*/
	public class PostCenterTestCase extends TestCase {
		
		private static const TEST_DELAY:Number = 120;
		private static const EXPECTED_LISTEN_NO_WINDOW_CALLED:uint = 1;
		private static var sListenNoWindowCalled:uint = 0;
		private static const EXPECTED_LISTEN_DIFFERENT_WINDOWS_CALLED:uint = 2;
		private static var sListenDifferentWindowsCalled:uint = 0;
		
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {
			doTestSendNoWindow();
			new FrameDelay(doTestSendDifferentWindows, 61);
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertTrue("ActionQueueTestCase sListenNoWindowCalled", sListenNoWindowCalled == EXPECTED_LISTEN_NO_WINDOW_CALLED);
			
			assertTrue("ActionQueueTestCase sListenDifferentWindowsCalled", sListenDifferentWindowsCalled == EXPECTED_LISTEN_DIFFERENT_WINDOWS_CALLED);
		}
		
		private function doTestSendNoWindow () : void {	
			PostCenter.defaultPostCenter.setCallback(listenNoWindow);
			PostCenter.defaultPostCenter.send(constructMessage("sayHello1", 1));
			PostCenter.defaultPostCenter.send(constructMessage("sayHello1", 2));
			PostCenter.defaultPostCenter.send(constructMessage("sayHello1", 3));
		}
		
		private function doTestSendDifferentWindows () : void {
			var pc:PostCenter = new PostCenter("different windows");
			pc.setCallback(listenDifferentWindows);
			pc.send(constructMessage("sayHello2", 1), "_self");
			pc.send(constructMessage("sayHello2", 2), "_self");
			pc.send(constructMessage("sayHello2", 3), "TesterWindow");
		}
		
		private function constructMessage (inFuncName:String, inVar:uint) : String {
			return "javascript:" + inFuncName + "(\"" + inVar + "\")";
		}
		
		private function listenNoWindow (inMessage:String, inWindow:String = null) : void {
			sListenNoWindowCalled++;
		}
		
		private function listenDifferentWindows (inMessage:String, inWindow:String = null) : void {
			sListenDifferentWindowsCalled++;
		}
		
	}
}
