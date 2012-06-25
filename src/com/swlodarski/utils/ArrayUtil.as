package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class ArrayUtil 
  {
    public static function create( $length : int, $func : Function, $this : * = null ) : Array
    {
      const arr : Array = [];
      var i : int;
      if ( $func.length == 0 ) {
        for ( i = 0 ; i < $length ; i += 1 ) {
          arr.push( $func.call( $this ));
        }
      }
      else if( $func.length == 1 ) {
        for ( i = 0 ; i < $length ; i += 1 ) {
          arr.push( $func.call( $this, i ));
        }
      }
      else if( $func.length == 2 ) {
        for ( i = 0 ; i < $length ; i += 1 ) {
          arr.push( $func.call( $this, i, $length ));
        }
      }
      else if( $func.length == 3 ) {
        for ( i = 0 ; i < $length ; i += 1 ) {
          arr.push( $func.call( $this, i, $length, arr ));
        }
      }
      return arr;
    }
    
    public static function sequence( $init : Number, $step : Number, $count : int ) : Array
    {
      const arr : Array = [];
      for ( var i : int = 0 ; i < $count ; i += 1 ) {
        arr.push( $init );
        $init += $step;
      }
      return arr;
    }
    
    public static function indexOfOn( $arr : Array, $member : String, $elem : *, $from : int = 0 ) : int
    {
      var e : *;
      if ( $from >= 0 ) {
        const len : int = $arr.length;
        for ( ; $from < len ; $from += 1 ) {
          e = $arr[ $from ];
          if ( e[ $member ] == $elem ) {
            return $from;
          }
        }
        return -1;
      }
      else {
        $from = $arr.length + $from;
        for ( ; $from >= 0 ; $from -= 1 ) {
          e = $arr[ $from ];
          if ( e[ $member ] == $elem ) {
            return $from;
          }
        }
        return -1;
      }
    }
    
    /**
     * Shuffles elements of an array in place and returns that array.
     * @param	$arr Array to be shuffled.
     * @return Shuffled array $arr (reference to the same array)
     */
    public static function shuffle( $arr : Array ) : Array
    {
      const n : int = $arr.length;
      var tmp : *, r : int;
      for( var i : int = 0 ; i < n - 1 ; i += 1 ) {
         r = i + Random.nextInt( 0, n - i );
         tmp = $arr[ i ];
         $arr[ i ] = $arr[ r ];
         $arr[ r ] = tmp;
      }
      return $arr;
    }
  }
}