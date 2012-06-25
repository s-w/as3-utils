package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public final class Queue 
  {    
    public function Queue() 
    {      
    }
    
    public function push( $value : * ) : Queue
    {
      _list.pushBack( $value );
      return this;
    }
    
    public function pop() : *
    {
      return _list.popFront();
    }
    
    public function isEmpty() : Boolean
    {
      return _list.isEmpty();
    }
    
    public function get head() : *
    {
      return _list.front;
    }
    
    public function get tail() : *
    {
      return _list.back;
    }
    
    public function get length() : int
    {
      return _list.length;
    }    
    
    private const _list : List = new List();    
  }
}
