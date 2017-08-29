package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Enemy extends MovieClip
	{
		public  var n: Number = 1;
		
		private var model: MovieClip;
		public  var glow_model: MovieClip = new Glow();
		public  var hit_detector: MovieClip = new HitDetector();
		public  var explosion_model: MovieClip = new Blink();
		public var health: Number = 2;
		public var mark: String = "enemy";
		public var killing_points: Number = 85;
		
		public var enemy_x: Number;
		public var enemy_y: Number;
		public var enemy_speed: Number = 1;
		public var _motion: Function;
		
		public var _bullet: MovieClip = new EnemyBullet();
		public var bullet_speed: Number;
		public var enemy_shooting_timer: Timer;
		public var damage: Number = 1;
		
		public var is_playing: Boolean = false;
		public var is_alive: Boolean;
		public var is_immortal: Boolean = false;
		
		
		public function Enemy(model: MovieClip) 
		{
			hit_detector.alpha = 0;
			this.model = model;
			addChild(model)
			
			addEventListener(Event.ENTER_FRAME, _move);
			setMotionPattern("oval");
			enemy_shooting_timer = new Timer(2000);
			enemy_shooting_timer.addEventListener(TimerEvent.TIMER, shoot);
			enemy_shooting_timer.start();
			is_playing = true;
			is_alive = true;
			explosion_model.scaleX *= 1.5;
			explosion_model.scaleY *= 1.5;
			explosion_model.gotoAndStop(1);
		}
		
		
		private function _move(e: Event): void
		{	
			n += enemy_speed;
			_motion();
		}
		
		
		public function setMotionPattern(pattern: String): void
		{
			switch(pattern)
			{
				case "oval":
					_motion = _move_oval;
					break;
				case "circle":
					_motion = _move_circle;
					break;
				case "move_8":
					_motion = _move_8;
					break;
				default:
					_motion = _move_oval;
				
			}
		}
		

		private function _move_oval(): void
		{
			enemy_x = Math.sin(n / 100) * 300 + 360;
			enemy_y = Math.cos(n / 100) * 100 + 200;
		}
		
		
		private function _move_circle(): void
		{
			enemy_x = Math.sin(n / 100) * 350 + 355;
			enemy_y = Math.cos(n / 100) * 350 + 355;
		}
		
		
		private function _move_8(): void
		{
			enemy_x = ((Math.SQRT2 * Math.cos(n / 100)) / (Math.pow(Math.sin(n / 100), 2) + 1)) * 250 + 355;
			enemy_y = ((Math.SQRT2 * Math.cos(n / 100) * Math.sin(n / 100) / (Math.pow(Math.sin(n / 100), 2) + 1))) * 400 + 200;
		}
		
		
		private function shoot(e: TimerEvent): void
		{
			if (parent)
			{
				parent.parent.shoot(this);
			}
		}
		
		
		public function death(): void
		{
			if (contains(model)) removeChild(model);
			is_alive = false;
			removeEventListener(Event.ENTER_FRAME, _move);
			enemy_shooting_timer.stop();
			enemy_shooting_timer.removeEventListener(TimerEvent.TIMER, shoot);
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
		
		
		public function freeze(): void
		{
			if (is_playing)
			{
				enemy_shooting_timer.stop();
				removeEventListener(Event.ENTER_FRAME, _move);
				is_playing = false;
			}
		}
		
		
		public function unfreeze(): void
		{
			if (!is_playing)
			{
				enemy_shooting_timer.start();
				addEventListener(Event.ENTER_FRAME, _move);
				is_playing = true;
			}
		}
		
		
		public function setShootingRate(n: Number): void
		{
			enemy_shooting_timer.delay = n;
			enemy_shooting_timer.reset();
		}

	}
	
}
