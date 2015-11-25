package example14_posteffect 
{
	import net.morocoshi.moja3d.filters.AuraFilter3D;
	import net.morocoshi.moja3d.filters.BloomFilter3D;
	import net.morocoshi.moja3d.filters.Filter3D;
	import net.morocoshi.moja3d.filters.GaussianFilter3D;
	import net.morocoshi.moja3d.filters.MaskPreviewFilter3D;
	import net.morocoshi.moja3d.filters.OutlineFilter3D;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.renderer.MaskColor;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * ポストエフェクトのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		[Embed(source = "asset/teapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		[Embed(source = "asset/noise.png")] private var Noise:Class;
		
		private var parser:M3DParser;
		
		public function ExampleMain() 
		{
			super(20, 250);
		}
		
		override public function init():void 
		{
			scene.view.backgroundColor = 0x999999;
			
			var teapot:Mesh = new M3DParser().parse(new Model).objects[0] as Mesh;
			teapot.upload(scene.context3D, true);
			
			for (var i:int = 0; i < 3; i++) 
			{
				var mesh:Mesh = teapot.reference() as Mesh;
				mesh.setPositionXYZ(i * 100 - 100, 0, 0);
				mesh.rotationZ = Math.PI * 45 / 180;
				
				var fill:Material = new FillMaterial([0x800000, 0x008000, 0x000080][i], 1, true);
				fill.shaderList.addShader(new SpecularShader(30, 1, false));
				fill.culling = "none";
				mesh.setMaterialToAllSurfaces(fill);
				mesh.renderMask = [MaskColor.RED, MaskColor.GREEN, MaskColor.BLUE][i];
				scene.root.addChild(mesh);
			}
			
			//各種フィルターの生成
			var preview:MaskPreviewFilter3D = new MaskPreviewFilter3D();
			var gaussian:GaussianFilter3D = new GaussianFilter3D(0.05, 10, 50, 2);
			var bloom:BloomFilter3D = new BloomFilter3D(0.3, 0.7, 5, 0.1, 10, 50, 2, MaskColor.BLUE);
			
			var noiseTexture:ImageTextureResource = new ImageTextureResource(new Noise);
			noiseTexture.upload(scene.context3D);
			var aura:AuraFilter3D = new AuraFilter3D(5, 0.2, 0.05, 10, 20, 4, noiseTexture, 0, 0.1, 5, 0, -1);
			aura.addAuraColor(MaskColor.RED, 0xff0000, 1);
			aura.addAuraColor(MaskColor.BLUE, 0x0000ff, 1);
			
			var outline:OutlineFilter3D = new OutlineFilter3D();
			outline.addElement(MaskColor.RED, 0xffff00, 1);
			outline.addElement(MaskColor.GREEN, 0x000000, 1);
			outline.addElement(MaskColor.BLUE, 0xffffff, 1);
			
			//ボタン
			buttons.addButton("None", setFilter3D, []);
			buttons.addButton("BloomFilter3D", setFilter3D, [bloom]);
			buttons.addButton("OutlineFilter3D", setFilter3D, [outline]);
			buttons.addButton("GaussianFilter3D", setFilter3D, [gaussian]);
			buttons.addButton("AuraFilter3D", setFilter3D, [aura]);
			buttons.addButton("MaskPreviewFilter3D", setFilter3D, [preview]);
		}
		
		private function setFilter3D(filter:Filter3D = null):void 
		{
			scene.filters.length = 0;
			if (filter)
			{
				scene.filters.push(filter);
			}
		}
		
	}

}