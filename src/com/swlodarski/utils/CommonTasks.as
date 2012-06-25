package com.swlodarski.utils 
{
  import flash.utils.clearTimeout;
  import flash.utils.setTimeout;
	/**
   * ...
   * @author sw
   */
  public class CommonTasks 
  {
    public static function wait( $milliseconds : Number, $async : Boolean = false ) : Task
    {
      if ( $async ) {
        return new AsyncTask( {
          action: function( $task : Task ) : void {
            setTimeout( $task.complete, $milliseconds );
          }
        }});
      }
      else {
        return new Task( {
          action: function( $task : Task ) : void {
            setTimeout( $task.complete, $milliseconds );
          }
        }});
      }
    }
    
    public static function sleep( $milliseconds : Number, $async : Boolean = false ) : Task
    {      
      if ( $async ) {
        return new AsyncTask( _createSleepFunc( $milliseconds ));
      }
      else {
        return new Task( _createSleepFunc( $milliseconds ));
      }
    }
    
    private static function _createSleepFunc( $milliseconds : Number ) : Object
    {
      var tid : uint;
      return {
        action: function( $task : Task ) : void {
          tid = setTimeout( $task.complete, $milliseconds );
        },
        cancel: function() : void {
          clearTimeout( tid );
        }
      }
    }    
  }
}
