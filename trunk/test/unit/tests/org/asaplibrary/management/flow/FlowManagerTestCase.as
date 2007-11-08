package org.asaplibrary.management.flow {
	
	import flash.display.DisplayObject;

	import asunit.framework.TestCase;
	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.FrameDelay;

	public class FlowManagerTestCase extends TestCase {

		private static const TEST_DELAY:Number = 31;

		private static const SECTION_NAME:String = "TEST_SECTION";
		private var mFlowSection:FlowSection;
		private static const CHILD_SECTION_NAME:String = "TEST_SECTION.CHILD_SECTION";
		private var mChildFlowSection:FlowSection;
		private static const EXTERNAL_SECTION_NAME:String = "FlowSectionTestCase";
		private var mTestTrigger:Object;
		
		private static var sChildRuleFunctionCalled:Number = 0;
		private static const EXPECTED_CHILD_RULE_FUNCTION_CALLED:Number = 1;

		private static var sWillLoadEventCalled:Number = 0;
		private static const EXPECTED_WILL_LOAD_EVENT_CALLED:Number = 1;

		private static var sLoadedEventCalled:Number = 0;
		private static const EXPECTED_LOADED_EVENT_CALLED:Number = 1;

		protected var FM:FlowManager = FlowManager.defaultFlowManager;
		public static const OPTIONS:Class = FlowOptions;		

		function FlowManagerTestCase () {
			mFlowSection = new FlowSection(SECTION_NAME);
			mChildFlowSection = new FlowSection(CHILD_SECTION_NAME);
			mTestTrigger = new Object();
		}
		
		public override function run () : void {
			new FrameDelay(assertResults, TEST_DELAY);
			super.run();
		}
		
		public function testConstructor() : void {
			var instance:FlowManager = FM;
			assertTrue("FlowManager testConstructor", instance);
			
			var newInstance:FlowManager = new FlowManager();
			assertTrue("FlowManager newInstance", newInstance);
			assertFalse("FlowManager not default instance", instance === newInstance);
			
			var flowSection:FlowSection = new FlowSection("SECTION", newInstance);
			assertTrue("FlowManager newInstance", flowSection.getFlowManager() === newInstance);
		}
		
		public function testAddRule() : void {
			// this rule should be ignored when going to CHILD_SECTION_NAME
			var rule:FlowRule = new FlowRule(
				CHILD_SECTION_NAME,
				OPTIONS.START,
				OPTIONS.NONE,
				flowChildRuleTest
			);
			FM.addRule(rule);
			// this rule should be used when going to CHILD_SECTION_NAME
			rule = new FlowRule(
				CHILD_SECTION_NAME,
				OPTIONS.START,
				OPTIONS.CHILD,
				flowChildRuleTest
			);
			FM.addRule(rule);
			FM.goto(SECTION_NAME);
			FM.goto(CHILD_SECTION_NAME);
		}
		
		private function flowChildRuleTest (inSection:FlowSection) : void {
			sChildRuleFunctionCalled++;
			assertTrue("FlowManager flowChildRuleTest", inSection === mChildFlowSection);
		}
		
		public function testRegisterFlowSection () : void {
			FM.registerFlowSection(mFlowSection);
			assertTrue("FlowManager testRegisterFlowSection", FM.getSectionByName(SECTION_NAME) === mFlowSection);
		}
		
		public function testGetCurrentSection () : void {
			FM.goto(SECTION_NAME);
			assertTrue("FlowManager testGetCurrentSection", FM.getCurrentSection() === mFlowSection);
		}
		
		public function testGetCurrentSectionName () : void {
			FM.goto(SECTION_NAME);
			assertTrue("testGetCurrentSectionName",
			FM.getCurrentSectionName() == SECTION_NAME);
		}
		
		public function testLoadMovie () : void {
			FM.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
			FM.setDownloadDirectory("testdata/");
			FM.goto(EXTERNAL_SECTION_NAME);
		}
		
		private function handleNavigationEvent (e:FlowNavigationEvent) : void {
			switch (e.subtype) {
				case FlowNavigationEvent.WILL_LOAD:
					// movie is about to be loaded
					sWillLoadEventCalled++;
					break;
				case FlowNavigationEvent.LOADED:
					sLoadedEventCalled++;
					handleLoadedSection(e);
					FM.removeEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
					
					FM.removeSection(EXTERNAL_SECTION_NAME);
					//MovieManager.getInstance().removeMovie(EXTERNAL_SECTION_NAME);
					break;
			}
		}
		
		private function handleLoadedSection (e:FlowNavigationEvent) : void {
			FM.goto(e.name);
			assertTrue("handleLoadedSection EXTERNAL_SECTION_NAME",
			FM.getCurrentSectionName() == EXTERNAL_SECTION_NAME);
			assertTrue("handleLoadedSection e.name",
			FM.getCurrentSectionName() == e.name);
		}
		
		public function testTrigger () : void {
			FM.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent2);
			FM.goto(SECTION_NAME, mTestTrigger);
			var trigger:Object = FM.getFlowNavigationDataByName(SECTION_NAME).trigger;
			assertTrue("testTrigger e.name",
			trigger === mTestTrigger);
			FM.removeEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent2);
		}
		
		private function handleNavigationEvent2 (e:FlowNavigationEvent) : void {
			assertTrue("handleNavigationEvent2 trigger",
			e.trigger === mTestTrigger);
		}
		
		private function assertResults () : void {
			assertTrue("assertResults EXPECTED_CHILD_RULE_FUNCTION_CALLED", sChildRuleFunctionCalled == EXPECTED_CHILD_RULE_FUNCTION_CALLED);
			
			assertTrue("assertResults EXPECTED_WILL_LOAD_EVENT_CALLED", sWillLoadEventCalled == EXPECTED_WILL_LOAD_EVENT_CALLED);
			
			assertTrue("assertResults EXPECTED_LOADED_EVENT_CALLED", sLoadedEventCalled == EXPECTED_LOADED_EVENT_CALLED);
		}
		
	}
}

