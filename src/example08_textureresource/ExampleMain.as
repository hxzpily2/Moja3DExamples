package example08_textureresource 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * モデルのテクスチャを弄るサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		[Embed(source = "asset/mappedTeapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		
		private var parser:M3DParser;
		private var teapot:Mesh;
		
		public function ExampleMain() 
		{
			super(20);
		}
		
		override public function init():void 
		{
			//モデル読み込み
			parser = new M3DParser();
			parser.addEventListener(Event.COMPLETE, parser_completeHandler);
			parser.parse(new Model);
		}
		
		private function parser_completeHandler(e:Event):void 
		{
			parser.removeEventListener(Event.COMPLETE, parser_completeHandler);
			
			teapot = parser.objects[0] as Mesh;
			scene.root.addChild(teapot);
			
			//ティーポットの参照コピーを配置して、マテリアルだけ複製する
			var copy:Mesh = teapot.reference() as Mesh;
			copy.surfaces[0].material = copy.surfaces[0].material.clone(true);
			scene.root.addChild(copy).y = 70;
			
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true);
			
			//ボタン
			buttons.addButton("setTextureResource1()", setTextureResource1);
			buttons.addButton("setTextureResource2()", setTextureResource2);
		}
		
		/**
		 * マテリアルから細かくテクスチャの情報を取得する方法
		 */
		private function setTextureResource1():void 
		{
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
			imageResource.setBitmapResource(bitmap, true);
			//アップロード
			imageResource.upload(scene.context3D);
		}
		
		/**
		 * マテリアルにテクスチャが1枚だけ設定されてる場合の簡易取得方法
		 */
		private function setTextureResource2():void
		{
			//teapot内にあるImageTextureResourceを取得
			var imageResource:ImageTextureResource = teapot.getResources(true, ImageTextureResource)[0] as ImageTextureResource;
			
			//リソース画像取得
			var bitmap:BitmapData = imageResource.bitmapData;
			bitmap.fillRect(new Rectangle(Random.number(0, 400), Random.number(0, 400), 64, 64), 0x0000ff);
			
			//画像を再設定する。第二引数をtrueにするとPNG画像に透過要素があるかチェックして不透明画像ならdrawCallが減る可能性がある。でもチェックが重い。
			imageResource.setBitmapResource(bitmap, true);
			//アップロード
			imageResource.upload(scene.context3D);
		}
		
	}

}