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
	function updateTestContent (inContent) {
		var testcontentElem = document.getElementById("testcontent");
		testcontentElem.innerHTML += "Received:\"" + inContent + "\"<br />";
	}
	function setContent (inContent) {
		updateTestContent(inContent);
	}
	</code>
	Plus a page element with id "testcontent":
	<code>
	<div id="testcontent" style="margin:1em 0; padding:1em; background:#fc0; text-weight:bold;"></div>
	</code>
	*/
	public class PostCenterTestCase extends TestCase {
		
		private static const TEST_DELAY:Number = 31;
		private static const EXPECTED_MESSAGES_SENT:uint = 2;
		private static var sMessagesSent:uint = 0;
		private static const EXPECTED_ALL_MESSAGES_SENT:uint = 1;
		private static var sAllMessagesSent:uint = 0;
		
		function PostCenterTestCase () {
			super();
			
			var pc:PostCenter = PostCenter.defaultPostCenter;
			pc.addEventListener(PostCenterEvent._EVENT, handlePostCenterEvent);
		}		
			
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {
			doTestSendDefaultWindow();
			doTestSendDifferentWindows();
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertTrue("ActionQueueTestCase sMessagesSent", sMessagesSent == EXPECTED_MESSAGES_SENT);
			
			assertTrue("ActionQueueTestCase sAllMessagesSent", sAllMessagesSent == EXPECTED_ALL_MESSAGES_SENT);
		}
		
		private function doTestSendDefaultWindow () : void {
			var pc:PostCenter = PostCenter.defaultPostCenter;
			pc.send(constructMessage("default window 1"));
			pc.send(constructMessage("default window 2"));
			pc.send(constructMessage("default window 3"));
		}
		
		private function doTestSendDifferentWindows () : void {
			var pc:PostCenter = PostCenter.defaultPostCenter;
			pc.send(constructMessage("window _self 1"), "_self");
			pc.send(constructMessage("window _self 2"), "_self");
			pc.send(constructMessage("window TesterWindow 1 (_self 3)"), "TesterWindow");
		}
		
		private function handlePostCenterEvent (e:PostCenterEvent) : void {
			switch (e.subtype) {
				case PostCenterEvent.MESSAGE_SENT:
					sMessagesSent++;
					break;
				case PostCenterEvent.ALL_SENT:
					sAllMessagesSent++;
					break;
			}
		}
		
		private function constructMessage (inContent:String) : String {
			return "javascript:updateTestContent(\"" + inContent + "\")";
		}
		
	}
}
