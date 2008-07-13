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
			tc.startMovie();
			assertTrue("LocalController startMovie", tc.playCalled);
		}
		
		public function testStopMovie() : void {
			var tc:TestController = new TestController(this);
			tc.stopMovie();
			assertTrue("LocalController stopMovie", tc.stopCalled);
		}	
		
	}
}

import org.asaplibrary.management.movie.*;

class TestController extends LocalController {

	private var mTestController:LocalControllerTestCase;
	public var playCalled:Boolean;
	public var stopCalled:Boolean;
	
	function TestController (inTestController:LocalControllerTestCase) {
		super();
		mTestController = inTestController;
	}
	
	public override function startMovie () : void {
		super.startMovie();
	}
	
	public override function play () : void {
		playCalled = true;
	}
	
	public override function stopMovie () : void {
		super.stopMovie();
	}
	
	public override function stop () : void {
		stopCalled = true;
	}
}