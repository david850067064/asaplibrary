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
	/**
	 *	cuepoint data is dispatched when an embedded cue point is reached while playing a video file
	 *	this class converts untyped info object into typed data
	 */
	public class VideoCuePoint {
		/** The name given to the cue point when it was embedded in the FLV file */
		public var name : String;
		/** A associative array of name/value pair strings specified for this cue point. */
		public var parameters : Array;
		/** The time in seconds at which the cue point occurred in the video file during playback */
		public var time : Number;
		/** A Boolean value that is true if the FLV file is encoded with a keyframe on the last frame that allows seeking to the end of a progressive download movie clip */
		public var type : Boolean;

		/** The type of cue point that was reached, either navigation or event */
		/**
		 * Constructor.
		 * @param data Object to parse, this should be a raw NetStream.onMetaData data object.   
		 */
		public function VideoCuePoint(inData : Object) {
			name = (inData.name == undefined) ? null : inData.name;
			parameters = inData.parameters;
			time = isNaN(inData.time) ? null : inData.time;
			type = (inData.type == undefined) ? false : inData.type;
		}
	}
}