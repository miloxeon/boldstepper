package  
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import com.mesmotronic.ane.AndroidFullScreen;
	
	public class Game extends MovieClip
	{
		public var level1: Level;
		private var spawn_timer: Timer;
		private var restart_dialog: RestartDialog;
		private var start_screen: StartScreen;
		
		public function Game() 
		{
			if (!AndroidFullScreen.immersiveMode())
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			stage.scaleMode = StageScaleMode.NO_BORDER;
			//newGame();
			getToStartScreen();
		}

		
		private function getToStartScreen(): void
		{
			start_screen = new StartScreen();
			stage.addChild(start_screen);
			start_screen.addEventListener(Event.COMPLETE, startGame);
		}
		
		
		private function startGame(e: Event): void
		{
			start_screen.removeEventListener(Event.COMPLETE, startGame);
			stage.removeChild(start_screen);
			newGame();
		}
		

		private function newGame(): void
		{
			level1 = new Level1();
			spawn_timer = new Timer(1000);
			spawn_timer.addEventListener(TimerEvent.TIMER, _spawn);
			spawn_timer.start();
			stage.addChild(level1);
			level1.startGame();
			addEventListener(Event.DEACTIVATE, _freeze);
			addEventListener(Event.ACTIVATE, _unfreeze);
			level1.addEventListener(Event.CUT, _lose);
		}
		

		private function _lose(e: Event): void
		{
			level1.removeEventListener(Event.CUT, _lose);
			spawn_timer.stop();
			removeEventListener(Event.DEACTIVATE, _freeze);
			removeEventListener(Event.ACTIVATE, _unfreeze);
			
			stage.removeChild(level1);
			level1 = null;
			
			restart_dialog = new RestartDialog();
			restart_dialog.addEventListener(Event.COMPLETE, _start_over);
			
			stage.addChild(restart_dialog);
		}
		
		
		private function _start_over(e: Event): void
		{	
			restart_dialog.removeEventListener(Event.COMPLETE, _start_over);
			stage.removeChild(restart_dialog);
			restart_dialog = null;
			newGame();
		}
		
		
		public function _freeze(e: Event): void
		{
			level1.freeze();
		}
		
		
		public function _unfreeze(e: Event): void
		{
			level1.unfreeze();
		}
		
		
		private function _spawn(e: TimerEvent)
		{
			if (level1.getEnemies().length <= 2)
				level1.spawnTestEnemies();
		}

	}
	
}
