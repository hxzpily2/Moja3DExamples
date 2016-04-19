package example09_billboard 
{
	import net.morocoshi.common.graphics.Palette;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.preset.TextureMaterial;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * ビルボードのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		[Embed(source = "asset/wood.jpg")] private var IMAGE1:Class;
		[Embed(source = "asset/icon.png")] private var IMAGE2:Class;
		
		private var parser:M3DParser;
		
		public function ExampleMain() 
		{
			super();
		}
		
		override public function init():void 
		{
			var material:Material = new TextureMaterial(new ImageTextureResource(new IMAGE1, true), new ImageTextureResource(new IMAGE2, true), 1, true);
			for (var i:int = 0; i < 30; i++) 
			{
				var p:Plane = new Plane(10, 10, 1, 1, 0.5, 0.5, false, material, null);
				p.x = Math.cos(i / 30 * 6.28) * 50;
				p.y = Math.sin(i / 30 * 6.28) * 50;
				p.z = 0;
				p.colorTransform = Palette.getFillColor(Random.integer(0, 0xffffff), 0.8, 0.7);
				scene.billboard.addObject(p, false, true, "+z", "+x");
				scene.root.addChild(p);
			}
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true);
		}
		
	}

}