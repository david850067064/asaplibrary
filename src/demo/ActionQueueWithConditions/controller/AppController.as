package demo.ActionQueueWithConditions.controller {
	import fl.controls.Slider;
	import flash.text.TextField;
	import fl.events.SliderEvent;

	import org.asaplibrary.util.actionqueue.*;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class AppController extends MovieClip {
		public var tBox : MovieClip;
		public var tFeedback : TextField;
		public var tSlider : Slider;
		private const SLIDER_START_VALUE : Number = 50;
		private const FADE_DURATION : Number = 1.0;
		private var mFadeQueue : ActionQueue;
		private var mSliderValue : Number;
		private var mSliderReady : Boolean;
		private var mSliderFinal : Boolean;

		function AppController() {
			initUI();
			start();
		}

		private function start() : void {
			tFeedback.text = "";
			resetValues();
			resetStage();
			startFade();
		}

		private function resetValues() : void {
			mSliderFinal = false;
			if (mFadeQueue) mFadeQueue.quit();
		}

		private function resetStage() : void {
			tSlider.alpha = 1;
			tBox.alpha = 1;
			tSlider.value = SLIDER_START_VALUE;
		}

		private function initUI() : void {
			tSlider.addEventListener(SliderEvent.THUMB_RELEASE, sliderDone);
			tSlider.addEventListener(Event.ADDED, setUpSlider);
		}

		private function setUpSlider(e : Event) : void {
			tSlider.removeEventListener(Event.ADDED, setUpSlider);
			tSlider.value = SLIDER_START_VALUE;
			mSliderReady = true;
		}

		private function sliderDone(e : SliderEvent) : void {
			var target : Slider = e.target as Slider;
			mSliderValue = target.value;
			mSliderFinal = true;
		}

		private function startFade() : void {
			mFadeQueue = new ActionQueue();
			
			// wait until the slider is ready
			mFadeQueue.addCondition(new Condition(function() : Boolean {
				return mSliderReady;
			}));
			mFadeQueue.addAction(function() : void {
				tFeedback.appendText("\nPast condition 1 (slider ready)");
			});
			var alpha : Number = SLIDER_START_VALUE / 100;
			mFadeQueue.addAction(new AQFade().fade(tBox, FADE_DURATION, NaN, alpha));
			mFadeQueue.addCondition(new Condition(function() : Boolean {
				return mSliderFinal;
			}));
			mFadeQueue.addAction(function() : void {
				tFeedback.appendText("\nPast condition 2 (slider final value set)");
			});
			mFadeQueue.addAction(finishFade);
			tFeedback.appendText("ActionQueue started");
			mFadeQueue.run();
		}

		private function finishFade() : void {
			var alpha : Number = mSliderValue / 100;
			mFadeQueue.addAction(new AQFade().fade(tBox, FADE_DURATION, NaN, alpha));
			mFadeQueue.addAction(new AQFade().fade(tSlider, FADE_DURATION, NaN, 0));
			mFadeQueue.addPause(1.5);
			mFadeQueue.addAction(start);
		}
	}
}
