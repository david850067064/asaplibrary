package {

	import asunit.framework.TestSuite;
	
	import org.asaplibrary.data.*;
	import org.asaplibrary.data.array.*;
	import org.asaplibrary.data.tree.*;
	import org.asaplibrary.data.xml.*;
	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.*;
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.loader.*;
	import org.asaplibrary.util.notificationcenter.*;
	
	public class AllTests extends TestSuite {

		public function AllTests () {
			super();
			
			/* data */
			addTest(new BaseEnumeratorTestCase());
			addTest(new ArrayEnumeratorTestCase());
			addTest(new TraverseArrayEnumeratorTestCase());

			addTest(new URLDataTestCase());
			addTest(new XMLLoaderTestCase());
			addTest(new ParserTestCase());
			addTest(new TreeTestCase());
			addTest(new TreeEnumeratorTestCase());
			
			/* management */
			addTest(new LocalControllerTestCase());
			addTest(new MovieManagerTestCase());
			addTest(new FlowManagerTestCase());
			
			/* util */
			addTest(new BooleanUtilsTestCase());
			addTest(new FramePulseTestCase());
			addTest(new FrameDelayTestCase());
			addTest(new StageUtilsTestCase(AsUnitTestRunner.canvas));
			
			/* util.actionqueue */
			addTest(new ActionQueueTestCase(AsUnitTestRunner.canvas)); // TODO: markers
			addTest(new ActionRunnerTestCase());
			addTest(new ActionTestCase());
			addTest(new TimedActionTestCase());
			addTest(new ConditionTestCase());
			addTest(new ConditionManagerTestCase());
			
			addTest(new NumberUtilsTestCase());
			addTest(new AssetLoaderTestCase());
			addTest(new NotificationCenterTestCase());
			
			/*
			PostCenter: see separate test in folder postcenter
			*/
		}
	}
	
}
