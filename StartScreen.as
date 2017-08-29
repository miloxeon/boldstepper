package  
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class StartScreen extends Layerable
	{
		private var black: 			  MovieClip = new Black();
		
		private var rainbow: 		  MovieClip = new Start_BackGlow();
		private var sign: 			  MovieClip = new Start_Sign();
		private var sign_glow: 		  MovieClip = new Start_SignGlow();
		private var start_label: 	  MovieClip = new Start_Start();
		private var start_label_glow: MovieClip = new Start_StartGlow();
		
		private var stars: 			  ScrollingStars = new ScrollingStars(10);
		
		private var blink_timer: Timer;
		private var rainbow_move_factor: Number = 0.1;
		
		
		public function StartScreen()
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			stars_layer.addChild(stars);
			stars.startScrolling();
			
			glow_layer.addChild(rainbow);
			rainbow.alpha = 0.4;
			
			glow_layer.addChild(sign_glow);
			sign_glow.x = getCenterCoordinates(sign_glow);
			sign_glow.y = 145;
			
			glow_layer.addChild(start_label_glow);
			start_label_glow.x = getCenterCoordinates(start_label_glow);
			start_label_glow.y = 743;
			start_label_glow.alpha = 0.5;
			
			front_layer.addChild(sign);
			sign.x = sign_glow.x;
			sign.y = sign_glow.y;
			
			front_layer.addChild(start_label);
			start_label.x = start_label_glow.x;
			start_label.y = start_label_glow.y;
			
			addChild(black);
			displayLayers();
			
			sign.addEventListener(Event.ENTER_FRAME, pulse_sign);
			start_label.addEventListener(Event.ENTER_FRAME, pulse_start_label);
			rainbow.addEventListener(Event.ENTER_FRAME, move_rainbow);
			
			blink_timer = new Timer(100);
			blink_timer.addEventListener(TimerEvent.TIMER, blinkRandomly);
			blink_timer.start();
			
			start_label_glow.addEventListener(TouchEvent.TOUCH_BEGIN, START_GAME);
			start_label.addEventListener(TouchEvent.TOUCH_BEGIN, START_GAME);
		}
		
		

		private function START_GAME(e: TouchEvent): void
		{
			stars.stopScrolling();
			
			start_label_glow.removeEventListener(TouchEvent.TOUCH_BEGIN, START_GAME);
			start_label.removeEventListener(TouchEvent.TOUCH_BEGIN, START_GAME);
			sign.removeEventListener(Event.ENTER_FRAME, pulse_sign);
			sign.removeEventListener(Event.ENTER_FRAME, _sign_pulse_out);
			sign.removeEventListener(Event.ENTER_FRAME, _sign_pulse_in);
			start_label.removeEventListener(Event.ENTER_FRAME, pulse_start_label);
			start_label.removeEventListener(Event.ENTER_FRAME, _start_label_pulse_out);
			start_label.removeEventListener(Event.ENTER_FRAME, _start_label_pulse_in);
			rainbow.removeEventListener(Event.ENTER_FRAME, move_rainbow);
			blink_timer.removeEventListener(TimerEvent.TIMER, blinkRandomly);
			blink_timer.stop();
			
			stars_layer.removeChild(stars);
			glow_layer.removeChild(rainbow);
			glow_layer.removeChild(sign_glow);
			glow_layer.removeChild(start_label_glow);
			front_layer.removeChild(sign);
			front_layer.removeChild(start_label);
			removeChild(black);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function move_rainbow(e: Event): void
		{
			if (rainbow.y <= -10 || rainbow.y >= 10)
			{
				rainbow_move_factor *= -1;
			}
			rainbow.y += rainbow_move_factor;
		}
		
		
		
		private function pulse_sign(e: Event): void
		{
			sign_glow.alpha = (sign.scaleX - 1) * 9;
	
			if (sign.scaleX <= 1)
			{
				sign.removeEventListener(Event.ENTER_FRAME, _sign_pulse_out);
				sign.addEventListener(Event.ENTER_FRAME, _sign_pulse_in);
			}
			else if (sign.scaleX >= 1.06)
			{
				sign.removeEventListener(Event.ENTER_FRAME, _sign_pulse_in);
				sign.addEventListener(Event.ENTER_FRAME, _sign_pulse_out);
			}
		}
		
		
		private function _sign_pulse_in(e: Event): void
		{
			sign.scaleX *= 1.001;
			sign.scaleY = sign.scaleX;
			
			sign_glow.scaleX = sign.scaleX;
			sign_glow.scaleY = sign.scaleY;
			
			sign_glow.x = getCenterCoordinates(sign_glow);
			sign.x = sign_glow.x;
			sign.y -= 0.25;
		}
		
		
		private function _sign_pulse_out(e: Event): void
		{
			sign.scaleX /= 1.001;
			sign.scaleY = sign.scaleX;
			
			sign_glow.scaleX = sign.scaleX;
			sign_glow.scaleY = sign.scaleY;
			
			sign_glow.x = getCenterCoordinates(sign_glow);
			sign.x = sign_glow.x;
			sign.y += 0.25;
		}
		
		
		
		private function pulse_start_label(e: Event): void
		{
			start_label_glow.alpha = 0.1 + (start_label.scaleX - 1) * 3;
			
			if (start_label.scaleX <= 1)
			{
				start_label.removeEventListener(Event.ENTER_FRAME, _start_label_pulse_out);
				start_label.addEventListener(Event.ENTER_FRAME, _start_label_pulse_in);
			}
			else if (start_label.scaleX >= 1.1)
			{
				start_label.removeEventListener(Event.ENTER_FRAME, _start_label_pulse_in);
				start_label.addEventListener(Event.ENTER_FRAME, _start_label_pulse_out);
			}
		}
		
		
		private function _start_label_pulse_in(e: Event): void
		{
			start_label.scaleX *= 1.01;
			start_label.scaleY = start_label.scaleX;
			
			start_label_glow.scaleX = start_label.scaleX;
			start_label_glow.scaleY = start_label.scaleY;
			
			start_label_glow.x = getCenterCoordinates(start_label_glow);
			start_label.x = start_label_glow.x;
			start_label.y -= 0.25;
		}
		
		
		private function _start_label_pulse_out(e: Event): void
		{
			start_label.scaleX /= 1.01;
			start_label.scaleY = start_label.scaleX;
			
			start_label_glow.scaleX = start_label.scaleX;
			start_label_glow.scaleY = start_label.scaleY;
			
			start_label_glow.x = getCenterCoordinates(start_label_glow);
			start_label.x = start_label_glow.x;
			start_label.y += 0.25;
		}
		
		
		private function blinkRandomly(e: TimerEvent): void
		{
			function _remove_blink(e: Event): void
			{
				if (blink.stage) glow_layer.removeChild(blink);
				blink.removeEventListener(Event.COMPLETE, _remove_blink);
			}
			
			
			var blink: Blinker;
			var blink_x: Number = (sign.x - 50) + (sign.x + sign.width + 50) * Math.random();
			var blink_y: Number = (sign.y - 50) + (sign.y + sign.height + 50) * Math.random();
				
			blink = new Blinker(blink_x, blink_y);
			blink.alpha = 0.5;
			blink.addEventListener(Event.COMPLETE, _remove_blink);
			glow_layer.addChild(blink);
		}
		
	}
}
