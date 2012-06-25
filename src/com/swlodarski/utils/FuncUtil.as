package com.swlodarski.utils 
{
	/**
   * ...
   * @author sw
   */
  public class FuncUtil 
  {
    public static function applyFront( $func : Function, $args : Array, $this : * = null ) : Function
    {
      const diff : int = $func.length - $args.length;
      if ( diff == 0 ) {
        return function() : * {
          return $func.apply( $this, $args );
        }
      }
      else if ( diff == 1 ) { 
        return function( $a1 : * ) : * {
          return $func.apply( $this, $args.concat( $a1 ));
        }
      }
      else if ( diff == 2 ) { 
        return function( $a1 : *, $a2 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2 ));
        }
      }
      else if ( diff == 3 ) { 
        return function( $a1 : *, $a2 : * , $a3 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3 ));
        }
      }
      else if ( diff == 4 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4 ));
        }
      }
      else if ( diff == 5 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4, $a5 ));
        }
      }
      else if ( diff == 6 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4, $a5, $a6 ));
        }
      }
      else if ( diff == 7 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4, $a5, $a6, $a7 ));
        }
      }
      else if ( diff == 8 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8 ));
        }
      }
      else if ( diff == 9 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : *, $a9 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9 ));
        }
      }
      else if ( diff == 10 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : *, $a9 : *, $a10 : * ) : * {
          return $func.apply( $this, $args.concat( $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $a10 ));
        }
      }
      else {
        return function( $args1 : Array ) : * {
          return $func.apply( $this, $args.concat( $args1 ));
        }
      }
    }
    
    public static function applyBack( $func : Function, $args : Array, $this : * = null ) : Function
    {
      const diff : int = $func.length - $args.length;
      if ( diff == 0 ) {
        return function() : * {
          return $func.apply( $this, $args );
        }
      }
      else if ( diff == 1 ) { 
        return function( $a1 : * ) : * {
          return $func.apply( $this, [ $a1 ].concat( $args ));
        }
      }
      else if ( diff == 2 ) { 
        return function( $a1 : *, $a2 : * ) : * {
          return $func.apply( $this, [ $a1, $a2 ].concat( $args ));
        }
      }
      else if ( diff == 3 ) { 
        return function( $a1 : *, $a2 : * , $a3 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3 ].concat( $args ));
        }
      }
      else if ( diff == 4 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4 ].concat( $args ));
        }
      }
      else if ( diff == 5 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4, $a5 ].concat( $args ));
        }
      }
      else if ( diff == 6 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4, $a5, $a6 ].concat( $args ));
        }
      }
      else if ( diff == 7 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4, $a5, $a6, $a7 ].concat( $args ));
        }
      }
      else if ( diff == 8 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8 ].concat( $args ));
        }
      }
      else if ( diff == 9 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : *, $a9 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9 ].concat( $args ));
        }
      }
      else if ( diff == 10 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : *, $a9 : *, $a10 : * ) : * {
          return $func.apply( $this, [ $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $a10 ].concat( $args ));
        }
      }
      else {
        return function( $args1 : Array ) : * {
          return $func.apply( $this, $args1.concat( $args ));
        }
      }
    }
    
    public static function negate( $func : Function, $this : * = null ) : Function
    {
      if ( $func.length == 0 ) {
        return function() : * {
          return !$func.call( $this );
        }
      }
      else if ( $func.length == 1 ) { 
        return function( $a1 : * ) : * {
          return !$func.call( $this, $a1 );
        }
      }
      else if ( $func.length == 2 ) { 
        return function( $a1 : *, $a2 : * ) : * {
          return !$func.call( $this, $a1, $a2 );
        }
      }
      else if ( $func.length == 3 ) { 
        return function( $a1 : *, $a2 : * , $a3 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3 );
        }
      }
      else if ( $func.length == 4 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4 );
        }
      }
      else if ( $func.length == 5 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4, $a5 );
        }
      }
      else if ( $func.length == 6 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4, $a5, $a6 );
        }
      }
      else if ( $func.length == 7 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4, $a5, $a6, $a7 );
        }
      }
      else if ( $func.length == 8 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8 );
        }
      }
      else if ( $func.length == 9 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : *, $a9 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9 );
        }
      }
      else if ( $func.length == 10 ) { 
        return function( $a1 : *, $a2 : *, $a3 : *, $a4 : *, $a5 : *, $a6 : *, $a7 : *, $a8 : *, $a9 : *, $a10 : * ) : * {
          return !$func.call( $this, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $a10 );
        }
      }
      else {
        return function( $args1 : Array ) : * {
          return !$func.apply( $this, $args1 );
        }
      }
    }
  }
}