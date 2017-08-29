package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Level extends Layerable
	{
		public var enemies: Array = new Array();
		public var player: Player = new Player();
		
		//variables for touch handlers
		public var touch_start_x: Number;
		public var touch_start_y: Number;
		public var player_start_x: Number;
		public var player_start_y: Number;
		public var player_x: Number;
		public var player_y: Number;
		
		//background picture animations
		private var stars: ScrollingStars = new ScrollingStars();
		public  var black: MovieClip = new Black();
		private var white: MovieClip = new White();
		private var white_fade_out_factor: Number = 0.01;
		
		//score and health variables
		public 	var score: Number = 0;
		private var score_label:  MovieClip = getScoreLabel();
		private var health_label: MovieClip = getHealthLabel();
		private var zeroes: Number = 7;
		
		//maintenance flags
		public var shooting_allowed: Boolean = false;
		public var is_playing: Boolean = false;
		
		
		public function Level() 
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			stars_layer.addChild(stars);

			score_layer.addChild(score_label);
			score_label.x = 20;
			score_label.y = 20;
			
			score_layer.addChild(health_label);
			health_label.x = 670;
			health_label.y = score_label.y;

			addChild(black);
			displayLayers();
			
			addChild(white);
			white.addEventListener(Event.ENTER_FRAME, white_fade_out);
		}

		
		public function white_fade_out(e: Event): void
		{
			if (white.alpha - white_fade_out_factor <= 0)
			{
				white.removeEventListener(Event.ENTER_FRAME, white_fade_out);
				removeChild(white);
			}
			else
			{
				white.alpha -= white_fade_out_factor;
			}
		}
		
		
		
		public function startGame(): void
		{
			stars.startScrolling();
			
			is_playing = true;
			shooting_allowed = true;
			stage.addEventListener(TouchEvent.TOUCH_END, touch_end_handler);
			addEventListener(Event.ENTER_FRAME, moveEnemies);
			addEventListener(Event.ENTER_FRAME, moveBullets);
			addEventListener(TouchEvent.TOUCH_BEGIN, touchHandler);
		}
		
		
		private function touch_end_handler(e: TouchEvent): void
		{
			stage.removeEventListener(TouchEvent.TOUCH_END, touch_end_handler);
			addEventListener(TouchEvent.TOUCH_MOVE, movePlayer);
		}
		
		//below are player functions
		public function spawnPlayer(): void
		{
			characters_layer.addChild(player);
			glow_layer.addChild(player.glow_model);
			hitmarkers_layer.addChild(player.hit_detector);
			player.glow_model.x = player.x;
			player.glow_model.y = player.y;
			player.hit_detector.x = player.x;
			player.hit_detector.y = player.y;
			
		}
		
		
		public function touchHandler(e: TouchEvent): void
		{
			touch_start_x = e.stageX;
			touch_start_y = e.stageY;
			player_start_x = player.x;
			player_start_y = player.y;
		}
		
		
		public function movePlayer(e: TouchEvent): void
		{
			player_x = player_start_x + e.stageX - touch_start_x;
			player_y = player_start_y + e.stageY - touch_start_y;

			if (player_x < 0) 	 		player.x = 0;
			else if(player_x > 720)  	player.x = 720;
			else 						player.x = player_x;

			if (player_y < 0)		 	player.y = 0;
			else if(player_y > 1184) 	player.y = 1200;
			else						player.y = player_y;
			
			player.glow_model.x = player.x;
			player.glow_model.y = player.y;
			
			player.hit_detector.x = player.x;
			player.hit_detector.y = player.y;
		}
		

		//below are enemy functions
		public function spawnEnemies(n: Number = 0): void
		{
			var enemies_count: Number = n;
			if (enemies_count > enemies.length || enemies_count <= 0)
			{
				enemies_count = enemies.length;
			}
			for (var i: uint = 0; i < enemies_count; i++)
			{
				characters_layer.addChild(enemies[i]);
				glow_layer.addChild(enemies[i].glow_model);
				
				enemies[i].alpha = 0;
				enemies[i].glow_model.alpha = 0;
				enemies[i].addEventListener(Event.ENTER_FRAME, GLOW(enemies[i]));
				hitmarkers_layer.addChild(enemies[i].hit_detector);
			}
			enemies.splice(0, enemies_count);
		}
		
		
		private function GLOW(enemy: Enemy): Function
		{
			return function foo(e: Event): void
			{
				if (enemy.alpha + 0.1 >= 1)
				{
					enemy.alpha = 1;
					enemy.glow_model.alpha = enemy.alpha;
					enemy.removeEventListener(Event.ENTER_FRAME, GLOW);
				}
				else
				{
					enemy.alpha += 0.1;
					enemy.glow_model.alpha = enemy.alpha;
				}
			}
		}
		
		
		public function moveEnemies(e: Event): void
		{
			for each (var enemy in getEnemies())
			{
				enemy.x = enemy.enemy_x;
				enemy.y = enemy.enemy_y;
				enemy.glow_model.x = enemy.x;
				enemy.glow_model.y = enemy.y;
				enemy.hit_detector.x = enemy.x;
				enemy.hit_detector.y = enemy.y;
			}
		}
		
		
		//below are common functions
		public function shoot(character: Object): void
		{
			//characterDeath(player);
			
			if (shooting_allowed)
			{
				var new_bullet: Bullet = new Bullet(character._bullet);
				new_bullet.bullet_speed = character.bullet_speed;
				new_bullet._mark = character.mark;
				new_bullet.damage = character.damage;
				projectiles_layer.addChild(new_bullet);
				hitmarkers_layer.addChild(new_bullet.hit_detector);
				new_bullet.x = character.x;
				new_bullet.y = character.y;
				new_bullet.hit_detector.x = character.x;
				new_bullet.hit_detector.y = character.y;
			}
		}
		
		
		public function moveBullets(e: Event): void
		{
			for each (var bullet in getBullets())
			{
				checkBulletHits(bullet);
				
				if (checkBulletBoundaries(bullet))
				{
					bullet.y += bullet.bullet_speed;
					bullet.hit_detector.y = bullet.y
				}
				else
				{
					removeBullet(bullet);
				}
			}
		}
		
		
		private function checkBulletBoundaries(bullet: Bullet): Boolean
		{
			switch (bullet._mark)
			{
				case "player":
					if (bullet.y < -10) return false;
					break;
				
				case "enemy":
					if (bullet.y > 1290) return false;
					break;
			}
			return true;
		}
		
		
		private function checkBulletHits(bullet: Bullet): void
		{
			switch (bullet._mark)
			{
				case "player":
					for each (var enemy in getEnemies())
					{
						if (enemy.hit_detector.hitTestObject(bullet.hit_detector) && enemy.is_alive)
						{
							bulletHitHandler(bullet, enemy);
						}
					}
					break;
					
				case "enemy":
					if (player.hit_detector.hitTestObject(bullet.hit_detector) && player.is_alive)
					{
						bulletHitHandler(bullet, player);
						player.blink();
					}
					break;
			}
		}
		
		
		private function bulletHitHandler(bullet: Bullet, character: Object): void
		{
			function _remove_bullet(e: Event): void
			{
				bullet.removeEventListener(Event.COMPLETE, _remove_bullet);
				if (projectiles_layer.contains(bullet)) projectiles_layer.removeChild(bullet);
			}
			
			if (!character.is_immortal)
			{
				if (hitmarkers_layer.contains(bullet.hit_detector)) hitmarkers_layer.removeChild(bullet.hit_detector);
				recountHealth(character, bullet);
			
				if (character.health <= 0)
				{
					recountScore(character);
					characterDeath(character);
				}
				bullet.addEventListener(Event.COMPLETE, _remove_bullet);
				bullet.explode();
			}
		}
		

		private function removeBullet(bullet: Bullet): void
		{
			if (bullet.hit_detector.stage) hitmarkers_layer.removeChild(bullet.hit_detector);
			if (bullet.stage) projectiles_layer.removeChild(bullet);
		}
		

		public function characterDeath(character: Object): void
		{
			function _death(e: Event) : void
			{
				character.removeEventListener(Event.COMPLETE, _death);
				if (characters_layer.contains(character)) characters_layer.removeChild(character);
			}
			
			
			if (hitmarkers_layer.contains(character.hit_detector)) hitmarkers_layer.removeChild(character.hit_detector);
			if (glow_layer.contains(character.glow_model)) glow_layer.removeChild(character.glow_model);
			character.addEventListener(Event.COMPLETE, _death);
			character.death();
			if (character.mark == "player")
			{
				removeEventListener(TouchEvent.TOUCH_MOVE, movePlayer);
				shooting_allowed = false;
				fadeOutToNextTry();
				
			}
		}
		
		
		//below are maintenance functions
		private function fadeOutToNextTry(): void
		{
			function _fadeOut(e: TimerEvent): void
			{
				if (fade_to_black.alpha + 0.01 >= 1)
				{
					fade_out_timer.stop();
					removeEventListener(Event.ENTER_FRAME, _fadeOut);
					fade_to_black.alpha = 1;
					dispatchEvent(new Event(Event.CUT));
				}
				else
				{
					fade_to_black.alpha += 0.01;
				}
			}
			
			
			var fade_to_black: MovieClip = new Black();
			var fade_out_timer: Timer = new Timer(30);
			
			fade_to_black.alpha = 0;
			front_layer.addChild(fade_to_black);

			fade_out_timer.addEventListener(TimerEvent.TIMER, _fadeOut);
			fade_out_timer.start();
		}
		

		public function freeze(): void
		{
			if (is_playing)
			{
				stars.stopScrolling();
				
				for each (var enemy in getEnemies())
				{
					enemy.freeze();
				}
				
				trackEventsOff();
				
				is_playing = false;
				shooting_allowed = false;
			}
		}
		
		
		public function unfreeze(): void
		{
			if (!is_playing)
			{
				stars.startScrolling();
				
				for each (var enemy in getEnemies())
				{
					enemy.unfreeze();
				}
				
				trackEventsOn();
				
				is_playing = true;
				if (player.is_alive)
					shooting_allowed = true;
			}
		}
		
		
		public function recountScore(character: Object): void
		{
			if (score + character.killing_points < 9999999) score += character.killing_points;
			
			var saved_x: Number = score_label.x;
			var saved_y: Number = score_label.y;
			
			score_layer.removeChild(score_label);
			score_label = getScoreLabel();
			score_layer.addChild(score_label);
			
			score_label.x = saved_x;
			score_label.y = saved_y;
		}
		
		
		private function recountHealth(character: Object, bullet: Bullet): void
		{
			if (!character.is_immortal)
				character.health -= bullet.damage;
			
			var saved_x: Number = health_label.x;
			var saved_y: Number = health_label.y;
			
			score_layer.removeChild(health_label);
			health_label = getHealthLabel();
			score_layer.addChild(health_label);
			
			health_label.x = saved_x;
			health_label.y = saved_y;
		}
		

		public function getEnemies(): Array
		{
			var child: Object;
			var children: Array = new Array();
			for (var i: uint = 0; i < characters_layer.numChildren; i++)
			{
				child = characters_layer.getChildAt(i);
				if(child.hasOwnProperty("enemy_x"))
				{
					children.push(child);
				}
			}
			return children;
		}
		
		
		public function getBullets(): Array
		{
			var child: Object;
			var children: Array = new Array();
			for (var i: uint = 0; i < projectiles_layer.numChildren; i++)
			{
				child = projectiles_layer.getChildAt(i);
				if(child.hasOwnProperty("bullet_speed"))
				{
					children.push(child);
				}
			}
			return children;
		}
		
		
		private function getScoreLabel(spacing: Number = 5): MovieClip
		{
			function repeat_digit(digit: String, repeats: Number): String
			{
				var result: String = '';
				for (var i: uint = 0; i < repeats; i++) result += digit;
				return result;
			}
			
			
			function getGlyph(digit: String = '0'): MovieClip
			{
				switch (digit)
				{
					case '0': return new Digit_0();
					case '1': return new Digit_1();
					case '2': return new Digit_2();
					case '3': return new Digit_3();
					case '4': return new Digit_4();
					case '5': return new Digit_5();
					case '6': return new Digit_6();
					case '7': return new Digit_7();
					case '8': return new Digit_8();
					case '9': return new Digit_9();
				}
			}
			
			
			
			var _score: String = repeat_digit('0', zeroes - score.toString().length) + score.toString();
			
			var score_label: MovieClip = new MovieClip();
			var current_glyph_position: Number = 0;
			
			for (var i: uint = 0; i < _score.length; i++)
			{
				var digit: MovieClip = getGlyph(_score.charAt(i));
				score_label.addChild(digit);
				digit.x = current_glyph_position;
				current_glyph_position += (digit.width + spacing);
			}
			return score_label;
		}
		
		
		private function getHealthLabel(spacing: Number = 5): MovieClip
		{
			var health_label: MovieClip = new MovieClip();
			var current_glyph_position: Number = 0;
			
			for (var i: uint = 0; i < player.health; i++)
			{
				var _label: MovieClip = new LifeMarker();
				health_label.addChild(_label);
				_label.x = current_glyph_position;
				current_glyph_position -= (_label.width + spacing);
			}
			return health_label;
		}
		
		
		private function trackEventsOn(): void
		{
			addEventListener(Event.ENTER_FRAME, moveEnemies);
			addEventListener(Event.ENTER_FRAME, moveBullets);
			addEventListener(TouchEvent.TOUCH_BEGIN, touchHandler);
			addEventListener(TouchEvent.TOUCH_MOVE, movePlayer);
		}
		
		
		private function trackEventsOff(): void
		{
			removeEventListener(Event.ENTER_FRAME, moveEnemies);
			removeEventListener(Event.ENTER_FRAME, moveBullets);
			removeEventListener(TouchEvent.TOUCH_BEGIN, touchHandler);
			removeEventListener(TouchEvent.TOUCH_MOVE, movePlayer);
		}
		
	}
	
}
