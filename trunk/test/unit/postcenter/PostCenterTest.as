package {

	import asunit.framework.TestSuite;
	
	import org.asaplibrary.util.postcenter.*;
	
	public class PostCenterTest extends TestSuite {

		public function PostCenterTest () {
			super();
			addTest(new PostCenterTestCase()); // use together with Tester.html
		}
	}
	
}
