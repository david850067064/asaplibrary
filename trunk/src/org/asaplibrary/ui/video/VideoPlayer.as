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
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.media.IControllable;
	import org.asaplibrary.util.media.IHasMediaProgress;
	import org.asaplibrary.util.media.MediaEvent;
	import org.asaplibrary.util.media.MediaStatus;
	import org.asaplibrary.util.progress.ProgressDelegate;

	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getQualifiedClassName;

	/**
	Creates a new Video instance to play progressive flash video files (flv)
	 
	note: this class cannot play streaming video files
	
	example code:
	<code>
	// create videoplayer
	var video:VideoPlayer = new VideoPlayer(320, 240);
	// add videoplayer to stage or displaylist
	addChild(video);
	// position videoplayer
	video.x = 20;
	video.y = 20;
	// set source url
	video.setSourceURL(url)
	// start playing the video
	video.play();
	</code> 
	 */
	public class VideoPlayer extends Sprite implements IHasMediaProgress, IControllable {
		protected var mNetStream : NetStream;
		protected var mNetConnection : NetConnection;
		protected var mVideo : Video;
		protected var mMetaData : VideoMetaData;
		protected var mCuePoint : VideoCuePoint;
		protected var mVideoPath : String;
		protected var mStatus : String;
		protected var mDuration : Number;
		protected var mBufferIsEmpty : Boolean;
		protected var mLoadProgressDelegate : ProgressDelegate;
		protected var mPlayProgressDelegate : ProgressDelegate;

		/**
		 * Constructor
		 * @param inWidth: display width of the video
		 * @param inHeight: display height of the video
		 * @param inSmooth: if true, video will be smoothed; can be a performance hit
		 */
		public function VideoPlayer(inWidth : Number, inHeight : Number, inSmooth : Boolean = true) {
			// create net connection
			mNetConnection = new NetConnection();
			mNetConnection.connect(null);

			// create netstream
			mNetStream = new CustomNetStream(mNetConnection);
			mNetStream.checkPolicyFile = true;

			mNetStream.addEventListener(CustomNetStreamEvent._EVENT, handleCustomNetStreamEvent);
			mNetStream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			mNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
			mNetStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			mNetStream.bufferTime = 10;

			// create actual video
			mVideo = new Video(inWidth, inHeight);
			mVideo.deblocking = VideoDeblocking.AUTO;
			mVideo.smoothing = inSmooth;
			mVideo.attachNetStream(mNetStream);
			resizeVideo(inWidth, inHeight);
			addChild(mVideo);

			// create progress delegates
			mLoadProgressDelegate = new ProgressDelegate(getBytesLoaded, getBytesTotal);
			mPlayProgressDelegate = new ProgressDelegate(getPositionInMS, getDurationInMS);
		}

		/**
		 * Set visibility of video on true - doesn't start playing the video
		 */
		public function show() : void {
			visible = true;
		}

		/**
		 * Set visibility of video on false & stop the video
		 */
		public function hide() : void {
			stop();

			visible = false;
		}

		/**
		 * Set the url for the video
		 */
		public function setSourceURL(inURL : String) : void {
			mVideo.clear();

			mVideoPath = inURL;
		}

		/**
		 *	Set the number of seconds to buffer before play starts. Default value is 10 seconds.
		 *	NB: This must be lower than the length of the whole video, otherwise the MediaEvent.PLAY_STARTED event will never be fired.
		 */
		public function setBufferTime(inSeconds : Number) : void {
			mNetStream.bufferTime = inSeconds;
		}

		/**
		 * 	start movie from beginning
		 */
		public function play() : void {
			mNetStream.play(mVideoPath);

			mLoadProgressDelegate.start();
			mPlayProgressDelegate.start();
		}

		/**
		 * Pause the video
		 */
		public function pause() : void {
			mNetStream.pause();

			setStatus(MediaStatus.PAUSED);

			mPlayProgressDelegate.stop();
		}

		/**
		 * Resume the video after pause
		 */
		public function resume() : void {
			mNetStream.resume();

			setStatus(MediaStatus.PLAYING);

			mPlayProgressDelegate.start();
		}

		/**
		 * Stop the video
		 */
		public function stop() : void {
			mNetStream.pause();
			mNetStream.close();

			setStatus(MediaStatus.STOPPED);

			mPlayProgressDelegate.stop();
		}

		/**
		 *	Change video size
		 */
		public function resizeVideo(inWidth : Number, inHeight : Number) : void {
			mVideo.width = inWidth;
			mVideo.height = inHeight;
		}

		/**
		 *	The loading progress of the movie.
		 */
		public function getBytesLoaded() : uint {
			return mNetStream.bytesLoaded;
		}

		/**
		 *	The total size of the movie.
		 */
		public function getBytesTotal() : uint {
			return mNetStream.bytesTotal;
		}

		/**
		 *	Returns metadata of loaded movie
		 */
		public function getMetaData() : VideoMetaData {
			return mMetaData;
		}

		/**
		 *	Returns most recent cuepoint
		 */
		public function getCurrentCuePoint() : VideoCuePoint {
			return mCuePoint;
		}

		/**
		 *	Set volume between 0 and 1
		 */
		public function setVolume(inVolume : Number) : void {
			mNetStream.soundTransform = new SoundTransform(inVolume);
		}

		/**
		 *	@return the current video sound volume
		 */
		public function getVolume() : Number {
			return mNetStream.soundTransform.volume;
		}

		/**
		 *	@return videoplayer status	
		 */
		public function getStatus() : String {
			return mStatus;
		}

		/**
		 * Add a handler for loading progress
		 * @param inHandler: function that handles events of type ProgressEvent
		 */
		public function addLoadProgressHandler(inHandler : Function) : void {
			mLoadProgressDelegate.addProgressHandler(inHandler);
		}

		/**
		 * Add a handler for play progress
		 * @param inHandler: function that handles events of type ProgressEvent
		 */
		public function addPlayProgressHandler(inHandler : Function) : void {
			mPlayProgressDelegate.addProgressHandler(inHandler);
		}

		/**
		 * Add a handler for MediaEvent type events
		 * @param inHandler: function that handles events of type MediaEvent
		 */
		public function addMediaEventHandler(inHandler : Function) : void {
			addEventListener(MediaEvent._EVENT, inHandler);
		}

		/**
		 * Remove previously added handler for ProgressEvent type events for loading 
		 */
		public function removeLoadProgressHandler(inHandler : Function) : void {
			mLoadProgressDelegate.removeProgressHandler(inHandler);
		}

		/**
		 * Remove previously added handler for ProgressEvent type events for playing
		 */
		public function removePlayProgressHandler(inHandler : Function) : void {
			mPlayProgressDelegate.removeProgressHandler(inHandler);
		}

		/**
		 * Remove previously added handler for MediaEvent type events
		 */
		public function removeMediaEventHandler(inHandler : Function) : void {
			removeEventListener(MediaEvent._EVENT, inHandler);
		}

		/**
		 * Does nothing
		 */
		public function goNext() : void {
		}

		/**
		 * Does nothing
		 */
		public function goPrev() : void {
		}

		/**
		 * Go to beginning of video
		 */
		public function goStart() : void {
			setPosition(0);
		}

		/**
		 * Go to end of video
		 */
		public function goEnd() : void {
			setPosition(mDuration);
		}

		/**
		 * @return the current play position in seconds
		 */
		public function getPosition() : Number {
			return mNetStream.time;
		}

		/**
		 * Go to specified play position
		 * @param inSeconds: new position in seconds 
		 */
		public function setPosition(inSeconds : Number) : void {
			if (inSeconds >= 0 && inSeconds < mDuration) {
				mNetStream.seek(inSeconds);
			} else {
				dispatchEvent(new MediaEvent(MediaEvent.SEEK_INVALID));
			}
		}

		/**
		 * @return the duration of the video in seconds
		 */
		public function getDuration() : Number {
			return mDuration;
		}

		/**
		 * @return the current play position in milliseconds
		 */
		protected function getPositionInMS() : uint {
			return 1000 * getPosition();
		}

		/**
		 * @return the duration of the video in milliseconds
		 */
		protected function getDurationInMS() : uint {
			return 1000 * mDuration;
		}

		/**
		 * Set the status & dispatch a status change event
		 */
		protected function setStatus(inStatus : String) : void {
			mStatus = inStatus;
			dispatchEvent(new MediaEvent(MediaEvent.STATUS_CHANGE, mStatus));
		}

		/**
		 *	Flash Player dispatches NetStatusEvent objects when NetStream reports its status
		 */
		protected function handleNetStatusEvent(event : NetStatusEvent) : void {
			switch (event.info.code) {
				case "NetStream.Buffer.Empty":
					mBufferIsEmpty = true;
					dispatchEvent(new MediaEvent(MediaEvent.BUFFER_EMPTY));
					if (mStatus == MediaStatus.STOPPED) {
						dispatchEvent(new MediaEvent(MediaEvent.PLAY_FINISHED));
					}
					break;
				case "NetStream.Buffer.Full":
					mBufferIsEmpty = false;
					dispatchEvent(new MediaEvent(MediaEvent.PLAY_STARTED));
					break;
				case "NetStream.Play.Start":
					setStatus(MediaStatus.PLAYING);
					break;
				case "NetStream.Play.Stop":
					setStatus(MediaStatus.STOPPED);
					mPlayProgressDelegate.stop();
					if (mBufferIsEmpty) dispatchEvent(new MediaEvent(MediaEvent.PLAY_FINISHED));
					break;
				case "NetStream.Play.StreamNotFound":
					Log.error("handleNetStatusEvent: NetStream.Play.StreamNotFound", toString());
					dispatchEvent(new MediaEvent(MediaEvent.MEDIA_NOT_FOUND));
					mPlayProgressDelegate.stop();
					mLoadProgressDelegate.stop();
					break;
			}
		}

		/**
		 *	Flash Player dispatches an AsyncErrorEvent when an exception is thrown from native asynchronous code 
		 */
		protected function handleAsyncError(event : AsyncErrorEvent) : void {
			Log.error("handleAsyncError: " + event.text, toString());

			mPlayProgressDelegate.stop();
			mLoadProgressDelegate.stop();
		}

		/**
		 *	Flash Player dispatches SecurityErrorEvent objects to report the occurrence of a security error
		 */
		protected function handleSecurityError(event : SecurityErrorEvent) : void {
			Log.error("handleSecurityError: " + event.text, toString());

			dispatchEvent(new MediaEvent(MediaEvent.SECURITY_ERROR));

			mPlayProgressDelegate.stop();
			mLoadProgressDelegate.stop();
		}

		/**
		 *	Handler for metadata & cuepoints events from the NetStream object.
		 */
		protected function handleCustomNetStreamEvent(e : CustomNetStreamEvent) : void {
			switch (e.subtype) {
				case CustomNetStreamEvent.METADATA:
					// store data
					mMetaData = new VideoMetaData(e.data);
					// store duration
					mDuration = mMetaData.duration;
					dispatchEvent(new MediaEvent(MediaEvent.METADATA, null, mMetaData));
				case CustomNetStreamEvent.CUEPOINT:
					// store cuepoint
					mCuePoint = new VideoCuePoint(e.data);
					dispatchEvent(new MediaEvent(MediaEvent.CUEPOINT));
			}
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
