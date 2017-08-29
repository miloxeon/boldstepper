package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Level1 extends Level
	{

		public function Level1() 
		{
			spawnTestEnemies();
			player.x = 360;
			player.y = 1000;
			spawnPlayer();
		}
		
		
		public function spawnTestEnemies(): void
		{
			var enemies_array: Array = new Array(new EnemyModel1(), new EnemyModel2(), new EnemyModel3(), new EnemyModel4(), new EnemyModel5(), new EnemyModel6());
			var motion_patterns: Array = new Array("oval", "circle", "move_8");
			
			for each (var current_enemy_model in enemies_array)
			{
				var _enemy: Enemy = new Enemy(current_enemy_model);
				_enemy.bullet_speed = 3 * Math.random() + 5;
				_enemy.setMotionPattern(motion_patterns[Math.floor(Math.random() * motion_patterns.length)]);
				_enemy.enemy_speed = 2 * Math.random();
				_enemy.n = 400 * Math.random();
				_enemy.x = _enemy.enemy_x;
				_enemy.y = _enemy.enemy_y;
				enemies.push(_enemy);
			}

			spawnEnemies();
		}

	}
	
}
