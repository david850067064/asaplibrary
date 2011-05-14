package demo.VideoPlayer.controller {
	import org.asaplibrary.ui.buttons.HilightButton;
	import org.asaplibrary.ui.video.VideoMetaData;
	import org.asaplibrary.ui.video.VideoPlayer;
	import org.asaplibrary.util.media.MediaEvent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * Simple controller to demonstrate use of VideoPlayer
	 */
	public class AppController extends MovieClip {
		private const URL : String = "flv/trailer_big_buck_bunny.flv";
		private const WIDTH : int = 426;
		private const HEIGHT : int = 240;
		private const X : int = 18;
		private const Y : int = 100;
		public var tBody : TextField;
		public var tStartButton : HilightButton;
		public var tPauseButton : HilightButton;
		public var tResumeButton : HilightButton;
		private var mVideo : VideoPlayer;

		public function AppController() {
			super();
			initUI();
		}

		private function initUI() : void {
			// create videoplayer
			mVideo = new VideoPlayer(WIDTH, HEIGHT);
			// add videoplayer to displaylist
			addChild(mVideo);
			// position videoplayer
			mVideo.x = X;
			mVideo.y = Y;
			// listen to videoplayer events
			mVideo.addMediaEventHandler(handleMediaEvent);

			// listen to buttons
			tStartButton.addEventListener(MouseEvent.CLICK, handleButtonClick);
			tPauseButton.addEventListener(MouseEvent.CLICK, handleButtonClick);
			tResumeButton.addEventListener(MouseEvent.CLICK, handleButtonClick);
		}

		/**
		 *	
		 */
		private function handleButtonClick(e : MouseEvent) : void {
			switch (e.target) {
				case tStartButton:
					// play new video
					mVideo.setSourceURL(URL);
					mVideo.play();
					break;
				case tPauseButton:
					mVideo.pause();
					break;
				case tResumeButton:
					mVideo.resume();
					break;
			}
		}

		/**
		 *
		 */
		private function handleMediaEvent(e : MediaEvent) : void {
			switch (e.subtype) {
				case MediaEvent.METADATA:
					showMetaData();
					break;
			}
		}

		/**
		 *	use meta data
		 */
		private function showMetaData() : void {
			// get meta data from video
			var md : VideoMetaData = mVideo.getMetaData();
			// add information to textfield
			tBody.text = "Video metadata: duration = " + Math.round(md.duration) + " sec, width = " + md.width + " px, height = " + md.height + " px";
		}

		/**
		 *	
		 */
		override public function toString() : String {
			return "com.lostboys.VideoController";
		}
	}
}