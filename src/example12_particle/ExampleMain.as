package example12_particle 
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import net.morocoshi.common.graphics.Create;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.particle.animators.ParticleAnimator;
	import net.morocoshi.moja3d.particle.animators.SprayParticleAnimator;
	import net.morocoshi.moja3d.particle.ParticleEmitter;
	import net.morocoshi.moja3d.particle.ParticleSystem;
	import net.morocoshi.moja3d.particle.range.CubeRange;
	import net.morocoshi.moja3d.particle.range.ParticleRange;
	import net.morocoshi.moja3d.particle.wind.TurbulenceWind;
	import net.morocoshi.moja3d.primitives.Cube;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.shaders.render.OpacityShader;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * パーティクルのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var system:ParticleSystem;
		private var wind:TurbulenceWind;
		
		[Embed(source = "asset/smoke.png")] private var Smoke:Class;
		
		public function ExampleMain() 
		{
			super(100, 500);
		}
		
		override public function init():void 
		{
			//3Dシーンの構成
			var planeMaterial:Material = new Material();
			planeMaterial.shaderList.addShader(new FillShader(0x666666, 1));
			planeMaterial.shaderList.addShader(new LambertShader());
			scene.root.addChild(new Plane(1500, 1500, 1, 1, 0.5, 0.5, false, planeMaterial, null)).z = -1;
			
			//パーティクル生成
			buildParticles();
			
			scene.root.upload(scene.context3D, true);
			
			
			//ボタンリスト
			buttons.addButton("60 FPS", setFPS, [60]);
			buttons.addButton("30 FPS", setFPS, [30]);
			buttons.addButton("15 FPS", setFPS, [15]);
			buttons.addButton("5 FPS", setFPS, [5]);
			buttons.addButton("WIND", switchWind, []);
			buttons.addButton("ENABLED", switchEnabled, []);
		}
		
		private function switchWind():void 
		{
			system.wind = system.wind? null : wind;
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
		
		override public function tick():void 
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
			
			system.emitters[2].rotationZ = time;
			
			system.update();
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
			
			var f:Number = 30;
			var animator:ParticleAnimator = new ParticleAnimator();
			animator.addAlphaKey(0, 0);
			animator.addAlphaKey(0.1, 0.4);
			animator.addAlphaKey(1, 0);
			animator.setLife(2, 3);
			animator.setScale(0.2);
			animator.setScaleSpeed(0.5);
			animator.setSpinSpeed( -0.5, 0.5);
			animator.friction = 0.5;
			animator.gravity = new Vector3D(0, 0, -10);
			animator.velocityMin = new Vector3D(-f, -f, -f);
			animator.velocityMax = new Vector3D(f, f, f);
			
			wind = new TurbulenceWind();
			wind.setNoise(124, 1500, 10);
			wind.setIntensity(700);
			
			var emitter1:ParticleEmitter = new ParticleEmitter();
			emitter1.particleWidth = 100;
			emitter1.particleHeight = 100;
			emitter1.range = new CubeRange(0, 0, 0);
			emitter1.animator = animator;
			emitter1.birthRate = 20;
			
			var emitter2:ParticleEmitter = emitter1.clone() as ParticleEmitter;
			
			var emitter3:ParticleEmitter = emitter1.clone() as ParticleEmitter;
			
			emitter1.rotationX = 1.14;
			
			var spray:SprayParticleAnimator = new SprayParticleAnimator();
			spray.addAlphaKey(0, 1);
			spray.addAlphaKey(1, 0);
			spray.gravity.z = -300;
			spray.friction = 0.5;
			spray.setLife(1, 1.2);
			spray.setScale(0.2);
			spray.setScaleSpeed(0.6);
			spray.setSprayIntensity(500);
			spray.setSprayRange(0, 20 / 180 * Math.PI);
			
			
			emitter2.range = new ParticleRange();
			emitter2.animator = spray;
			emitter2.birthRate = 80;
			
			emitter3.range = new CubeRange(200, 0, 0);
			emitter3.animator.velocityMin.z = 200;
			emitter3.animator.velocityMax.z = 200;
			emitter3.birthRate = 100;
			
			emitter1.addChild(new Sphere(8, 6, 4, fill1));
			emitter2.addChild(new Sphere(8, 6, 4, fill1));
			emitter2.addChild(new Cube(5, 5, 50, 1, 1, 1, fill2)).z = 25;
			emitter3.addChild(new Plane(200, 10, 1, 1, 0.5, 0.5, false, fill1, null));
			
			system = new ParticleSystem(material);
			system.addEmiter(emitter1);
			system.addEmiter(emitter2);
			system.addEmiter(emitter3);
			
			for each (var item:ParticleEmitter in system.emitters) 
			{
				scene.root.addChild(item);
			}
			
			system.setContetx3D(scene.context3D);
			system.play();
			
			scene.root.addChild(system);
		}
		
	}

}