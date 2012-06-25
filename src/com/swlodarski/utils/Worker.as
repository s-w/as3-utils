package com.swlodarski.utils 
{
  import com.swlodarski.utils.List;
  import flash.utils.setTimeout;
	/**
   * @author sw
   */
  public class Worker
  {
    public var data : * = null;
    
    public function Worker( $props : Object = null ) 
    {
      if ( $props != null ) {
        data = $props.data;
        _self = $props.self;
        _cancel = $props.cancel as Function;
        _complete = $props.complete as Function;
      }
    }
    
    public function get length() : int
    {
      return _tasks.length;
    }
    
    public function get activeTask() : Task
    {
      return _activeTask;
    }
    
    public function at( $pos : int ) : Task
    {
      return _tasks.at( $pos );
    }
    
    public function getTaskByName( $name : String ) : Task
    {
      function pred( $task : Task ) : Boolean 
      {
        return $task.name == $name;
      }
      return _tasks.find( pred );
    }
    
    public function pushFront( $what : * ) : Worker
    {
      if ( $what is Task ) {
        const t : Task = Task( $what );
        t._worker = this;
        _tasks.pushFront( t );        
      }
      else if ( $what is Array ) {
        const ts : Array = $what as Array;
        for ( var i : int = ts.length ; i >= 0 ; i -= 1 ) {
          ts[ i ]._worker = this;
          _tasks.pushFront( ts[ i ]);
        }
      }
      return this;
    }
    
    public function pushBack( $what : * ) : Worker
    {
      if ( $what is Task ) {
        const t : Task = Task( $what );
        t._worker = this;
        _tasks.pushBack( t );
      }
      else if ( $what is Array ) {
        const ts : Array = $what as Array;
        for ( var i : int = 0 ; i < ts.length ; i += 1 ) {
          ts[ i ]._worker = this;
          _tasks.pushBack( ts[ i ]);
        }
      }
      return this;
    }
    
    public function remove( $task : Task ) : Worker
    {
      _tasks.remove( $task );
      return this;
    }
    
    public function removeAt( $pos : int ) : Task
    {
      return _tasks.removeAt( $pos );
    }
    
    public function start() : void 
    {
      _active = true;
      _next();
    }
    
    public function stop() : void
    {
      _active = false;
    }
    
    public function clear() : void
    {
      _tasks.clear();
      _active = false;
    }
    
    public function completeActiveTask() : void
    {
      if( _activeTask != null ) {
        _activeTask.complete();
      }
    }
    
    public function cancelActiveTask() : void
    {
      if ( _activeTask != null ) {
        if ( _activeTask._cancel != null ) {
          if( _activeTask._cancel.length == 0 ) {
            _activeTask._cancel.call( _activeTask._self );        
          }
          else {
            _activeTask._cancel.call( _activeTask._self, _activeTask );
          }
        }
        _activeTask = null;
        _active = false;
      }
    }
    
    public function cancel() : void
    {      
      if ( _active ) {
        _active = false;
        if ( _activeTask && _activeTask._cancel != null ) {
          if( _activeTask._cancel.length == 0 ) {
            _activeTask._cancel.call( _activeTask._self );        
          }
          else {
            _activeTask._cancel.call( _activeTask._self, _activeTask );
          }
        }
        _activeTask = null;
      }
      _tasks.clear();
      if ( _cancel != null ) {
        if ( _cancel.length == 0 ) {
          _cancel.call( _self );
        }
        else {
          _cancel.call( _self, this );
        }
        _cancel = null;
      }
    }   
    
    internal function _next() : void
    {
      if( _active ) {
        if ( !_tasks.isEmpty()) {
          if ( Task( _tasks.front ).async ) {
            setTimeout( _nextAsync, 1 );
          }
          else {
            _activeTask = _tasks.popFront();
            if ( _activeTask._action.length == 0 ) {
              _activeTask._action.call( _activeTask._self );
              _activeTask.complete();
            }
            else {
              _activeTask._action.call( _activeTask._self, _activeTask );
            }
          }
        }
        else {
          _active = false
          _activeTask = null;
          if ( _complete != null ) {
            if( _complete.length == 0 ) {
              _complete.call( _self );
            }
            else {
              _complete.call( _self, this );
            }
            _complete = null;
          }
          _cancel = null;
        }
      }      
    }    

    private function _nextAsync() : void
    {
      if( _active ) {
        _activeTask = _tasks.popFront();
        if ( _activeTask._action.length == 0 ) {
          _activeTask._action.call( _activeTask._self );
          _activeTask.complete();
        }
        else {
          _activeTask._action.call( _activeTask._self, _activeTask );
        }
      }
    }
    
    private const _tasks : List = new List();
    private var _activeTask : Task = null;
    private var _active : Boolean = false;
    private var _cancel : Function;
    private var _complete : Function;
    private var _self : * ;
  }
}
