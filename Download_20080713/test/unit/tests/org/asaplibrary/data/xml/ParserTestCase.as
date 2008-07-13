/**
@todo:
Parser.parseXML
*/

package org.asaplibrary.data.xml {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.xml.Parser;
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.util.FrameDelay;
	import org.asaplibrary.data.URLData;
	
	public class ParserTestCase extends TestCase {

		private var mURLs:Array;
		
		public function testParse () : void {
			var xml:XML = <settings>
							<urls>
								<url name="addressform" url="../xml/address.xml" />
								<url name="entries" url="../xml/entries.xml" />
							</urls>
						  </settings>
			assertTrue("testParse", handleSettingsLoaded(xml) != false);
		}
		
		// parse XML
		// @param o: XML
		// @return true if parsing went ok, otherwise false
		private function handleSettingsLoaded (inXml:XML) : Boolean {
			var xmlList:XMLList = XMLList(inXml);
			mURLs = Parser.parseList(xmlList.urls.url, URLData, false);
			return (mURLs != null);
		}

	}
}
