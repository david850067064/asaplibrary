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
package org.asaplibrary.data.tree {
	import org.asaplibrary.data.BaseEnumerator;
	import org.asaplibrary.util.debug.Log;

	import flash.utils.getQualifiedClassName;

	/**
	Straightforward enumeration (iterator) class for {@link Tree} objects. TreeEnumerator has one way of iterating: forward ({@link #getNextObject}).
	@use
	<code>
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
	</code>
	 */
	public class TreeEnumerator extends BaseEnumerator {
		private var mRootNode : Tree;
		/**< The root node. May be set to any node. */
		private var mCurrentNode : Tree;
		/**< The current state (node). */
		private var mIsEnumerating : Boolean;
		private var mLastNode : Tree;

		/**< Last node of the Tree; for performance reasons searched only once. */
		/**
		Creates a new enumerator.
		@param inRoot: Tree (root node) to enumerate
		 */
		public function TreeEnumerator(inRoot : Tree) {
			super();
			if (inRoot == null) {
				Log.error("TreeEnumerator constructor: root node must be passed.", toString());
				return;
			}
			root = inRoot;
		}

		/**
		The enumerated Tree.
		 */
		public function get root() : Tree {
			return mRootNode;
		}

		/**
		Sets a new node as root node.
		@param inRoot : the new root node
		 */
		public function set root(inRoot : Tree) : void {
			mRootNode = inRoot;
			mLastNode = getLastNode(mRootNode);
			mIsEnumerating = false;
			mCurrentNode = null;
		}

		/**
		@return The current Tree node.
		 */
		public override function getCurrentObject() : * {
			return Tree(mCurrentNode);
		}

		/**
		Moves the enumerator to Tree node inTreeNode.
		@param inTreeNode: the node to start enumerating from
		 */
		public function setCurrentObject(inTreeNode : Tree) : void {
			update(inTreeNode);
		}

		/**
		Moves the enumerator to the next position and returns its value.
		@return The Tree node at the new position.
		 */
		public override function getNextObject() : * {
			var nextNode : Tree = performGetNextObject();
			if (nextNode != null) {
				return update(nextNode);
			}
			return null;
		}

		/**
		Resets the enumerator to the start.
		 */
		public override function reset() : void {
			update(null);
		}

		/**
		@exclude
		 */
		public override function toString() : String {
			return getQualifiedClassName(this) + ": root node=" + mRootNode;
		}

		/**
		Finds the last child (of the last child recursively) of node inNode.
		 */
		protected function getLastNode(inNode : Tree) : Tree {
			if (!inNode.children) {
				// terminate condition
				return inNode;
			}
			var lastPos : int = inNode.children.length - 1;
			return getLastNode(inNode.children[lastPos]);
		}

		/**
		Updates the position of the enumerator to Tree node inNewNode. The new node may be null.
		@param inNewNode: the Tree node to move the enumerator to
		@return The node passed in mCurrentNode, or null.
		 */
		protected function update(inNewNode : Tree) : Tree {
			mCurrentNode = inNewNode;
			mIsEnumerating = (inNewNode != null);
			return mCurrentNode;
		}

		/**
		Finds the nexts object in the Tree.
		@return The Tree node at the next position.
		 */
		protected function performGetNextObject() : Tree {
			if (!mIsEnumerating) {
				// before iterating
				mIsEnumerating = true;
				return mRootNode;
			}
			if (mCurrentNode && mCurrentNode == mLastNode) {
				mCurrentNode = null;
				return null;
			}
			if (mCurrentNode && mCurrentNode.children) {
				return getFirstChildFW();
			}
			// ELSE - THIS NODE HAS NO CHILDREN
			return getNextSiblingFW(false);
		}

		// FORWARD TRAVERSAL METHODS
		/**
		Gets the first child of the current node.
		@return The found node; if no node found, returns null.
		 */
		protected function getFirstChildFW() : Tree {
			var nextNode : Tree = mCurrentNode.children[0];
			if (nextNode == null) {
				return null;
			}
			return nextNode;
		}

		/**
		Called in case the node has no children.
		Gets the first sibling (sharing the same parent) of the current node.
		@param inFindSameDepth : (true or false) true: the found node must match the current node's depth; default false
		@return The found node; if no node found, returns null.
		@implementationNote
		When the pointer is at b2 we continue at C.
		<code>
		|-root
		|- A
		|
		|- B
		|  |- b1
		|  |- b2
		|
		|- C
		
		</code>
		 */
		protected function getNextSiblingFW(inFindSameDepth : Boolean) : Tree {
			var nextNode : Tree = getForwardNode(mCurrentNode, inFindSameDepth);
			if (nextNode == null) {
				return null;
			}
			return nextNode;
		}

		/**
		Recursive method, initially called by {@link #getNextSiblingFW}.
		@param inTempNode : storage of temporary current node while recursing 
		@param inFindSameDepth : (true or false) true: the found node must match the current node's depth; default false
		@return The found node; if no node found, returns null.
		 */
		protected function getForwardNode(inTempNode : Tree, inFindSameDepth : Boolean) : Tree {
			if (!inTempNode) return null;
			if (!inTempNode.parent) return null;

			var siblings : Array = inTempNode.parent.children;
			if (!siblings) return null;

			var thisSiblingPosition : int = siblings.indexOf(inTempNode);

			if (siblings.length - 1 > thisSiblingPosition) {
				// the parent has more children after this current child
				var nextNode : Tree = siblings[thisSiblingPosition + 1];
				return nextNode;
			}
			// this node is the last child or the only child
			// move up one parent
			if (!inFindSameDepth) {
				return getForwardNode(inTempNode.parent, inFindSameDepth);
			}
			// else
			return null;
		}
	}
}