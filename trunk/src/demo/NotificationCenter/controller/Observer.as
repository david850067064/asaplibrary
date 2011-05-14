package demo.NotificationCenter.controller {
	import demo.NotificationCenter.data.AppSettings;

	import fl.controls.Button;

	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.util.notificationcenter.*;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	public class Observer extends LocalController {
		public var tReceiver : MovieClip;
		public var tData : TextField;
		public var tAddObserverBtn : Button;
		public var tRemoveObserverBtn : Button;
		private const RECEIVER_DEFAULT_TEXT : String = "";
		private const RECEIVER_RECEIVING_TEXT : String = "Observing\n...";

		function Observer() {
			NotificationCenter.getDefaultCenter().setCheckOnAdding(true);
			// prevent us from adding more and more listeners for the same notification name. But this is hypothetical for now because we will disable the add button once clicked, to provide a better user interface.

			// Test this movie on itself.
			testStandAlone();

			// update button states as soon as they are there
			addEventListener(Event.ADDED, initUI);
		}

		/**
		Test this movie on itself.
		 */
		private function testStandAlone() : void {
			addObserver();
			var postData : Date = new Date();
			NotificationCenter.getDefaultCenter().post(AppSettings.NOTE_NAME, null, postData);
			removeObserver();
		}

		private function initUI(e : Event = null) : void {
			removeEventListener(Event.ADDED, initUI);
			// listen for button clicks
			tAddObserverBtn.addEventListener("click", addObserver);
			tRemoveObserverBtn.addEventListener("click", removeObserver);
			// initial button states
			tAddObserverBtn.enabled = true;
			tRemoveObserverBtn.enabled = false;
			// clear data field
			tData.text = RECEIVER_DEFAULT_TEXT;
		}

		private function addObserver(e : Event = null) : void {
			// register 'this' to the NotificationCenter and start listening for notifications with name AppSettings.NOTE_NAME.
			NotificationCenter.getDefaultCenter().addObserver(this, handleSenderDidUpdate, AppSettings.NOTE_NAME);
			// update button states
			tAddObserverBtn.enabled = false;
			tRemoveObserverBtn.enabled = true;
			// update data field
			tData.text = RECEIVER_RECEIVING_TEXT;
		}

		private function removeObserver(e : Event = null) : void {
			// unregister 'this' from NotificationCenter
			NotificationCenter.getDefaultCenter().removeObserver(this, AppSettings.NOTE_NAME);
			// update button states
			tAddObserverBtn.enabled = true;
			tRemoveObserverBtn.enabled = false;
			// clear data field
			tData.text = RECEIVER_DEFAULT_TEXT;
		}

		public function handleSenderDidUpdate(inNote : Notification) : void {
			trace("handleSenderDidUpdate: " + inNote);
			// these are the value objects from the received Notification object
			var notificationName : String = inNote.name;
			var notificationData : Object = inNote.data;
			// do something with the data object
			var dateString : String = formatDatePart(notificationData.getHours()) + ":" + formatDatePart(notificationData.getMinutes()) + ":" + formatDatePart(notificationData.getSeconds());
			tData.text = notificationName + "\n" + dateString;
		}

		private function formatDatePart(inDatePart : int) : String {
			var dateString : String = inDatePart.toString();
			dateString = ("0" + dateString).substring(dateString.length - 1);
			return dateString;
		}
	}
}
