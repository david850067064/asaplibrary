/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org

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
package org.asaplibrary.util.sound {
	import org.asaplibrary.ui.form.components.ISelectable;
	import org.asaplibrary.util.debug.Log;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;

	/**
	 * Class for managing sounds in an application.
	 * @example
	 * Add a sound in the library as follows:<code>
	var name:String = "linkageIDOfSoundInLibrary";
	SoundManager.getInstance().addSound(new (getDefinitionByName(name)) as Sound, name);
	</code>
	Then play the sound as follows:
	<code>
	SoundManager.getInstance().playSound(name);
	</code>
	 * Sounds can be added only once for a particular name, so make sure they are removed with <code>removeSound(name)</code> when a swf containing sounds is removed.
	 * External sounds (mp3's on the file system or server) can be added to the list of available sounds with <code>addExternalSound()</code>, after which they can be played and controlled by name. They can also be played directly with <code>playExternalSound()</code>, which is meant for external sounds that need less control.
	 * Sounds that are currently being played, or present in the list, can be muted and unmuted with <code>muteAllSounds()</code> and <code>unmuteAllSounds()</code>. Muting is also applied to sounds that are started after mute is set. These sounds will start normally, but will not be audible if muting is applied.
	 * The overall sound volume can be set with <code>setOverallVolume()</code>. This multiplies the volume of individual sounds with the overall volume value.
	 */
	public class SoundManager extends EventDispatcher {
		/* Singleton implementation */
		private static const theInstance : SoundManager = new SoundManager();

		public static function getInstance() : SoundManager {
			return theInstance;
		}

		private static var COOKIENAME_MUTESTATE : String = "muteState";
		/** 
		 * If true, an error is logged when a sound is not found for playing, stopping, setting volume etc. 
		 * Errors for adding sounds, or load errors, are always logged.
		 */
		public static var doShowErrors : Boolean = true;
		private var mOverallVolume : Number = 1;
		private var mMuteSwitch : ISelectable;
		private var mIsMuted : Boolean;
		private var mSounds : Object = new Object();
		private var mMuteCookie : SharedObject;

		public function SoundManager() {
			if (theInstance) throw new Error("Singleton, use getInstance()");

			mMuteCookie = SharedObject.getLocal(COOKIENAME_MUTESTATE);
			try {
				mIsMuted = mMuteCookie.data.mute;
			} catch (e : Error) {
			}
		}

		/**
		 *	Add a sound for specified name.
		 *	@param inSound: Sound object to add
		 *	@param inName: unique identifier for sound
		 */
		public function addSound(inSound : Sound, inName : String) : void {
			if (mSounds[inName]) {
				Log.error("addSound: sound with name '" + inName + "' already exists", toString());
				return;
			}

			mSounds[inName] = new SoundData(inSound, inName);
		}

		/**
		 *	Add an external sound for specified name.
		 *	@param inURL: url of sound to be added
		 *	@param inName: unique identifier for sound
		 *	@param inStartLoad: when true, the sound starts loading immediately
		 *	@param inStartPlay: when true, the sound starts playing when enough data has been loaded
		 */
		public function addExternalSound(inURL : String, inName : String, inStartLoad : Boolean = false, inStartPlay : Boolean = false) : void {
			if (mSounds[inName]) {
				Log.error("addSound: sound with name '" + inName + "' already exists", toString());
				return;
			}

			var sound : Sound = new Sound();
			sound.addEventListener(Event.COMPLETE, handleSoundLoaded);
			sound.addEventListener(IOErrorEvent.IO_ERROR, handleSoundLoadError);

			var sd : SoundData = new SoundData(sound, inName);
			sd.url = inURL;
			sd.isExternal = true;

			mSounds[inName] = sd;

			if (inStartLoad || inStartPlay) {
				sd.sound.load(new URLRequest(inURL));
				sd.isLoading = true;
			}

			if (inStartPlay) playSound(inName);
		}

		/**
		 * Play sound with specified name; if the sound is already playing, it is stopped to prevent stacking.
		 * @param inName: unique identifier of previously added sound
		 * @param inLoop: if true, the sound is looped
		 * @param inPlayCount: number of times to play the sound; ignored if inLoop == true
		 */
		public function playSound(inName : String, inLoop : Boolean = false, inPlayCount : int = 1) : void {
			stopSound(inName);

			var sd : SoundData = getSoundDataByName(inName);
			if (!sd) return;

			if (sd.isExternal) {
				if (!sd.isLoaded && !sd.isLoading) sd.sound.load(new URLRequest(sd.url));
			}

			sd.isLooping = inLoop;
			sd.channel = sd.sound.play(0, inLoop ? 999 : inPlayCount - 1);

			setVolume(sd, sd.volume);

			if (sd.channel) sd.channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
		}

		/**
		 * Play an external sound without explicit name - inURL is defined as name for sound; if a sound with specified url is already playing, it is stopped and removed.
		 * @param inURL: url of sound to be played
		 * @param inLoop: if true, sound will be looped indefinitely
		 * @param inVolume: value for sound volume
		 */
		public function playExternalSound(inURL : String, inLoop : Boolean = false, inVolume : Number = 1) : void {
			removeSound(inURL);

			addExternalSound(inURL, inURL, true);
			playSound(inURL, inLoop);
			setSoundVolume(inURL, inVolume);
		}

		/**
		 *	Stop sound with specified name.
		 *	@param inName: unique identifier of previously added sound
		 */
		public function stopSound(inName : String) : void {
			var sd : SoundData = getSoundDataByName(inName);
			if (sd && sd.channel) sd.channel.stop();
		}

		/**
		 *	Set volume of sound with specified name.
		 *	@param inName: unique identifier of previously added sound
		 *	@param inVolume: volume of sound (0 < inVolume < 1)
		 */
		public function setSoundVolume(inName : String, inVolume : Number) : void {
			var sd : SoundData = getSoundDataByName(inName);
			if (!sd) return;

			sd.volume = inVolume;
			setVolume(sd, inVolume);
		}

		/**
		 * Set multiplication factor for all sounds. Normally this would fall in the range 0 < inVolume < 1.
		 */
		public function setOverallVolume(inVolume : Number) : void {
			mOverallVolume = inVolume;

			updateAllVolumes();
		}

		/**
		 *	Mute all sounds that have been added to the SoundManager.
		 */
		public function muteAllSounds() : void {
			mIsMuted = true;

			updateMuteCookie();

			updateAllVolumes();
		}

		/**
		 *	Unmute all sounds that have been added to the SoundManager.
		 */
		public function unmuteAllSounds() : void {
			mIsMuted = false;

			updateMuteCookie();

			updateAllVolumes();
		}

		/**
		 * Remove sound with specified name.
		 * @param inName: unique identifier of previously added sound
		 */
		public function removeSound(inName : String) : void {
			var sd : SoundData = getSoundDataByName(inName);
			if (!sd) return;

			if (sd.channel) {
				sd.channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				sd.channel.stop();
			}
			sd.sound.removeEventListener(Event.COMPLETE, handleSoundLoaded);
			sd.sound.removeEventListener(IOErrorEvent.IO_ERROR, handleSoundLoadError);

			mSounds[inName] = null;
		}

		/**
		 * Set mute switch; any class that implements ISelectable can be used for this. The state of the switch is updated according to the current mute state.
		 */
		public function setMuteSwitch(inSwitch : ISelectable) : void {
			mMuteSwitch = inSwitch;
			mMuteSwitch.addEventListener(MouseEvent.CLICK, toggleMute);

			mMuteSwitch.setSelected(mIsMuted);
		}

		/**
		 * @param inSoundName the name of the added sound 
		 * @param inPanning The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right).
		 *
		 *	Thanks to Jankees van Woezik (hhtp://www.base24.nl)
		 */
		public function setPan(inSoundName : String, inPanning : Number) : void {
			var sd : SoundData = getSoundDataByName(inSoundName);
			if (!sd) return;
			try {
				var transform : SoundTransform = sd.channel.soundTransform;
				transform.pan = inPanning;
				sd.channel.soundTransform = transform;
			} catch (e : Error) {
				Log .error("setPan error: " + e.message, toString());
			}
		}

		/**
		 * Handle event from mute switch to set mute state according to switch state.
		 */
		private function toggleMute(e : Event) : void {
			if ((e.target as ISelectable).isSelected()) muteAllSounds();
			else unmuteAllSounds();
		}

		/**
		 * Set volumes of all sounds again. The function setVolume() takes care of muting and overall volume.
		 */
		private function updateAllVolumes() : void {
			for each (var sd:SoundData in mSounds) setVolume(sd, sd.volume);
		}

		/**
		 * Set volume of sound specified by SoundData object; if mIsMuted == true, the volume is set to 0, otherwise it's set to the specified value multiplied with the overall value.
		 */
		private function setVolume(inSD : SoundData, inVolume : Number) : void {
			if (!inSD.channel) return;

			var st : SoundTransform = inSD.channel.soundTransform;
			st.volume = mIsMuted ? 0 : inVolume * mOverallVolume;
			inSD.channel.soundTransform = st;
		}

		/**
		 * Handle event sent by an external sound that is loaded, that load is complete.
		 */
		private function handleSoundLoaded(e : Event) : void {
			var sd : SoundData = getSoundDataBySound(e.target as Sound);
			if (!sd) return;

			sd.isLoaded = true;
			sd.isLoading = false;

			dispatchEvent(new SoundEvent(Event.COMPLETE, sd.name));
		}

		/**
		 * Handle event sent by a looping sound channel that the loop is done.
		 */
		private function handleSoundComplete(e : Event) : void {
			var sd : SoundData = getSoundDataByChannel(e.target as SoundChannel);
			if (!sd) return;

			sd.channel = null;

			if (sd.isLooping) {
				playSound(sd.name, true);
				setVolume(sd, sd.volume);
			} else {
				dispatchEvent(new SoundEvent(Event.SOUND_COMPLETE, sd.name));
			}
		}

		/**
		 * Handle event sent by a loading sound that an error has occurred.
		 */
		private function handleSoundLoadError(e : Event) : void {
			var sd : SoundData = getSoundDataBySound(e.target as Sound);
			Log.error("Error loading sound with name '" + sd.name + "' from '" + sd.url + "'", toString());
		}

		/**
		 * Get sound data for specified channel.
		 */
		private function getSoundDataByChannel(inChannel : SoundChannel) : SoundData {
			for each (var sd:SoundData in mSounds) if (sd.channel == inChannel) return sd;

			return null;
		}

		/**
		 * Get sound data for specified sound.
		 */
		private function getSoundDataBySound(inSound : Sound) : SoundData {
			for each (var sd:SoundData in mSounds) if (sd.sound == inSound) return sd;

			return null;
		}

		/**
		 * Get sound data for specified name.
		 */
		private function getSoundDataByName(inName : String) : SoundData {
			if (!mSounds[inName]) {
				if (doShowErrors) Log.error("sound with name '" + inName + "' not found", toString());
				return null;
			}
			return mSounds[inName] as SoundData;
		}

		private function updateMuteCookie() : void {
			mMuteCookie.data.mute = mIsMuted;
			mMuteCookie.flush();
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import flash.media.Sound;
import flash.media.SoundChannel;

class SoundData {
	public var name : String;
	public var url : String;
	public var sound : Sound;
	public var channel : SoundChannel;
	public var volume : Number = 1;
	public var isLooping : Boolean = false;
	public var isExternal : Boolean = false;
	public var isLoaded : Boolean = false;
	public var isLoading : Boolean = false;

	public function SoundData(inSound : Sound, inName : String) {
		sound = inSound;
		name = inName;
	}
}
