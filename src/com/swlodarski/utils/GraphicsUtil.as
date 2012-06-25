package com.swlodarski.utils 
{
  import flash.display.Graphics;
  import flash.display.Shape;
	/**
   * @author sw
   */
  public class GraphicsUtil 
  {    
		public static function createRect( $width : Number, $height : Number, 
	    $color : uint = 0x000000, $alpha : Number = 1.0 ) : Shape
		{
			var s : Shape = new Shape();
			drawRect( s.graphics, $width, $height, $color, $alpha );
			return s;
		}
    
		public static function drawRect( $display : Graphics, $width : Number, $height : Number,       
      $color : int = 0x000000, $alpha : Number = 1.0, $x : int = 0, $y : int = 0 ) : void
		{
			$display.beginFill( $color, $alpha );
			$display.drawRect( $x, $y, $width, $height );
			$display.endFill();
		}
		
		public static function createRoundRect( $width : Number, $height : Number,
      $ellipseWidth : Number, $ellipseHeight : Number, $color : int = 0x000000, $alpha : Number = 1.0 ) : Shape
		{
			var s : Shape = new Shape();
			drawRoundRect( s.graphics, $width, $height, $ellipseWidth, $ellipseHeight, $color, $alpha );
			return s;
		}
		
		public static function drawRoundRect( $display : Graphics, $width : Number, $height : Number,
      $ellipseWidth : Number, $ellipseHeight : Number, $color : int = 0x000000, $alpha : Number = 1.0 ) : void
		{
			$display.beginFill( $color, $alpha );
			$display.drawRoundRect( 0, 0, $width, $height, $ellipseWidth, $ellipseHeight );
			$display.endFill();			
		}
		
		public static function createGradientRect( $width : Number, $height : Number,
		  $type : String, $colors : Array, $alphas : Array, $ratios : Array, 
			$matrix : Matrix = null, $spreadMethod : String = "pad", 
			$interpolationMethod : String = "rgb", $focalPointRatio : Number = 0 ) : Shape
		{
			var s : Shape = new Shape();
      drawGradientRect( s.graphics, $width, $height, $type, $colors, $alphas, 
        $ratios, $matrix, $spreadMethod, $interpolationMethod, $focalPointRatio );
      return s;
		}
		
		public static function drawGradientRect( $display : Graphics, $width : Number, $height : Number,
		  $type : String, $colors : Array, $alphas : Array, $ratios : Array, 
			$matrix : Matrix = null, $spreadMethod : String = "pad", 
			$interpolationMethod : String = "rgb", $focalPointRatio : Number = 0 ) : void
		{
			if( $matrix == null ) {
				$matrix = new Matrix();
				$matrix.createGradientBox( $width, $height, 0, 0, 0 );
			}
			$display.beginGradientFill( $type, $colors, $alphas, $ratios, $matrix, 
			  $spreadMethod, $interpolationMethod, $focalPointRatio );
			$display.drawRect( 0, 0, $width, $height );
			$display.endFill();
		}
    
		public static function createCircle( $radius : Number,
		  $color : uint = 0x000000, $alpha : Number = 1.0 ) : Shape
		{
			var s : Shape = new Shape();
			drawCircle( s.graphics, $radius, $color, $alpha );
			return s;
		}	
		
		public static function drawCircle( $display : Graphics, $radius : Number,
      $color : int = 0x000000, $alpha : Number = 1.0 ) : void
		{
			$display.clear();
			$display.beginFill( $color, $alpha );
			$display.drawCircle( 0, 0, $radius );
			$display.endFill();
		}
	}
}
