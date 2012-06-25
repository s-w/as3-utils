package com.swlodarski.utils 
{
	/**
   * @author sw
   * Sort functionality by Simon Tatham (http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html)
   */
  public class List extends Collection
  {    
    public static function fromArray( $array : Array ) : List
    {
      const l : List = new List();
      for each( var o : * in $array ) {
        l.pushBack( o );
      }
      return l;
    }
      
    public function List() 
    {
      _beg = new _ListNode( null );
      _end = new _ListNode( null );
      _beg._next = _end;
      _end._prev = _beg;
    }
    
    public function pushFront( $value : * ) : List
    {
      const newNode : _ListNode = new _ListNode( $value );
      newNode._prev = _beg;
      newNode._next = _beg._next;
      _beg._next._prev = newNode;
      _beg._next = newNode;      
      _len += 1;
      return this;
    }
    
    public function pushBack( $value : * ) : List
    {
      const newNode : _ListNode = new _ListNode( $value );
      newNode._prev = _end._prev;
      newNode._next = _end;
      _end._prev._next = newNode;
      _end._prev = newNode;
      _len += 1;
      return this;
    }
    
    public function popFront() : *
    {
      const v : * = _beg._next._value;      
      _beg._next = _beg._next._next;
      _beg._next._prev = _beg;
      _len -= 1;
      return v;
    }
    
    public function popBack() : * 
    {
      const v : * = _end._prev._value;
      _end._prev = _end._prev._prev;
      _end._prev._next = _end;
      _len -= 1;
      return v;
    }
    
    public function at( $pos : int ) : *
    {
      var iter : _ListNode = _beg._next;
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
      var iter : _ListNode = _beg._next;
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
      var iter : _ListNode = _beg._next, 
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
      var iter : _ListNode = _beg._next,
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
    
    public function lastIndexOf( $value : * ) : int
    {
      var iter : _ListNode = _end._prev,
        pos : int = _len - 1;
      while ( iter != _beg ) {
        if ( iter._value == $value ) {
          return pos;
        }
        iter = iter._prev;
        pos -= 1;
      }
      return -1;
    }
    
    public function lastIndexOfEx( $pred : Function, $this : * = null ) : int
    {
      var iter : _ListNode = _end._prev,
        pos : int = _len - 1;
      while ( iter != _beg ) {
        if ( $pred.call( $this, iter._value )) {
          return pos;
        }
        iter = iter._prev;
        pos -= 1;
      }
      return -1;
    }
    
    public function insertBefore( $pos : int, $value : * ) : List
    {
      const newNode : _ListNode = new _ListNode( $value );
      var n : _ListNode = _beg._next;
      while ( $pos > 0 ) {
        n = n._next;
        $pos -= 1;
      }
      newNode._prev = n._prev;
      newNode._next = n;
      n._prev._next = newNode;
      n._prev = newNode;
      _len += 1;
      return this;
    }
    
    public function insertAfter( $pos : int, $value : * ) : List
    {
      const newNode : _ListNode = new _ListNode( $value );
      var n : _ListNode = _len == 0 ? _beg : _beg._next;      
      while ( $pos > 0 ) {
        $pos -= 1;
        n = n._next;
      }
      newNode._next = n._next;
      newNode._prev = n;
      n._next._prev = newNode;
      n._next = newNode;
      _len += 1;
      return this;
    }
    
    public function removeAt( $pos : int ) : *
    {
      var n : _ListNode = _beg._next;
      while ( $pos > 0 ) {
        n = n._next;
        $pos -= 1;
      }
      n._prev._next = n._next;
      n._next._prev = n._prev;
      _len -= 1;      
      return n._value;
    }
    
    public function remove( $value : * ) :*
    {
      var n : _ListNode = _beg._next;
      while ( n != _end ) {
        if ( n._value == $value ) {
          n._prev._next = n._next;
          n._next._prev = n._prev;
          _len -= 1;      
          return n._value;
        }
        n = n._next;
      }
      return null;
    }
    
    public function clear() : void
    {
      _beg._next = _end;
      _end._prev = _beg;
      _len = 0;
    }
    
    public function reverse() : List
    {
      if( _len > 1 ) {
        var tmp : _ListNode = null,
          c : _ListNode = _beg._next;
        _beg._next = _end._prev;
        _end._prev = c;       
        while ( c != _end ) {
          tmp = c._next;
          c._next = c._prev;
          c._prev = tmp;
          c = tmp;
        }
        _beg._next._prev = _beg;  
        _end._prev._next = _end;  
      }
      return this;      
    }
    
    public function join( $sep : String = "," ) : String
    {
      var str : String = "";
      var iter : _ListNode = _beg._next;
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
    
    public function map( $func : Function, $this : * = null ) : List
    {
      const l : List = new List();
      var iter : _ListNode = _beg._next;
      while ( iter != _end ) {
        if ( $func.call( $this, iter._value )) {
          l.pushBack( iter._value );
        }
        iter = iter._next;
      }
      return l;
    }
    
    public function merge( $list : List ) : List
    {
      if ( $list._len > 0 ) {
        var iter : _ListNode = _beg._next;
        while ( iter != $list._end ) {
          pushBack( iter._value );
          iter = iter._next;
        }
      }
      return this;
    }

    public function sort( $cmp : Function, $this : * = null ) : List
    {
      if ( _len < 2 ) {
        return this;
      }
      var p : _ListNode, q : _ListNode, e : _ListNode,
        list : _ListNode, tail : _ListNode,
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
            e._prev = tail;
            tail = e;
          }
          p = q;
        }
        tail._next = _end; 
        if (nmerges <= 1 ) {          
          _end._prev = tail;
          list._prev = _beg;
          _beg._next = list;
          return this;
        }
        insize *= 2;
      }
      return this;
    }
    
    public function clone() : List
    {
      return (new List()).merge( this );
    }    
    
    public function get front() : *
    {
      return _beg._next._value;
    }
    
    public function get back() : *
    {
      return _end._prev._value;
    }
    
    override public function isEmpty() : Boolean
    {
      return _len == 0;
    }
    
    override public function iterator( $position : int = 0 ) : Iterator 
    {      
      if ( $position == -1 ) {
        return new _Iter( _end, _end );
      }
      else { 
        const iter : _Iter = new _Iter( _beg._next, _end );
        while ( $position > 0 ) {
          iter.advance();
          $position -= 1;
        }
        return iter;
      }      
    }
    
    override public function reverseIterator( $position : int = 0 ) : ReverseIterator
    {
      if ( $position == -1 ) {
        return new _RIter( _beg, _beg );
      }
      else {
        const iter : _RIter = new _RIter( _end._prev, _beg );
        while ( $position > 0 ) {
          iter.advance();
          $position -= 1;
        }
        return iter;
      }
    }
    
    override public function foreach( $func : Function, $this : * = null ) : void 
    {
      var n : _ListNode = _beg._next;
      while ( n != _end ) {
        $func.call( $this, n._value );
        n = n._next;
      }
    }
    
    override public function get length() : int 
    {
      return _len;
    }  
    
    private var _beg : _ListNode;
    private var _end : _ListNode;
    private var _len : int;
  }
}

////////////////////////////////////////////////////////////////////////////////

import com.swlodarski.utils.Iterator;
import com.swlodarski.utils.ReverseIterator;

////////////////////////////////////////////////////////////////////////////////

class _ListNode
{   
  public function _ListNode( $value : * ) 
  {
    _value = $value;
  }
  
  public var _value : *;
  public var _prev : _ListNode;
  public var _next : _ListNode;   
}

////////////////////////////////////////////////////////////////////////////////

class _Iter extends Iterator
{
  public function _Iter( $curr : _ListNode, $end : _ListNode )
  {
    _curr = $curr;
    _end = $end;
  }
  
  override public function isValid() : Boolean 
  {
    return _curr != _end;
  }
  
  override public function advance() : Iterator 
  {
    _curr = _curr._next;
    return this;
  }
  
  override public function get value() : * 
  {
    return _curr._value;
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _Iter = $b as _Iter;
    return b && _curr == b._curr;
  }
  
  public var _end : _ListNode;  
  public var _curr : _ListNode;  
}

////////////////////////////////////////////////////////////////////////////////

class _RIter extends ReverseIterator
{
  public function _RIter( $curr : _ListNode, $end : _ListNode )
  {
    _curr = $curr;
    _end = $end;
  }
  
  override public function isValid() : Boolean 
  {
    return _curr != _end;
  }
  
  override public function advance() : Iterator 
  {
    _curr = _curr._prev;
    return this;
  }
  
  override public function get value() : * 
  {
    return _curr._value;
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _RIter = $b as _RIter;
    return b && _curr == b._curr;
  }
  
  public var _curr : _ListNode;  
  public var _end : _ListNode; 
  
}

////////////////////////////////////////////////////////////////////////////////

