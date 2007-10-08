package {

	import asunit.framework.TestSuite;
	
	import org.asaplibrary.data.*;
	import org.asaplibrary.data.array.*;
	import org.asaplibrary.data.tree.*;
	import org.asaplibrary.data.xml.*;
	import org.asaplibrary.util.*;
	import org.asaplibrary.util.actionqueue.*;
	
	public class AllTests extends TestSuite {

		public function AllTests () {
			super();
			//addTest(new BaseEnumeratorTestCase());
			
			addTest(new URLDataTestCase());
			addTest(new XMLLoaderTestCase());
			
			//addTest(new ArrayEnumeratorTestCase());
			//addTest(new TreeTestCase());
			//addTest(new TreeEnumeratorTestCase());
			//addTest(new BooleanUtilsTestCase());
			//addTest(new FramePulseTestCase());
			//addTest(new FrameDelayTestCase());
			//addTest(new ActionQueueTestCase(AsUnitTestRunner.canvas));
			//addTest(new NumberUtilsTestCase());
		}
	}
	
}
