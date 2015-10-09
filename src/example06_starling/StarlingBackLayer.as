package example06_starling 
{
	import net.morocoshi.common.math.random.Random;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author tencho
	 */
	public class StarlingBackLayer extends Sprite 
	{
		
		public function StarlingBackLayer() 
		{
			for (var i:int = 0; i < 20; i++) 
			{
				var quad:Quad = new Quad(50, 50, 0xff4400, true);
				quad.x = Random.number(100, 600);
				quad.y = Random.number(50, 400);
				quad.alpha = 1;
				addChild(quad);
			}
		}
		
	}

}