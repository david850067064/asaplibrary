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
 /**
  * Facilitates the creation of multi-language Flash movies, by semi-automatically "feeding" strings from localized XML files into text containers. See {@link LanguageManager} for usage details.
  */
package org.asaplibrary.management.lang {
	/**
	Interface to be implemented by any class that wishes to add itself to the LanguageManager.
	This interface provides two functions that the LanguageManager expects.
	 */
	public interface IMultiLanguageTextContainer {
		/**
		 * Set the data for the container
		 * @param inData: the object containing the data
		 */
		function setData(inData : TextItemData) : void;

		/**
		 * Set the text for the container
		 * Utility function, not used by the LanguageManager
		 * @param inText: the string containing the text
		 * @param inIsHTML: if true, text is rendered as HTML, otherwise directly
		 */
		function setText(inText : String, inIsHTML : Boolean = true) : void;
	}
}
