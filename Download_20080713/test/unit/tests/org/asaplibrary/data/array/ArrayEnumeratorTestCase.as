package org.asaplibrary.data.array {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.array.ArrayEnumerator;
		
	public class ArrayEnumeratorTestCase extends TestCase {

		public function testConstructor() : void {
			var instance:ArrayEnumerator = new ArrayEnumerator();
			assertTrue("ArrayEnumerator instantiated", instance);
		}
		
		public function testGetAllObjects () : void {
			var chars:Array = ["a", "b", "c", "d", "e"];
			var enumerator:ArrayEnumerator = new ArrayEnumerator(chars);	
			assertTrue("ArrayEnumerator getAllObjects", (enumerator.getAllObjects() == chars));
		}
		
		public function testSetArray () : void {
			var chars:Array = ["a", "b", "c", "d", "e"];
			var enumerator:ArrayEnumerator = new ArrayEnumerator();
			enumerator.setObjects(chars);
			assertTrue("ArrayEnumerator getAllObjects", (enumerator.getAllObjects() == chars));
		}
		
		public function testIteration () : void {
		
			var chars:Array = ["a", "b", "c", "d", "e"];
			var enumerator:ArrayEnumerator = new ArrayEnumerator(chars);
			
			assertTrue("ArrayEnumerator getCurrentObject", (enumerator.getCurrentObject() == null));
			assertTrue("ArrayEnumerator getCurrentLocation at start", (enumerator.getCurrentLocation() == -1));
			
			assertTrue("ArrayEnumerator getNextObject", (enumerator.getNextObject() == "a"));
			assertTrue("ArrayEnumerator getCurrentObject after getNextObject", (enumerator.getCurrentObject() == "a"));
			assertTrue("ArrayEnumerator getCurrentLocation after getNextObject", (enumerator.getCurrentLocation() == 0));
			
			enumerator.reset();
			assertTrue("ArrayEnumerator getCurrentObject after reset", (enumerator.getCurrentObject() == null));
			
			enumerator.getNextObject(); // a
			enumerator.getNextObject(); // b
			enumerator.getNextObject();	// c
			enumerator.getNextObject();	// d
			enumerator.getNextObject();	// e
			assertTrue("ArrayEnumerator getNextObject", (enumerator.getNextObject() == null));
	
			enumerator.setCurrentLocation(2); // c
			assertTrue("ArrayEnumerator getCurrentObject after setCurrentLocation", (enumerator.getCurrentObject() == "c"));
			
			enumerator.setCurrentObject("b"); 
			assertTrue("ArrayEnumerator getCurrentObject after setCurrentObject", (enumerator.getCurrentObject() == "b"));
			
		}
	}
}
