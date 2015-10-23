package example09_alphasort 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.common.graphics.Palette;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.preset.TextureMaterial;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * モデルのテクスチャを弄るサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		[Embed(source = "asset/wood.jpg")] private var IMAGE1:Class;
		[Embed(source = "asset/icon.png")] private var IMAGE2:Class;
		
		private var scene:Scene3D;
		private var parser:M3DParser;
		private var container:Object3D;
		
		public function ExampleMain() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 60;
			
			//シーンの初期化
			scene = new Scene3D();
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			addChild(scene.stats);
			scene.startRendering();
			scene.view.startAutoResize(stage);
			scene.view.backgroundColor = 0x808080;
			scene.setTPVController(stage, -90, 5, 200, 0, 0, 20);
			
			//モデルを配置するコンテナ
			container = new Object3D();
			container.name = "container";
			scene.root.addChild(new AmbientLight(0xffffff, 1));
			scene.root.addChild(new DirectionalLight(0xffffff, 1.0)).lookAtXYZ(5, 5, -5);
			scene.root.addChild(container);
			
			var material:Material = new TextureMaterial(new ImageTextureResource(new IMAGE1, true), new ImageTextureResource(new IMAGE2, true), 1, true);
			//material.culling = TriangleFace.BOTH;
			for (var i:int = 0; i < 10; i++) 
			{
				var p:Plane = new Plane(100, 100, 1, 1, 0.5, 0.5, false, material, null);
				p.x = Math.cos(i / 10 * 6.28) * 100;
				p.y = Math.sin(i / 10 * 6.28) * 100;
				p.z = 0;
				p.colorTransform = Palette.getFillColor(Random.integer(0, 0xffffff), 0.8, 0.7)
				var container1:Object3D = new Object3D();
				var container2:Object3D = new Object3D();
				container1.addChild(p);
				container2.addChild(container1);
				scene.root.addChild(container2);
				scene.billboard.addObject(p, false, true, "+z", "+x");
			}
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true, false);
		}
		
		private function parser_completeHandler(e:Event):void 
		{
			//ボタンリスト
			var buttonList:LabelButtonList = new LabelButtonList(true, 15, 150);
			buttonList.x = 10;
			buttonList.y = 180;
			//buttonList.addButton("setTextureResource1()", setTextureResource1);
			//buttonList.addButton("setTextureResource2()", setTextureResource2);
			addChild(buttonList);
			
			
		}
		
	}

}