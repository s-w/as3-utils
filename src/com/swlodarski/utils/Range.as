package com.swlodarski.utils 
{
	/**
   * ...
   * @author sw
   */
  public final class Range 
  {    
    public function Range( $begin : Iterator, $end : Iterator ) 
    {
      begin = $begin;
      end = $end;
    }
    
    public function foreach( $func : Function, $this : * = null ) : void
    {
      while ( !begin.equals( end )) {
        $func.call( $this, begin.value );
        begin.advance();
      }
    }
    
    public var begin : Iterator;
    public var end : Iterator;
  }
}