package org.asaplibrary.data.xml {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.xml.XMLLoader;
	import org.asaplibrary.util.FrameDelay;

	public class XMLLoaderTestCase extends TestCase {

		private static const XML_NAME:String = "TESTXML";
		private static const TEST_DELAY:Number = 31;

		private static var sCompleteCalled:Number = 0;
		private static const EXPECTED_COMPLETE_CALLED:Number = 1;
		
		private static var sErrorCalled:Number = 0;
		private static const EXPECTED_ERROR_CALLED:Number = 1;
		
		public override function run () : void {
			new FrameDelay(assertResults, TEST_DELAY);
			super.run();
		}
		
		public function testConstructor() : void {
			var instance:XMLLoader = new XMLLoader();
			assertTrue("XMLLoader testConstructor", instance != null);
		}
		
		public function testLoadXML() : void {
			doTestLoadGood();
			doTestLoadBad();
		}
		
		private function doTestLoadGood() : void {
			var instance:XMLLoader = new XMLLoader();
			instance.addEventListener(XMLLoaderEvent._EVENT, handleXMLLoaded);
			instance.loadXML("testdata/test.xml", XML_NAME)
		}
		
		private function doTestLoadBad() : void {
			var instance:XMLLoader = new XMLLoader();
			instance.addEventListener(XMLLoaderEvent._EVENT, handleXMLLoaded);
			instance.loadXML("testdata/XXX.xml", XML_NAME)
		}

		private function handleXMLLoaded (e:XMLLoaderEvent) : void {
			if (e.name != XML_NAME) return;
			
			switch (e.subtype) {
				case XMLLoaderEvent.COMPLETE: handleXMLComplete(e); break;
				case XMLLoaderEvent.ERROR: handleXMLError(e); break;
			}
		}
		
		private function handleXMLComplete (e:XMLLoaderEvent) : void {
			sCompleteCalled++;
		}
		
		private function handleXMLError (e:XMLLoaderEvent) : void {
			sErrorCalled++;
		}
		
		private function assertResults () : void {
			assertTrue("assertResults sCompleteCalled", sCompleteCalled == EXPECTED_COMPLETE_CALLED);
			assertTrue("assertResults sErrorCalled", sErrorCalled == EXPECTED_ERROR_CALLED);
		}
	}
}
