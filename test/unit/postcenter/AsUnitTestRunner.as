package {
	import asunit.textui.TestRunner;
	import flash.display.Sprite;
	
	public class AsUnitTestRunner extends TestRunner {

		public static var canvas : Sprite;
		
		public function AsUnitTestRunner() {
			canvas = this;
			
			start(PostCenterTest, null, TestRunner.SHOW_TRACE);
		}
	}
}
