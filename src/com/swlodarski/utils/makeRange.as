package com.swlodarski.utils 
{
	/**
   * @author sw
   */    
  public function makeRange( $begin : Iterator, $end : Iterator ) : Range
  {
    return new Range( $begin, $end );
  }
}