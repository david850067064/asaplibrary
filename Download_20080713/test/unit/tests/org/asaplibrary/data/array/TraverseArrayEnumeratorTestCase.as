package org.asaplibrary.data.array {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.array.*;
		
	public class TraverseArrayEnumeratorTestCase extends TestCase implements ITraverseArrayDelegate {
	
		private static var DELEGATE_TEST_VALUE = "e";
	
		private var mReceivedOnArrayTraverseEvent:Boolean;
		private var mObjects:Array;
		
		public function testNew() : void {
			
			var letters:Array = ["a", "b", "c", "d", "e"];
			
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
	
			// test everything from TraverseArrayEnumerator
			assertTrue("TraverseArrayEnumerator getAllObjects", (enumerator.getAllObjects() == letters));
			
			enumerator.setObjects(letters);
			assertTrue("TraverseArrayEnumerator getAllObjects after setObjects", (enumerator.getAllObjects() == letters));
	
			assertTrue("TraverseArrayEnumerator getCurrentObject", (enumerator.getCurrentObject() == null));
		}

		public function testCurrentObject () : void {		
			
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
			
			assertTrue("TraverseArrayEnumerator getCurrentObject", (enumerator.getCurrentObject() == null));
			
			var letter:String = enumerator.getNextObject();
			assertTrue("TraverseArrayEnumerator getNextObject", (letter == "a"));
			assertTrue("TraverseArrayEnumerator getCurrentObject after getNextObject", (enumerator.getCurrentObject() == "a"));
		}
		
		public function testReset () : void {
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
			enumerator.reset();
			assertTrue("TraverseArrayEnumerator getCurrentObject after reset", (enumerator.getCurrentObject() == null));
		}
		
		public function testIteration () : void {
		
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
		
			enumerator.getNextObject(); // a
			enumerator.getNextObject(); // b
			enumerator.getNextObject();	// c
			enumerator.getNextObject();	// d
			enumerator.getNextObject();	// e
			assertTrue("TraverseArrayEnumerator getNextObject", (enumerator.getNextObject() == null));
		}
			
		public function testIterationForwardWithoutLooping () : void {
			
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
			
			// test without looping
			enumerator.reset();
			enumerator.getNextObject(); // a
			enumerator.getNextObject(); // b
			enumerator.getNextObject();	// c
			enumerator.getNextObject();	// d
			enumerator.getNextObject();	// e
			assertTrue("TraverseArrayEnumerator hasNextObject without looping 'a'", (enumerator.hasNextObject() == false));
			assertTrue("TraverseArrayEnumerator getNextObject without looping 'a'", (enumerator.getNextObject() == null));
		}
			
		public function testIterationForwardWithLooping () : void {
		
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
		
			// test with looping
			enumerator.setLoop(true);
			enumerator.getNextObject(); // a
			enumerator.getNextObject(); // b
			enumerator.getNextObject();	// c
			enumerator.getNextObject();	// d
			enumerator.getNextObject();	// e
			assertTrue("TraverseArrayEnumerator hasNextObject with looping 'a'", (enumerator.hasNextObject() == true));
			assertTrue("TraverseArrayEnumerator getNextObject with looping 'a'", (enumerator.getNextObject() == "a"));
		}
		
		public function testIterationBackwardWithLooping () : void {
		
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
		
			// test with looping
			enumerator.setLoop(true);
			enumerator.getPreviousObject(); // e
			enumerator.getPreviousObject(); // d
			assertTrue("TraverseArrayEnumerator getCurrentObject with looping backwards 'd'", (enumerator.getCurrentObject() == 'd'));
		}
					
		public function testPreviousWithoutLooping () : void {
	
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
		
			// test 'previous' without looping
			enumerator.setLoop(false);
			enumerator.reset();
			assertTrue("TraverseArrayEnumerator getPreviousObject no loop 'e'", (enumerator.getPreviousObject() == null));
		}
			
		public function testPreviousWithLooping () : void {
	
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
			
			// test 'previous' with looping
			enumerator.setLoop(true);
			enumerator.reset();			
			assertTrue("TraverseArrayEnumerator getPreviousObject loop 'e'", (enumerator.getPreviousObject() == "e"));
		}
		
		public function testArrayEnumeratorEvent () : void {
			
			var letters:Array = ["a", "b", "c", "d", "e"];
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(letters);
			enumerator.addEventListener(TraverseArrayEnumeratorEvent._EVENT, handleTraverseUpdate);
			enumerator.getNextObject();
			
			// evaluate received events without delegate
			assertTrue("TraverseArrayEnumerator event", mReceivedOnArrayTraverseEvent);
		}

		public function testDelegate () : void {
			
			var letters:Array = ["a", "b", "c", "d", "e"];
			setObjects(letters);
			var enumerator:TraverseArrayEnumerator = new TraverseArrayEnumerator(getArray());
			enumerator.setLoop(true);
		
			mReceivedOnArrayTraverseEvent = false;
			enumerator.addDelegate(this);
			// evaluate received events with delegate
			enumerator.reset();	
			enumerator.getNextObject(); // b?
			assertFalse("TraverseArrayEnumerator event with delegate - should be refused", mReceivedOnArrayTraverseEvent);		
			assertTrue("TraverseArrayEnumerator getCurrentObject after delegate refusion", (enumerator.getCurrentObject() == null));
			
			enumerator.getPreviousObject(); // e
			assertTrue("TraverseArrayEnumerator event with delegate - should be accepted: 'e'", (enumerator.getCurrentObject() == 'e'));
		}

		private function setObjects (inArray:Array) : void {
			mObjects = inArray;
		}
		
		private function getArray () : Array {
			return mObjects;
		}
		
		private function handleTraverseUpdate (e:TraverseArrayEnumeratorEvent) : void {
			mReceivedOnArrayTraverseEvent = true;
		}
		
		public function mayUpdateToObject (inObjects:Array, inLocation:Number) : Boolean {
			return (inObjects[inLocation] == DELEGATE_TEST_VALUE);
		}
	}
}