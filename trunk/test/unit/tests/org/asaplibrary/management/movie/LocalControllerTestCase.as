package org.asaplibrary.management.movie {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.management.movie.*;
		
	public class LocalControllerTestCase extends TestCase {

		public function testConstructor() : void {
			var instance:LocalController = new LocalController();
			assertTrue("LocalController testConstructor", instance);
			assertFalse("LocalController isStandalone", instance.isStandalone());
		}
		
		public function testSetName() : void {
			var instance:LocalController = new LocalController();
			instance.setName("TRINIDAD");
			assertTrue("LocalController getName", instance.getName() == "TRINIDAD");
		}
		
		public function testStartMovie() : void {
			var tc:TestController = new TestController(this);
			tc.start();
			assertTrue("LocalController start", tc.startCalled);
		}
		
		public function testStopMovie() : void {
			var tc:TestController = new TestController(this);
			tc.stop();
			assertTrue("LocalController stopMovie", tc.stopCalled);
		}	
		
	}
}

import org.asaplibrary.management.movie.*;

class TestController extends LocalController {

	private var mTestController:LocalControllerTestCase;
	public var startCalled:Boolean;
	public var stopCalled:Boolean;
	
	function TestController (inTestController:LocalControllerTestCase) {
		super();
		mTestController = inTestController;
	}
	
	public override function start () : void {
		super.start();
		startCalled = true;
	}
	
	public override function stop () : void {
		super.stop();
		stopCalled = true;
	}
}