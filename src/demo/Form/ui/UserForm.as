package demo.Form.ui {
	import demo.Form.data.UserFormService;

	import org.asaplibrary.data.xml.ServiceEvent;
	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.ui.buttons.HilightButton;
	import org.asaplibrary.ui.form.components.InputField;
	import org.asaplibrary.ui.form.components.RadioGroup;
	import org.asaplibrary.ui.form.components.SimpleCheckBox;
	import org.asaplibrary.ui.form.focus.FocusManager;
	import org.asaplibrary.util.KeyMapper;
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.validation.IHasError;
	import org.asaplibrary.util.validation.IValidationRule;
	import org.asaplibrary.util.validation.Validator;
	import org.asaplibrary.util.validation.rules.BooleanValidationRule;
	import org.asaplibrary.util.validation.rules.EmailValidationRule;
	import org.asaplibrary.util.validation.rules.EmptyStringValidationRule;
	import org.asaplibrary.util.validation.rules.NullValidationRule;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author stephan.bezoen
	 */
	public class UserForm {
		private var tFirstName : InputField;
		private var tLastName : InputField;
		private var tEmail : InputField;
		private var tSubmit : HilightButton;
		private var tError : TextField;
		private var tMale : SimpleCheckBox;
		private var tFemale : SimpleCheckBox;
		private var tTerms : SimpleCheckBox;
		private var mContainer : MovieClip;
		private var mValidator : Validator;
		private var mIsAutoValidate : Boolean;
		/** objects of type InputField */
		private var mFields : Array;
		private var mService : UserFormService;
		private var mFocusManager : FocusManager;
		private var mGenderGroup : RadioGroup;
		private var mKeyMapper : KeyMapper;

		public function UserForm(inContainer : MovieClip) {
			mContainer = inContainer;

			mService = new UserFormService();
			mService.addEventListener(ServiceEvent._EVENT, handleServiceEvent);

			initUI();
		}

		/**
		 * Reset form
		 */
		public function reset() : void {
			mIsAutoValidate = false;
			tError.visible = false;

			tFirstName.reset();
			tLastName.reset();
			tEmail.reset();
			mGenderGroup.reset();
			tTerms.reset();

			mFocusManager.setFocus(tFirstName);
		}

		private function initUI() : void {
			// get UI components
			tFirstName = mContainer.tFirstName;
			tLastName = mContainer.tLastName;
			tEmail = mContainer.tEmail;
			tSubmit = mContainer.tSubmit;
			tError = mContainer.tError;
			tMale = mContainer.tMale;
			tFemale = mContainer.tFemale;
			tTerms = mContainer.tTerms;

			// set hints
			tFirstName.hintText = "First name";
			tFirstName.hintTextColor = 0x888888;
			tLastName.hintText = "Last name";
			tLastName.hintTextColor = 0x888888;
			tEmail.hintText = "Email";
			tEmail.hintTextColor = 0x888888;

			// create radio group for gender
			mGenderGroup = new RadioGroup();
			mGenderGroup.addButton(tMale, "m");
			mGenderGroup.addButton(tFemale, "f");

			// aggregate all input fields
			mFields = [tFirstName, tLastName, tEmail];

			// focus management
			mFocusManager = new FocusManager(LocalController.globalStage);
			mFocusManager.addElement(tFirstName);
			mFocusManager.addElement(tLastName);
			mFocusManager.addElement(tEmail);

			// validation
			mValidator = new Validator();
			mValidator.addValidationRule(new EmptyStringValidationRule(tFirstName));
			mValidator.addValidationRule(new EmptyStringValidationRule(tLastName));
			mValidator.addValidationRule(new EmailValidationRule(tEmail));
			mValidator.addValidationRule(new NullValidationRule(mGenderGroup));
			mValidator.addValidationRule(new BooleanValidationRule(tTerms));

			// event handling
			var leni : uint = mFields.length;
			for (var i : uint = 0; i < leni; i++) {
				(mFields[i] as InputField).addEventListener(Event.CHANGE, handleInputChange);
			}
			mGenderGroup.addEventListener(Event.CHANGE, handleInputChange);
			tTerms.addEventListener(MouseEvent.CLICK, handleInputChange);

			tSubmit.addEventListener(MouseEvent.CLICK, handleSubmit);

			// key handling
			mKeyMapper = new KeyMapper(LocalController.globalStage);
			mKeyMapper.setMapping(Keyboard.ENTER, handleSubmit, KeyboardEvent.KEY_UP);

			reset();
		}

		private function handleInputChange(e : Event) : void {
			if (mIsAutoValidate) validate(false);
		}

		private function handleSubmit(e : MouseEvent = null) : void {
			mIsAutoValidate = true;

			validate(true);
		}

		private function validate(inPostForm : Boolean) : void {
			clearErrors();

			var errors : Array = mValidator.validate();

			var leni : uint = errors.length;
			for (var i : uint = 0; i < leni; i++) {
				var rule : IValidationRule = errors[i];
				var target : IHasError = rule.getTarget() as IHasError;
				if (target) target.showError();
			}

			if (leni > 0) showError("Not all fields have been filled in properly.");
			else if (inPostForm) postForm();
		}

		private function postForm() : void {
			var o : Object = new Object();
			o.firstname = tFirstName.text;
			o.lastname = tLastName.text;
			o.email = tEmail.text;
			o.gender = mGenderGroup.getValue();
			o.agreetoterms = tTerms.isSelected() ? "1" : "0";

			Log.debug("Posting form with following data:", toString());
			for (var s:String in o) {
				Log.debug("\t" + s + " = " + o[s], toString());
			}
			mService.postUserForm(o);
		}

		private function handleServiceEvent(e : ServiceEvent) : void {
			if ((e.subtype == ServiceEvent.LOAD_ERROR) || (e.subtype == ServiceEvent.PARSE_ERROR)) {
				Log.error("Server error: message = " + e.error, toString());
				showError("Something went wrong with the server. Try again later.");
				return;
			}

			if (e.subtype != ServiceEvent.COMPLETE) return;

			reset();

			showError("All went well.");
		}

		private function showError(inMessage : String) : void {
			tError.text = inMessage;
			tError.visible = true;
		}

		private function clearErrors() : void {
			var targets : Array = mValidator.getTargets();

			var leni : uint = targets.length;
			for (var i : uint = 0; i < leni; i++) {
				// treat target as IHasError, despite the fact that they were added as IValidatable
				var iha : IHasError = targets[i];
				if (iha) iha.hideError();
			}

			tError.visible = false;
		}

		public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
