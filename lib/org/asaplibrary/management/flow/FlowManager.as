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

package org.asaplibrary.management.flow {
	
	import flash.events.*;

	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.util.actionqueue.*;	

	public class FlowManager extends EventDispatcher {
		
		private static var mInstance:FlowManager;
		
		private var mActionRunner:ActionRunner;
		private var mSections:Object; // of type String => IFlowSection
		private var mRules:Object; // of type FlowRule
		private var mCurrentSectionName:String;
		private var mSectionDestinations:Array; // of type SectionVO
		private var mDownloadDirectory:String = "";
		
		/**
		Access point for the one instance of the FlowManager
		*/
		public static function getInstance () : FlowManager {
			if (mInstance == null) {
				mInstance = new FlowManager();
			}
			return mInstance;
		}
		
		/**

		*/
		public function addRule (inRule:FlowRule) : void {
			var sectionName:String = inRule.name;
			if (mRules[sectionName] == null) {
				mRules[sectionName] = new Object();
			}
			var mode:uint = inRule.mode;
			mRules[sectionName][mode] = inRule;
		}
		
		/**
		Applies a FlowRule to a list of sections.
		*/
		public function addRuleForSections (inRule:FlowRule, inSectionNames:Array) : void {
			if (inRule == null || inSectionNames == null) return;
			var i:uint, ilen:uint = inSectionNames.length;
			for (i=0; i<ilen; ++i) {
				var rule:FlowRule = inRule.copy();
				rule.name = inSectionNames[i];
				addRule(rule);
			}
		}
		
		/**

		*/
		public function addAction (inAction:IAction) : void {
			if (inAction == null) return;
			mActionRunner.insertAction(inAction);
		}
		
		/**
		Stores FlowSections in a look-up hash.
		*/
		public function registerFlowSection (inFlowSection:IFlowSection, inSectionName:String = null) : void {
			var name:String = inSectionName ? inSectionName : inFlowSection.getName();
			mSections[name] = inFlowSection;
		}
			
		/**
		
		*/
		public function goto (inSectionName:String, inStopEverythingFirst:Boolean = true, inUpdateState:Boolean = true) : void {
			if (inStopEverythingFirst) {
				reset();
			}
			mSectionDestinations.push( new SectionVO(inSectionName, inUpdateState) );
			runNextGoToSection();
		}
		
		public function setDownloadDirectory (inUrl:String) : void {
			mDownloadDirectory = inUrl;
		}
		
		protected function reset () : void {
			mActionRunner.reset();
		}
		
		/**
		
		*/
		public function getSectionByName (inSectionName:String) : IFlowSection {
			return mSections[inSectionName];
		}
		
		/**
		
		*/
		public function getCurrentSection () : IFlowSection {
			if (mCurrentSectionName == null) return null;
			return mSections[mCurrentSectionName];
		}
						
		/**
		
		*/
		protected function addSectionActions (inSectionName:String, inMode:uint, inType:uint, inHelper:StringNodeHelper ) : void {
			var actions:Array = new Array();
			var sectionNames:Array = new Array();
			if (inMode == FlowSectionOptions.HIDE) {
				sectionNames = inHelper.getHideSections(inSectionName, mCurrentSectionName, inType);
			}
			if (inMode == FlowSectionOptions.SHOW) {
				sectionNames = inHelper.getShowSections(inSectionName, mCurrentSectionName, inType);
			}
			
			// see if any FlowRule is defined for this section name
			var action:Action = getRuleAction(inSectionName, inMode, inType);
			if (action != null) {
				actions.push(action);
			}
			if (sectionNames != null && sectionNames.length > 0) {
				actions = getSectionActions(sectionNames, inMode, inType);
			}
			mActionRunner.addActions(actions);
		}
		
		/**
		@return Action
		*/
		protected function getRuleAction (inSectionName:String, inMode:uint, inType:uint) : Action {
			var rule:FlowRule;
			var action:Action;
			
			if (mRules[inSectionName] != null) {
				rule = mRules[inSectionName][inMode];
			}
			if (rule != null && (rule.type & inType)) {
				var section:IFlowSection = mSections[inSectionName];
				action = new Action(null, rule.callback, [section]);
			}
			return action;
		}
		
		/**
		Called by {@link #addSectionActions}.
		*/
		protected function getSectionActions (inSectionNames:Array, inMode:uint,  inType:uint) : Array {
			if (inSectionNames == null || inSectionNames.length == 0) {
				return null;
			}
			var sectionActions:Array = new Array();
			var i:uint, ilen:uint = inSectionNames.length;
			var section:IFlowSection;
			for (i=0; i<ilen; ++i) {
				var sectionName:String = inSectionNames[i];
				// see if any FlowRule is defined
				var action:IAction = getRuleAction(sectionName, inMode, inType);
				if (action != null) {
					sectionActions.push(action);
					continue;
				}
				
				// else no rule found for this section name or mode
				
				section = mSections[sectionName];
				if (section != null) {
					if (inMode == FlowSectionOptions.HIDE) {
						// default hide action
						action = section.hideAction;
					}
					if (inMode == FlowSectionOptions.SHOW) {
						// default show action
						action = section.showAction;
					}
					if (action != null) {
						sectionActions.push(action);
					}
				}
			}
			return sectionActions;
		}
		
		/**
		@sends FlowNavigationEvent#WILL_UPDATE
		*/
		protected function runNextGoToSection () : void {
						
			var sectionVO:SectionVO = mSectionDestinations.shift();
			if (sectionVO == null) {
				reset();
				return;
			}
			
			var doUpdateState:Boolean = sectionVO.doUpdateState;
			var sectionName:String = sectionVO.sectionName;
						
			var section:IFlowSection = mSections[sectionName];
			if (!section) {
				// not found, try to load first
				loadSection(sectionName);
				return;
			}
			
			var helper:StringNodeHelper = new StringNodeHelper();
			var type:uint = helper.getType(sectionName, mCurrentSectionName);
			
			// hide current section
			addSectionActions( sectionName, FlowSectionOptions.HIDE, type, helper );
			addSectionActions( sectionName, FlowSectionOptions.HIDE_END, type, helper );
			
			// show new section
			addSectionActions( sectionName, FlowSectionOptions.SHOW, type, helper );
			addSectionActions( sectionName, FlowSectionOptions.SHOW_END, type, helper );
			
			if (doUpdateState) {
				// add state update action
				mActionRunner.addAction(new Action(this, setCurrentSection, [sectionName]));

				mCurrentSectionName = sectionName;
				
				dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.WILL_UPDATE, sectionName, this));
			}
			
			if (!mActionRunner.isRunning()) {
				mActionRunner.run();
			}
		}
		
		/**
		Tells {@link MovieManager} to load a SWF movie with name inSectionName in the directory set by {@link #setDownloadDirectory) (default the current movie directory). The loaded movie event is processed in {@link #onMovieEvent}.
		@param inSectionName: name of the section and the SWF; a section named 'Sections.Section4' will be loaded as 'Section4.swf'
		@sends FlowNavigationEvent#WILL_LOAD
		*/
		protected function loadSection (inSectionName:String) : void {
			var sectionNameParts:Array = inSectionName.split(".");
			var fileName:String = sectionNameParts[sectionNameParts.length-1];
			var url:String = mDownloadDirectory + fileName + ".swf";
			var mm:MovieManager = MovieManager.getInstance();
			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.WILL_LOAD, inSectionName, this));
			mm.addEventListener( MovieManagerEvent._EVENT, onMovieEvent );
			mm.loadMovie(url, inSectionName);
		}
		
		/**
		@sends FlowNavigationEvent#UPDATE
		*/
		protected function setCurrentSection (inSectionName:String) : void {
			mCurrentSectionName = inSectionName;
			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.UPDATE, mCurrentSectionName, this));
		}
		
		/**
		Handles MovieManagerEvents.
		@sends FlowNavigationEvent#LOADED
		*/
		protected function onMovieEvent (e:MovieManagerEvent) {
			if (e.subtype == MovieManagerEvent.MOVIE_READY) {
				if (e.controller is IFlowSection) {
					var section:IFlowSection = IFlowSection(e.controller);
					registerFlowSection(section);
					dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.LOADED, section.getName(), this));
				}
			}
		}
		
		/**
		Supposedly private constructor
		*/
		function FlowManager () {
			super();
			
			mActionRunner = new ActionRunner("FlowManager");
			mSections = new Object();
			mRules = new Object();
			mSectionDestinations = new Array();
		}
		
		override public function toString () : String {
			return ";FlowManager";
		}
		
	}
}

class SectionVO {
	
	public var sectionName:String;
	public var doUpdateState:Boolean;
	
	function SectionVO (inSectionName:String, inDoUpdateState:Boolean) : void {
		sectionName = inSectionName;
		doUpdateState = inDoUpdateState;
	}
	
	public function toString () : String {
		return "SectionVO: sectionName=" + sectionName + "; doUpdateState=" + doUpdateState;
	}
	
}

import org.asaplibrary.management.flow.*;

/**
Helper class to find tree-like relations in node names. For example with these section names:
<code>
Portfolio
Portfolio.Photos
Portfolio.Photos.Detail1
Portfolio.Movies
</code>
... StringNodeHelper will define that going from 'Portfolio.Photos' to 'Portfolio.Movies' is a SIBLING relationship, and going from 'Portfolio.Photos.Detail1' to 'Portfolio.Photos' is a PARENT relationship.

The possible options are listed in {@link FlowSectionOptions}.
*/
class StringNodeHelper {

	/**
	
	*/
	public function getType (inNewSection:String, inCurrentSection:String) : uint {
		
		if (!inCurrentSection || !inNewSection) {
			return FlowSectionOptions.UNRELATED;
		}
		
		// equal?
		if (inNewSection == inCurrentSection) {
			return FlowSectionOptions.EQUAL;
		}

		// child?
		if ( isChild(inNewSection, inCurrentSection) ) {
			return FlowSectionOptions.CHILD;
		}

		// parent?
		// (reverse child)			
		if ( isChild(inCurrentSection, inNewSection) ) {
			return FlowSectionOptions.PARENT;
		}

		// sibling?
		if ( isSibling(inNewSection, inCurrentSection) ) {
			return FlowSectionOptions.SIBLING;
		}
		
		// distant relative?
		if ( isDistantRelative(inNewSection, inCurrentSection) ) {
			return FlowSectionOptions.DISTANT;
		}

		return FlowSectionOptions.UNRELATED;
	}

	/**
	
	*/
	public function getHideSections (inNewSection:String, inCurrentSection:String, inType:uint) : Array {
		
		if (inCurrentSection == null) return null;
		
		var base:String = getCommonBase(inNewSection, inCurrentSection);
		
		var hideSections = new Array();
		
		var baseDepth:uint = 0;
		if (base != null) {
			baseDepth = base.split(".").length;
		}
		switch (inType) {
			case FlowSectionOptions.CHILD:
				// do nothing
				break;
			case FlowSectionOptions.PARENT:
				// hide current up to base
				hideSections = hideSections.concat( getSectionNamesBackward(inCurrentSection, baseDepth) );
				break;
			case FlowSectionOptions.SIBLING:
				// hide current section
				hideSections.push(inCurrentSection);
				break;
			case FlowSectionOptions.DISTANT:
			case FlowSectionOptions.UNRELATED:
				// hide current up to base
				hideSections = hideSections.concat( getSectionNamesBackward(inCurrentSection, baseDepth) );
				break;
			default:
				//
		}
		return hideSections;
	}
	
	/**
	
	*/
	public function getShowSections (inNewSection:String, inCurrentSection:String, inType:uint) : Array {
		
		var base:String = getCommonBase(inNewSection, inCurrentSection);
		var showSections = new Array();
		
		var startDepth:uint = 0;
		if (base != null) {
			startDepth = base.split(".").length + 1;
		}
		switch (inType) {
			case FlowSectionOptions.CHILD:
				// show current up to new
				showSections = showSections.concat( getSectionNamesForward(inNewSection, startDepth));
				break;
			case FlowSectionOptions.PARENT:
				// do nothing
				break;
			case FlowSectionOptions.SIBLING:
				// show new
				showSections.push( inNewSection );
				break;
			case FlowSectionOptions.DISTANT:
			case FlowSectionOptions.UNRELATED:
				// show base up to new
				showSections = showSections.concat( getSectionNamesForward(inNewSection, startDepth));
				break;
			default:
				//
		}
		return showSections;
	}
	
	/**
	@return True if inNewSection is a direct or distant child of inCurrentSection.
	*/
	protected function isChild (inNewSection:String, inCurrentSection:String) : Boolean {
		var re:RegExp = new RegExp("^(" + inCurrentSection + ")($|\.)", "i");
		var result:Object = re.exec(inNewSection);
		if (result != null && result[1] != null ) {
			return true;
		}
		return false;
	}
	
	/**
	@return True if inNewSection is a distant relative of inCurrentSection (they have a common base).
	*/
	protected function isDistantRelative (inNewSection:String, inCurrentSection:String) : Boolean {
		var base:String = getCommonBase(inNewSection, inCurrentSection);
		return (base != null);
	}
		
	/**
	@return True if inNewSection is a direct sibling of inCurrentSection.
	*/
	protected function isSibling (inNewSection:String, inCurrentSection:String) : Boolean {
		var pattern:String = "^(.*)\\.";
		var baseNew:String;
		var baseCurrent:String;
		
		var reNew:RegExp = new RegExp(pattern, "i");
		var resultNew:Object = reNew.exec(inNewSection);
		var reCurrent:RegExp = new RegExp(pattern, "i");
		var resultCurrent:Object = reCurrent.exec(inCurrentSection);
		
		if (resultNew && resultCurrent && resultNew[1] == resultCurrent[1]) {
			return true;
		}
		return false;
	}
	
	/**
	Finds the common base parts of 2 node names. For example:
	<code>
	Portfolio.Photos.Detail1
	Portfolio.Photos.Detail2
	</code>
	... have as common base 'Portfolio.Photos'.
	*/
	protected function getCommonBase (inNewSection:String, inCurrentSection:String) : String {
		if (getCommonBase == null || inCurrentSection == null) {
			return null;
		}
		var partsNew:Array = inNewSection.split(".");
		var partsCurrent:Array = inCurrentSection.split(".");
		var i:uint, ilen = Math.min(partsNew.length, partsCurrent.length);
		var matchDepth:int = -1;
		for (i=0; i<ilen; ++i) {
			if (partsNew[i] != partsCurrent[i]) {
				break;
			}
			matchDepth = i;
		}
		if (matchDepth == -1) return null;
		return partsCurrent.slice(0, matchDepth+1).join(".");
	}
	
	/**
	
	*/
	protected function getSectionNamesBackward (inName:String, inTargetDepth:uint) : Array {
		var sections:Array = new Array();
		var parts:Array = inName.split(".");
		var i:uint = parts.length, min:uint = inTargetDepth;
		while (i > min) {
			var partsCopy:Array = parts.slice(); // makes a shallow copy
			partsCopy = partsCopy.slice(0,i);
			if (partsCopy.length > 0) {
				sections.push( partsCopy.join(".") );
			}
			i--;
		}
		return sections;
	}
	
	/**
	
	*/
	protected function getSectionNamesForward (inName:String, inStartDepth:uint) : Array {
		var sections:Array = new Array();
		var parts:Array = inName.split(".");
		var i:uint = inStartDepth, max:uint = parts.length;
		while (i <= max) {
			var partsCopy:Array = parts.slice(); // makes a shallow copy
			partsCopy = partsCopy.slice(0,i);
			if (partsCopy.length > 0) {
				sections.push( partsCopy.join(".") );
			}
			i++;
		}
		return sections;
	}

}

