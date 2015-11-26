package example11_rendertexture 
{
	import net.morocoshi.common.graphics.Palette;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.overlay.objects.Image2D;
	import net.morocoshi.moja3d.primitives.Cube;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.resources.RenderTextureResource;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * 画面をテクスチャにキャプチャするサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var capturedTexture:RenderTextureResource;
		private var autoCapture:Boolean;
		
		public function ExampleMain() 
		{
			super(20);
		}
		
		override public function init():void 
		{
			super.init();
			
			//3Dシーンの構成
			scene.root.addChild(buildModels());
			scene.root.upload(scene.context3D, true);
			
			
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
			buttons.addButton("capture", capture);
			buttons.addButton("setAutoCapture(true)", setAutoCapture, [true]);
			buttons.addButton("setAutoCapture(false)", setAutoCapture, [false]);
		}
		
		override public function tick():void 
		{
			if (autoCapture) capture();
		}
		/**
		 * シーンをテクスチャにキャプチャする
		 */
		private function capture():void 
		{
			scene.renderSceneTo(capturedTexture, scene.root, null, scene.camera, scene.view, scene.filters, false);
		}
		
		private function setAutoCapture(value:Boolean):void 
		{
			autoCapture = value;
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
				cloned.colorTransform = Palette.getMultiplyColor(Random.integer(0, 0xffffff), 1, 1);
				result.addChild(cloned);
			}
			
			return result;
		}
		
	}

}