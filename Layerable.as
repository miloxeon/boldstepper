package  
{
	import flash.display.MovieClip;
	
	public class Layerable extends MovieClip
	{
		public var front_layer:		  MovieClip = new Layer();
		public var score_layer:		  MovieClip = new Layer();
		public var characters_layer:  MovieClip = new Layer();
		public var projectiles_layer: MovieClip = new Layer();
		public var hitmarkers_layer:  MovieClip = new Layer();
		public var glow_layer: 		  MovieClip = new Layer();
		public var stars_layer: 	  MovieClip = new Layer();
		
		
		public function Layerable() 
		{
			
		}
		
		
		public function displayLayers(): void
		{
			addChild(stars_layer);
			addChild(glow_layer);
			addChild(hitmarkers_layer);
			addChild(projectiles_layer);
			addChild(characters_layer);
			addChild(score_layer);
			addChild(front_layer);
		}
		
		
		public function getCenterCoordinates(object: MovieClip, stage_width: Number = 720): Number
		{
			return (stage_width - object.width) / 2;
		}

	}
	
}
