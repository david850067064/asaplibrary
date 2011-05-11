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
package org.asaplibrary.ui.video {
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * extends Netstream class so we can listen to Netstream events using eventListeners
	 */
	public class CustomNetStream extends NetStream {
		public var onMetaData : Function;
		public var onCuePoint : Function;

		public function CustomNetStream(nc : NetConnection) {
			onMetaData = metaDataHandler;
			onCuePoint = cuePointHandler;
			super(nc);
		}

		/**
		 * 	metadate is dispatched when Flash Player receives descriptive information embedded in the video being played
		 */
		private function metaDataHandler(infoObject : Object) : void {
			dispatchEvent(new CustomNetStreamEvent(CustomNetStreamEvent.METADATA, infoObject));
		}

		/**
		 *	cuepoint data is dispatched when an embedded cue point is reached while playing a video file 
		 */
		private function cuePointHandler(infoObject : Object) : void {
			dispatchEvent(new CustomNetStreamEvent(CustomNetStreamEvent.CUEPOINT, infoObject));
		}

		/**
		 *	
		 */
		override public function toString() : String {
			return "com.lostboys.ui.video.CustomNetStream";
		}
	}
}
