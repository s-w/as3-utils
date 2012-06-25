package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class PriorityQueue extends Collection
  {
    public static function fromCollection( $cmp : Function, $col : Collection ) : PriorityQueue
    {
      const h : PriorityQueue = new PriorityQueue( $cmp, $col.length );
      for ( const iter : Iterator = $col.iterator() ; iter.isValid() ; iter.advance()) {
        h.push( iter.value );
      }
      return h;      
    }

    public static function fromArray( $cmp : Function, $arr : Array ) : PriorityQueue
    {
      return new PriorityQueue( $cmp, 0, $arr );
    }
    
    public function PriorityQueue( $cmp : Function, $capacity : int = 10, $arr : Array = null ) 
    {
      _cmp = $cmp;
      if ( $arr ) {
        _arr = $arr;
        _len = _arr.length;
        for ( var i : int = ( _len >> 1 ) - 1 ; i >= 0 ; i -= 1 ) {
          _heapify( i );
        }
      }
      else {
        _arr = [];
        _arr.length = $capacity;        
      }
    }
    
    public function push( $value : * ) : PriorityQueue
    {      
      if ( _len < _arr.length ) {
        _arr[ _len ] = $value;
      }
      else {
        _arr.push( $value ); 
      }
      _len += 1;
      var i : int = _len, j : int, k : int, l : int;
      for ( ; i > 1 ; ) {
        j = i >> 1; k = i - 1; l = j - 1;
        if( _cmp( _arr[ k ], _arr[ l ]) > 0 ) {
          const tmp : * = _arr[ l ];
          _arr[ l ] = _arr[ k ];
          _arr[ k ] = tmp;
          i = j;
        }
        else {
          return this;
        }
      }
      return this;
    }

    public function pop() : *
    {
      var tmp : * , ret : * ;    
      ret = _arr[ 0 ];
      _len -= 1;
      _arr[ 0 ] = _arr[ _len ];
      _arr[ _len ] = null;
      var i : int = 0, j : int, l : int = 1, r : int = 2;
      for ( ;; ) {
        j = ( _len > l && _cmp( _arr[ i ], _arr[ l ]) < 0 ) ? l : i;
        if ( _len > r && _cmp( _arr[ j ], _arr[ r ]) < 0 ) j = r;
        if ( i != j ) {
          tmp = _arr[ i ];
          _arr[ i ] = _arr[ j ];
          _arr[ j ] = tmp;
          l = (( j + 1 ) << 1 ) - 1;
          r = l + 1;
          i = j;
        }
        else {
          _gc += 1;
          if ( _gc % 50 == 0 ) {
            while ( _arr.length > _len + 10 ) {
              _arr.pop();
            }
          }
          return ret;
        }
      }
    }
    
    public function top() : *
    {
      return _arr[ 0 ];
    }
    
    public function clear() : void
    {
      _arr.length = _len = 0;
    }
    
    override public function foreach( $func : Function, $this : * = null ) : void 
    {
      for each( var obj : * in _arr ) {
        $func.call( $this, obj );
      }
    }
    
    override public function iterator( $position : int = 0 ) : Iterator 
    {
      return new _PriorityQueueIter( _arr, _len, $position );
    }
    
    override public function reverseIterator( $position : int = 0 ) : ReverseIterator 
    {
      return new _PriorityQueueRIter( _arr, _len, $position );
    }
    
    override public function get length() : int
    {
      return _len;
    }
    
    override public function isEmpty() : Boolean
    {
      return _len == 0;
    }
    
    public function toArray() : Array
    {
      return _arr.slice( 0, _len );
    }
    
    private function _heapify( $i : int ) : void
    {
      var tmp : * ;
      var i : int = $i, j : int,
        l : int = (( i + 1 ) << 1 ) - 1, 
        r : int = l + 1;
      for ( ; ; ) {
        j = ( _len > l && _cmp( _arr[ i ], _arr[ l ]) < 0 ) ? l : i;
        if ( _len > r && _cmp( _arr[ j ], _arr[ r ]) < 0 ) j = r;
        if ( i != j ) {
          tmp = _arr[ i ];
          _arr[ i ] = _arr[ j ];
          _arr[ j ] = tmp;
          l = (( j + 1 ) << 1 ) - 1;
          r = l + 1;
          i = j;
        }
        else {
          return;
        }
      }
    }
    
    private var _cmp : Function;
    private var _arr : Array;
    private var _len : int = 0;
    private var _gc : int = 0;
  }
}

import com.swlodarski.utils.Iterator;
import com.swlodarski.utils.ReverseIterator;

class _PriorityQueueIter extends Iterator
{
  public function _PriorityQueueIter( $arr : Array, $len : int, $pos : int )
  {
    _arr = $arr;
    _len = $len;
    _pos = $pos;
  }
  
  override public function isValid() : Boolean 
  {
    return _pos < _len;
  }
  
  override public function advance() : Iterator 
  {
    _pos += 1;
    return this;
  }
  
  override public function get value() : * 
  {
    return _arr[ _pos ];
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _PriorityQueueIter = $b as _PriorityQueueIter;
    return b && _arr == b._arr && _pos == b._pos;
  }
  
  private var _pos : int;
  private var _arr : Array;
  private var _len : int;
}

class _PriorityQueueRIter extends ReverseIterator
{
  public function _PriorityQueueRIter( $arr : Array, $len : int, $pos : int )
  {
    _arr = $arr;
    _len = $len;
    _pos =  _len - 1 - $pos;
  }
  
  override public function isValid() : Boolean 
  {
    return _pos >= 0;
  }
  
  override public function advance() : Iterator 
  {
    _pos -= 1;
    return this;
  }
  
  override public function get value() : * 
  {
    return _arr[ _pos ];
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _PriorityQueueRIter = $b as _PriorityQueueRIter;
    return b && _arr == b._arr && _pos == b._pos;
  }
  
  private var _pos : int;
  private var _arr : Array;
  private var _len : int;
}


