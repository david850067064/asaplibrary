package org.asaplibrary.data.tree {
	
	import asunit.framework.TestCase;
	import org.asaplibrary.data.tree.Tree;
		
	public class TreeTestCase extends TestCase {

		public function testConstructor() : void {
			var instance:Tree = new Tree();
			assertTrue("Tree instantiated", instance);
		}
		
		public function testName() : void {
			var root:Tree = new Tree("root");
			assertTrue("Tree name", root.name == "root");
			root.name = "newname";
			assertTrue("Tree name", root.name == "newname");
		}
		
		public function testData() : void {
			var root:Tree = new Tree("root");
			root.data = 10;
			assertTrue("Tree data", root.data == 10);
		}
		
		public function testAddChildNode() : void {
			var root:Tree = new Tree("root");
			var child:Tree = new Tree("A");
			root.addChildNode(child);
			assertTrue("Tree testAddChildNode", root.children[0] == child);
		}
		
		public function testAddChild() : void {
			var root:Tree = new Tree("root");

			var child:Tree = root.addChild("A");
			child.data = -1;
			assertTrue("Tree child", child);
			assertTrue("Tree child name", child.name == "A");
			assertTrue("Tree child data", child.data == -1);
			assertTrue("Tree child parent", child.parent == root);
		
			var data:Number = 10;
			var child2:Tree = child.addChild("B", data);
			assertTrue("Tree child", child2);
			assertTrue("Tree child name", child2.name == "B");
			assertTrue("Tree child data", child2.data == 10);
			assertTrue("Tree child parent", child2.parent == child);
		}
		
		public function testParent() : void {
			var root:Tree = new Tree("root");
			var child:Tree = root.addChild("A");
			assertTrue("Tree child parent", child.parent == root);
			var newroot:Tree = new Tree("newroot");
			child.parent = newroot;
			assertTrue("Tree child new parent", child.parent == newroot);
		}
		
		public function testChildren() : void {
			var root:Tree = new Tree("root");
			var child1:Tree = root.addChild("A");
			var child2:Tree = root.addChild("B");
			assertTrue("Tree children length", root.children.length == 2);
			assertTrue("Tree child 1", root.children[0] == child1);
			assertTrue("Tree child 2", root.children[1] == child2);
		}
		
	}
}
