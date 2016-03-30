package example15_toonshader 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.ParserMaterial;
	import net.morocoshi.moja3d.materials.TriangleFace;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.ToonShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * トゥーンシェーダーのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var parser:M3DParser;
		private var toonShader:ToonShader;
		
		[Embed(source = "asset/model.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		[Embed(source = "asset/tone1.png")] private var ToneMap1:Class;
		[Embed(source = "asset/tone2.png")] private var ToneMap2:Class;
		[Embed(source = "asset/tone3.png")] private var ToneMap3:Class;
		
		public function ExampleMain() 
		{
			super(40, 200, false);
		}
		
		override public function init():void 
		{
			scene.view.backgroundColor = 0x1A6EAF;
			scene.root.addChild(new AmbientLight(0xffffff, 0.3));
			scene.root.addChild(new DirectionalLight(0xffffff, 1)).lookAtXYZ(2, -1, -1);
			
			parser = new M3DParser();
			parser.addEventListener(Event.COMPLETE, parser_completeHandler);
			parser.parse(new Model, scene.root);
		}
		
		private function parser_completeHandler(e:Event):void 
		{
			parser.removeEventListener(Event.COMPLETE, parser_completeHandler);
			
			var toneImages:Array = [new ToneMap1(), new ToneMap2(), new ToneMap3()];
			
			//LambertShaderの代わりにToonShaderを使う
			toonShader = new ToonShader(new ImageTextureResource(toneImages[0]));
			for each(var material:ParserMaterial in parser.materials)
			{
				material.culling = TriangleFace.BOTH;
				material.shaderList.removeAllShader();
				material.addTextureShader();
				material.shaderList.addShader(toonShader);
			}
			
			parser.resourcePack.attachTo(scene.root.getResources(true), false);
			scene.root.upload(scene.context3D, true);
			
			//トーンマップ切り替え用ボタンの生成
			for (var i:int = 0; i < toneImages.length; i++)
			{
				createButton(i, toneImages[i].bitmapData);
			}
			
			buttons.addButton("OUTLINE", switchOutlineEnabled);
			switchOutlineEnabled();
		}
		
		private function switchOutlineEnabled():void 
		{
			for (var i:int = 0; i < 3; i++) 
			{
				var m:Mesh = parser.objects[i] as Mesh;
				m.outlineEnabled = !m.outlineEnabled;
				m.outlineThickness = 3;
				m.outlineColor = 0x000000;
				m.outlineAlpha = 1;
			}
		}
		
		private function createButton(i:int, image:BitmapData):void 
		{
			var resource:ImageTextureResource = new ImageTextureResource(image);
			resource.upload(scene.context3D);
			
			var clip:Sprite = new Sprite();
			clip.addChild(new Bitmap(image));
			clip.width = clip.height = 80;
			clip.x = i * 100 + 110;
			clip.y = 25;
			clip.buttonMode = true;
			clip.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				toonShader.resource = resource;
			});
			stage.addChild(clip);
		}
		
		override public function tick():void 
		{
			if (!parser.objects.length) return;
			
			var time:Number = getTimer() / 1000;
			for (var i:int = 0; i < 3; i++) 
			{
				parser.objects[i].rotationZ = time;
			}
		}
		
	}

}