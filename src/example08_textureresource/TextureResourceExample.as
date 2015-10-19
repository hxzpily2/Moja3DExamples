package example08_textureresource 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * モデルのテクスチャを弄るサンプル
	 * 
	 * @author tencho
	 */
	[SWF(width="640", height="480")]
	public class TextureResourceExample extends Sprite 
	{
		[Embed(source = "asset/mappedTeapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		
		private var scene:Scene3D;
		private var container:Object3D;
		private var parser:M3DParser;
		
		public function TextureResourceExample() 
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
			scene.setTPVController(stage, -90, 45, 100, 0, 0, 20);
			
			//モデルを配置するコンテナ
			container = new Object3D();
			scene.root.addChild(new AmbientLight(0xffffff, 0.5));
			scene.root.addChild(new DirectionalLight(0xffffff, 1.0)).lookAtXYZ(5, 5, -5);
			scene.root.addChild(container);
			
			//モデル読み込み
			parser = new M3DParser();
			parser.addEventListener(Event.COMPLETE, parser_completeHandler);
			parser.parse(new Model, container);
		}
		
		private function parser_completeHandler(e:Event):void 
		{
			parser.removeEventListener(Event.COMPLETE, parser_completeHandler);
			
			//ボタンリスト
			var buttonList:LabelButtonList = new LabelButtonList(true, 15, 150);
			buttonList.x = 10;
			buttonList.y = 180;
			buttonList.addButton("setTextureResource1()", setTextureResource1);
			buttonList.addButton("setTextureResource2()", setTextureResource2);
			addChild(buttonList);
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true, false);
		}
		
		/**
		 * マテリアルから細かくテクスチャの情報を取得する方法
		 */
		private function setTextureResource1():void 
		{
			//ティーポットのモデルを特定
			var teapot:Mesh = container.getChildAt(0) as Mesh;
			//サーフェイスに貼られたマテリアルを取得
			var material:Material = teapot.surfaces[0].material;
			//マテリアル内のテクスチャシェーダーを取得
			var shader:TextureShader = material.shaderList.getShaderAs(TextureShader) as TextureShader;
			//テクスチャのdiffuseに設定された画像リソースを取得（透過画像の場合はtexture.opacity）
			var imageResource:ImageTextureResource = shader.diffuse as ImageTextureResource;
			
			//リソース画像取得
			var bitmap:BitmapData = imageResource.bitmapData;
			bitmap.fillRect(new Rectangle(Random.number(0, 400), Random.number(0, 400), 64, 64), 0xff0000);
			
			//画像を再設定する。第二引数をtrueにするとPNG画像に透過要素があるかチェックして不透明画像ならdrawCallが減る可能性がある。でもチェックが重い。
			//JPG画像のように透過要素が無いことが確定している場合はfalseのままでいい
			imageResource.setBitmapResource(bitmap, false);
			//アップロード
			imageResource.upload(scene.context3D, false);
		}
		
		/**
		 * マテリアルにテクスチャが1枚だけ設定されてる場合の簡易取得方法
		 */
		private function setTextureResource2():void
		{
			//コンテナ内にあるImageTextureResourceを取得
			var imageResource:ImageTextureResource = container.getResources(true, ImageTextureResource)[0] as ImageTextureResource;
			
			//リソース画像取得
			var bitmap:BitmapData = imageResource.bitmapData;
			bitmap.fillRect(new Rectangle(Random.number(0, 400), Random.number(0, 400), 64, 64), 0x0000ff);
			
			//画像を再設定する。第二引数をtrueにするとPNG画像に透過要素があるかチェックして不透明画像ならdrawCallが減る可能性がある。でもチェックが重い。
			//JPG画像のように透過要素が無いことが確定している場合はfalseのままでいい
			imageResource.setBitmapResource(bitmap, false);
			//アップロード
			imageResource.upload(scene.context3D, false);
		}
		
	}

}