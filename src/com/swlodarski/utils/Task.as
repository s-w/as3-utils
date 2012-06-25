package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class Task
  {    
    public function Task( $vars : Object ) 
    {
      _self = $vars.self;
      _name = $vars.name as String;
      _action = $vars.action as Function;
      _cancel = $vars.cancel as Function;
    }
    
    public function complete() : void
    {
      if ( !_completed ) {
        _completed = true;
        _worker._next();
      }
    }
  
    public function get name() : String 
    {
      return _name;
    }
    
    public function get data() : *
    {
      return _worker.data;
    }
    
    public function set data( $data : * ) : void
    {
      _worker.data = $data;
    }
    
    public function get async() : Boolean
    {
      return false;
    }
    
    public function cancel() : void
    {
      if ( this == _worker.activeTask ) {
        _worker.cancelActiveTask();
      }
    }
        
    internal var _self : * ;
    internal var _name : String;
    internal var _action : Function;
    internal var _cancel : Function;
    internal var _worker : Worker;
    private var _completed : Boolean = false;
  }
}
