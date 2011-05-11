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
	import flash.events.IEventDispatcher;

	/**
	 * @author Stephan Bezoen
	 * 
	 * Interface to be implemented by classes that can be controlled by a media control bar 
	 */
	public interface IControllable extends IEventDispatcher {
		function play() : void;

		function stop() : void;

		function pause() : void;

		function resume() : void;

		function goNext() : void;

		function goPrev() : void;

		function goStart() : void;

		function goEnd() : void;

		function getPosition() : Number;

		function setPosition(inPosition : Number) : void;

		function getDuration() : Number;

		function setVolume(inVolume : Number) : void;

		function getStatus() : String;

		function addMediaEventHandler(inHandler : Function) : void;

		function removeMediaEventHandler(inHandler : Function) : void;
	}
}
