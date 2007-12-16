/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
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
Basic implementation of {@link IMultiLanguageTextContainer} to be used with the {@link LanguageManager} to provide language dependent texts in an application.
To use this class, perform the following steps:
<ol>
<li>Create a new movieclip in the library</li>
<li>Give it a significant name containing font information, p.e. "arial 11px center"; this allows for easy reuse of containers</li>
<li>Link it to the class org.asaplibrary.management.lang.MultiLanguageTextContainer</li>
<li>Inside the movieclip, create a dynamic textfield. Name it "tf_txt"</li>
<li>Set font embedding as necessary</li>
<li>Place instances of the library item on the stage where necessary.</li>
<li>Name the instances whatever you like, as long as the name ends with underscore, followed by the integer id of the text to be associated with the instance. P.e.: "helloWorld_1"</li>
<li>In your application, load an xml file containing texts into the LanguageManager: <code>LanguageManager.getInstance().loadXML("texts_en.xml");</code></li>
</ol>
This class can be used either
<ul><li>directly,</li>
<li>as base class for further extension or </li>
<li>as example of how to implement the {@link IMultiLanguageTextContainer} interface.</li></ul>
 */

package org.asaplibrary.management.lang {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class MultiLanguageTextContainer extends MovieClip implements IMultiLanguageTextContainer {
		public var tf_txt : TextField;
		
		
		public function MultiLanguageTextContainer () {
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
		
		/**
		 * IMultiLanguageTextContainer implementation
		 * Set the data for the container
		 * @param inData: the object containing the data
		 */
		public function setData (inData : TextItemData) : void {
			setText(inData.text, inData.isHTML);
		}
		
		/**
		 * IMultiLanguageTextContainer implementation
		 * Set the text for the container
		 * @param inText: the string containing the text
		 * @param inIsHTML: if true, text is rendered as HTML, otherwise directly
		 */
		public function setText (inText : String, inIsHTML : Boolean = true) : void {
			if (inIsHTML) tf_txt.htmlText = inText;
			else tf_txt.text = inText;
		}
		
		/**
		 * Handle internal event that instance has been added to the stage
		 * @param	e
		 */
		private function handleAdded (e : Event) : void {
			var id : String = name.substring(name.lastIndexOf("_") + 1);

			LanguageManager.getInstance().addContainer(id, this);
		}
		
		/**
		 * Handle internal event that instance has been removed from the stage
		 * @param	e
		 */
		private function handleRemoved (e : Event) : void {
			LanguageManager.getInstance().removeContainer(this);
		}
		
		override public function toString () : String {
			return ";org.asaplibrary.management.lang.MultiLanguageTextContainer";
		}
	}
}
