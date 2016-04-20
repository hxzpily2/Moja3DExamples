package example19_lod 
{
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.LOD;
	import net.morocoshi.moja3d.primitives.Sphere;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * LODのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		public function ExampleMain() 
		{
			super(0, 700);
		}
		
		override public function init():void 
		{
			scene.view.backgroundColor = 0x111111;
			
			//3つの球を生成
			var high:Sphere = new Sphere(50, 30, 20, new FillMaterial(0x4488ff, 1, true));
			var med:Sphere = new Sphere(50, 8, 6, new FillMaterial(0xff8800, 1, true));
			var low:Sphere = new Sphere(50, 4, 3, new FillMaterial(0xff2200, 1, true));
			
			//LODにオブジェクトを登録する。表示範囲をカメラ平面からの距離で指定する。
			var lod:LOD = new LOD();
			lod.registerObject(high, -Infinity, 1000);
			lod.registerObject(med, 1000, 2000);
			lod.registerObject(low, 2000, Infinity);
			
			//いっぱい配置
			for (var ix:int = -10; ix <= 10; ix++) 
			for (var iy:int = -10; iy <= 10; iy++) 
			{
				var cloned:LOD = lod.reference() as LOD;
				cloned.setPositionXYZ(ix * 200, iy * 200, 0);
				scene.root.addChild(cloned);
			}
			
			scene.root.upload(scene.context3D, true);
		}
		
	}

}