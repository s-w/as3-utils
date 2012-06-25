package com.swlodarski.utils 
{
	/**
   * @author sw
   */  

  public class Random 
  {
    
    /**
     * @return pseudo-random value between 0 and 1 (0 <= value < 1)
     */
    public static function next() : Number
    {
      return Math.random();
    }
    
    /**
     * @return pseudo-random value between $from and $to ($from <= value < $to)
     */
    public static function nextInt( $from : int = int.MIN_VALUE, $to : int = int.MAX_VALUE ) : int
    {
      return $from + int( Math.random() * ( $to - $from )); 
    }
    
    /**
     * @return pseudo-random value between $from and $to ($from <= value < $to)
     */
    public static function nextUint( $from : uint = uint.MIN_VALUE, $to : uint = uint.MAX_VALUE ) : uint
    {
      return $from + uint( Math.random() * ( $to - $from ));   
    }
    
    /**
     * @return pseudo-random value between $from and $to ($from <= value < $to)
     */
    public static function nextNumber( $from : Number, $to : Number ) : Number
    {
      return $from + Math.random() * ( $to - $from ); 
    }
    
    public static function nextBool() : Boolean
    {
      return Math.random() < 0.5;
    }
    
    public static function generateInt( $from : int = int.MIN_VALUE, $to : int = int.MAX_VALUE ) : Function
    {
      return function() : int {
        return $from + int( Math.random() * ( $to - $from )); 
      };
    }
    
    public static function generateUint( $from : uint = uint.MIN_VALUE, $to : uint = uint.MAX_VALUE ) : Function
    {
      return function() : uint {
        return $from + uint( Math.random() * ( $to - $from )); 
      };
    }
    
    public static function generateNumber( $from : Number, $to : Number ) : Function
    {
      return function() : Number {
        return $from + Math.random() * ( $to - $from ); 
      };
    }
  }
}