package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public final class Stack 
  {    
    public function Stack() 
    {      
    }
    
    public function get size() : int
    {
      return _list.length;
    }
    
    public function push( $value : * ) : Stack
    {
      _list.push( $value );
      return this;
    }
    
    public function pop() : *
    {
      return _list.pop();
    }
    
    public function isEmpty() : Boolean
    {
      return _list.isEmpty();
    }
    
    public function get top() : * 
    {
      return _list.front;
    }
    
    private const _list : LinkedList = new LinkedList();    
  }
}
