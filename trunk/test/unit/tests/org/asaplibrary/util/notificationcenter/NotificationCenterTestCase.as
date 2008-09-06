package org.asaplibrary.util.notificationcenter {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.util.notificationcenter.*;
	import org.asaplibrary.util.debug.*;
	import org.asaplibrary.util.FrameDelay;

	public class NotificationCenterTestCase extends TestCase {

		private static const TEST_DELAY:Number = 30;

		private static var EXPECTED_ONLOG_CALLED:Number = 1;
		private static var sOnLogCalledCount:Number = 0;
		private static var EXPECTED_NOTIFICATION_HANDLER_CALLED:Number = 1;
		private static var sNotificationHandlerCalledCount:Number = 0;
		private static var EXPECTED_NOTIFICATION_ADD_OBSERVER_HANDLER_CALLED:Number = 3;
		private static var sNotificationAddObserverHandlerCalledCount:Number = 0;
		
		private const mSenderObject:Array = new Array(1, 2, 3);

		function NotificationCenterTestCase () {
			super();
		}
		
		public override function run () : void {
			new FrameDelay(assertResults, TEST_DELAY);
			super.run();
		}
		
		public function testDefaultNotificationCenter () : void {
			var nc:NotificationCenter = NotificationCenter.getDefaultCenter();
			assertTrue("testDefaultNotificationCenter", nc != null);
		}
		
		public function testCustomNotificationCenter () : void {
			var nc:NotificationCenter = new NotificationCenter();
			assertTrue("testCustomNotificationCenter", nc != null);
			nc.setCheckOnAdding(true);
			assertTrue("testCustomNotificationCenter checkDuplicates true", nc.getCheckOnAdding());
			nc.setCheckOnAdding(false);
			assertFalse("testCustomNotificationCenter checkDuplicates false", nc.getCheckOnAdding());
		}
		
		
		public function testCheckNotifyErrors () : void {
			var nc:NotificationCenter = new NotificationCenter(true);
			assertTrue("testCheckNotifyErrors", nc.getNotifyErrors());
			Log.addLogListener(onLog);
			// double removal
			nc.removeObserver(this);
			Log.removeLogListener(onLog);
			nc.setNotifyErrors(false);
			// test again to see if event is not passed to onLog
			nc.removeObserver(this);
		}
		
		private function onLog (e:LogEvent) {
			sOnLogCalledCount++;
		}
		
		public function testCheckDuplicatesOnAdding () : void {
			var nc:NotificationCenter = new NotificationCenter();
			nc.setCheckOnAdding(true);
			assertTrue("testCheckDuplicatesOnAdding", nc.getCheckOnAdding());
			// first observer
			nc.addObserver(this, handleNotification, "someName");
			// second observer
			nc.addObserver(this, handleNotification, "someName");
			nc.post("someName", null, new Date());
		}
		
		public function handleNotification (inNote:Notification) : void {
			sNotificationHandlerCalledCount++;
		}

		public function testAddObserver () : void {
			var nc:NotificationCenter = new NotificationCenter();
			const NOTE_NAME:String = "addObserverTest";
			
			// name
			nc.addObserver(this, handleAddObserverNotification, NOTE_NAME);

			// object
			nc.addObserver(this, handleAddObserverNotification, null, mSenderObject);
			
			// post
			// 1
			nc.post(NOTE_NAME);
			// 2
			nc.post(NOTE_NAME, null);
			// 3
			nc.post(NOTE_NAME, mSenderObject);
		}
		
		public function handleAddObserverNotification (inNote:Notification) : void {
			sNotificationAddObserverHandlerCalledCount++;
		}
		
		public function testRemoveObserver () : void {
			var nc:NotificationCenter = new NotificationCenter();
			//nc.setCheckOnAdding(true);
			//nc.setNotifyErrors(true);
			
			const NOTE_NAME:String = "removeObserverTest";
			
			// name
			nc.addObserver(this, handleAddObserverNotification, NOTE_NAME);
			nc.removeObserver(this, NOTE_NAME);
			nc.post(NOTE_NAME); // should not get any result

			// object
			nc.addObserver(this, handleAddObserverNotification, null, mSenderObject);
			nc.removeObserver(this, null, mSenderObject);
			nc.post(NOTE_NAME, mSenderObject); // should not get any result
		}
		
		public function assertResults () : void {
			assertTrue("onLog count", sOnLogCalledCount == EXPECTED_ONLOG_CALLED);
			
			assertTrue("handleNotification count", sNotificationHandlerCalledCount == EXPECTED_NOTIFICATION_HANDLER_CALLED);
			
			assertTrue("handleNotificationAddObserver count", sNotificationAddObserverHandlerCalledCount == EXPECTED_NOTIFICATION_ADD_OBSERVER_HANDLER_CALLED);
		}
	}
}
