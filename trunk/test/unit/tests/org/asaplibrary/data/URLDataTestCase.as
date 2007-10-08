package org.asaplibrary.data {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.URLData;
		
	public class URLDataTestCase extends TestCase {

		public function testConstructor() : void {
			var instance:URLData = new URLData();
			assertTrue("URLData testConstructor", instance);
			
			instance = new URLData("NAME", "http://asaplibrary.org", 
		}
		
		public function testGetCurrentObject () : void {
			var be:BaseEnumerator = new BaseEnumerator();
			assertTrue("BaseEnumerator testGetCurrentObject", be.getCurrentObject() == null);
		}
		
		public function testGetNextObject () : void {
			var be:BaseEnumerator = new BaseEnumerator();
			assertTrue("BaseEnumerator testGetNextObject", be.getNextObject() == null);
		}
		
		public function testGetAllObjects () : void {
			var be:BaseEnumerator = new BaseEnumerator();
			assertTrue("BaseEnumerator testGetAllObjects", be.getAllObjects() == null);
		}
		
	}
}

/*
	<?xml version="1.0" encoding="UTF-8"?>
		<settings>
			<urls>
				<url name="addressform" url="../xml/address.xml" />
				<url name="entries" url="../xml/entries.xml" />
			</urls>
		</settings>
	</code>
*/