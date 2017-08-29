package  {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ScrollingBackground extends MovieClip
	{
		private var back_part_1: MovieClip;
		private var back_part_2: MovieClip;
		private var back_height: Number;
		private var scroll_speed: Number;
		

		public function ScrollingBackground(background: MovieClip, scroll_speed: Number) 
		{
			this.scroll_speed = scroll_speed;
			back_height = background.height;
			initializeScrolling(background);
		}
		
		
		private function initializeScrolling(back: MovieClip): void
		{
			back_part_1 = back;
			back_part_1.x = 0;
			back_part_1.y = 0;
			addChild(back_part_1);
			
			var handle: Class = Object(back_part_1).constructor;
			back_part_2 = new handle();
			back_part_2.x = 0;
			back_part_2.y = -back_part_2.height;
			addChild(back_part_2);
		}


		private function scrollHandler(e: Event)
		{
			if	   (back_part_1.y >= back_height) {back_part_1.y = back_part_2.y - back_height;}
			else if(back_part_2.y >= back_height) {back_part_2.y = back_part_1.y - back_height;}
			back_part_1.y += scroll_speed;
			back_part_2.y += scroll_speed;
		}
		
		
		public function startScrolling(): void {addEventListener(Event.ENTER_FRAME, scrollHandler);}
		
		
		public function stopScrolling(): void  {removeEventListener(Event.ENTER_FRAME, scrollHandler);}
		
	}
}
