package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Blinker extends MovieClip
	{
		private var blink: MovieClip = new Blink();
		
		
		public function Blinker(x_pos: Number, y_pos: Number) 
		{
			blink.gotoAndStop(1);
			addChild(blink);
			blink.x = x_pos;
			blink.y = y_pos;
			blink.addEventListener(Event.COMPLETE, end);
			blink.play();
		}
		
		
		private function end(e: Event): void
		{
			blink.stop();
			removeChild(blink);
			blink.removeEventListener(Event.COMPLETE, end);
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
	
}
