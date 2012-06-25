package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class StringUtil 
  {
    public static const CHARS : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/.,';][=-`~!@#$%^&*(){}\":?><\|";

    public static function startsWith( $str : String, $start : String ) : Boolean
    {
      return $str.length < $start.length ? 
        false : $str.slice( 0, $start.length ) == $start;
    }    
    
    public static function endsWith( $str : String, $end : String ) : Boolean
    {
      return $str.length < $end.length ? 
        false : $str.slice( 0 - $end.length ) == $end;
    }
    
    public static function pushFront( $src : String, $what : String, $count : int = 1 ) : String
    {
      var str : String = "";
      while ( $count-- > 0 ) {
        str += $what;
      }      
      return str + $src;
    }
    
    public static function pushBack( $src : String, $what : String, $count : int = 1 ) : String
    {
      var str : String = "";
      while ( $count-- > 0 ) {
        str += $what;
      }
      return $src + str;
    }
    
    public static function random( $length : int ) : String
    {
      return randomFrom( $length, CHARS );
    }
    
    public static function randomFrom( $length : int, $str : String ) : String
    {
      var rs : String = "";
      const strLen : int = $str.length;
      for ( var i : int = 0 ; i < $length ; i += 1 ) {
        rs += $str.charAt( Random.nextInt( 0, strLen ));
      }
      return rs;
    }
  }
}
