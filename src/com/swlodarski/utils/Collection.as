package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class Collection 
  {    
    public function foreach( $func : Function, $this : * = null ) : void
    {
      throw Error( "foreach has to be overridden." );
    }
    
    public function iterator( $position : int = 0 ) : Iterator
    {
      throw Error( "iterator has to be overridden." );
    }
    
    public function reverseIterator( $position : int = 0 ) : ReverseIterator
    {
      throw Error( "reverse_iterator has to be overridden." );
    }
    
    public function get length() : int
    {
      throw Error( "length has to be overridden." );
    }
    
    public function isEmpty() : Boolean
    {
      throw Error( "isEmpty has to be overridden." );
    }
  }
}