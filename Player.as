package  
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class Player extends MovieClip
	{
		private var model: MovieClip = new PlayerModel();
		public  var glow_model: MovieClip = new Glow();
		public  var hit_detector: MovieClip = new HitDetector_Player();
		public  var explosion_model: MovieClip = new Blink();
		public 	var _bullet: MovieClip = new PlayerBullet();
		
		public  var is_alive: Boolean;
		public  var is_immortal: Boolean = false;
		private var player_is_faded: Boolean = false;
		
		public  var health_max: Number = 3;
		public 	var health: Number = 3;
		public  var mark: String = "player";
		public  var killing_points: Number = 0;
		public 	var bullet_speed: Number = 15;
		public  var damage: Number = 1;
		private var blinks_number: Number = 30;
		
		public 	var player_shooting_timer: Timer;
		private var player_one_blink_timer: Timer = new Timer(100);
		private var player_blinks_timer: Timer = new Timer(blinks_number * player_one_blink_timer.delay, 1);
		
		
		public function Player() 
		{
			addChild(model);
			
			hit_detector.alpha = 0;
			bullet_speed *= -1;
			is_alive = true;
			
			player_shooting_timer = new Timer(700);
			player_shooting_timer.addEventListener(TimerEvent.TIMER, shoot);
			player_shooting_timer.start();
			
			explosion_model.scaleX *= 1.5;
			explosion_model.scaleY *= 1.5;
			explosion_model.gotoAndStop(1);
		}
		
		
		public function shoot(e: TimerEvent): void
		{
			parent.parent.shoot(this);
		}
		

		public function death(): void
		{
			if (contains(model)) removeChild(model);
			is_alive = false;
			player_shooting_timer.stop();
			player_shooting_timer.removeEventListener(TimerEvent.TIMER, shoot);
			explosion_model.addEventListener(Event.COMPLETE, _stop);
			addChild(explosion_model);
			explosion_model.play();
		}
		
		
		private function _stop(e: Event): void
		{
			explosion_model.stop();
			explosion_model.removeEventListener(Event.COMPLETE, _stop);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		

		public function blink(): void
		{
			is_immortal = true;
			player_blinks_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _blink_end);
			player_one_blink_timer.addEventListener(TimerEvent.TIMER, _blink);
			
			player_blinks_timer.start();
			player_one_blink_timer.start();
			
		}
		
		
		private function _blink(e: TimerEvent): void
		{
			switch (player_is_faded)
			{
				case true:
					model.alpha = 1;
					player_is_faded = false;
					break;
				case false:
					model.alpha = 0.1;
					player_is_faded = true;
					break;
			}
		}
		
		
		private function _blink_end(e: TimerEvent): void
		{
			player_blinks_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _blink_end);
			player_one_blink_timer.removeEventListener(TimerEvent.TIMER, _blink);
			model.alpha = 1;
			is_immortal = false;
			player_one_blink_timer.stop();
		}
		
		
		public function freeze(): void
		{
			player_shooting_timer.stop();
		}
		
		
		public function unfreeze(): void
		{
			player_shooting_timer.start();
		}
		
	}
}
