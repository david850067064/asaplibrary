/*
Copyright 2007-2011 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

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
package org.asaplibrary.management.movie {
	import flash.events.IEventDispatcher;

	/**
	Interface for the LocalController class. See {@link LocalController} for details.
	 */
	public interface ILocalController extends IEventDispatcher {
		function startMovie() : void;

		function stopMovie() : void;

		function die() : void;

		function getName() : String;

		function setName(inName : String) : void;

		function isStandalone() : Boolean;
	}
}
