package example07_resourcepack 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.resources.ExternalTextureResource;
	import net.morocoshi.moja3d.resources.Resource;
	import net.morocoshi.moja3d.resources.ResourcePack;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * モデルのテクスチャをリソースパックで切り替えるサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		[Embed(source = "asset/primitives.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		[Embed(source = "asset/dirt_01.png")]private var Image1:Class;		
		[Embed(source = "asset/dirt_03.png")]private var Image2:Class;		
		[Embed(source = "asset/wood_04.png")]private var Image3:Class;		
		[Embed(source = "asset/tan_webbing.png")]private var Image4:Class;		
		
		private var container:Object3D;
		
		public function ExampleMain() 
		{
			super(0);
		}
		
		override public function init():void 
		{
			//モデルを配置するコンテナ
			container = new Object3D();
			scene.root.addChild(container);
			
			//モデル読み込み（画像が含まれなければCOMPLETEイベントを待たなくてもいい）
			new M3DParser().parse(new Model, container);
			scene.root.upload(scene.context3D, true);

			//リソースパックの作成
			
			//テクスチャ画像を登録
			var resourcePack1:ResourcePack = new ResourcePack();
			resourcePack1.register("dirt_01", new Image1, false);
			resourcePack1.register("dirt_03", new Image2, false);
			resourcePack1.register("wood_04", new Image3, false);
			resourcePack1.register("tan_webbing", new Image4, false);
			
			//単色画像を登録
			var resourcePack2:ResourcePack = new ResourcePack();
			resourcePack2.register("dirt_01", new BitmapData(2, 2, false, 0x448899), false);
			resourcePack2.register("dirt_03", new BitmapData(2, 2, false, 0xffcc00), false);
			resourcePack2.register("wood_04", new BitmapData(2, 2, false, 0xcc2244), false);
			resourcePack2.register("tan_webbing", new BitmapData(2, 2, false, 0x009922), false);
			
			//ボタンリスト
			buttons.addButton("ResourcePack1", setResourcePack, [resourcePack1]);
			buttons.addButton("ResourcePack2", setResourcePack, [resourcePack2]);
			
		}
		
		private function setResourcePack(resourcePack:ResourcePack):void 
		{
			//コンテナオブジェクト内にある全ての外部テクスチャリソースを取得する
			var resources:Vector.<Resource> = container.getResources(true, ExternalTextureResource);
			
			//リソースパック内の情報を各種リソースに割り当て＆upload
			resourcePack.attachTo(resources, true, scene.context3D);
		}
		
	}

}