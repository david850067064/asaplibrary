package demo.Form.data {
	import org.asaplibrary.data.URLData;
	import org.asaplibrary.data.xml.Parser;
	import org.asaplibrary.data.xml.Service;
	import org.asaplibrary.data.xml.ServiceEvent;
	import org.asaplibrary.util.debug.Log;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author stephan.bezoen
	 */
	public class URLManager extends Service {
		// Singleton implementation
		private static const theInstance : URLManager = new URLManager();

		public function URLManager() {
			if (theInstance) throw new Error("Singleton, use OneStat.getInstance()");
		}

		public static function getInstance() : URLManager {
			return theInstance;
		}

		/** default name for urls.xml */
		private static const XML_URL : String = "urls.xml";
		/** objects of type URLData */
		private var mURLs : Array;

		/**
		 * Load settings from specified url if provided, or from default url
		 * @param inURL: url to load settings from
		 */
		public function loadURLs(inURL : String = null) : void {
			load(new URLData(URLNames.URLS, inURL ? inURL : XML_URL), null, true);
		}

		/**
		 * Get named url data
		 * @param	inName: name of data block
		 * @return	the data block, or null if none was found
		 */
		public static function getURLDataByName(inName : String) : URLData {
			return URLManager.getInstance()._getURLDataByName(inName);
		}

		/**
		 * Get named url 
		 * @param 	inName: name of data block
		 * @return 	url as string or null if none was found
		 */
		public static function getURLByName(inName : String) : String {
			return URLManager.getInstance()._getURLByName(inName);
		}

		/**
		 * Open a browser window for url with specified name
		 */
		public static function openURLByName(inName : String) : void {
			URLManager.getInstance()._openURLByName(inName);
		}

		private function _getURLDataByName(inName : String) : URLData {
			var len : Number = mURLs.length;
			for (var i : Number = 0; i < len; i++) {
				var ud : URLData = URLData(mURLs[i]);
				if (ud.name == inName) return ud;
			}
			Log.error("getURLDataByName: url with name '" + inName + "' not found. Check urls.xml!", toString());
			return null;
		}

		private function _getURLByName(inName : String) : String {
			var len : Number = mURLs.length;
			for (var i : Number = 0; i < len; i++) {
				var ud : URLData = URLData(mURLs[i]);
				if (ud.name == inName) return ud.url;
			}
			Log.error("getURLDataByName: url with name '" + inName + "' not found. Check urls.xml!", toString());
			return null;
		}

		private function _openURLByName(inName : String) : void {
			var ud : URLData = getURLDataByName(inName);
			if (!ud) return;

			try {
				navigateToURL(new URLRequest(ud.url), ud.target);
			} catch (e : Error) {
				Log.error("openURLByName: Error navigating to URL '" + ud.url + "', system says:" + e.message, toString());
			}
		}

		/**
		 * Process loaded XML
		 * @param inData: loaded XML data
		 * @param inName: name of load operation
		 */
		override protected function processData(inData : XML, inName : String) : void {
			// get grouped urls
			var groupedURLs : XMLList = inData.group.(@id == (inData.@currentgroup)).url;
			mURLs = Parser.parseList(groupedURLs, URLData);

			// check if this yielded any urls
			if (!mURLs) mURLs = new Array();

			// add ungrouped urls
			var ungroupedURLs : Array = Parser.parseList(inData.url, URLData);
			if (ungroupedURLs) mURLs = mURLs.concat(ungroupedURLs);

			// send event we're done
			dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, inName));
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
