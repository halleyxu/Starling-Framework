/**
 * Created by rhett on 14-8-25.
 */
package starling.display
{

	import starling.display.*;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;

	import starling.display.*;

	import starling.display.DisplayObjectContainer;

	import flash.text.TextField;

	import starling.events.Event;


	/**
	 * 造假的TextField ，实际显示在nativeStage
	 */
	public class NativeTextfield extends DisplayObject
	{

		// 实体
		public var tf:TextField;

		private static var crossOverLayer:CrossOverLayer;

		public static function initCrossOver( parent:flash.display.DisplayObjectContainer ):void
		{
			if( crossOverLayer == null )
			{
				crossOverLayer = new CrossOverLayer();
			}
			parent.addChild( crossOverLayer );
		}


		public function NativeTextfield()
		{
			super();
			tf = new TextField();
		}


		override public function getBounds( targetSpace:DisplayObject, resultRect:Rectangle = null ):Rectangle
		{
			if( targetSpace != null )
			{
				var global:Point = targetSpace.localToGlobal( new Point( targetSpace.x, targetSpace.y ) );
				return new Rectangle( global.x, global.y, tf.width, tf.height );
			} else
			{
				return new Rectangle( tf.x, tf.y, tf.width, tf.height );
			}
		}


		private static var sHelperRect:Rectangle = new Rectangle();
		private static var sHelperPoint:Point = new Point();

		override public function render( support:RenderSupport, parentAlpha:Number ):void
		{
			if( parent && !tf.parent )
			{
				crossOverLayer.addChild( tf );
			}
			var pos:Point = localToGlobal( sHelperPoint );
			tf.x = pos.x + _x;
			tf.y = pos.y + _y;
		}


		override internal function setParent( value:DisplayObjectContainer ):void
		{
			if( value == null )
			{
				//native
				if( tf.parent ) tf.parent.removeChild( tf );
				parent.removeEventListener( Event.REMOVED_FROM_STAGE, onParentRemoved );
			} else
			{
				//native
				crossOverLayer.addChild( tf );
				value.addEventListener( Event.REMOVED_FROM_STAGE, onParentRemoved );
			}
			super.setParent( value );
		}


		private function onParentRemoved( event:Event ):void
		{
			if( tf.parent ) tf.parent.removeChild( tf );
		}


		private var _x:Number = 0.0;
		override public function get x():Number
		{
			return _x;
		}

		override public function set x( value:Number ):void
		{
			_x = value;
		}

		private var _y:Number = 0.0;
		override public function get y():Number{return _y;}

		override public function set y( value:Number ):void { _y = value;}



		// 以下是proxy

		public function get htmlText():String {return tf.htmlText;}

		public function set htmlText( v:String ):void {tf.htmlText = v;}

		public function set autoSize( v:String ):void {tf.autoSize = v;}
		public function get autoSize(  ):String {return tf.autoSize;}

		 public function get defaultTextFormat():flash.text.TextFormat { return tf.defaultTextFormat;}

		 public function set defaultTextFormat(format:flash.text.TextFormat):void { tf.defaultTextFormat = format; }



		override public function get height():Number
		{
			return tf.height;
		}

		override public function set height( value:Number ):void
		{
			tf.height = value;
		}

		override public function get width():Number
		{
			return tf.width;
		}

		override public function set width( value:Number ):void
		{
			tf.width = value;
		}
	}
}

import flash.display.Sprite;

class CrossOverLayer extends Sprite
{
	public function CrossOverLayer()
	{

	}
}