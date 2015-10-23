package example10_depthshadow 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.filters.BloomFilter3D;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.ParserMaterial;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Shadow;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.shaders.shadow.ShadowShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * デプスシャドウ
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		[Embed(source="asset/ring.m3d", mimeType="application/octet-stream")] private var Modal:Class;
		
		private var scene:Scene3D;
		private var parser:M3DParser;
		
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
			scene.startRendering();
			scene.view.startAutoResize(stage);
			scene.view.backgroundColor = 0x808080;
			scene.setTPVController(stage, -90, 5, 200, 0, 0, 20);
			
			scene.root.addChild(new AmbientLight(0xffffff, 1));
			
			var sun:DirectionalLight = new DirectionalLight(0xffffff, 1.0);
			sun.mainShadow = new Shadow();
			sun.mainShadow.setShadowArea(300, 1000);
			sun.mainShadow.depthBias *= 200;
			scene.root.addChild(sun).lookAtXYZ(5, 5, -5);
			
			var material:Material = new Material();
			material.shaderList.addShader(new FillShader(0x556677, 1));
			material.shaderList.addShader(new ShadowShader());
			material.shaderList.addShader(new LambertShader());
			scene.root.addChild(new Plane(1500, 1500, 1, 1, 0.5, 0.5, false, material, null)).z = -50;
			
			parser = new M3DParser();
			parser.parse(new Modal, scene.root);
			
			for each(var pm:ParserMaterial in parser.materials)
			{
				pm.shaderList.removeAllShader();
				pm.addTextureShader();
				pm.shaderList.addShader(new ShadowShader());
				pm.shaderList.addShader(new LambertShader());
			}
			
			scene.root.getChildAt(3).renderMask = 0xff0000;
			scene.filters.push(new BloomFilter3D(0, 0, 2, 3, 19, 50, 3, 0xff0000));
			//scene.filters.push(new MaskPreviewFilter3D());
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true, false);
			
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		private function tick(e:Event):void 
		{
			parser.animationPlayer.setTime(getTimer() / 1000);
		}
		
	}

}