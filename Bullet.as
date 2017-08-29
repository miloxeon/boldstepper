package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Bullet extends MovieClip
	{
		public  var bullet_speed: Number;
		private var explosion_model: MovieClip = new Explosion();
		private var explosion_blur_model: MovieClip;
		private var bullet_model: MovieClip;
		public  var hit_detector: MovieClip;
		public  var glow_model: MovieClip = new Glow();
		public  var _mark: String;
		public  var damage: Number = 100;
		
		public function Bullet(model: MovieClip) 
		{
			explosion_model.gotoAndStop(0);
			var handle: Class = (model as Object).constructor;
			bullet_model = new handle();
			hit_detector = new handle();
			addChild(bullet_model);
		}
		
		
		public function explode(): void
		{
			damage = 0;
			bullet_speed = 0;
			if (contains(bullet_model)) removeChild(bullet_model);
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
	}
	
}
