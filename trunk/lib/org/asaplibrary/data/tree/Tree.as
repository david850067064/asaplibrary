/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
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

	public class Tree {
	
		private var mName:String; /**< Tree identifier. */
		private var mParent:Tree = null; /**< Parent node. */
		private var mChildren:Array; /*< List of child nodes (typical of a position tree). */
		
		private var mData:Object = null; /**< Contents of this node. */
				
		/**
		
		*/
		function Tree (inName:String = "", inParent:Tree = null) {
			parent = inParent;
			name = inName;
		}
		
		/**
		
		*/
		public function addChild (inName:String,
								  inData:Object = null) : Tree {
		
			var childNode = new Tree(inName, this);
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
		public function get name () : String {
			return mName;
		}
		
		public function set name (inName:String) : void {
			mName = inName;
		}
				
		/**
		The node's parent node.
		*/
		public function get parent () : Tree {
			return mParent;
		}
		
		public function set parent (inParent:Tree) : void {
			mParent = inParent;
		}
				
		/**
		The array of child nodes.
		*/
		public function get children () : Array {
			return mChildren;
		}
		
		/**
		Generic data container.
		*/
		public function get data () : Object {
			return mData;
		}
		public function set data (inData:Object) : void {
			mData = inData;
		}
		
		/**
		@exclude
		*/
		public function toString () : String {
			var dataStr:String = data ? data.toString() : "";
			return "Tree " + name + "; data=" + dataStr;
		}
		
		/**
		Prints info on this node and its children.
		*/
		public function printNodes (inOffsetString:String = "") : void
		{
			trace(inOffsetString + toString());
			if (!mChildren) return;
			var i:Number, ilen:Number = mChildren.length;
			for (i=0; i<ilen; ++i) {
				mChildren[i].printNodes(inOffsetString + "\t");
			}
		}
		
	}
	
}