package org.asaplibrary.data.tree {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.tree.TreeEnumerator;
		
	public class TreeEnumeratorTestCase extends TestCase {

		public function testConstructor() : void {
			var t:Tree = new Tree("root");
			var instance:TreeEnumerator = new TreeEnumerator(t);
			assertTrue("TreeEnumerator instantiated", instance);
		}
		
		public function testRoot() : void {
			var root:Tree = new Tree("root");
			var e:TreeEnumerator = new TreeEnumerator(root);
			var newroot:Tree = new Tree("newroot");
			e.root = newroot;
			assertTrue("TreeEnumerator root", e.root == newroot);
		}
		
		/*
		public function testDocumentation () : void {
			var root:Tree = new Tree("root");
			var child:Tree = root.addChild("A");
			var e:TreeEnumerator = new TreeEnumerator(root);
			trace(e.getCurrentObject()); // null
			var node:Tree = e.getNextObject();
			trace(e.getCurrentObject()); // Tree: root
			node = e.getNextObject();
			trace(e.getCurrentObject()); // Tree: "A"
			node = e.getNextObject();
			trace(e.getCurrentObject()); // null
		}
		*/
		
		public function testEnumerate() : void {
			var root:Tree = new Tree("root");
			var child:Tree = root.addChild("A");
			
			var e:TreeEnumerator = new TreeEnumerator(root);
			assertTrue("TreeEnumerator getCurrentObject", e.getCurrentObject() == null);
			var node:Tree = e.getNextObject();
			assertTrue("TreeEnumerator getNextObject", node == root);
			node = e.getNextObject();
			assertTrue("TreeEnumerator getNextObject 2", node == child);
			assertTrue("TreeEnumerator getCurrentObject 2", e.getCurrentObject() == child);
			node = e.getNextObject();
			assertTrue("TreeEnumerator getNextObject 3", node == null);
			
			assertTrue("TreeEnumerator getCurrentObject 3", e.getCurrentObject() == null);			
		}
		
		public function testReset() : void {
			var root:Tree = new Tree("root");
			var child1:Tree = root.addChild("A");
			var child2:Tree = root.addChild("B");
			
			var e:TreeEnumerator = new TreeEnumerator(root);
			var node:Tree = e.getNextObject(); // root
			node = e.getNextObject(); // A
			e.reset();
			assertTrue("TreeEnumerator reset", e.getCurrentObject() == null);
			node = e.getNextObject(); // root
			assertTrue("TreeEnumerator reset,getNextObject", e.getCurrentObject() == root);
		}
		
		public function testSetCurrentObject() : void {
			var root:Tree = new Tree("root");
			var child1:Tree = root.addChild("A");
			var child2:Tree = root.addChild("B");
			
			var e:TreeEnumerator = new TreeEnumerator(root);
			e.setCurrentObject(child1);
			assertTrue("TreeEnumerator setCurrentObject", e.getCurrentObject() == child1);
			var node:Tree = e.getNextObject(); // B
			assertTrue("TreeEnumerator setCurrentObject", e.getCurrentObject() == child2);
		}
	}
}
