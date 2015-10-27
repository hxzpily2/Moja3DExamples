package example11_remove 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.common.graphics.Palette;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.primitives.Cube;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * 追加と削除とリソースの破棄
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		private var scene:Scene3D;
		private var parser:M3DParser;
		private var container:Object3D;
		private var cubeMaterial:FillMaterial;
		
		public function ExampleMain() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 60;
			
			cubeMaterial = new FillMaterial(0x808080, 1, true);
			
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
			
			scene.root.addChild(new AmbientLight(0xffffff, 1));
			var sun:DirectionalLight = new DirectionalLight(0xffffff, 1.0);
			scene.root.addChild(sun).lookAtXYZ(5, 3, -2);
			
			var material:Material = new Material();
			material.shaderList.addShader(new FillShader(0x556677, 1));
			material.shaderList.addShader(new LambertShader());
			scene.root.addChild(new Plane(1500, 1500, 1, 1, 0.5, 0.5, false, material, null));
			
			container = new Object3D();
			scene.root.addChild(container);
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true, false);
			
			//ボタンリスト
			var buttonList:LabelButtonList = new LabelButtonList(true, 15, 150);
			buttonList.x = 10;
			buttonList.y = 180;
			buttonList.addButton("addCubes", addCubes);
			buttonList.addButton("removeChildren()", removeAll);
			addChild(buttonList);
		}
		
		private function removeAll():void 
		{
			container.disposeChildren();
			container.removeChildren();
		}
		
		private function addCubes():void 
		{
			for (var i:int = 0; i < 20; i++) 
			{
				var c:Cube = new Cube(10, 10, 10, 1, 1, 1, cubeMaterial);
				c.setPositionXYZ(Random.number( -100, 100), Random.number( -100, 100), Random.number(10, 100));
				c.colorTransform = Palette.getMultiplyColor(Random.integer(0, 0xffffff), 1);
				container.addChild(c);
			}
			container.upload(scene.context3D, true, false);
		}
		
	}

}