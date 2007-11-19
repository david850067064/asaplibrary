package ui {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;	

	public class Particle extends Sprite {
	
		private var mParticle:Shape;
		private var mParticleTimer:Timer;
		private var mParticleVelocity:Number;
		private var mX:Number;
		private var mY:Number;
		private var mRadius:Number;
		private var GRAVITY:Number = .1;
		private var mVx:Number;
		private var mVy:Number;
		private var mColor:Number;
		private var mStartTime:Number;
		private var FADE_OUT_DURATION:Number = 3;
		
		public function Particle (inX:Number, inY:Number, inColor:Number) {
			
			mParticle = new Shape();
			mParticleVelocity = 5 - Math.random() * 10;
			mX = inX;
			mY = inY;
			mVx = 2 - (Math.random() * 4);
			mVy = -(Math.random() * 4);
			mColor = inColor;
			mRadius = .5 + Math.random() * .5;
			
			mParticleTimer = new Timer(30);
			mParticleTimer.addEventListener(TimerEvent.TIMER, moveParticle);
			mParticleTimer.start();
			mStartTime = getTimer();
		}
		
		private function moveParticle(event:TimerEvent) : void {
				
			mVy += GRAVITY;
			mY += mVy;
			mX += mVx;
			
			var timePassed:Number = (getTimer() - mStartTime) / 1000; // in seconds
			var alpha:Number = (timePassed < FADE_OUT_DURATION) ? (FADE_OUT_DURATION - timePassed) / FADE_OUT_DURATION : 0;
			createParticleShape(alpha);
			
			if (mY > stage.stageHeight + 20) {
				mParticleTimer.stop();
				removeChild(mParticle);
				delete this;
			}
		}
		
		private function createParticleShape(inAlpha:Number) : void {
			mParticle.graphics.clear();	
			mParticle.graphics.lineStyle(0, mColor, inAlpha);
			mParticle.graphics.drawCircle(mX, mY, mRadius);
			var blur:Number = 6 + Math.random() * 6;
			mParticle.filters = [new GlowFilter(mColor, inAlpha, blur, blur, 2, BitmapFilterQuality.MEDIUM)];
			addChild(mParticle);
		}
	}
}
