package demo.LanguageManager.controller {
	import org.asaplibrary.management.lang.LanguageManager;
	import org.asaplibrary.management.lang.MultiLanguageTextContainer;
	import org.asaplibrary.ui.buttons.HilightButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author stephan.bezoen
	 * @author Arthur Clemens
	 */
	public class AppController extends MovieClip {
		/** part of the url to be replaced by the language code */
		private const CODE_DELIMITER : String = "#code#";
		/** base url for language dependent texts */
		private const URL_TEXTS : String = "xml/texts_" + CODE_DELIMITER + ".xml";
		/** language codes */
		private const CODE_ENGLISH : String = "en";
		private const CODE_GERMAN : String = "de";
		private const CODE_FRENCH : String = "fr";
		public var btn_en : HilightButton;
		public var btn_fr : HilightButton;
		public var btn_de : HilightButton;
		public var change_btn : HilightButton;
		public var text_10 : MultiLanguageTextContainer;
		public var text_11 : MultiLanguageTextContainer;
		private var mButtons : Array;

		public function AppController() {
			super();

			// get all the buttons
			mButtons = [btn_en, btn_fr, btn_de, change_btn];
			var len : Number = mButtons.length;
			for (var i : Number = 0; i < len; i++) {
				HilightButton(mButtons[i]).addEventListener(MouseEvent.CLICK, handleButtonUpdate);
			}
			setButtonVisibility(false);

			// get the language manager, listen to events
			var lm : LanguageManager = LanguageManager.getInstance();
			lm.addEventListener(LanguageManager.EVENT_LOADED, handleLanguageLoaded);

			// make the text fields without assigned text show their id
			lm.generateDebugText = true;

			// load the English texts
			loadTexts(CODE_ENGLISH);
		}

		/**
		 *	Handle event from the LanguageManager that texts have been loaded
		 */
		private function handleLanguageLoaded(e : Event) : void {
			setButtonVisibility(true);
		}

		/**
		 *	Show or hide all buttons
		 */
		private function setButtonVisibility(inState : Boolean) : void {
			var len : Number = mButtons.length;
			for (var i : Number = 0; i < len; i++) {
				HilightButton(mButtons[i]).visible = inState;
			}
		}

		/**
		 *	
		 */
		private function handleButtonUpdate(e : MouseEvent) : void {
			var target : HilightButton = e.target as HilightButton;
			switch (target.name) {
				case "btn_en":
					loadTexts(CODE_ENGLISH);
					break;
				case "btn_fr":
					loadTexts(CODE_FRENCH);
					break;
				case "btn_de":
					loadTexts(CODE_GERMAN);
					break;
				case "change_btn":
					changeText(text_11, "10");
					break;
			}
		}

		/**
		 *	Load an XML file with language specific texts
		 *	@param inCode: language code
		 */
		private function loadTexts(inCode : String) : void {
			var url : String = URL_TEXTS;
			url = url.split(CODE_DELIMITER).join(inCode);

			LanguageManager.getInstance().loadXML(url);
		}

		/**
		 *	Change the text of specified text field to the text with the specified id
		 *	@param inField: a textfield container for multilanguage purposes
		 *	@param inNewID: the id of the text to be set
		 */
		private function changeText(inField : MultiLanguageTextContainer, inNewID : String) : void {
			inField.setText(LanguageManager.getInstance().getTextByID(inNewID));
		}
	}
}