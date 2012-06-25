package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class Iterator 
  {    
    public function Iterator() 
    {      
    }
    
    public function isValid() : Boolean
    {
      throw Error( "isValid has to be overridden." );
    }
    
    public function advance() : Iterator
    {
      throw Error( "advance has to be overridden.." );
    }
    
    public function get value() : *
    {
      throw Error( "value has to be overridden." );
    }
    
    public function equals( $b : Iterator ) : Boolean
    {
      throw Error( "equals has to be overridden." );
    }
  }
}