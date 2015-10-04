package 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author tencho
	 */
	public class LabelButtonList extends Sprite 
	{
		public var isVertical:Boolean;
		public var padding:Number;
		public var size:Number;
		private var offset:Number;
		
		public function LabelButtonList(isVertical:Boolean, padding:Number, size:Number) 
		{
			this.isVertical = isVertical;
			this.padding = padding;
			this.size = size;
			offset = 0;
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function addSpace(size:Number):void
		{
			offset += size;
		}
		
		public function addButton(label:String, click:Function = null, args:Array = null):LabelButton
		{
			var button:LabelButton = new LabelButton(label, size, click, args);
			if (isVertical)
			{
				button.y = offset;
			}
			else
			{
				button.x = offset;
			}
			offset = (isVertical? offset + button.height : offset + button.width) + padding;
			addChild(button);
			
			return button;
		}
		
	}

}