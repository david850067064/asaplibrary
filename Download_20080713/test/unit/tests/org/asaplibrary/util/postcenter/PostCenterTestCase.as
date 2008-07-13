package org.asaplibrary.util.postcenter {
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
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
		private static const EXPECTED_REQUESTS_SENT:uint = 5;
		private static var sRequestsSent:uint = 0;
		private static const EXPECTED_ALL_REQUESTS_SENT:uint = 1;
		private static var sAllRequestsSent:uint = 0;
		
		function PostCenterTestCase () {
			super();
			
			var pc:PostCenter = PostCenter.defaultPostCenter;
			pc.addEventListener(PostCenterEvent._EVENT, handlePostCenterEvent);
		}		
			
		/**
		List tests that should be run first - before any function starting with 'test'.
		*/
		public override function run() : void {
			doTestLoopURLRequest();
			doTestSendDefaultWindow();
			doTestSendDifferentWindows();
			doTestSendRequests();
			new FrameDelay(startTests, TEST_DELAY);
		}
		
		/**
		Now call each public function starting with 'test'.
		*/
		public function startTests () : void {
			super.run();
		}
		
		public function testEvaluateResult () : void {
			assertTrue("ActionQueueTestCase sRequestsSent", sRequestsSent == EXPECTED_REQUESTS_SENT);
			
			assertTrue("ActionQueueTestCase sAllRequestsSent", sAllRequestsSent == EXPECTED_ALL_REQUESTS_SENT);
		}
		
		/**
		Tests sending URLRequests in a loop without using PostCenter.
		*/
		private function doTestLoopURLRequest () : void {
			var items:uint = 10;
			var i:uint;
			for (i=0; i<items; ++i) {
				var m:String = constructMessage("Without postcenter (" + items + " calls) -- " + (i+1));
				trace("m=" + m);
				var r:URLRequest = new URLRequest(m);
				navigateToURL(r, "_self");
			}
		}
		
		private function doTestSendDefaultWindow () : void {
			var pc:PostCenter = PostCenter.defaultPostCenter;
			pc.sendMessage(constructMessage("default window 1"));
			pc.sendMessage(constructMessage("default window 2"));
			pc.sendMessage(constructMessage("default window 3"));
		}
		
		private function doTestSendDifferentWindows () : void {
			var pc:PostCenter = PostCenter.defaultPostCenter;
			pc.sendMessage(constructMessage("window _self 1"), "_self");
			pc.sendMessage(constructMessage("window _self 2"), "_self");
			pc.sendMessage(constructMessage("window TesterWindow 1 (_self 3)"), "TesterWindow");
		}
		
		private function doTestSendRequests () : void {
			var pc:PostCenter = PostCenter.defaultPostCenter;
			var request:URLRequest;
			request = new URLRequest(constructMessage("request _self 1"));
			pc.sendURLRequest(request);
			request = new URLRequest(constructMessage("request _self 2"));
			pc.sendURLRequest(request);
			request = new URLRequest(constructMessage("request _self 3"));
			pc.sendURLRequest(request);
		}
		
		private function handlePostCenterEvent (e:PostCenterEvent) : void {
			switch (e.subtype) {
				case PostCenterEvent.REQUEST_SENT:
					sRequestsSent++;
					break;
				case PostCenterEvent.ALL_SENT:
					sAllRequestsSent++;
					break;
			}
		}
		
		private function constructMessage (inContent:String) : String {
			return "javascript:updateTestContent(\"" + inContent + "\")";
		}
		
	}
}
