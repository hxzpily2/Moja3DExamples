package example17_line 
{
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.filters.BloomFilter3D;
	import net.morocoshi.moja3d.objects.Line3D;
	import net.morocoshi.moja3d.renderer.MaskColor;
	import net.morocoshi.moja3d.resources.LinePoint;
	import net.morocoshi.moja3d.resources.LineSegment;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * ラインのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var beam:Line3D;
		
		public function ExampleMain() 
		{
			super(0, 200);
		}
		
		override public function init():void 
		{
			scene.view.backgroundColor = 0x111111;
			
			var torus:Line3D = createTorus();
			torus.renderMask = MaskColor.BLACK;
			torus.lineGeometry.upload(scene.context3D);
			
			beam = new Line3D();
			beam.renderMask = MaskColor.RED;
			var seg:LineSegment = beam.lineGeometry.addSegment(6);
			for (var i:int = 0; i < 10; i++) 
			{
				seg.addPoint(0, 0, 0, 0xffff00, 0.99 - i / 10);
			}
			
			scene.root.addChild(torus);
			scene.root.addChild(beam);
			
			scene.filters.push(new BloomFilter3D(0, 0, 5, 0.05, 15, 50, 2, MaskColor.RED));
		}
		
		private function createTorus():Line3D 
		{
			var torus:Line3D = new Line3D();
			
			var segment:LineSegment = torus.lineGeometry.addSegment(2.5);
			var q:Number = 4.1;
			var n:int = 1000;
			for (var i:int = 0; i < n; i++) 
			{
				var p:Number = i / n;
				var t:Number = Math.PI * 2 * p * 10;
				var r:Number = Math.cos(t * q) * 20 + 80;
				var tx:Number = Math.cos(t) * r;
				var ty:Number = Math.sin(t) * r;
				var tz:Number = Math.sin(t * q) * 20;
				var rgb:uint = (0x80 * p) << 16 | (0xAA * p) << 8 | 0xff;
				segment.addPoint(tx, ty, tz, rgb, 1);
			}
			segment.close();
			torus.calculateBounds();
			
			return torus;
		}
		
		override public function tick():void 
		{
			var time:Number = getTimer() / 500;
			var n:int = beam.lineGeometry.segments[0].points.length;
			for (var i:int = 0; i < n; i++) 
			{
				var p:LinePoint = beam.lineGeometry.segments[0].points[i];
				var t:Number = time - i * 0.1;
				p.x = Math.cos(t * 5.8) * 30;
				p.y = Math.sin(t * 3.6) * 30;
				p.z = Math.cos(t * 4.7) * 30;
			}
			beam.lineGeometry.upload(scene.context3D);
		}
		
	}

}