package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.TouchEvent;
	
	public class RestartDialog extends MovieClip
	{
		private var console_front: MovieClip = new ConsoleFront();
		private var console_back: MovieClip	 = new ConsoleBack();
		private var cartridge: MovieClip	 = new ConsoleCartridge();
		private var insert_label: MovieClip  = new InsertCartridgeLabel();
		private var stars: ScrollingStars 	 = new ScrollingStars(10);
		
		private var cartridge_moving_start_y: Number;
		private var cartrige_throw_speed: Number = 15;

		
		public function RestartDialog() 
		{
			addChild(new Black());
			
			stars.startScrolling();
			addChild(stars);
			
			insert_label.x = getCenterCoordinates(insert_label);
			insert_label.y = 350;
			addChild(insert_label);
			
			console_back.x = getCenterCoordinates(console_back);
			console_back.y = 1000;
			addChild(console_back);
			
			cartridge.x = getCenterCoordinates(cartridge);
			cartridge.y = 870;
			addChild(cartridge);
			
			console_front.x = getCenterCoordinates(console_front);
			console_front.y = 1000;
			addChild(console_front);
			
			addEventListener(Event.ENTER_FRAME, startMovement);	
		}
		

		private function startMovement(e: Event): void
		{
			if (cartridge.y - cartrige_throw_speed <= 600)
			{
				cartridge.y == 600;
				removeEventListener(Event.ENTER_FRAME, startMovement);
				cartridge.addEventListener(TouchEvent.TOUCH_BEGIN, initCartridgeMove);
			}
			else
			{	
				cartridge.y -= cartrige_throw_speed;
			}
		}
		
		
		private function getCenterCoordinates(object: MovieClip): Number
		{
			return (720 - object.width) / 2;
		}
		
		
		private function initCartridgeMove(e: TouchEvent): void
		{
			cartridge.removeEventListener(TouchEvent.TOUCH_BEGIN, initCartridgeMove);
			cartridge_moving_start_y = e.stageY - cartridge.y;
			addEventListener(TouchEvent.TOUCH_MOVE, moveCartridge);
			addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		}
		
		
		private function moveCartridge(e: TouchEvent): void
		{
			var cartridge_y: Number 	  = e.stageY - cartridge_moving_start_y;
			var cartrige_bottom_y: Number = cartridge_y + (cartridge.height - cartridge_moving_start_y);
			
			if 	(cartridge_y < 600) 		
				cartridge.y = 600;
			
			else if (cartrige_bottom_y > 870) 
			{
				cartridge.y = 870;
				addEventListener(TouchEvent.TOUCH_END, dispatchByTouchEnd);
				removeEventListener(TouchEvent.TOUCH_MOVE, moveCartridge);
				cartridge.removeEventListener(TouchEvent.TOUCH_BEGIN, initCartridgeMove);
				removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			}
			
			else
				cartridge.y = cartridge_y;
		}
		
		
		private function touchEndHandler(e: TouchEvent): void
		{
			removeEventListener(TouchEvent.TOUCH_MOVE, moveCartridge);
			cartridge.addEventListener(TouchEvent.TOUCH_BEGIN, initCartridgeMove);
		}
		
		
		private function dispatchByTouchEnd(e: TouchEvent): void
		{
			removeEventListener(TouchEvent.TOUCH_END, dispatchByTouchEnd);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}
