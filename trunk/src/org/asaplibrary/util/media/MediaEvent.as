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
package org.asaplibrary.util.media {
	import org.asaplibrary.ui.video.VideoMetaData;

	import flash.events.Event;

	public class MediaEvent extends Event {
		/** Generic event type */
		public static const _EVENT : String = "mediaEvent";
		/** Event sent when player status has changed */
		public static const STATUS_CHANGE : String = "onStatusChange";
		/** Event sent when the player starts playing video */
		public static const PLAY_STARTED : String = "onPlayStarted";
		/** Event sent when the video stopped at the end */
		public static const PLAY_FINISHED : String = "onPlayFinished";
		public static const BUFFER_EMPTY : String = "onBufferEmpty";
		public static const BUFFER_FLUSH : String = "onBufferFlush";
		public static const CUEPOINT : String = "onCuePoint";
		public static const METADATA : String = "onMetaData";
		public static const MEDIA_NOT_FOUND : String = "onMediaNotFound";
		public static const SECURITY_ERROR : String = "onSecurityError";
		public static const SEEK_INVALID : String = "onSeekInvalid";
		// extra streaming events
		public static const STREAM_NOTFOUND : String = "onStreamNotFound";
		public static const CONNECTION_ERROR : String = "onConnectionError";
		public static const CONNECTION_FULL : String = "onConnectionFull";
		/** specific type of event */
		public var subtype : String;
		/** status of media player */
		public var status : String;
		/** metadata in case of subtype METADATA */
		public var metadata : VideoMetaData;

		public function MediaEvent(inSubtype : String, inStatus : String = null, inMetaData : VideoMetaData = null) {
			super(_EVENT);

			subtype = inSubtype;
			status = inStatus;
			metadata = inMetaData;
		}

		override public function clone() : Event {
			return new MediaEvent(subtype, status, metadata);
		}
	}
}
