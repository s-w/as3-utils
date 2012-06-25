package com.swlodarski.utils 
{
  import flash.utils.Dictionary;
  import mx.utils.ObjectUtil;
	/**
   * @author sw
   */
  public class DictionaryUtil 
  {    
    public static function isEmpty( $dict : Dictionary ) : Boolean
    {
      for each( var e : * in $dict ) {
        return false;
      }
      return true;
    }
    
    public static function keys( $dict : Dictionary ) : Array
    {
      const v : Array = [];
      for( var key : * in $dict ) {
        v.push( key );
      }
      return v;
    }
    
    public static function values( $dict : Dictionary ) : Array
    {
      const v : Array = [];
      for each( var value : * in $dict ) {
        v.push( value );
      }
      return v;
    }
    
    public static function keysValues( $dict : Dictionary ) : Array
    {
      const v : Array = [];
      for( var key : * in $dict ) {
        v.push({ key: key, value: $dict[ key ]});
      }
      return v;
    }
    
    public static function toDict( $arr : Array, $weakKeys : Boolean = false ) : Dictionary
    {
      const d : Dictionary = new Dictionary( $weakKeys );
      for ( var key : * in $arr ) {
        d[ $arr[ key ]] = key;
      }
      return d;
    }
    
    public static function toString( $dict : Dictionary ) : String
    {
      return ObjectUtil.toString( $dict );      
    }
  }
}
