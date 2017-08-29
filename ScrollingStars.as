package  {
	import flash.display.MovieClip;
	
	public class ScrollingStars extends MovieClip
	{
		private var back: ScrollingBackground;
		private var middle: ScrollingBackground;
		private var front: ScrollingBackground;

		public function ScrollingStars(SPEED: Number = 1) 
		{
			back = new ScrollingBackground(new StarsBack(), 0.7 * SPEED);
			back.alpha = 0.4;
			addChild(back);
			
			middle = new ScrollingBackground(new StarsMiddle(), 1.1 * SPEED);
			middle.alpha = 0.6;
			middle.y = 120;
			addChild(middle);
			
			front = new ScrollingBackground(new StarsFront(), 2 * SPEED);
			front.y = 85;
			addChild(front);
		}
		
		
		public function startScrolling(): void
		{
			back.startScrolling();
			middle.startScrolling();
			front.startScrolling();
		}
		
		
		public function stopScrolling(): void
		{
			back.stopScrolling();
			middle.stopScrolling();
			front.stopScrolling();
		}
		
	}
}
