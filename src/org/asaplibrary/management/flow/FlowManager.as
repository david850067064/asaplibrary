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
  * Enables to navigate a multi-part Flash movie using the principle of deep links. 
  * Uses {@link LocalController} subclass {@link FlowSection} to identify movie "sections". 
  * The syntax to go to a new section is simply:
  * <code>
  * FlowManager.defaultFlowManager.goto("Intro");
  * </code>
  * See {@link FlowManager} for usage details.
  */
package org.asaplibrary.management.flow {
	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.util.actionqueue.*;
	import org.asaplibrary.util.debug.Log;

	import flash.events.*;
	import flash.utils.getQualifiedClassName;

	/**
	Enables to navigate a multi-part Flash movie using the principle of deep links.
	
	<h2>Introduction</h2>
	Flow states are represented by site 'sections', using the {@link IFlowSection} type.
	
	{@link FlowSection} inherits from {@link LocalController}, but can be assigned to any MovieClip in the site that needs to be navigated to.
	FlowManager registers FlowSections and uses their names to build a tree-like structure.
	
	The syntax to go to a new section is simply:
	<code>
	FlowManager.defaultFlowManager.goto("Intro");
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
	When going from 'Sections.Section1' to 'Sections.Section2', FlowManager will detect that this is a sibling relationship. The possible types of relationships are defined in {@link FlowOptions}.
	
	You may also use a dot to indicate a level. In the next list the Section items have a higher depth than Intro:
	<code>
	public static const SECTION_INTRO:String = "Intro";
	public static const SECTION1:String      = ".Section1";
	public static const SECTION1_1:String    = ".Section1.Section1_1";
	public static const SECTION2:String      = ".Section2";
	</code>
	This is useful when you want to let FlowManager automatically load movies based on the section names. 
	
	<h2>Starting and stopping, or showing and hiding</h2>
	The default behavior for <code>start</code> is setting the visibility to true; for <code>stop</code> to set it to false.
	
	Start and stop are called from the 2 base functions {@link FlowSection#startAction} and {@link FlowSection#stopAction}. You can override the default behavior of these methods in a subclass.
	
	When traversing from one section to the other, it depends if <code>startSection</code> or <code>stopSection</code> is called. When going to a child section, <code>stop</code> will not called on the current section. When going to a sibling section, the current stop <em>will</em> be called, and right after <code>start</code>.
	
	Each startAction and stopAction function may return a {@link IAction} or a subclass thereof, including an {@link ActionQueue}. Any animation is processed sequentially - an ActionQueue is first finished before the next Action is called.
	
	In the example demo one of the sections overrides the default startAction - it lets the clip scale from small to large in a elastic manner:
	<code>
	public override function get startAction () : IAction {
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
	Sometimes it is desired to manage these start and stop actions from a higher level.  For example after the intro animation we want to go to section 1.
	To do this Rules can be defined.

	Rules are created with the {@link FlowRule} class:
	<code>
	var rule:FlowRule = new FlowRule (
	"Intro",
	OPTIONS.START_END,
	OPTIONS.ANY,
	proceedToSection1
	);
	FlowManager.defaultFlowManager.addRule(rule);
	</code>
	This rule says that for a section with name <code>Intro</code>, when encountering mode <code>START_END</code> (end of the start action), and <code>ANY</code> relationship type, function <code>proceedToSection1</code> needs to be called. And that function simply has:
	<code>
	protected function proceedToSection1 (inSection:IFlowSection) : void {
	FlowManager.defaultFlowManager.goto("Sections.Section1", this, false);
	}
	</code>	
	You will notice that the current section is always passed to the callback function.
	
	<h3>Apply many</h3>
	It is also possible to set a Rule for multiple sections at once. For example:
	<code>
	var rule:FlowRule = new FlowRule (
	null,
	OPTIONS.STOP,
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
	As 'man in the middle' you can control what happens before and after a startAction. In the example demo we move the stage right after starting the section. Function <code>moveSection</code> is called because of a Rule:
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
	FlowManager.defaultFlowManager.addAction(inSection.startAction);
	FlowManager.defaultFlowManager.addAction(queue);
	}
	</code>
	
	<h2>Automatic loading of missing Sections</h2>
	When a section is not found, FlowManager will try to load it. Right before loading it will dispatch an event with subtype {@link FlowNavigationEvent#WILL_LOAD}. After loading successfully an event with subtype {@link FlowNavigationEvent#LOADED} is sent.
	
	You may even navigate to a section within a to-be-loaded movie. After loading you can proceed to the nested section by using the <code>destination</code> property of the incoming FlowNavigationEvent.
	<code>
	protected function attachMovie (e:FlowNavigationEvent) : void {
	if (section != null) {
	// add child clip...
	FlowManager.defaultFlowManager.goto(e.destination);
	}
	}
	</code>
	
	Note: calls to sections within a to be loaded movie are not supported yet.
	
	<h2>Responding to state changes</h2>
	Before a new state change, an event with subtype {@link FlowNavigationEvent#WILL_UPDATE} is sent. After the transition has been complete, an event with subtype {@link FlowNavigationEvent#UPDATE} is sent.
	
	In the example demo a MenuController listens for state changes. It is subscribed to changes using:
	<code>
	FlowManager.defaultFlowManager.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);
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
	<li>Now write <code>FlowManager.defaultFlowManager.goto( "My.starting.section" );</code> (insert your section)</li>
	</ul>
	 */
	public class FlowManager extends EventDispatcher {
		private static var sDefaultFlowManager : FlowManager;
		/**
		Identifier name, used for debugging.
		 */
		private var mName : String;
		private var mActionRunner : ActionRunner;
		private var mSections : Object;
		// of type String => IFlowSection
		private var mRules : Object;
		// of type FlowRule
		private var mCurrentSectionName : String;
		private var mSectionDestinations : Array;
		// of type FlowNavigationData
		private var mNavigationData : Object;
		// of type String => FlowNavigationData
		private var mDownloadDirectory : String = "";
		private var mDownloadSections : Object;

		// of type String => DownloadSection
		/**
		Creates a new FlowManager. Use only when you need a custom FlowManager instance. For default use, call {@link #defaultFlowManager}.
		@param inName: (optional) identifier name of this FlowManager - used for debugging
		 */
		function FlowManager(inName : String = "Anonymous FlowManager") {
			super();
			if (inName != null) {
				mName = inName;
			}
			init();
		}

		/**
		Initializes variables.
		 */
		protected function init() : void {
			mActionRunner = new ActionRunner("FlowManager");
			mActionRunner.addEventListener(ActionEvent._EVENT, handleActionRunnerEvent);
			mSections = new Object();
			mRules = new Object();
			mSectionDestinations = new Array();
			mNavigationData = new Object();
			mDownloadSections = new Object();
		}

		override public function toString() : String {
			return getQualifiedClassName(this) + mName;
		}

		/**
		@return The default global instance of the FlowManager.
		 */
		public static function get defaultFlowManager() : FlowManager {
			if (sDefaultFlowManager == null) {
				sDefaultFlowManager = new FlowManager("Default FlowManager");
			}
			return sDefaultFlowManager;
		}

		/**
		Registers a {@link FlowRule}.
		@param inRule: FlowRule to register
		 */
		public function addRule(inRule : FlowRule) : void {
			var sectionName : String = inRule.name;
			if (mRules[sectionName] == null) {
				mRules[sectionName] = new Object();
			}
			var mode : uint = inRule.mode;
			mRules[sectionName][mode] = inRule;
		}

		/**
		Applies a {@link FlowRule} to a list of sections.
		@param inRule: FlowRule to register
		@param inSectionNames: list of section names to apply the Rule to
		 */
		public function addRuleForSections(inRule : FlowRule, inSectionNames : Array) : void {
			if (inRule == null || inSectionNames == null) return;
			var i : uint, ilen : uint = inSectionNames.length;
			for (i = 0; i < ilen; ++i) {
				var rule : FlowRule = inRule.copy();
				rule.name = inSectionNames[i];
				addRule(rule);
			}
		}

		/**
		Adds an {@link IAction} to the existing list of actions.
		@param inAction: action to add
		 */
		public function addAction(inAction : IAction) : void {
			if (inAction == null) return;
			mActionRunner.insertAction(inAction);
		}

		/**
		Stores FlowSections in a look-up hash. Called by {@link IFlowSection FlowSections}.
		@param inFlowSection: the FlowSection to register
		 */
		public function registerFlowSection(inFlowSection : IFlowSection, inSectionName : String = null) : void {
			var name : String = inSectionName ? inSectionName : inFlowSection.getName();
			mSections[name] = inFlowSection;
		}

		/**
		Goes to a new section.
		@param inSectionName: name of the {@link IFlowSection} to move to
		@param inStopEverythingFirst: (optional) whether the current actions are finished first (false) or stopped halfway (true); default: true
		@param inUpdateState: (optional) whether the state is updated when going to the new section. This is not always desirable - for instance showing a navigation bar should not update the state itself. Default: true (state is updated).
		@example
		To show section "Gallery", write:
		<code>
		FlowManager.defaultFlowManager.goto("Gallery");
		</code>
		If you want to track the object or button that causes the goto call, add parameter <code>inTrigger</code>:
		<code>
		FlowManager.defaultFlowManager.goto("Gallery", gallery_btn);
		</code>
		To continue all current animations, set parameter <code>inStopEverythingFirst</code> to true:
		<code>
		FlowManager.defaultFlowManager.goto("Gallery", gallery_btn, true);
		</code>
		To prevent sending out a state update, set parameter <code>inUpdateState</code> to false:
		<code>
		FlowManager.defaultFlowManager.goto("Gallery", gallery_btn, true, false);
		</code>
		 */
		public function goto(inSectionName : String, inTrigger : Object = null, inStopEverythingFirst : Boolean = true, inUpdateState : Boolean = true) : void {
			if (inStopEverythingFirst) {
				reset();
			}
			var sectionNavigationData : FlowNavigationData = new FlowNavigationData(inSectionName, inTrigger, inStopEverythingFirst, inUpdateState);
			mNavigationData[inSectionName] = sectionNavigationData;
			mSectionDestinations.push(sectionNavigationData);
			runNextGoToSection();
		}

		/**
		Removes a FlowSection from the list. If the section was loaded, it will be removed.
		@param inSectionName: name of the section to remove
		@return True if the section was successfully removed; otherwise false.
		@implementationNote Calls {@link MovieManager#removeMovie}.
		 */
		public function removeSection(inSectionName : String) : Boolean {
			var section : FlowSection = mSections[inSectionName];
			if (section == null) false;
			if (inSectionName == mCurrentSectionName) {
				reset();
			}
			section.die();
			var lc : ILocalController = MovieManager.getInstance().getLocalControllerByName(inSectionName);
			if (lc != null) {
				return MovieManager.getInstance().removeMovie(lc);
			}
			return true;
		}

		/**
		Sets the download directory of to be loaded movies.
		@param inUrl: URL of the directory; by default the current movie directory is used
		 */
		public function setDownloadDirectory(inUrl : String) : void {
			mDownloadDirectory = inUrl;
		}

		/**
		Stops all running actions.
		@implementationNote The {@link ActionRunner} is reset
		 */
		protected function reset() : void {
			mActionRunner.reset();
		}

		/**
		Gets the {@link IFlowSection} with name inSectionName, if it has been registered.
		@param inSectionName: name of the FlowSection
		@return The found FlowSection
		 */
		public function getSectionByName(inSectionName : String) : IFlowSection {
			return mSections[inSectionName];
		}

		/**
		Gets the {@link FlowNavigationData} with name inSectionName, if it has been registered (once {@link #goto} has been called).
		@param inSectionName: name of the FlowSection
		@return The found FlowNavigationData
		@example
		Use the data object to pass on the states after loading a movie:
		<code>
		protected function handleNavigationEvent (e:FlowNavigationEvent) : void {
		e.stopImmediatePropagation();
		switch (e.subtype) {
		case FlowNavigationEvent.LOADED:
		// attach movie...
		var data:FlowNavigationData = FlowManager.defaultFlowManager.getFlowNavigationDataByName(e.name);
		FlowManager.defaultFlowManager.goto(e.destination, data.trigger, data.stopEverythingFirst, data.updateState);
		break;
		}
		}
		</code>
		 */
		public function getFlowNavigationDataByName(inSectionName : String) : FlowNavigationData {
			return mNavigationData[inSectionName];
		}

		/**
		Gets the currently visited {@link IFlowSection}.
		 */
		public function getCurrentSection() : IFlowSection {
			if (mCurrentSectionName == null) return null;
			return mSections[mCurrentSectionName];
		}

		/**
		Updates the state with the current section name.
		@param inSectionName: name of the current FlowSection
		@sends FlowNavigationEvent#UPDATE
		 */
		protected function setCurrentSection(inSectionName : String) : void {
			mCurrentSectionName = inSectionName;

			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.UPDATE, mCurrentSectionName, getNavigationTrigger(inSectionName)));
		}

		/**
		Retrieves the object that has triggered the {@link #goto} call.
		@param inSectionName: name of the FlowSection
		@return The trigger object; if not specified will return FlowManager.
		 */
		protected function getNavigationTrigger(inSectionName : String) : Object {
			var data : FlowNavigationData = getFlowNavigationDataByName(inSectionName);
			if (data != null) {
				return data.trigger;
			}
			return this;
		}

		/**
		Gets the name of the currently visited {@link IFlowSection}.
		 */
		public function getCurrentSectionName() : String {
			if (mCurrentSectionName == null) return null;
			return mCurrentSectionName;
		}

		/**
		Adds {@link Action Actions} to the ActionRunner's list.
		@param inSectionName: name of the FlowSection
		@param inMode: one of the modes in {@FlowOptions}
		@param inType: one of the types in {@FlowOptions}
		@param inHelper: reference of the used {@link StringNodeHelper}
		@return The list of section names that are starting/stopping.
		 */
		protected function getSectionNames(inSectionName : String, inMode : uint, inType : uint, inHelper : StringNodeHelper) : Array {
			var sectionNames : Array = new Array();
			if (inMode == FlowOptions.STOP) {
				sectionNames = inHelper.getStopSections(inSectionName, mCurrentSectionName, inType);
			}
			if (inMode == FlowOptions.START) {
				sectionNames = inHelper.getStartSections(inSectionName, mCurrentSectionName, inType);
			}
			return sectionNames;
		}

		protected function addSectionActions(inSectionName : String, inSectionNames : Array, inMode : uint, inType : uint) : void {
			var actions : Array = new Array();
			// see if any FlowRule is defined for this section name
			var action : Action = getRuleAction(inSectionName, inMode, inType);
			if (action != null) {
				actions.push(action);
			}
			if (inSectionNames != null && inSectionNames.length > 0) {
				actions = getSectionActions(inSectionNames, inMode, inType);
			}
			mActionRunner.addActions(actions);
		}

		/**
		Returns an Action stored with a FlowRule, if any.
		@param inSectionName: name of the FlowSection
		@param inMode: one of the modes in {@FlowOptions}
		@param inType: one of the types in {@FlowOptions}
		@return Action, or null if no Action was found.
		 */
		protected function getRuleAction(inSectionName : String, inMode : uint, inType : uint) : Action {
			var rule : FlowRule;
			var action : Action;

			if (mRules[inSectionName] != null) {
				rule = mRules[inSectionName][inMode];
			}
			if (rule != null && (rule.type & inType)) {
				var section : IFlowSection = mSections[inSectionName];
				action = new Action(rule.callback, [section]);
			}
			return action;
		}

		/**
		Called by {@link #addSectionActions}.
		 */
		protected function getSectionActions(inSectionNames : Array, inMode : uint, inType : uint) : Array {
			if (inSectionNames == null || inSectionNames.length == 0) {
				return null;
			}
			var sectionActions : Array = new Array();
			var i : uint, ilen : uint = inSectionNames.length;
			var section : IFlowSection;
			for (i = 0; i < ilen; ++i) {
				var sectionName : String = inSectionNames[i];
				// see if any FlowRule is defined
				var action : IAction = getRuleAction(sectionName, inMode, inType);
				if (action != null) {
					sectionActions.push(action);
					continue;
				}

				// else no rule found for this section name or mode

				section = mSections[sectionName];
				if (section != null) {
					if (inMode == FlowOptions.STOP) {
						// default hide action
						action = section.stopAction;
					}
					if (inMode == FlowOptions.START) {
						// default start action
						action = section.startAction;
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
		@sends FlowNavigationEvent#SECTIONS_STOPPING
		@sends FlowNavigationEvent#SECTIONS_STARTING
		 */
		protected function runNextGoToSection() : void {
			var sectionNavigationData : FlowNavigationData = mSectionDestinations.shift();
			if (sectionNavigationData == null) {
				reset();
				return;
			}

			var sectionName : String = sectionNavigationData.name;
			var doUpdateState : Boolean = sectionNavigationData.updateState;
			var section : IFlowSection = mSections[sectionName];
			var helper : StringNodeHelper = new StringNodeHelper();
			var type : uint = helper.getType(sectionName, mCurrentSectionName);

			if (section == null && sectionName != null) {
				// not found, try to load first
				loadSection(sectionName);
				return;
			}
			var evt : FlowNavigationEvent;
			if (doUpdateState) {
				// hide current section
				var stoppingSections : Array = getSectionNames(sectionName, FlowOptions.STOP, type, helper);

				// dispatch stopping section names, if any, before adding the actions to the list
				if (stoppingSections != null) {
					evt = new FlowNavigationEvent(FlowNavigationEvent.SECTIONS_STOPPING, sectionName, getNavigationTrigger(sectionName));
					evt.stoppingSections = stoppingSections;
					dispatchEvent(evt);
				}

				addSectionActions(sectionName, stoppingSections, FlowOptions.STOP, type);

				var stopEndSections : Array = getSectionNames(sectionName, FlowOptions.STOP_END, type, helper);
				addSectionActions(sectionName, stopEndSections, FlowOptions.STOP_END, type);
			}

			// show new section
			var startingSections : Array = getSectionNames(sectionName, FlowOptions.START, type, helper);
			// dispatch starting sections, if any, before adding the actions to the list
			if (startingSections != null) {
				evt = new FlowNavigationEvent(FlowNavigationEvent.SECTIONS_STARTING, sectionName, getNavigationTrigger(sectionName));
				evt.startingSections = startingSections;
				dispatchEvent(evt);
			}
			addSectionActions(sectionName, startingSections, FlowOptions.START, type);

			var startEndSections : Array = getSectionNames(sectionName, FlowOptions.START_END, type, helper);
			addSectionActions(sectionName, startEndSections, FlowOptions.START_END, type);

			if (doUpdateState) {
				// add state update action
				mActionRunner.addAction(new Action(setCurrentSection, [sectionName]));

				mCurrentSectionName = sectionName;

				dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.WILL_UPDATE, sectionName, getNavigationTrigger(sectionName)));
			}

			if (!mActionRunner.isRunning()) {
				mActionRunner.run();
			}
		}

		/**
		Try to load the section. The section inSectionName may several levels deep. We try to get the first section that has not been registered and download that one first.
		We store the destination in mDownloadSections for the next time {@link #goto} is called with that first section as destination, so we can switch the destination to our actual one.
		@param inSectionName to go to, eventually
		 */
		protected function loadSection(inSectionName : String) : void {
			// find which section needs to be loaded first
			var helper : StringNodeHelper = new StringNodeHelper();
			var sectionParts : Array = helper.getSectionPartsFromName(inSectionName);

			var unregisteredSectionName : String = getFirstUnregisteredSectionName(sectionParts);

			var fileName : String = helper.removeLeadingDots(unregisteredSectionName);
			if (fileName == null) {
				return;
			}

			mDownloadSections[unregisteredSectionName] = new DownloadSection(unregisteredSectionName, inSectionName);

			loadSectionFile(fileName, unregisteredSectionName);
		}

		/**
		
		 */
		protected function getFirstUnregisteredSectionName(inParts : Array) : String {
			// find the first section name not yet registered
			// we know we need to download that one first
			var i : uint, ilen : uint = inParts.length;
			var sectionName : String;
			for (i = 0; i < ilen; ++i) {
				sectionName = inParts[i];
				if (getSectionByName(sectionName) == null) {
					return sectionName;
				}
			}
			return null;
		}

		/**
		Tells {@link MovieManager} to load a SWF movie with name inSectionName in the directory set by {@link #setDownloadDirectory} (default the current movie directory). The loaded movie event is processed in {@link #onMovieEvent}.
		@param inFilePart: part name of the filename; '.swf' will be added
		@param inSectionName: name of the section and the SWF; a section named 'Sections.Section4' will be loaded as 'Section4.swf'
		@param inTargetSectionName: section name to go to after this file has been loaded
		@sends FlowNavigationEvent#WILL_LOAD
		 */
		protected function loadSectionFile(inFilePart : String, inSectionName : String) : void {
			/*
			var sectionNameParts:Array = inSectionName.split(".");
			var fileName:String = sectionNameParts[sectionNameParts.length-1];
			if (fileName.length == 0) {
			Log.error("loadSectionFile; trying to load empty file for section: " + inSectionName, toString());
			}
			 */
			if (inFilePart.length == 0) {
				Log.error("loadSectionFile; trying to load empty file for section: " + inSectionName, toString());
				return;
			}
			var url : String = mDownloadDirectory + inFilePart + ".swf";
			Log.info("loadSectionFile; trying to load file: " + url, toString());
			var mm : MovieManager = MovieManager.getInstance();
			dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.WILL_LOAD, inSectionName, getNavigationTrigger(inSectionName)));
			mm.addEventListener(MovieManagerEvent._EVENT, onMovieEvent);
			mm.loadMovie(url, inSectionName);
		}

		/**
		Handles MovieManagerEvents.
		@sends FlowNavigationEvent#LOADED
		 */
		protected function onMovieEvent(e : MovieManagerEvent) : void {
			switch (e.subtype) {
				case MovieManagerEvent.MOVIE_READY:
					if (e.controller is IFlowSection) {
						// retrieve the destination and pass it to the event
						var destination : String;
						var downloadSection : DownloadSection = mDownloadSections[e.name];
						if (downloadSection != null) {
							destination = downloadSection.destination;
							// void stored data
							mDownloadSections[e.name] = null;
						}
						dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.LOADED, e.name, getNavigationTrigger(e.name), destination));
					}
					break;
				case MovieManagerEvent.ERROR:
					dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.LOADING_ERROR, e.name, getNavigationTrigger(e.name)));
					break;
			}
		}

		/**
		Notifies listeners when the transition actions have been finished.
		@sends FlowNavigationEvent#FINISHED
		 */
		protected function handleActionRunnerEvent(e : ActionEvent) : void {
			switch (e.subtype) {
				case ActionEvent.FINISHED:
					dispatchEvent(new FlowNavigationEvent(FlowNavigationEvent.FINISHED, mCurrentSectionName, getNavigationTrigger(mCurrentSectionName)));
					break;
			}
		}
	}
}
import org.asaplibrary.management.flow.*;

/**
ValueObject for to-be-loaded sections.
 */
class DownloadSection {
	public var name : String;
	public var destination : String;

	function DownloadSection(inName : String, inDestination : String) {
		name = inName;
		destination = inDestination;
	}
}
/**
Helper class to find tree-like relations in node names. For example with these section names:
<code>
Portfolio
Portfolio.Photos
Portfolio.Photos.Detail1
Portfolio.Movies
</code>
... StringNodeHelper will define that going from 'Portfolio.Photos' to 'Portfolio.Movies' is a SIBLING relationship, and going from 'Portfolio.Photos.Detail1' to 'Portfolio.Photos' is a PARENT relationship.

The possible options are listed in {@link FlowOptions}.
 */
class StringNodeHelper {
	/**
	
	 */
	public function getType(inNewSection : String, inCurrentSection : String) : uint {
		if (!inCurrentSection || !inNewSection) {
			return FlowOptions.UNRELATED;
		}

		// equal?
		if (inNewSection == inCurrentSection) {
			return FlowOptions.EQUAL;
		}

		// child?
		if ( isChild(inNewSection, inCurrentSection) ) {
			return FlowOptions.CHILD;
		}

		// parent?
		// (reverse child)
		if ( isChild(inCurrentSection, inNewSection) ) {
			return FlowOptions.PARENT;
		}

		// sibling?
		if ( isSibling(inNewSection, inCurrentSection) ) {
			return FlowOptions.SIBLING;
		}

		// distant relative?
		if ( isDistantRelative(inNewSection, inCurrentSection) ) {
			return FlowOptions.DISTANT;
		}

		return FlowOptions.UNRELATED;
	}

	/**
	
	 */
	public function getStopSections(inNewSection : String, inCurrentSection : String, inType : uint) : Array {
		if (inCurrentSection == null || inCurrentSection.length == 0) return null;

		var base : String = getCommonBase(inNewSection, inCurrentSection);

		var stopSections : Array = new Array();

		var baseDepth : uint = 0;
		if (base != null) {
			baseDepth = base.split(".").length;
		}
		switch (inType) {
			case FlowOptions.CHILD:
				// do nothing
				break;
			case FlowOptions.PARENT:
				// hide current up to base
				stopSections = stopSections.concat(getSectionNamesBackward(inCurrentSection, baseDepth));
				break;
			case FlowOptions.SIBLING:
				// hide current section
				stopSections.push(inCurrentSection);
				break;
			case FlowOptions.DISTANT:
			case FlowOptions.UNRELATED:
				// hide current up to base
				stopSections = stopSections.concat(getSectionNamesBackward(inCurrentSection, baseDepth));
				break;
			default:
			//
		}
		return stopSections;
	}

	/**
	
	 */
	public function getStartSections(inNewSection : String, inCurrentSection : String, inType : uint) : Array {
		if (inNewSection == null || inNewSection.length == 0) return null;

		var base : String = getCommonBase(inNewSection, inCurrentSection);
		var startSections : Array = new Array();

		var startDepth : uint = 0;
		if (base != null) {
			startDepth = base.split(".").length + 1;
		}
		switch (inType) {
			case FlowOptions.CHILD:
				// show current up to new
				startSections = startSections.concat(getSectionNamesForward(inNewSection, startDepth));
				break;
			case FlowOptions.PARENT:
				// do nothing
				break;
			case FlowOptions.SIBLING:
				// show new
				startSections.push(inNewSection);
				break;
			case FlowOptions.DISTANT:
			case FlowOptions.UNRELATED:
				// show base up to new
				startSections = startSections.concat(getSectionNamesForward(inNewSection, startDepth));
				break;
			default:
			//
		}
		return startSections;
	}

	/**
	Creates a list of section names. if inSectionName is "Portfolio.Photos.Detail1" this will return a list of:
	["Portfolio", "Portfolio.Photos", "Portfolio.Photos.Detail1"].
	 */
	public function getSectionPartsFromName(inSectionName : String) : Array {
		if (inSectionName == null || inSectionName.length == 0) return null;
		const SEPARATOR : String = ".";
		var parts : Array = inSectionName.split(SEPARATOR);
		var outParts : Array = new Array();
		var base : String = "";
		var i : uint, ilen : uint = parts.length;
		for (i = 0; i < ilen; ++i) {
			var partName : String = parts[i];
			if (i > 0) {
				base += SEPARATOR;
			}
			base += partName;
			if (partName.length > 0) {
				outParts.push(base);
			}
		}
		return outParts;
	}

	/**
	Removes potential dot chars from the beginning of a name.
	@param inName: raw string that potentially has leading dots
	 */
	public function removeLeadingDots(inName : String) : String {
		var re : RegExp = /\.?(.*?)$/;
		var result : Object = re.exec(inName);
		return result[1];
	}

	/**
	@return True if inNewSection is a direct or distant child of inCurrentSection.
	 */
	protected function isChild(inNewSection : String, inCurrentSection : String) : Boolean {
		var re : RegExp = new RegExp("^(" + inCurrentSection + ")($|\.)", "i");
		var result : Object = re.exec(inNewSection);
		if (result != null && result[1] != null ) {
			return true;
		}
		return false;
	}

	/**
	@return True if inNewSection is a distant relative of inCurrentSection (they have a common base).
	 */
	protected function isDistantRelative(inNewSection : String, inCurrentSection : String) : Boolean {
		var base : String = getCommonBase(inNewSection, inCurrentSection);
		return (base != null);
	}

	/**
	@return True if inNewSection is a direct sibling of inCurrentSection.
	 */
	protected function isSibling(inNewSection : String, inCurrentSection : String) : Boolean {
		var pattern : String = "^(.*)\\.";
		var reNew : RegExp = new RegExp(pattern, "i");
		var resultNew : Object = reNew.exec(inNewSection);
		var reCurrent : RegExp = new RegExp(pattern, "i");
		var resultCurrent : Object = reCurrent.exec(inCurrentSection);

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
	protected function getCommonBase(inNewSection : String, inCurrentSection : String) : String {
		if (inNewSection == null || inCurrentSection == null) {
			return null;
		}
		var partsNew : Array = inNewSection.split(".");
		var partsCurrent : Array = inCurrentSection.split(".");
		var i : uint, ilen : uint = Math.min(partsNew.length, partsCurrent.length);
		var matchDepth : int = -1;
		for (i = 0; i < ilen; ++i) {
			if (partsNew[i] != partsCurrent[i]) {
				break;
			}
			matchDepth = i;
		}
		if (matchDepth == -1) return null;
		return partsCurrent.slice(0, matchDepth + 1).join(".");
	}

	/**
	
	 */
	protected function getSectionNamesBackward(inName : String, inTargetDepth : uint) : Array {
		var sections : Array = new Array();
		var parts : Array = inName.split(".");
		if (parts.length == 0) return null;
		var i : uint = parts.length, min : uint = inTargetDepth;
		while (i > min) {
			if (String(parts[i - 1]).length == 0) {
				i--;
				continue;
			}
			var partsCopy : Array = parts.slice();
			// makes a shallow copy
			partsCopy = partsCopy.slice(0, i);
			// take item 0 to i
			if (partsCopy.length > 0) {
				sections.push(partsCopy.join("."));
			}
			i--;
		}
		return sections;
	}

	/**
	
	 */
	protected function getSectionNamesForward(inName : String, inStartDepth : uint) : Array {
		var sections : Array = new Array();
		var parts : Array = inName.split(".");
		if (parts.length == 0) return null;
		var i : uint = inStartDepth, max : uint = parts.length;
		while (i <= max) {
			var partsCopy : Array = parts.slice();
			// makes a shallow copy
			partsCopy = partsCopy.slice(0, i);
			if (partsCopy.length > 0) {
				sections.push(partsCopy.join("."));
			}
			i++;
		}
		return sections;
	}
}

