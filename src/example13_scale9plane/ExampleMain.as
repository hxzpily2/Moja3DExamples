package example13_scale9plane 
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.primitives.Scale9Plane;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * Scale9Planeのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		[Embed(source = "asset/scale9.png")] private var IMAGE1:Class;
		
		private var plane:Scale9Plane;
		
		public function ExampleMain() 
		{
			super(0, 500);
		}
		
		override public function init():void 
		{
			var material:Material = new Material([new TextureShader(new ImageTextureResource(new IMAGE1, true))]);
			
			var scale9:Rectangle = new Rectangle(80, 80, 96, 96);
			plane = new Scale9Plane(256, 256, scale9, 0.5, 0.5, true, material, material);
			scene.root.addChild(plane);
			
			scene.root.upload(scene.context3D, true);
		}
		
		
		override public function tick():void 
		{
			plane.scaleX = Math.cos(getTimer() / 1500) * 1 + 1.5;
			plane.scaleY = Math.cos(getTimer() / 1000) * 1 + 1.5;
		}
		
	}

}