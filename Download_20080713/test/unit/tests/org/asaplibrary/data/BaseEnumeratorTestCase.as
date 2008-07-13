package org.asaplibrary.data {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.BaseEnumerator;
		
	public class BaseEnumeratorTestCase extends TestCase {

		public function testConstructor() : void {
			var instance:BaseEnumerator = new BaseEnumerator();
			assertTrue("BaseEnumerator testConstructor", instance);
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
