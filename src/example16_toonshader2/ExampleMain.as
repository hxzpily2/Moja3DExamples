package example16_toonshader2 
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
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.objects.Outline;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.ToonTextureShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * トゥーンシェーダーのサンプル2
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var parser:M3DParser;
		private var toonShader:ToonTextureShader;
		
		[Embed(source = "asset/model.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		[Embed(source = "asset/texture1.jpg")] private var Texture1:Class;
		[Embed(source = "asset/texture2.jpg")] private var Texture2:Class;
		[Embed(source = "asset/texture3.jpg")] private var Texture3:Class;
		[Embed(source = "asset/texture4.jpg")] private var Texture4:Class;
		[Embed(source = "asset/tone1.png")] private var ToneMap1:Class;
		[Embed(source = "asset/tone2.png")] private var ToneMap2:Class;
		[Embed(source = "asset/tone3.png")] private var ToneMap3:Class;
		
		public function ExampleMain() 
		{
			super(40, 200, false);
		}
		
		override public function init():void 
		{
			//※平行光源は1個だけで、強度は1にしておく（重要）
			scene.root.addChild(new DirectionalLight(0xffffff, 1)).lookAtXYZ(2, -1, -1);
			
			//このモデルにテクスチャは含まれないのでパースに延滞は発生しない（COMPLETEイベントを待たなくていい）
			parser = new M3DParser();
			parser.parse(new Model, scene.root);
			
			var toneImages:Array = [new ToneMap1(), new ToneMap2(), new ToneMap3()];
			
			//4段階の明るさのテクスチャ画像。diffuse1は一番明るく、diffuse4は一番暗い。
			var diffuse1:ImageTextureResource =　new ImageTextureResource(new Texture1);
			var diffuse2:ImageTextureResource =　new ImageTextureResource(new Texture2);
			var diffuse3:ImageTextureResource =　new ImageTextureResource(new Texture3);
			var diffuse4:ImageTextureResource =　new ImageTextureResource(new Texture4);
			
			//トーンマップの色は右から明るい順に0xFFFFFF,0xAAAAAA,0x555555,0x000000の4色にしておく
			//このそれぞれの階調がdiffuse1～diffuse4のテクスチャに割り当てられる
			var toneMap:ImageTextureResource =　new ImageTextureResource(toneImages[0]);
			
			//TextureShaderの代わりにToonTextureShaderを使う
			toonShader = new ToonTextureShader(diffuse1, diffuse2, diffuse3, diffuse4, null, toneMap);
			for each(var material:ParserMaterial in parser.materials)
			{
				material.culling = TriangleFace.BOTH;
				material.shaderList.removeAllShader();
				material.shaderList.addShader(toonShader);
			}
			scene.root.upload(scene.context3D, true);
			
			//トーンマップ切り替え用ボタンの生成
			for (var i:int = 0; i < toneImages.length; i++)
			{
				createButton(i, toneImages[i].bitmapData);
			}
			
			for each(var mesh:Mesh in parser.getObjectsAs(Mesh)) 
			{
				mesh.outline = new Outline(3, 0x000000, 1, true);
			}
			
			buttons.addButton("OUTLINE", switchOutlineEnabled);
			switchOutlineEnabled();
		}
		
		/**
		 * アウトラインのON/OFF
		 */
		private function switchOutlineEnabled():void 
		{
			for each(var mesh:Mesh in parser.getObjectsAs(Mesh)) 
			{
				mesh.outline.enabled = !mesh.outline.enabled;
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
				toonShader.toneMap = resource;
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