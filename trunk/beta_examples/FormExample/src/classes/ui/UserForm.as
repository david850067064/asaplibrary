package ui {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.asaplibrary.data.xml.ServiceEvent;
	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.ui.buttons.HilightButton;
	import org.asaplibrary.ui.form.components.InputField;
	import org.asaplibrary.ui.form.focus.FocusManager;
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.validation.IHasError;
	import org.asaplibrary.util.validation.IValidationRule;
	import org.asaplibrary.util.validation.Validator;
	import org.asaplibrary.util.validation.rules.EmailValidationRule;
	import org.asaplibrary.util.validation.rules.EmptyStringValidationRule;
	
	import data.UserFormService;	

	/**
	 * @author stephan.bezoen
	 */
	public class UserForm {
		private var tFirstName : InputField;
		private var tLastName : InputField;
		private var tEmail : InputField;
		private var tSubmit : HilightButton;
		private var tError : TextField;

		private var mContainer : MovieClip;
		private var mValidator : Validator;
		private var mIsAutoValidate : Boolean;
		private var mFields : Array;
		private var mService : UserFormService;
		private var mFocusManager : FocusManager;

		public function UserForm (inContainer:MovieClip) {
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
			
			tFirstName.text = "";
			tLastName.text = "";
			tEmail.text = "";
			
			mFocusManager.setFocus(tFirstName);
		}

		private function initUI() : void {
			// get UI components
			tFirstName = mContainer.tFirstName;
			tLastName = mContainer.tLastName;
			tEmail = mContainer.tEmail;
			tSubmit = mContainer.tSubmit;
			tError = mContainer.tError;
			
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
			
			// event handling
			tSubmit.addEventListener(MouseEvent.CLICK, handleSubmit);
			
			var leni : uint = mFields.length;
			for (var i:uint = 0; i < leni; i++) {
				(mFields[i] as InputField).addEventListener(Event.CHANGE, handleInputChange);
			}
			
			reset();
		}
		
		private function handleInputChange(e : Event) : void {
			if (mIsAutoValidate) validate(false);
		}

		private function handleSubmit(e : MouseEvent) : void {
			mIsAutoValidate = true;
			
			validate(true);
		}

		private function validate (inPostForm:Boolean) : void {
			clearErrors();
			
			var errors:Array = mValidator.validate();
			
			var leni : uint = errors.length;
			for (var i:uint = 0; i < leni; i++) {
				var rule : IValidationRule = errors[i];
				var target : IHasError = rule.getTarget() as IHasError;
				if (target) target.showError();
			}
			
			if (leni > 0) showError("Not all fields have been filled in properly.");
			else if (inPostForm) postForm();
		}
		
		private function postForm() : void {
			var o:Object = new Object();
			o.firstname = tFirstName.text;
			o.lastname = tLastName.text;
			o.email = tEmail.text;
			
			mService.postUserForm(o);
		}

		private function handleServiceEvent(e : ServiceEvent) : void {     
			if ((e.subtype == ServiceEvent.LOAD_ERROR) || (e.subtype == ServiceEvent.LOAD_ERROR)) { 
				Log.error("Server error: message = " + e.error, toString());
				showError("Something went wrong with the server. Try again later.");
				return;
			}
			
			if (e.subtype != ServiceEvent.COMPLETE) return;
			
			showError("All went well.");
		}
		
		private function showError(inMessage:String) : void {
			tError.text = inMessage;
			tError.visible = true;
		}

		private function clearErrors() : void {
			var leni : uint = mFields.length;
			for (var i:uint = 0; i < leni; i++) {
				(mFields[i] as IHasError).hideError();
			}
			
			tError.visible = false;
		}
		
		public function toString():String {
			return "; com.lostboys.ui.form.UserForm ";
		}
	}
}
