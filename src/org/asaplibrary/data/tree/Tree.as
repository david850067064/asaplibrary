/*
Copyright 2007-2011 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */
 /**
  * Tree iteration/enumeration classes.
  */
package org.asaplibrary.data.tree {
	import flash.utils.getQualifiedClassName;

	/**
	All sorts of information is hierarchical and can be represented by a tree structure: websites, photo albums, topic knowledge, etcetera.
	
	This Tree class is a position tree: each tree node has exactly one parent node and can have multiple children. The root node has no parent.
	Tree nodes can be added as sub-Tree objects.
	
	Use a {@link TreeEnumerator} to traverse the tree.
	@use
	<code>
	var root:Tree = new Tree("root");
	var data:Object = {order:0;};
	var child:Tree = root.addChild("A", data);
	</code>
	 */
	public class Tree {
		/** Tree identifier. */
		private var mName : String;
		/** Parent node. */
		private var mParent : Tree = null;
		/** List of child nodes (typical of a position tree). */
		private var mChildren : Array;
		/**< Contents of this node. */
		private var mData : Object = null;

		/**
		Creates a new Tree.
		@param inName: (optional) name of the tree.
		@param inParent: (optional) parent of this node
		 */
		function Tree(inName : String = "", inParent : Tree = null) {
			parent = inParent;
			name = inName;
		}

		/**
		Adds an existing Tree node as child.
		@param inTree: child node to add
		 */
		public function addChildNode(inTree : Tree) : void {
			inTree.parent = this;
			if (mChildren == null) mChildren = new Array();
			mChildren.push(inTree);
		}

		/**
		Creates a new Tree node and adds it as child.
		@param inName: the identifier name; this name should be unique and without spaces.
		@param inData: (optional) data container
		 */
		public function addChild(inName : String, inData : Object = null) : Tree {
			var childNode : Tree = new Tree(inName, this);
			if (mChildren == null) mChildren = new Array();
			mChildren.push(childNode);

			if (inData != null) {
				childNode.data = inData;
			}
			return childNode;
		}

		/**
		The identifier name; this name should be unique and without spaces.
		 */
		public function get name() : String {
			return mName;
		}

		public function set name(inName : String) : void {
			mName = inName;
		}

		/**
		The node's parent node.
		 */
		public function get parent() : Tree {
			return mParent;
		}

		public function set parent(inParent : Tree) : void {
			mParent = inParent;
		}

		/**
		The list of child nodes.
		 */
		public function get children() : Array {
			return mChildren;
		}

		/**
		Generic data container.
		 */
		public function get data() : Object {
			return mData;
		}

		public function set data(inData : Object) : void {
			mData = inData;
		}

		/**
		@exclude
		 */
		public function toString() : String {
			var dataStr : String = (mData != null) ? String(mData) : "";
			return getQualifiedClassName(this) + ": " + mName + "; data=" + dataStr;
		}

		/**
		Prints info on this node and its children.
		 */
		public function printNodes(inOffsetString : String = "") : void {
			if (!mChildren) return;
			var i : Number, ilen : Number = mChildren.length;
			for (i = 0; i < ilen; ++i) {
				Tree(mChildren[i]).printNodes(inOffsetString + "\t");
			}
		}
	}
}