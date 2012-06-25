package com.swlodarski.utils 
{
  import flash.utils.clearTimeout;
  import flash.utils.setTimeout;
	/**
   * @author sw
   */
  public class AsyncTask extends Task 
  {    
    public function AsyncTask( $vars : Object ) 
    {
      super( $vars );	
    }  
    
    override public function get async() : Boolean 
    {
      return true;
    }
  }
}
