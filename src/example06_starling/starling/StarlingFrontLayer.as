package example06_starling.starling 
{
	import net.morocoshi.common.math.random.Random;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author tencho
	 */
	public class StarlingFrontLayer extends Sprite 
	{
		
		public function StarlingFrontLayer() 
		{
			for (var i:int = 0; i < 20; i++) 
			{
				var quad:Quad = new Quad(50, 50, 0x00ff00, true);
				quad.x = Random.number(100, 600);
				quad.y = Random.number(100, 400);
				quad.alpha = 0.7;
				addChild(quad);
			}
		}
		
	}

}