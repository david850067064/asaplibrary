package demo.NotificationCenter.ui {
	import demo.NotificationCenter.data.AppSettings;

	import org.asaplibrary.ui.buttons.*;
	import org.asaplibrary.util.notificationcenter.*;

	public class SenderButton extends HilightButton {
		protected override function update(e : ButtonBehaviorEvent) : void {
			super.update(e);
			if (e.state == ButtonStates.DOWN) handleDown();
			if (e.state == ButtonStates.UP) handleUp();
		}

		private function handleDown() : void {
			gotoAndStop("down");
			// send current date as object
			var postData : Date = new Date();
			NotificationCenter.getDefaultCenter().post(AppSettings.NOTE_NAME, null, postData);
		}

		private function handleUp() : void {
			gotoAndStop("on");
		}
	}
}
