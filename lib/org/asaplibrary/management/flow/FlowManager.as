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
	import org.asaplibrary.util.debug.Log;

	/**
	<div style="background:#ffc; padding:1em; margin:0 0 1em 0; text-align:center">
	WARNING: provided "AS IS" -- this code has not been tested on production sites!
	</div>
	Enables to move from one state to the other within a site structure, even using 'deep links'.
	
	<h2>Introduction</h2>
	Flow states are represented by site 'sections', using the {@link IFlowSection} type.
	
	{@link FlowSection} inherits from {@link LocalController}, but can be assigned to any MovieClip in the site that needs to be navigated to.
	FlowManager registers FlowSections and uses their names to build a tree-like structure.
	
	The syntax to go to a new section is simply:
	<code>
	FlowManager.getInstance().goto("Intro");
	</code>
	FlowManager finds the FlowSection with that name, and finds what sections need to be shown or hidden or even loaded.
	
	<h2>Site structure</h2>
	The structure of the site is defined by hierarchical naming of FlowSections, using dots for each level. An example of a naming structure can be found in the example demo:
	<code>
	public static const SECTION_INTRO:String = "Intro";
	public static const SECTION1:String      = "Sections.Section1";
	public static const SECTION1_1:String    = "Sections.Section1.Section1_1";
	public static const SECTION2:String      = "Sections.Section2";
	</code>
	When going from 'Sections.Section1' to 'Sections.Section2', FlowManager will detect that this is a sibling relationship. The possible types of relationships are defined in {@link FlowSectionOptions}.
	
	<h2>Showing and hiding</h2>
	Each FlowSection has 2 methods that are called: {@link FlowSection#showAction} and {@link FlowSection#hideAction}. Depending on the type of relationship between the current and the new section, either one is called, or none.
	
	For example using the name list above, when going from 'Sections.Section1' to 'Sections.Section1.Section1_1', a CHILD relationship, the current section 'Sections.Section1' will not be hidden when showing the new section. So only the showAction of 'Sections.Section1.Section1_1' is called.
	While between 'Intro' and 'Sections.Section1' no relationship can be found, Intro will be hidden as expected.
	
	Each showAction and hideAction function may return a {@link IAction} or a subclass thereof, including an {@link ActionQueue}. Any animation is processed sequentially - an ActionQueue is first finished before the next Action is called.
	The default behavior will just set the visibility flag.
	
	In the example demo one of the sections overrides the default showAction - it lets the clip scale from small to large in a elastic manner:
	<code>
	public override function get showAction () : IAction {
		var queue:ActionQueue = new ActionQueue("Section1_1 show");
		queue.addAction(new AQSet().setVisible(this, true));
		queue.addAction(new AQSet().setScale(this, .5, .5));
		const CURRENT:Number = Number.NaN;
		var effect:Function = Elastic.easeOut;
		queue.addAction(new AQScale().scale(this, .8, CURRENT, CURRENT, 1, 1, effect));
		return queue;
	}
	</code>
	
	<h2>Rules</h2>
	Sometimes it is desired to manage these show and hide actions from a higher level.  For example after the intro animation we want to go to section 1.
	To do this Rules can be defined.

	Rules are created with the {@link FlowRule} class:
	<code>
	var rule:FlowRule = new FlowRule (
		"Intro",
		OPTIONS.SHOW_END,
		OPTIONS.ANY,
		proceedToSection1
	);
	FlowManager.getInstance().addRule(rule);
	</code>
	This rule says that for a section with name <code>Intro</code>, when encountering mode <code>SHOW_END</code> (end of the show action), and <code>ANY</code> relationship type, function <code>proceedToSection1</code> needs to be called. And that function simply has:
	<code>
	protected function proceedToSection1 (inSection:IFlowSection) : void {
		FlowManager.getInstance().goto("Sections.Section1", false);
	}
	</code>	
	You will notice that the current section is always passed to the callback function.
	
	<h3>Apply many</h3>
	It is also possible to set a Rule for multiple sections at once. For example:
	<code>
	var rule:FlowRule = new FlowRule (
		null,
		OPTIONS.HIDE,
		OPTIONS.DISTANT|OPTIONS.SIBLING,
		doNotHide
	);
	FM.addRuleForSections (
		rule,
		[AppSettings.SECTION1, AppSettings.SECTION2, AppSettings.SECTION3, AppSettings.SECTION4]
	);
	</code>
	You can define combinations of options using bitwise operators. In the example, <code>OPTIONS.DISTANT|OPTIONS.SIBLING</code> means either a distant relative OR a sibling.
	Function doNotHide simply voids the default behavior:
	<code>
	protected function doNotHide (inSection:IFlowSection) : void {
		// do nothing
	}
	</code>
	
	<h3>Enhancing default behavior</h3>
	As 'man in the middle' you can control what happens before and after a showAction. In the example demo we move the stage right after showing the section. Function <code>moveSection</code> is called because of a Rule:
	<code>
	protected function moveSection (inSection:IFlowSection) : void {
		var x:Number, y:Number;
		switch (inSection.getName()) {
			case AppSettings.SECTION1:
				x = 0; y = 40;
				break;
			// etcetera
		}
		var queue:ActionQueue = moveQueue(x, y); // creates a moving animation as ActionQueue
		FlowManager.getInstance().addAction(inSection.showAction);
		FlowManager.getInstance().addAction(queue);
		}
	</code>
	
	<h2>Automatic loading of missing Sections</h2>
	When a section is not found, FlowManager will try to load it. Right before loading it will dispatch an event with subtype {@link FlowNavigationEvent#WILL_LOAD}. After loading successfully an event with subtype {@link FlowNavigationEvent#LOADED} is sent.
	Note: calls to sections within a to be loaded movie are not supported yet.
	
	<h2>Responding to state changes</h2>
	Before a new state change, an event with subtype {@link FlowNavigationEvent#WILL_UPDATE} is sent. After the transition has been complete, an event with subtype {@link FlowNavigationEvent#UPDATE} is sent.
	
	In the example demo a MenuController listens for state changes. It is subscribed to changes using:
	<code>
	FlowManager.getInstance().addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
	</code>
	The receiving method is:
	<code>
	private function handleNavigationEvent (e:FlowNavigationEvent) : void {
		switch (e.subtype) {
			case FlowNavigationEvent.WILL_UPDATE:
			case FlowNavigationEvent.UPDATE:
				e.stopImmediatePropagation();
				// handle button state
				break;
		}
	}
	</code>
	Because {@link FlowNavigationEvent} events bubble through and other classes may deal with update changes as well, chance is that we get stuck in a recursive loop. We end this by writing <code>e.stopImmediatePropagation();</code>.
	
	<h2>How to start</h2>
	<ul>
		<li>Create a name list of navigatable elements in your Flash site/project.</li>
			<ul>
				<li>I prefer to have a list of consts in <code>data/AppSettings</code>, so when referring to "Intro" I write <code>AppSettings.SECTION_INTRO</code>.</li>
				<li>Section names are hierarchical. Use dots to indicate levels. For example: "Sections.Gallery" and "Sections.Gallery.Latest"</li>
			</ul>
		<li>Normally the main controller for each SWF is a LocalController. Now make it inherit from {@link FlowSection}, and pass the name of the section in the super constructor call.</li>
		<li>Other navigatable sections (like nested MovieClips) also need a {@link FlowSection} class.</li>
		<li>If your main controller is a FlowSection as well, do not forget to make it visible.</li>
		<li>Now write <code>FlowManager.getInstance().goto( "My.starting.section" );</code> (insert your section)</li>
   	</ul>
	*/
	public class FlowManager extends EventDispatcher {
		
		private static var sInstance:FlowManager;
		
		private var mActionRunner:ActionRunner;
		private var mSections:Object; // of type String => IFlowSection
		private var mRules:Object; // of type FlowRule
		private var mCurrentSectionName:String;
		private var mSectionDestinations:Array; // of type SectionNavigationData
		private var mNavigationData:Object; // of type String => SectionNavigationData
		private var mDownloadDirectory:String = "";
		
		/**
		Access point for the one instance of the FlowManager.
		*/
		public static function getInstance () : FlowManager {
			if (sInstance == null) {
				sInstance = new FlowManager();
			}
			return sInstance;
		}
		
		/**
		Registers a {@link FlowRule}.
		@param inRule: FlowRule to register
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
		Applies a {@link FlowRule} to a list of sections.
		@param inRule: FlowRule to register
		@param inSectionNames: list of section names to apply the Rule to
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
		Adds an {@link IAction} to the existing list of actions.
		@param inAction: action to add
		*/
		public function addAction (inAction:IAction) : void {
			if (inAction == null) return;
			mActionRunner.insertAction(inAction);
		}
		
		/**
		Stores FlowSections in a look-up hash. Called by {@link IFlowSection FlowSections}.
		@param inFlowSection: the FlowSection to register
		*/
		public function registerFlowSection (inFlowSection:IFlowSection, inSectionName:String = null) : void {
			var name:String = inSectionName ? inSectionName : inFlowSection.getName();
			mSections[name] = inFlowSection;
		}
			
		/**
		Goes to a new section.
		@param inSectionName: name of the {@link IFlowSection} to move to
		@param inStopEverythingFirst: (optional) whether the current actions are finished first (false) or stopped halfway (true); default: true
		@param inUpdateState: (optional) whether the state is updated when going to the new section. This is not always desirable - for instance showing a navigation bar should not update the state itself. Default: true (state is updated).
		@example
		<code>
		FlowManager.getInstance().goto(button.id);
		</code>
		*/
		public function goto (inSectionName:String, inStopEverythingFirst:Boolean = true, inUpdateState:Boolean = true) : void {
			if (inStopEverythingFirst) {
				reset();
			}
			var sectionNavigationData:SectionNavigationData = new SectionNavigationData(inSectionName, inStopEverythingFirst, inUpdateState);
			mNavigationData[inSectionName] = sectionNavigationData;
			mSectionDestinations.push(sectionNavigationData);
			runNextGoToSection();
		}
		
		/**
		Sets the download directory of to be loaded movies.
		@param inUrl: URL of the directory; by default the current movie directory is used
		*/
		public function setDownloadDirectory (inUrl:String) : void {
			mDownloadDirectory = inUrl;
		}
		
		/**
		Stops all running actions.
		@implementationNote The {@link ActionRunner} is reset
		*/
		protected function reset () : void {
			mActionRunner.reset();
		}
		
		/**
		Gets the {@link IFlowSection} with name inSectionName, if it has been registered.
		@param inSectionName: name of the FlowSection
		@return The found FlowSection
		*/
		public function getSectionByName (inSectionName:String) : IFlowSection {
			return mSections[inSectionName];
		}
		
		/**
		Gets the {@link SectionNavigationData} with name inSectionName, if it has been registered (once {@link #goto} has been called).
		@param inSectionName: name of the FlowSection
		@return The found SectionNavigationData
		*/
		public function getSectionNavigationDataByName (inSectionName:String) : SectionNavigationData {
			return mNavigationData[inSectionName];
		}
		
		/**
		Gets the currently visited {@link IFlowSection}.
		*/
		public function getCurrentSection () : IFlowSection {
			if (mCurrentSectionName == null) return null;
			return mSections[mCurrentSectionName];
		}
		
		/**
		Updates the state with the current section name.
		@param inSectionName: name of the current FlowSection
		@sends FlowNavigationEvent#UPDATE
		*/
		protected function setCurrentSection (inSectionName:String) : void {
			mCurrentSectionName = inSectionName;
			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.UPDATE, mCurrentSectionName, this));
		}
		
		/**
		Gets the name of the currently visited {@link IFlowSection}.
		*/
		public function getCurrentSectionName () : String {
			if (mCurrentSectionName == null) return null;
			return mCurrentSectionName;
		}
		
		/**
		Adds {@link Action Actions} to the ActionRunner's list.
		@param inSectionName: name of the FlowSection
		@param inMode: one of the modes in {@FlowSectionOptions}
		@param inType: one of the types in {@FlowSectionOptions}
		@param inHelper: reference of the used {@link StringNodeHelper}
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
		Returns an Action stored with a FlowRule, if any.
		@param inSectionName: name of the FlowSection
		@param inMode: one of the modes in {@FlowSectionOptions}
		@param inType: one of the types in {@FlowSectionOptions}
		@return Action, or null if no Action was found.
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
		Adds section actions to the ActionRunner and starts the runner.
		@sends FlowNavigationEvent#WILL_UPDATE
		*/
		protected function runNextGoToSection () : void {
						
			var sectionNavigationData:SectionNavigationData = mSectionDestinations.shift();
			if (sectionNavigationData == null) {
				reset();
				return;
			}
			
			var doUpdateState:Boolean = sectionNavigationData.updateState;
			var sectionName:String = sectionNavigationData.name;
						
			var section:IFlowSection = mSections[sectionName];
			if (!section) {
				// not found, try to load first
				loadSection(sectionName);
				return;
			}
			
			var helper:StringNodeHelper = new StringNodeHelper();
			var type:uint = helper.getType(sectionName, mCurrentSectionName);
			
			if (doUpdateState) {
				// hide current section
				addSectionActions( sectionName, FlowSectionOptions.HIDE, type, helper );
				addSectionActions( sectionName, FlowSectionOptions.HIDE_END, type, helper );
			}
			
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
		Tells {@link MovieManager} to load a SWF movie with name inSectionName in the directory set by {@link #setDownloadDirectory} (default the current movie directory). The loaded movie event is processed in {@link #onMovieEvent}.
		@param inSectionName: name of the section and the SWF; a section named 'Sections.Section4' will be loaded as 'Section4.swf'
		@sends FlowNavigationEvent#WILL_LOAD
		*/
		protected function loadSection (inSectionName:String) : void {
			var sectionNameParts:Array = inSectionName.split(".");
			var fileName:String = sectionNameParts[sectionNameParts.length-1];
			if (fileName.length == 0) {
				Log.error("loadSection; trying to load empty file for section: " + inSectionName, toString());
			}
			var url:String = mDownloadDirectory + fileName + ".swf";
			Log.info("loadSection; trying to load file: " + url, toString());
			var mm:MovieManager = MovieManager.getInstance();
			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.WILL_LOAD, inSectionName, this));
			mm.addEventListener( MovieManagerEvent._EVENT, onMovieEvent );
			mm.loadMovie(url, inSectionName);
		}
		
		/**
		Handles MovieManagerEvents.
		@sends FlowNavigationEvent#LOADED
		*/
		protected function onMovieEvent (e:MovieManagerEvent) {
			switch (e.subtype) {
				case MovieManagerEvent.MOVIE_READY:
					if (e.controller is IFlowSection) {
						var section:IFlowSection = IFlowSection(e.controller);
						registerFlowSection(section);
						dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.LOADED, section.getName(), this));
					}
					break;
				case MovieManagerEvent.ERROR:
					dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.LOADING_ERROR, e.name, this));
					break;
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
			mNavigationData = new Object();
		}
		
		override public function toString () : String {
			return ";org.asaplibrary.management.flow.FlowManager";
		}
		
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

