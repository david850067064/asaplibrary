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

package org.asaplibrary.util.actionqueue {
	
	import flash.events.*;

	import org.asaplibrary.util.actionqueue.IAction;
	
	/**
	An Action is a "Command Pattern" object that holds data of an object's method. See http://en.wikipedia.org/wiki/Command_pattern
	*/
	public class Action extends EventDispatcher implements IAction {
		
		protected var mMethod:Function;
		protected var mOwner:Object;
		protected var mArgs:Array;
		protected var mUndoMethod:Function;
		protected var mUndoArgs:Array;
		
		/**
		Creates a new Action.
		@param inOwner: method owner (the method will be called in the owner's scope)
		@param inMethod: function reference
		@param inArgs: (optional) arguments to pass to the method
		@param inUndoMethod: (optional) not implemented yet
		@param inUndoArgs: (optional) not implemented yet
		*/
		function Action (inOwner:Object,
						 inMethod:Function,
						 inArgs:Array = null,
						 inUndoMethod:Function = null,
						 inUndoArgs:Array = null) {
						 
			mMethod = inMethod;
			mOwner = inOwner;
			mArgs = inArgs;
			mUndoMethod = inUndoMethod;
			mUndoArgs = inUndoArgs;
		}
		
		/**
		Invokes the Action method.
		@return The result of the called method.
		*/
		public function run () : * {
			var result:* = mMethod.apply(mOwner, mArgs);
			dispatchEvent(new ActionEvent(ActionEvent.FINISHED, this));
			return result;
		}
		
		/**
		@return False
		*/
		public function isRunning () : Boolean {
			return false;
		}
		
		/**
		@exclude
		*/
		override public function toString() : String {
			return ";org.asaplibrary.util.actionqueue.Action";
		}

	}

}