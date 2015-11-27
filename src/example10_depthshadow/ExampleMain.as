package example10_depthshadow 
{
	import flash.events.Event;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.ParserMaterial;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Shadow;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	import net.morocoshi.moja3d.shaders.render.VertexColorShader;
	import net.morocoshi.moja3d.shaders.shadow.ShadowFadeType;
	import net.morocoshi.moja3d.shaders.shadow.ShadowShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * デプスシャドウのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var parser:M3DParser;
		private var sun:DirectionalLight;
		
		[Embed(source="asset/image1.jpg")] private var Diffuse:Class;
		[Embed(source = "asset/teapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		
		public function ExampleMain() 
		{
			super(20);
		}
		
		override public function init():void 
		{
			//ライト
			sun = new DirectionalLight(0xffffff, 2);
			sun.mainShadow = new Shadow();
			sun.mainShadow.setShadowArea(70, 70);
			sun.mainShadow.depthBias *= 50;
			sun.mainShadow.zNear = -80; 
			scene.root.addChild(sun).lookAtXYZ(10, 10, -10);
			
			//ティーポット
			parser = new M3DParser();
			parser.addEventListener(Event.COMPLETE, complete);
			parser.parse(new Model, scene.root);
		}
		
		private function complete(e:Event):void 
		{
			var shadowShader:ShadowShader = new ShadowShader(true, ShadowFadeType.CLIP_BORDER);
			
			var material:Material = new Material();
			material.shaderList.addShader(new FillShader(0x665544, 1));
			material.shaderList.addShader(shadowShader);
			material.shaderList.addShader(new LambertShader());
			scene.root.addChild(new Plane(1000, 1000, 1, 1, 0.5, 0.5, false, material, null));
			
			for each (var parserMaterial:ParserMaterial in parser.materials) 
			{
				parserMaterial.shaderList.removeAllShader();
				parserMaterial.shaderList.addShader(new TextureShader(new ImageTextureResource(new Diffuse), null));
				parserMaterial.shaderList.addShader(shadowShader);
				parserMaterial.shaderList.addShader(new LambertShader());
				parserMaterial.shaderList.addShader(new SpecularShader(100, 1, false));
				parserMaterial.shaderList.addShader(new VertexColorShader());
			}
			
			scene.root.upload(scene.context3D, true);
			
			buttons.addButton("DEBUG", debug);
		}
		
		private function debug():void 
		{
			sun.mainShadow.debug = !sun.mainShadow.debug;
		}
		
	}

}