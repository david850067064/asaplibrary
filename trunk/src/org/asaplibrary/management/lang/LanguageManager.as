/*
Copyright 2007-2008 by the authors of asaplibrary, http://asaplibrary.org
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
package org.asaplibrary.management.lang {
	import org.asaplibrary.data.xml.*;
	import org.asaplibrary.util.debug.Log;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	Class for managing language dependencies in an application.
	For text, the language dependent texts are expected to be in an xml per language, with the following structure:
	<code>
	<?xml version="1.0" encoding="UTF-8"?>
	<texts>
	<text id="helloWorld">Hello World</text>
	<text id="helloBoldWorld"><![CDATA[<b>Hello</b> World with bold Hello]]></text>
	<text id="helloHTMLWorld" html="false"><![CDATA[<b>Hello</b> World with visible html tags]]></text>
	<text id="helloWorldInBrackets" html="false"><![CDATA[>>>Hello World<<<]]></text>
	</texts>
	</code>
	The 'id' attribute is mandatory, and has to be a String. It cannot contain "_" (underscore).
	The 'html' attribute is optional. If left out, text is rendered as HTML text; any other value than "false" is seen as true. When false, the text is set directly into the text field, and any html tags are ignored.
	In case the text contains xml characters, the text has to be wrapped in a {@code  <![CDATA[[]]>} tag.
	The id is expected to be unique. When it isn't, the last item is taken.
	The xml file containing the language dependent texts has to be loaded with the method {@link #loadXML}. 
	When loaded and parsed, the LanguageManager sends an event of type LanguageManager.EVENT_LOADED. Subscribe to this event if you wish to be notified.
	No event is sent when the loading fails, only a Log message of level ERROR is output.
	Once an xml file has been loaded, data is available by id through {@link #getTextByID} and {@link #getDataByID}. Since the LanguageManager is a Singleton, the language dependent data is available throughout your application.
	However, the LanguageManager also contains a mechanism for automatic assignment of data. To use this functionality, use the provided class {@link MultiLanguageTextContainer}, or write your own implementation of {@link IMultiLanguageTextContainer}.
	When writing your own class, allow for a way to determine the id of the text that is to be used by a specific instance for your class. In case of the MultiLanguageTextContainer class, this id is retrieved from the name of the movieclip instance to which the class is linked, by taking everything after the last underscore and converting to a number. So "myText_1" gets the text with id=1.
	Once the id is known inside your class, add the instance to the LanguageManager with {@link #addContainer}, providing the id and the instance itself as parameters. If data has been loaded, it is provided to the instance immediately. Whenever new data is loaded, the LanguageManager calls "setData" on each instance that was added, thereby updating language dependent text instantaneously.
	A good spot to add an instance to the LanguageManager is when Event.ADDED is received. Make sure to remove it again when Event.REMOVED is received, to allow for proper memory management. This also makes sure that the instance keeps its text when subject to animation key frames.
	Instances can share the same id, and thereby have the same text.
	By default, the LanguageManager returns an empty string (or provides an empty string in the data) when a requested id is not found. 
	This has two drawbacks:
	<ul><li>The textfield becomes effectively invisible since there is no text in it</li>
	<li>Formatting of the textfield (such as weight or alignment) may be lost when the textfield is cleared</li></ul>
	To allow for easier debugging, the flag {@link #generateDebugText} can be set. If an unknown id is requested, the returned text will be ">> id = #id", where #id is replaced with the actually requested id. This makes it easier to find missing texts from the xml files.
	@example
	<ul>
	<li>Loading an xml file into the LanguageManager, specifying a language code to be used in determining the name of the xml file to be loaded.
	<code>
	// @param inCode: 2-letter ISO language code;
	// will be added to filename.
	// Example: with parameter "en" the file "texts_en.xml" will be loaded.
	private function loadLanguage (inCode:String) : void {
	var lm:LanguageManager = LanguageManager.getInstance();
	lm.addEventListener(LanguageManager.EVENT_LOADED, handleLanguageLoaded);
	lm.loadXML("../xml/texts_" + inCode + ".xml");
	}
	private function handleLanguageLoaded () : void {
	Log.debug("handleLanguageLoaded: Language file loaded.", toString());
	}
	</code>
	</li>
	<li>Assigning a text to a textfield manually from anywhere in your code:
	<code>myTextfield.text = LanguageManager.getInstance().getTextByID(23);</code>
	</li>
	<li>A class that gets a random text from the first 10 texts of the LanguageManager each time it is loaded:
	<code>
	class MyText extends MovieClip implements IMultiLanguageTextContainer {
	private var mID:Number;
	private var myTextField:TextField;
	public function MyText () {
	addEventListener(Event.ADDED, handleAdded);
	addEventListener(Event.REMOVED, handleRemoved);
	}
	public function setData (inData : TextItemData) : Void {
	setText(inData.text, inData.isHTML);
	}
	public function setText (inText:String, inIsHTML:Boolean = true) : Void {
	if (inIsHTML) tf_txt.htmlText = inText;
	else tf_txt.text = inText;
	}
	private function handleAdded (e:Event) : Void {
	mID = Math.floor(10 * Math.random());
			
	LanguageManager.getInstance().addContainer(mID, this);
	}
		
	private function handleRemoved (e:Event) : Void {
	LanguageManager.getInstance().removeContainer(this);
	}
	}
	</code>
	</li>
	</ul>
	 */
	public class LanguageManager extends EventDispatcher {
		/** The event sent when the language xml has been loaded and parsed */
		public static const EVENT_LOADED : String = "onLanguageLoaded";
		/** name of XML while loading */
		private static const XML_NAME : String = "languagexml";
		/** objects of type TextItemData */
		private var mTextDataItemMap : Object;
		/** objects of type MultiLanguageContainerData */
		private var mTextContainers : Array;
		private var mXMLLoader : XMLLoader;
		private var mGenerateDebugText : Boolean = false;
		private var mURL : String;
		// singleton instance
		private static var mInstance : LanguageManager = new LanguageManager();

		/**
		@return The singleton instance of the LanguageManager
		 */
		public static function getInstance() : LanguageManager {
			return mInstance;
		}

		/**
		 * Load language XML
		 * @param inURL: full path of the xml file to be loaded
		 */
		public function loadXML(inURL : String) : void {
			mURL = inURL;

			// start loading
			mXMLLoader.loadXML(inURL, LanguageManager.XML_NAME);
		}

		/**
		 * Flag indicates whether items show their id as text when no text is found in the xml. When false, an empty string is returned when no text is found. 
		 */
		public function set generateDebugText(inGenerate : Boolean) : void {
			mGenerateDebugText = inGenerate;
		}

		/**
		 * Add a multi-language container to the LanguageManager.
		 * If data has been loaded, the container will receive its data immediately.
		 * If the container had been added already, it will not be added again.
		 * @param inID: the id to be associated with the container
		 * @param inContainer: instance of a class implementing {@link IMultiLanguageTextContainer}
		 */
		public function addContainer(inID : String, inContainer : IMultiLanguageTextContainer) : void {
			if (getClipDataByContainer(inContainer) == null) {
				var mlcd : MultiLanguageContainerData = new MultiLanguageContainerData(inID, inContainer);
				mTextContainers.push(mlcd);
			}
			inContainer.setData(getDataByID(inID));
		}

		/**
		 * Remove a multi-language container from the LanguageManager
		 * @param inContainer: previously added instance of a class implementing {@link IMultiLanguageTextContainer}
		 */
		public function removeContainer(inContainer : IMultiLanguageTextContainer) : void {
			var index : uint = getClipDataIndexByContainer(inContainer);
			if (!isNaN(index)) {
				mTextContainers.splice(index, 1);
			}
		}

		/**
		 * Add text for a specific ID to the language manager.
		 * Set the text in any IMultiLanguageTextContainer instance associated with that id.
		 * @param inData: {@link TextItemData} instance containing necessary data.
		 */
		public function addText(inData : TextItemData) : void {
			// store item at location of id
			mTextDataItemMap[inData.id] = inData;

			var len : uint = mTextContainers.length;

			for (var i : uint = 0; i < len; ++i) {
				var md : MultiLanguageContainerData = mTextContainers[i] as MultiLanguageContainerData;

				if (md.id == inData.id) {
					md.container.setData(inData);
				}
			}
		}

		/**
		 * Retrieve a text
		 * @param inID: the id for the text to be found
		 * @return the text if found, an empty string if generateDebugText is set to false, or '>> id = ' + id if generateDebugText is set to true
		 */
		public function getTextByID(inID : String) : String {
			return getDataByID(inID).text;
		}

		/**
		 * Retrieve text data
		 * @param inID: the id for the text to be found
		 * @return the text data with the right text if found, with an empty string if generateDebugText is set to false, or with '>> id = ' + id if generateDebugText is set to true
		 */
		public function getDataByID(inID : String) : TextItemData {
			if (!mTextDataItemMap[inID]) {
				if (mGenerateDebugText) {
					return new TextItemData(inID, ">> id = " + inID);
				} else {
					return new TextItemData(inID, "");
				}
			} else {
				return TextItemData(mTextDataItemMap[inID]);
			}
		}

		/**
		 * Find the data block for the specified {@link IMultiLanguageTextContainer} instance
		 * @return the data block for the clip, or null if none was found
		 */
		private function getClipDataByContainer(inContainer : IMultiLanguageTextContainer) : MultiLanguageContainerData {
			var len : uint = mTextContainers.length;
			for (var i : uint = 0; i < len; ++i) {
				var md : MultiLanguageContainerData = mTextContainers[i] as MultiLanguageContainerData;
				if (md.container == inContainer) {
					return md;
				}
			}
			return null;
		}

		/**
		 * Find the index of the data block for the specified {@link IMultiLanguageTextContainer} instance
		 * @return the index of the data block, or NaN if none was found
		 */
		private function getClipDataIndexByContainer(inContainer : IMultiLanguageTextContainer) : uint {
			var len : uint = mTextContainers.length;
			for (var i : uint = 0; i < len; ++i) {
				var md : MultiLanguageContainerData = mTextContainers[i] as MultiLanguageContainerData;
				if (md.container == inContainer) return i;
			}
			return NaN;
		}

		/**
		 * Handle event from XMLLoader
		 * @param	e
		 */
		private function handleXMLLoaded(e : XMLLoaderEvent) : void {
			if (e.name != XML_NAME) return;

			switch (e.subtype) {
				case XMLLoaderEvent.COMPLETE:
					handleLanguageDataLoaded(e);
					break;
				case XMLLoaderEvent.ERROR:
					handleXMLLoadError(e);
					break;
			}
		}

		/**
		 * Handle event from XMLLoader that data has been loaded successfully
		 * @param	e
		 */
		private function handleLanguageDataLoaded(e : XMLLoaderEvent) : void {
			// parse XML into TextItemData objects
			var items : Array = Parser.parseList(e.data.text as XMLList, org.asaplibrary.management.lang.TextItemData);

			// add the items
			var len : uint = items.length;
			for (var i : uint = 0; i < len; i++) {
				addText(items[i]);
			}

			// send event we're done
			dispatchEvent(new Event(EVENT_LOADED));
		}

		/**
		 * Handle event from XMLLoader that there was an error loading the data
		 * @param	e
		 */
		private function handleXMLLoadError(e : XMLLoaderEvent) : void {
			Log.error("Could not load language XML from url " + mURL + ", error = " + e.error, toString());
		}

		/**
		 * singleton constructor. Do not use externally.
		 */
		public function LanguageManager() {
			// check if constructor was called internally
			if (mInstance) throw new Error("Do not use the constructor of this class!" + toString());

			mXMLLoader = new XMLLoader();
			mXMLLoader.addEventListener(XMLLoaderEvent._EVENT, handleXMLLoaded);

			mTextDataItemMap = new Object();
			mTextContainers = new Array();
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
import org.asaplibrary.management.lang.IMultiLanguageTextContainer;

/**
Helper class for storing information about IMultiLanguageTextContainer vs. ID
 */
class MultiLanguageContainerData {
	public var id : String;
	public var container : IMultiLanguageTextContainer;

	/**
	Constructor
	@param inID: the id of the text assigned to the container
	@param inContainer: instance of a class implementing {@link IMultiLanguageTextContainer}
	 */
	public function MultiLanguageContainerData(inID : String, inContainer : IMultiLanguageTextContainer) {
		id = inID;
		container = inContainer;
	}
}