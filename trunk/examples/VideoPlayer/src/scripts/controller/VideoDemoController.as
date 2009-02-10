/*
Copyright 2009 by the authors of asaplibrary, http://asaplibrary.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controller {
	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.ui.buttons.HilightButton;
	import org.asaplibrary.ui.video.VideoMetaData;
	import org.asaplibrary.ui.video.VideoPlayer;
	import org.asaplibrary.util.media.MediaEvent;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;	
	/**
	 * simple controller to demonstrate use of VideoPlayer
	 */
	public class VideoDemoController extends LocalController {
		
		public var tBody : TextField;
		public var tStartButton : HilightButton;
		public var tPauseButton : HilightButton;
		public var tResumeButton : HilightButton;
		
		private var mVideo : VideoPlayer;

		public function VideoDemoController() {
			super();
			
			initUI();
		}
		
		private function initUI() : void {
			// create videoplayer
			mVideo = new VideoPlayer(426, 240);
			// add videoplayer to displaylist
			addChild(mVideo);
			// position videoplayer
			mVideo.x = 18;
			mVideo.y = 100;
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
					mVideo.setSourceURL("../flv/trailer_big_buck_bunny.flv");
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
		private function showMetaData () : void {
			// get meta data from video
			var md : VideoMetaData = mVideo.getMetaData();
			// add information to textfield
			tBody.text = "Video metadata: duration = " + Math.round(md.duration) + " sec, width = " + md.width  + " px, height = " + md.height + " px";
		}

		/**
		*	
		*/
		override public function toString() : String {
			return "com.lostboys.VideoController";
		}
	}
}