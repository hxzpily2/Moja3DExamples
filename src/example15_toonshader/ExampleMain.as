package example15_toonshader 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.ParserMaterial;
	import net.morocoshi.moja3d.materials.TriangleFace;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
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
		private var toonImages:Array;
		
		[Embed(source = "asset/model.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		[Embed(source = "asset/toonshadow1.png")] private var ToonImage1:Class;
		[Embed(source = "asset/toonshadow2.png")] private var ToonImage2:Class;
		[Embed(source = "asset/toonshadow3.png")] private var ToonImage3:Class;
		
		public function ExampleMain() 
		{
			super(20, 300, false);
		}
		
		override public function init():void 
		{
			toonImages = [new ToonImage1(), new ToonImage2(), new ToonImage3()];
			
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
			
			toonShader = new ToonShader(new ImageTextureResource(toonImages[0]), true, 70, 0x000000);
			for each(var material:ParserMaterial in parser.materials)
			{
				material.culling = TriangleFace.BOTH;
				material.shaderList.removeAllShader();
				material.addTextureShader();
				material.shaderList.addShader(toonShader);
			}
			
			parser.resourcePack.attachTo(scene.root.getResources(true), false);
			scene.root.upload(scene.context3D, true);
			
			for (var i:int = 0; i < 3; i++ )
			{
				createButton(i);
			}
			
			buttons.addButton("OUTLINE", switchOutlineEnabled);
		}
		
		private function switchOutlineEnabled():void 
		{
			toonShader.outlineEnabled = !toonShader.outlineEnabled;
		}
		
		private function createButton(i:int):void 
		{
			var clip:Sprite = new Sprite();
			clip.x = i * 100 + 110;
			clip.y = 25;
			var image:Bitmap = toonImages[i]
			image.width = 80;
			image.height = 80;
			clip.addChild(image);
			stage.addChild(clip);
			
			var resource:ImageTextureResource = new ImageTextureResource(image);
			resource.upload(scene.context3D);
			
			clip.buttonMode = true;
			clip.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				setToonTexture(resource);
			});
		}
		
		private function setToonTexture(resource:ImageTextureResource):void 
		{
			toonShader.resource = resource;
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