package example13_scale9plane 
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.loader.M3DParser;
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
		[Embed(source = "asset/spriteSheet.png")] private var IMAGE1:Class;
		
		private var parser:M3DParser;
		private var plane:Scale9Plane;
		
		public function ExampleMain() 
		{
			super(0);
		}
		
		override public function init():void 
		{
			var material:Material = new Material();
			material.shaderList.addShader(new TextureShader(new ImageTextureResource(new IMAGE1, true), null));
			
			var w:Number = 100;
			var h:Number = 100;
			var scale9:Rectangle = new Rectangle(w / 4, h / 4, w / 2, h / 2);
			plane = new Scale9Plane(w, h, scale9, 0.5, 0.5, true, material, material);
			scene.root.addChild(plane);
			
			scene.root.upload(scene.context3D, true, false);
		}
		
		
		override public function tick():void 
		{
			plane.scaleX = Math.cos(getTimer() / 1500) * 1 + 1.5;
			plane.scaleY = Math.cos(getTimer() / 1000) * 1 + 1.5;
		}
		
	}

}