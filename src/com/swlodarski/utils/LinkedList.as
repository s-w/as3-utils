package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class LinkedList extends Collection
  {    
    public static function fromArray( $array : Array ) : LinkedList
    {
      const ll : LinkedList = new LinkedList();
      for each( var o : * in $array ) {
        ll.push( o );
      }
      return ll;
    }
    
    public function LinkedList() 
    {
      _beg = new _LinkedListNode( null );
      _end = new _LinkedListNode( null );
      _beg._next = _end;
    }
    
    public function push( $value : * ) : LinkedList
    {
      const newNode : _LinkedListNode = new _LinkedListNode( $value );
      newNode._next = _beg._next;
      _beg._next = newNode;      
      _len += 1;
      return this;
    }
    
    public function pop() : *
    {
      const v : * = _beg._next._value;      
      _beg._next = _beg._next._next;
      _len -= 1;
      return v;
    }
    
    public function insertBefore( $pos : int, $value : * ) : LinkedList
    {
      const newNode : _LinkedListNode = new _LinkedListNode( $value );
      var n : _LinkedListNode = _beg;
      while ( $pos > 0 ) {
        n = n._next;
        $pos -= 1;
      }
      newNode._next = n._next;
      n._next = newNode;
      _len += 1;
      return this;
    }
    
    public function insertAfter( $pos : int, $value : * ) : LinkedList
    {
      const newNode : _LinkedListNode = new _LinkedListNode( $value );
      var n : _LinkedListNode = _len == 0 ? _beg : _beg._next;
      while ( $pos > 0 ) {
        n = n._next;
        $pos -= 1;
      }
      newNode._next = n._next;
      n._next = newNode;
      _len += 1;
      return this;
    }
    
    public function removeAt( $pos : int ) : *
    {
      var n : _LinkedListNode = _beg;
      while ( $pos > 0 ) {
        n = n._next;
        $pos -= 1;
      }
      const v : * = n._next._value;
      n._next = n._next._next;
      _len -= 1;      
      return v;
    }
    
    public function remove( $value : * ) :*
    {
      var n : _LinkedListNode = _beg;
      while ( n._next != _end ) {
        if ( n._next._value == $value ) {
          const v : * = n._next._value;
          n._next = n._next._next;
          _len -= 1; 
          return v;
        }
        n = n._next;
      }
      return null;
    }
    
    public function at( $pos : int ) : *
    {
      var iter : _LinkedListNode = _beg._next;
      while ( iter != _end ) {
        iter = iter._next;
        if ( --$pos == 0 ) {
          return iter._value;
        }
      }
      return null;
    }
    
    public function find( $pred : Function, $this : * = null ) : *
    {
      var iter : _LinkedListNode = _beg._next;
      while ( iter != _end ) {
        if ( $pred.call( $this, iter._value )) {
          return iter._value;
        }
        iter = iter._next;       
      }
      return null;
    }
    
    public function indexOf( $value : * ) : int
    {
      var iter : _LinkedListNode = _beg._next,
        pos : int = 0;
      while ( iter != _end ) {
        if ( iter._value == $value ) {
          return pos;
        }
        iter = iter._next;
        pos += 1;
      }
      return -1;
    }
    
    public function indexOfEx( $pred : Function, $this : * = null ) : int
    {
      var iter : _LinkedListNode = _beg._next,
        pos : int = 0;
      while ( iter != _end ) {
        if ( $pred.call( $this, iter._value )) {
          return pos;
        }
        iter = iter._next;
        pos += 1;        
      }
      return -1;
    }
    
    public function sort( $cmp : Function, $this : * = null ) : LinkedList
    {
      if ( _len < 2 ) {
        return this;
      }
      var p : _LinkedListNode, q : _LinkedListNode, e : _LinkedListNode,
        list : _LinkedListNode, tail : _LinkedListNode,
        insize : int, nmerges : int, psize : int, 
        qsize : int, i : int;
      
      list = _beg._next;
      insize = 1;
      for ( ;; ) {        
        p = list;  
        list = tail = null;
        nmerges = 0;        
        while ( p != _end ) {
          nmerges += 1;
          q = p;
          psize = 0;
          for ( i = 0 ; i < insize ; i += 1 ) {
            psize += 1;
            q = q._next;
            if ( q == _end ) {
              break;
            }
          }
          qsize = insize;
          while ( psize > 0 || ( qsize > 0 && q != _end )) {
            if( psize == 0 ) {
              e = q; q = q._next; qsize -= 1;
            }
            else if ( qsize == 0 || q == _end ) {
              e = p; p = p._next; psize -= 1;
            }
            else if ( $cmp.call( $this, p._value, q._value ) <= 0 ) {
              e = p; p = p._next; psize -= 1;
            } 
            else {
              e = q; q = q._next; qsize -= 1;
            }            
            if ( tail ) {
              tail._next = e;
            } 
            else {
              list = e;
            }
            tail = e;
          }
          p = q;
        }
        tail._next = _end; 
        if (nmerges <= 1 ) {
          _beg._next = list;
          return this;
        }
        insize *= 2;
      }
      return this;
    }
    
    public function join( $sep : String = "," ) : String
    {
      var str : String = "",
        iter : _LinkedListNode = _beg._next;
      if ( iter != _end ) {
        str += iter._value;
        for ( ; ; ) {
          if ( iter._next != _end ) {
            iter = iter._next;
            str += $sep + iter._value;
          }
          else {
            return str;
          }
        }
      }
      return str;
    }
    
    public function map( $func : Function, $this : * = null ) : LinkedList
    {
      const l : LinkedList = new LinkedList();
      var iter : _LinkedListNode = _beg._next;
      while ( iter != _end ) {
        if ( $func.call( $this, iter._value )) {
          l.push( iter._value );
        }
        iter = iter._next;
      }
      return l;
    }
    
    public function clear() : void
    {
      _beg._next = _end;
      _len = 0;
    }
    
    public function merge( $list : LinkedList ) : LinkedList
    {
      if ( $list._len > 0 ) {
        var iter : _LinkedListNode = $list._beg._next;
        while ( iter != $list._end ) {
          push( iter._value );
          iter = iter._next;
        }
      }
      return this;
    }
    
    public function reverse() : LinkedList
    {
      var tmp : _LinkedListNode = null,
        p : _LinkedListNode = _end,
        c : _LinkedListNode = _beg._next;        
      while ( c != null ) {
        tmp = c._next;
        c._next = p;
        p = c;
        c = tmp;
      }
      _beg._next = _end._next;
      _end._next = null;      
      return this;
    }
    
    public function clone() : LinkedList
    {
      return (new LinkedList()).merge( this );
    }
    
    public function get front() : *
    { 
      return _beg._next._value;
    }
    
    override public function get length() : int 
    {
      return _len;
    }
    
    override public function isEmpty() : Boolean
    {
      return _len == 0;
    }
    
    override public function iterator( $position : int = 0 ) : Iterator 
    {
      const iter : _Iter = new _Iter( _beg._next, _end );
      while ( $position > 0 ) {
        iter.advance();
        $position -= 1;
      }
      return iter;
    }
    
    override public function foreach( $func : Function, $this : * = null ) : void 
    {
      var n : _LinkedListNode = _beg._next;
      while ( n != _end ) {
        $func.call( $this, n._value );
        n = n._next;
      }
    }
    
    private var _beg : _LinkedListNode;
    private var _end : _LinkedListNode;
    private var _len : int;    
  }
}

////////////////////////////////////////////////////////////////////////////////

import com.swlodarski.utils.LinkedList;
import com.swlodarski.utils.Iterator;
import com.swlodarski.utils.ReverseIterator;

////////////////////////////////////////////////////////////////////////////////

class _LinkedListNode
{
  public function _LinkedListNode( $value : * )
  {
    _value = $value;
  }
  
  public var _value : * ;
  public var _next : _LinkedListNode;
}

////////////////////////////////////////////////////////////////////////////////

class _Iter extends Iterator
{
  public function _Iter( $beg : _LinkedListNode, $end : _LinkedListNode )
  {
    _beg = $beg;
    _end = $end;
  }
  
  override public function isValid() : Boolean 
  {
    return _beg != _end;
  }
  
  override public function advance() : Iterator 
  {
    _beg = _beg._next;
    return this;
  }
  
  override public function get value() : * 
  {
    return _beg._value;
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _Iter = $b as _Iter;
    return b && _beg == b._beg;
  }
  
  public var _beg : _LinkedListNode;
  public var _end : _LinkedListNode;   
}

////////////////////////////////////////////////////////////////////////////////


