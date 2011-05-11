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
	import flash.utils.getQualifiedClassName;

	/**
	 *	metadate is dispatched when Flash Player receives descriptive information embedded in the video being played
	 *	this class converts untyped info object into typed data
	 */
	public class VideoMetaData {
		/** A number that indicates the audio codec (code/decode technique) that was used */
		public var audiocodecid : Number;
		/** A number that indicates the rate at which audio was encoded, in kilobytes per second */
		public var audiodatarate : Number;
		/** A number that indicates what time in the FLV file "time 0" of the original FLV file exists */
		public var audiodelay : Number;
		/** A Boolean value that is true if the FLV file is encoded with a keyframe on the last frame that allows seeking to the end of a progressive download movie clip */
		public var canSeekToEnd : Boolean;
		/** A number that specifies the duration of the FLV file, in seconds */
		public var duration : Number;
		/** A number that is the frame rate of the FLV file */
		public var framerate : Number;
		/** A number that is the height of the FLV file, in pixels */
		public var height : Number;
		/** A number that is the codec version that was used to encode the video */
		public var videocodecid : Number;
		/** A number that is the video data rate of the FLV file */
		public var videodatarate : Number;
		/** A number that is the width of the FLV file, in pixels */
		public var width : Number;

		/**
		 * Constructor.
		 * @param data Object to parse, this should be a raw NetStream.onMetaData data object.   
		 */
		public function VideoMetaData(inData : Object) {
			audiocodecid = isNaN(inData.audiocodecid) ? null : inData.audiocodecid;
			audiodatarate = isNaN(inData.audiodatarate) ? null : inData.audiodatarate;
			audiodelay = isNaN(inData.audiodelay) ? null : inData.audiodelay;
			canSeekToEnd = (inData.canSeekToEnd == undefined) ? false : inData.canSeekToEnd;
			duration = isNaN(inData.duration) ? null : inData.duration;
			framerate = isNaN(inData.framerate) ? null : inData.framerate;
			height = isNaN(inData.height) ? null : inData.height;
			videocodecid = (inData.videocodecid == undefined) ? null : inData.videocodecid;
			videodatarate = isNaN(inData.videodatarate) ? null : inData.videodatarate;
			width = isNaN(inData.width) ? null : inData.width;
		}

		public function toString() : String {
			// com.lostboys.ui.video.VideoMetaData
			return getQualifiedClassName(this);
		}
	}
}