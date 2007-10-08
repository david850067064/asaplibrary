/**
@todo
parseXML()
*/

package org.asaplibrary.data {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.URLData;
		
	public class URLDataTestCase extends TestCase {

		public function testConstructor() : void {
			var instance:URLData = new URLData();
			assertTrue("URLData testConstructor", instance);
			
			var name:String = "NAME";
			var url:String = "http://asaplibrary.org";
			var target:String = "new";
			
			instance = new URLData(name, url, target);
			assertTrue("URLData testConstructor name", instance.name == name);
			assertTrue("URLData testConstructor url", instance.url == url);
			assertTrue("URLData testConstructor name", instance.target == target);
		}
		
		public function testParseXML() : void {
			// cannot be tested yet
		}
		
	}
}
