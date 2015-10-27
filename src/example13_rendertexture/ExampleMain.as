package example13_rendertexture 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.common.graphics.Palette;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.overlay.objects.Image2D;
	import net.morocoshi.moja3d.primitives.Cube;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.resources.RenderTextureResource;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * キャプチャ
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		private var scene:Scene3D;
		private var capturedTexture:RenderTextureResource;
		
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
			
			//プレビュー設定
			scene.startRendering();
			scene.view.startAutoResize(stage);
			scene.view.backgroundColor = 0x222222;
			scene.setTPVController(stage, -90, 5, 200, 0, 0, 20);
			
			//3Dシーンの構成
			scene.root.addChild(new AmbientLight(0xffffff, 1));
			scene.root.addChild(new DirectionalLight(0xffffff, 1.0)).lookAtXYZ(5, 3, -2);
			scene.root.addChild(buildModels());
			scene.root.upload(scene.context3D, true, false);
			
			
			//------------------------------------------------------------
			//	オーバーレイ関連のコードはここから
			//------------------------------------------------------------
			
			//キャプチャ描画用のテクスチャを用意する
			capturedTexture = new RenderTextureResource();
			capturedTexture.createTexture(scene.context3D, 1024, 1024);
			
			//テクスチャを表示する2Dレイヤー要素を作成する
			var image:Image2D = new Image2D(capturedTexture);
			image.width = 400;
			image.height = 300;
			image.x = 240;
			image.rotation = 45 / 180 * Math.PI;
			image.alpha = 0.8;
			
			//Scene3Dのoverlayに追加
			scene.overlay.addChild(image);
			
			//------------------------------------------------------------
			//	ここまで
			//------------------------------------------------------------
			
			
			//ボタンリスト
			var buttonList:LabelButtonList = new LabelButtonList(true, 15, 150);
			buttonList.x = 10;
			buttonList.y = 180;
			buttonList.addButton("capture", capture);
			buttonList.addButton("startAutoCapture", startAutoCapture);
			buttonList.addButton("stopAutoCapture", stopAutoCapture);
			addChild(buttonList);
		}
		
		/**
		 * シーンをテクスチャにキャプチャする
		 */
		private function capture():void 
		{
			scene.renderSceneTo(capturedTexture, scene.root, null, scene.camera, scene.view, scene.filters);
		}
		
		private function startAutoCapture():void 
		{
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		private function stopAutoCapture():void
		{
			removeEventListener(Event.ENTER_FRAME, tick);
		}
		
		private function tick(e:Event):void 
		{
			capture();
		}
		
		private function buildModels():Object3D 
		{
			var result:Object3D = new Object3D();
			
			result.addChild(new Plane(1500, 1500, 1, 1, 0.5, 0.5, false, new FillMaterial(0x556677, 1, true), null));
			
			var cube:Cube = new Cube(10, 10, 10, 1, 1, 1, new FillMaterial(0x808080, 1, true));
			for (var i:int = 0; i < 100; i++) 
			{
				var cloned:Mesh = cube.reference() as Mesh;
				cloned.setPositionXYZ(Random.number( -100, 100), Random.number( -100, 100), Random.number(10, 100));
				cloned.colorTransform = Palette.getMultiplyColor(Random.integer(0, 0xffffff), 1);
				result.addChild(cloned);
			}
			
			return result;
		}
		
	}

}