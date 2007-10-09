package {

	import asunit.framework.TestSuite;
	
	import org.asaplibrary.data.*;
	import org.asaplibrary.data.array.*;
	import org.asaplibrary.data.tree.*;
	import org.asaplibrary.data.xml.*;
	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.util.*;
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.loader.*;
	
	public class AllTests extends TestSuite {

		public function AllTests () {
			super();
			
			// data
			//addTest(new BaseEnumeratorTestCase());
			//addTest(new ArrayEnumeratorTestCase());
			addTest(new TraverseArrayEnumeratorTestCase());

			//addTest(new URLDataTestCase());
			//addTest(new XMLLoaderTestCase());
			//addTest(new ParserTestCase());
			//addTest(new TreeTestCase());
			//addTest(new TreeEnumeratorTestCase());
			
			// management
			//addTest(new LocalControllerTestCase());
			//addTest(new MovieManagerTestCase());
			
			// util
			//addTest(new BooleanUtilsTestCase());
			//addTest(new FramePulseTestCase());
			//addTest(new FrameDelayTestCase());
			//addTest(new ActionQueueTestCase(AsUnitTestRunner.canvas));
			//addTest(new NumberUtilsTestCase());
			//addTest(new AssetLoaderTestCase());
		}
	}
	
}
