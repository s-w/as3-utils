package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class Map extends Collection 
  {
    
    public function Map( $cmp : Function ) 
    {
      _cmp = $cmp
    }
    
    public function insert( $key : * , $value : * ) : void
    {
      _treeInsert( _treeInsertBasic( $key, $value ));
    }
    
    public function remove( $key : * ) : *
    {
      const n : _TreeNode = _findNode( $key );
      if ( n != _SENTINEL ) {
        _size -= 1;
        return _treeDelete( n );
      }
      return null;
    }
    
    public function min() : Iterator
    {
      var n : _TreeNode = _root;
      while ( n.l != _SENTINEL ) {
        n = n.l;
      }
      return new _MapIterator( n, 0 );
    }
    
    public function max() : Iterator
    {
      var n : _TreeNode = _root;
      while ( n.r != _SENTINEL ) {
        n = n.r;
      }
      return new _MapIterator( n, 0 );
    }
    
    override public function isEmpty() : Boolean 
    {
      return _size == 0;
    }
    
    public function get size() : int 
    {
      return _size;
    }
    
    override public function get length() : int 
    {
      return _size;
    }
    
    public function value( $key : * ) : *
    {
      return _findNode( $key ).value;
    }
    
    public function find( $key : * ) : Iterator
    {
      return new _MapIterator( _findNode( $key ), 0 );
    }
    
    /**
     * Returns an Iterator to a node with a smallest key which compares $cmp( $key, node.key ) <= 0
     */    
    public function lowerBound( $key : * ) : Iterator
    {
      var n : _TreeNode = _root, nn : _TreeNode = _SENTINEL, cValue : int;
      while ( n != _SENTINEL ) {
        cValue = _cmp.call( null, $key, n.key );
        if ( cValue < 0 ) {
          nn = n;
          n = n.l;
        }
        else if ( cValue > 0 ) {
          n = n.r;
        }
        else {
          return new _MapIterator( n, 0 );
        }
      }
      return new _MapIterator( nn, 0 );
    }
    
    /**
     * Returns an Iterator to a node with a smallest key which compares $cmp( $key, node.key ) < 0
     */
    public function upperBound( $key : * ) : Iterator
    {
      var n : _TreeNode = _root, nn : _TreeNode = _SENTINEL;
      while ( n != _SENTINEL ) {
        if ( _cmp.call( null, $key, n.key ) >= 0 ) {
          n = n.r
        }
        else {
          nn = n;
          n = n.l;
        }
      }
      return new _MapIterator( nn, 0 );
    }
    
    override public function foreach( $func : Function, $this : * = null ) : void 
    {
      var n : _TreeNode = _treeMin( _root );
      while ( n != _SENTINEL ) {
        $func.call( $this, { key: n.key, value: n.value } );
        if ( n.r != _SENTINEL ) {
          n = n.r;
          while ( n.l != _SENTINEL ) {
            n = n.l;
          }
        }
        else if ( n == n.p.l ) {
          n = n.p;
        }
        else {
          while ( n == n.p.r ) {
            n = n.p;
          }
          n = n.p;
        }
      }
    }
    
    override public function iterator( $position : int = 0 ) : Iterator 
    {
      return new _MapIterator( _root != _SENTINEL ? 
        _treeMin( _root ) : _SENTINEL, $position );
    }
    
    override public function reverseIterator( $position : int = 0 ) : ReverseIterator 
    {
      return new _MapReverseIterator( _root != _SENTINEL ? 
        _treeMax( _root ) : _SENTINEL, $position );
    }
    
    private function _findNode( $key : * ) : _TreeNode
    {
      var n : _TreeNode = _root, cValue : int;
      while ( n != _SENTINEL ) {
        cValue = _cmp.call( null, $key, n.key );
        if ( cValue < 0 ) {
          n = n.l;
        }
        else if ( cValue > 0 ) {
          n = n.r;
        }
        else {
          return n;
        }
      }
      return _SENTINEL;
    }
    
    private function _treeInsertBasic( $key : * , $value : * ) : _TreeNode
    {
      if ( _root != _SENTINEL ) {
        var n : _TreeNode = _root, cValue : int;
        for ( ; ; ) {
          cValue = _cmp.call( null, $key, n.key );
          if ( cValue < 0 ) {
            if ( n.l != _SENTINEL ) {
              n = n.l;
            }
            else {
              _size += 1;
              n.l = new _TreeNode( $key, $value, n, _SENTINEL, _SENTINEL );
              return n.l;
            }
          }
          else if( cValue > 0 ) {
            if ( n.r != _SENTINEL ) {
              n = n.r;
            }
            else {
              _size += 1;
              n.r = new _TreeNode( $key, $value, n, _SENTINEL, _SENTINEL );
              return n.r;
            }
          }
          else {
            n.value = $value;
            // there is no need for rebalancing
            // return _root so _treeInsert could imediately exit;
            return _root;
          }
        }
      }
      else {
        _size += 1;
        _root = new _TreeNode( $key, $value, _SENTINEL, _SENTINEL, _SENTINEL );
      }
      return _root;
    }
    
    private function _treeInsert( $x : _TreeNode ) : void
    {
      var x : _TreeNode = $x, y : _TreeNode;
      while ( x != _root && x.p.color == _RED ) {
        if ( x.p == x.p.p.l ) {
          if ( x.p.p.r != _SENTINEL && x.p.p.r.color == _RED ) {
            x.p.color = x.p.p.r.color = _BLACK;
            x.p.p.color = _RED;
            x = x.p.p;
          }
          else if ( x == x.p.r ) {
            x = x.p;
            _leftRotate( x );
            x.p.color = _BLACK;
            x.p.p.color = _RED;
            _rightRotate( x.p.p );            
          }
          else {
            x.p.color = _BLACK;
            x.p.p.color = _RED;
            _rightRotate( x.p.p );
          }
        }
        else {
          if ( x.p.p.l != _SENTINEL && x.p.p.l.color == _RED ) {
            x.p.color = x.p.p.l.color = _BLACK;
            x.p.p.color = _RED;
            x = x.p.p;
          }
          else if ( x == x.p.l ) {
            x = x.p;
            _rightRotate( x );
            x.p.color = _BLACK;
            x.p.p.color = _RED;
            _leftRotate( x.p.p );
          }
          else {
            x.p.color = _BLACK;
            x.p.p.color = _RED;
            _leftRotate( x.p.p );
          }
        }
      }
      _root.color = _BLACK;
    }
    
    private function _treeDelete( $z : _TreeNode ) : *
    {
      var x : _TreeNode, 
        y : _TreeNode = ( $z.l == _SENTINEL || $z.r == _SENTINEL ) ? 
          $z : _treeSuccessor( $z );
      x = ( y.l != _SENTINEL ) ? y.l : y.r;
      x.p = y.p;
      if ( y.p == _SENTINEL ) {
        _root = x;
      }
      else if ( y == y.p.l ) {
        y.p.l = x;
      }
      else {
        y.p.r = x;
      }
      if ( y != $z ) {
        $z.key = y.key;
      }
      if ( y.color == _BLACK ) {
        _treeDeleteFix( x );
      }
      return y.value;
    }
    
    private function _treeDeleteFix( $x : _TreeNode ) : void
    {
      var x : _TreeNode = $x, w : _TreeNode;
      while ( x != _root && x.color == _BLACK ) {
        if ( x == x.p.l ) {
          w = x.p.r;
          if ( w.color == _RED ) {
            w.color = _BLACK;
            w.p.color = _RED;
            _leftRotate( w.p );
            w = x.p.r;
          }
          if ( w.l.color == _BLACK && w.r.color == _BLACK ) {
            w.color = _RED;
            x = x.p;
          }
          else if ( w.l.color == _BLACK ) {
            w.color = x.p.color;
            w.r.color = w.p.color = _BLACK;
            _leftRotate( w.p );
            x = _root;
          }
          else {
            _rightRotate( w );
            w = x.p.r;
            w.color = x.p.color;
            w.p.color = _BLACK;
            _leftRotate( w.p );
            x = _root;
          }
        }
        else {
          w = x.p.l;
          if ( w.color == _RED ) {
            w.color = _BLACK;
            w.p.color = _RED;
            _rightRotate( w.p );
            w = x.p.l;
          }
          if ( w.l.color == _BLACK && w.r.color == _BLACK ) {
            w.color = _RED;
            x = x.p;
          }
          else if ( w.l.color == _BLACK ) {            
            _leftRotate( w );
            w = x.p.l;
            w.color = x.p.color;
            w.p.color = _BLACK;
            _rightRotate( w.p );
            x = _root;
          }
          else {
            w.color = x.p.color;
            w.l.color = w.p.color = _BLACK;
            _rightRotate( w.p );
            x = _root;
          }
        }
      }
      x.color = _BLACK;
    }
    
    private function _treeSuccessor( $x : _TreeNode ) : _TreeNode
    {
      if ( $x.r != _SENTINEL ) {
        return _treeMin( $x.r );
      }
      else {
        var x : _TreeNode = $x, y : _TreeNode = $x.p;
        while ( y != _SENTINEL && x == y.r ) {
          x = y;
          y = y.p;
        }
        return y;
      }
    }
    
    private function _treeMin( $x : _TreeNode ) : _TreeNode
    {
      while ( $x.l != _SENTINEL ) {
        $x = $x.l;
      }
      return $x;
    }
    
    private function _treeMax( $x : _TreeNode ) : _TreeNode
    {
      while ( $x.r != _SENTINEL ) {
        $x = $x.r;
      }
      return $x;
    }
    
    private function _leftRotate( $x : _TreeNode ) : void
    {
      var x : _TreeNode = $x, y : _TreeNode = $x.r;
      x.r = y.l;
      if ( y.l != _SENTINEL ) {
        y.l.p = x;
      }
      y.p = x.p;
      if ( x.p == _SENTINEL ) {
        _root = y;
      }
      else if ( x == x.p.l ) {
        x.p.l = y;        
      }
      else {
        x.p.r = y;
      }
      y.l = x;
      x.p = y;
    }
    
    private function _rightRotate( $y : _TreeNode ) : void
    {
      var x : _TreeNode = $y.l, y : _TreeNode = $y;
      y.l = x.r;
      if ( y.l != _SENTINEL ) {
        y.l.p = y;
      }
      x.p = y.p;      
      if ( y.p == _SENTINEL ) {
        _root = x;
      }
      if ( y.p.r == y ) {
        y.p.r = x;
      }
      else {
        y.p.l = x;
      }
      y.p = x;
      x.r = y;
    }    
    
    public function toString() : String
    {
      return _nodeToString( _root, 0 );
    }
    
    private function _nodeToString( $node : _TreeNode, $depth : int ) : String
    {
      if ( $node != _SENTINEL ) {        
        var str : String = StringUtil.pushFront( "", "  ", $depth );
        str += "(key=" + $node.key + " color=" + ($node.color == _BLACK ? "BLACK" : "RED");
        if ( $node.p != _SENTINEL ) str += " p=" + $node.p.key;
        if ( $node.l != _SENTINEL ) str += " l=" + $node.l.key;
        if ( $node.r != _SENTINEL ) str += " r=" + $node.r.key;
        str += ")\n";
        if ( $node.l != _SENTINEL ) str += _nodeToString( $node.l, $depth + 1 );
        if ( $node.r != _SENTINEL ) str += _nodeToString( $node.r, $depth + 1 );
        return str;
      }
      return "";
    }
    
    private var _size : int;
    private var _cmp : Function;
    private var _root : _TreeNode = _SENTINEL;
  }

}

const _RED : int = 1;
const _BLACK : int = 2;
const _SENTINEL : _TreeNode = new _TreeNode( null, null, null, null, null, _BLACK );

class _TreeNode
{
  public var key : *;
  public var value : * ;
  public var color : int = _RED;
  public var p : _TreeNode;
  public var l : _TreeNode;
  public var r : _TreeNode; 
  
  public function _TreeNode( $key : * , $value : * ,
    $p : _TreeNode, $l : _TreeNode, $r : _TreeNode, $color : int = 1 /* _RED */ )
  {
    key = $key;    
    value = $value;
    p = $p; l = $l; r = $r;
    color = $color;
  }
}


import com.swlodarski.utils.Iterator;
import com.swlodarski.utils.ReverseIterator;

class _MapIterator extends Iterator
{
  public function _MapIterator( $node : _TreeNode, $pos : int ) 
  {
    _SENTINEL.p = _SENTINEL.l = _SENTINEL.r = null;
    _n = $node;
    _nn = _n.r != _SENTINEL ? _n.r : _n.p;
    while ( $pos-- > 0 ) {
      advance();
    }
  }
  
  override public function advance() : Iterator 
  {
    _n = _nn;
    if ( _n == _SENTINEL ) {
      return this;
    }
    if ( _nn.r != _SENTINEL ) {
      _nn = _nn.r;
      while ( _nn.l != _SENTINEL ) {
        _nn = _nn.l;
      }
    }
    else if ( _nn == _nn.p.l ) {
      _nn = _nn.p;
    }
    else {
      while ( _nn == _nn.p.r ) {
        _nn = _nn.p;
      }
      _nn = _nn.p;
    }
    return this;
  }  
  
  override public function isValid() : Boolean 
  {
    return _n != _SENTINEL;
  }
  
  override public function get value() : * 
  {
    return { key: _n.key, value: _n.value };
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _MapIterator = $b as _MapIterator;
    return b && b._n.key == _n.key;
  }  
  
  private var _n : _TreeNode;
  private var _nn : _TreeNode;
}

class _MapReverseIterator extends ReverseIterator
{
  public function _MapReverseIterator( $node : _TreeNode, $pos : int ) 
  {
    _SENTINEL.l = _SENTINEL.r = null;
    _n = $node;
    _nn = _n.l != _SENTINEL ? _n.l : _n.p;
    while ( $pos-- > 0 ) {
      advance();
    }
  }
  
  override public function advance() : Iterator 
  {
    _n = _nn;
    if ( _n == _SENTINEL ) {
      return this;
    }
    if ( _nn.l != _SENTINEL ) {
      _nn = _nn.l;
      while ( _nn.r != _SENTINEL ) {
        _nn = _nn.r;
      }
    }
    else if ( _nn == _nn.p.r ) {
      _nn = _nn.p;
    }
    else {
      while ( _nn == _nn.p.l ) {
        _nn = _nn.p;
      }
      _nn = _nn.p;
    }
    return this;
  }  
  
  override public function isValid() : Boolean 
  {
    return _n != _SENTINEL;
  }
  
  override public function get value() : * 
  {
    return { key: _n.key, value: _n.value };
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _MapReverseIterator = $b as _MapReverseIterator;
    return b && b._n.key == _n.key;
  }  
  
  private var _n : _TreeNode;
  private var _nn : _TreeNode;
}



