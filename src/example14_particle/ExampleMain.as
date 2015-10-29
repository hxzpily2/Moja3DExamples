package example14_particle 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import net.morocoshi.common.graphics.Create;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.particle.animators.ParticleAnimator;
	import net.morocoshi.moja3d.particle.animators.SprayParticleAnimator;
	import net.morocoshi.moja3d.particle.ParticleEmitter;
	import net.morocoshi.moja3d.particle.ParticleSystem;
	import net.morocoshi.moja3d.particle.range.CubeRange;
	import net.morocoshi.moja3d.particle.range.ParticleRange;
	import net.morocoshi.moja3d.primitives.Cube;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.resources.RenderTextureResource;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.shaders.render.OpacityShader;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * パーティクル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		private var scene:Scene3D;
		private var capturedTexture:RenderTextureResource;
		private var system:ParticleSystem;
		
		[Embed(source = "asset/smoke.png")] private var Smoke:Class;
		
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
			scene.setTPVController(stage, -45, 5, 500, 0, 0, 200);
			
			//3Dシーンの構成
			var planeMaterial:Material = new Material();
			planeMaterial.shadowThreshold = 0.1;
			planeMaterial.shaderList.addShader(new FillShader(0x333333, 1));
			planeMaterial.shaderList.addShader(new LambertShader());
			scene.root.addChild(new Plane(1500, 1500, 1, 1, 0.5, 0.5, false, planeMaterial, null)).z = -1;
			scene.root.addChild(new AmbientLight(0xffffff, 1));
			scene.root.addChild(new DirectionalLight(0xffffff, 1.0)).lookAtXYZ(1, 4, -6);
			
			
			//パーティクル生成
			buildParticles();
			
			
			scene.root.upload(scene.context3D, true, false);
			
			addEventListener(Event.EXIT_FRAME, tick);
			tick(null);
			
			
			//ボタンリスト
			var buttonList:LabelButtonList = new LabelButtonList(true, 15, 150);
			buttonList.x = 10;
			buttonList.y = 180;
			buttonList.addButton("60 FPS", setFPS, [60]);
			buttonList.addButton("30 FPS", setFPS, [30]);
			buttonList.addButton("15 FPS", setFPS, [15]);
			buttonList.addButton("5 FPS", setFPS, [5]);
			buttonList.addButton("ENABLED", switchEnabled, []);
			addChild(buttonList);
		}
		
		private function switchEnabled():void 
		{
			for each (var item:ParticleEmitter in system.emitters) 
			{
				item.enabled = !item.enabled;
			}
		}
		
		private function setFPS(fps:Number):void 
		{
			stage.frameRate = fps;
		}
		
		private function tick(e:Event):void 
		{
			var time:Number = getTimer() / 1000;
			
			system.emitters[0].x = Math.cos(time) * 150;
			system.emitters[0].y = Math.sin(time) * 150;
			system.emitters[0].z = Math.sin(time * 3) * 50 + 80;
			
			system.emitters[1].x = 0;
			system.emitters[1].y = 200;
			system.emitters[1].z = 300;
			system.emitters[1].rotationX = time * 1.4; 
			system.emitters[1].rotationY = time * 1.6;
			
			system.emitters[2].animator.setSpinSpeed(0, 0);
			system.emitters[2].rotationZ = time; 
		}
		
		private function buildParticles():void 
		{
			var fill1:FillMaterial = new FillMaterial(0xff0000, 1, false);
			var fill2:FillMaterial = new FillMaterial(0x0000ff, 1, false);
			
			var material:Material = new Material();
			material.opaquePassEnabled = false;
			var image:BitmapData = new BitmapData(16, 16, false);
			image.draw(Create.gradientBox(0, 0, 16, 16, true, -90, [0xffffff, 0x808080], [1, 1], [0, 1]));
			material.shaderList.addShader(new TextureShader(new ImageTextureResource(image), null));
			material.shaderList.addShader(new OpacityShader(new ImageTextureResource(new Smoke)));
			
			var animator:ParticleAnimator = new ParticleAnimator();
			animator.addAlphaKey(0, 0);
			animator.addAlphaKey(0.1, 0.4);
			animator.addAlphaKey(1, 0);
			animator.setLife(1.5, 2);
			animator.setScale(0.1, 0.2);
			animator.setScaleSpeed(0.1, 0.2);
			animator.setSpinSpeed(-0.5, 0.5);
			animator.gravity = new Vector3D(0, 0, -0.01);
			animator.velocityMin = new Vector3D(-0.2, -0.2, 1);
			animator.velocityMax = new Vector3D(0.2, 0.2, 0.7);
			
			var emitter:ParticleEmitter = new ParticleEmitter();
			emitter.particleWidth = 100;
			emitter.particleHeight = 100;
			emitter.range = new CubeRange(0, 0, 0);
			emitter.animator = animator;
			emitter.birthRate = 30;
			
			system = new ParticleSystem(material);
			system.addEmiter(emitter);
			system.addEmiter(emitter.clone() as ParticleEmitter);
			system.addEmiter(emitter.clone() as ParticleEmitter);
			
			var spray:SprayParticleAnimator = new SprayParticleAnimator();
			spray.addAlphaKey(0, 1);
			spray.addAlphaKey(1, 0);
			spray.gravity.z = -300;
			spray.setLife(1, 1.2);
			spray.setScale(0.1, 0.1);
			spray.setScaleSpeed(0.4, 0.5);
			spray.setSprayIntensity(500);
			spray.setSprayRange(0, 20 / 180 * Math.PI);
			
			system.emitters[1].range = new ParticleRange();
			system.emitters[1].animator = spray;
			system.emitters[1].birthRate = 100;
			
			system.emitters[2].range = new CubeRange(200, 10, 0);
			system.emitters[2].animator.velocityMin.z = 200;
			system.emitters[2].animator.velocityMax.z = 200;
			system.emitters[2].birthRate = 100;
			
			system.emitters[0].addChild(new Sphere(8, 6, 4, fill1));
			system.emitters[1].addChild(new Sphere(8, 6, 4, fill1));
			system.emitters[1].addChild(new Cube(5, 5, 50, 1, 1, 1, fill2)).z = 25;
			system.emitters[2].addChild(new Plane(200, 10, 1, 1, 0.5, 0.5, false, fill1, null));
			
			for each (var item:ParticleEmitter in system.emitters) 
			{
				scene.root.addChild(item);
			}
			
			system.setContetx3D(scene.context3D);
			system.startAutoUpdate();
			
			scene.root.addChild(system);
		}
		
	}

}