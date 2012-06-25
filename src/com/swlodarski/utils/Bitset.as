package com.swlodarski.utils 
{
	/**
   * @author sw
   */
  public class Bitset extends Collection 
  {
    /**
     * Creates a new Bitset object based on argument string.
     * Given string "01111" it creates a Bitset object containing 5 values,
     * where last character ($str[ $str.length - 1 ]) is a first value of the object. 
     */
    public static function fromString( $str : String ) : Bitset
    {
      const bs : Bitset = new Bitset( $str.length );
      for ( var i : int = $str.length - 1 ; i >= 0  ; i -= 1 ) {
        bs.set( $str.length - 1 - i, $str.charCodeAt( i ) != 48 );
      }
      return bs;
    }
    
    public function Bitset( $nbits : int = 0 ) 
    {
      _bits = new Vector.< int >( Math.ceil( $nbits / _BITS_PER_WORD ));
      _len = $nbits;
    }
    
    /**
     * Pushes new bit of argument value to the end of this Bitset.
     * Length of an object is set to $length = $length + 1
     */
    public function push( $value : Boolean ) : Bitset
    {
      var v : int = int( $value );       
      if ( _len < _BITS_PER_WORD * _bits.length ) {
        const vindex : int = _len / _BITS_PER_WORD,
          bindex : int = _len % _BITS_PER_WORD;
        _bits[ vindex ] |= ( v << bindex );
      }
      else {
        _bits.push( v );        
      }
      _len += 1;
      return this;
    }
    
    /**
     * Removes last bit from a set and returns its value.
     * Length of an object is set to $length = $length - 1
     */
    public function pop() : Boolean
    {
      _len -= 1;
      const v : Boolean = ( _bits[ int( _len / _BITS_PER_WORD )] & 
        ( 1 << ( _len % _BITS_PER_WORD ))) != 0;
      _trimVector();
      _trim();      
      return v;
    }
    
    /**
     * Gets bit at $index
     */
    public function get( $index : int ) : Boolean
    {
      return ( _bits[ int( $index / _BITS_PER_WORD )] & 
        ( 1 << ( $index % _BITS_PER_WORD ))) != 0;
    }
    
    /**
     * Sets bit at $index to $value
     */
    public function set( $index : int, $value : Boolean = true ) : Bitset
    {
      const vindex : int = $index / _BITS_PER_WORD,
        bindex : int = $index % _BITS_PER_WORD;
      if ( $value ) {
        _bits[ vindex ] |= ( 1 << bindex );
      }
      else {
        _bits[ vindex ] &= ~( 1 << bindex );        
      }
      return this;
    }
    
    /**
     * Finds next clear (false) bit starting from $from position. 
     * If $from is >= 0, search is conducted forward from $from to length (exclusive).
     * If $from is < 0, search is conducted backward from (length + $from) to 0 (inclusive),
     * so if $from = -1 then search starts from (length - 1) position (inclusive), if $from = -2 it starts from (length - 2) and so forth.
     */
    public function nextClearBit( $from : int ) : int
    {
      // If $from > 0 then search from 0 to length, otherwise from length-1 to 0
      if ( $from >= 0 ) {
        return _nextClearPositive( $from );
      }
      else {
        return _len > 0 ? _nextClearNegative( $from ) : -1;
      }
    }
    
    /**
     * Finds next set (true) bit starting from $from position. 
     * If $from is >= 0, search is conducted forward from $from to length (exclusive).
     * If $from is < 0, search is conducted backward from (length + $from) to 0 (inclusive),
     * so if $from = -1 then search starts from (length - 1) position (inclusive), if $from = -2 it starts from (length - 2) and so forth.
     */
    public function nextSetBit( $from : int ) : int
    {
      if ( $from >= 0 ) {
        return _nextSetPositive( $from );
      }
      else {
        return _len > 0 ? _nextSetNegative( $from ) : -1;
      }
    }
    
    /**
     * Sets all bits between $from(inclusive) and $to(exclusive) to $value.
     */
    public function setRange( $from : int, $to : int, $value : Boolean = true ) : Bitset
    {
      if ( $from >= $to ) {
        return this;
      }
      const bitDis : int = $to - $from,
        startWord : int = $from / _BITS_PER_WORD,
        startWordBit : int = $from % _BITS_PER_WORD,
        endWord : int = ( $to / _BITS_PER_WORD ),
        endWordBit : int = ( $to % _BITS_PER_WORD );
      var i : int;
      if ( $value ) {
        if ( startWord < endWord ) {
          _bits[ startWord ] |= ~((1 << startWordBit) - 1);
          for ( i = startWord + 1 ; i < endWord ; i += 1 ) {
            _bits[ i ] = -1;
          }
          if ( endWordBit != 0 ) {
            _bits[ endWord ] |= ((1 << endWordBit) - 1);
          }
        }
        else {
          _bits[ endWord ] |= ((1 << endWordBit) - 1) &
            ~((1 << startWordBit) - 1);            
        }
      }
      else {
        if ( startWord < endWord ) {
          _bits[ startWord ] &= ((1 << startWordBit) - 1);
          for ( i = startWord + 1 ; i < endWord ; i += 1 ) {
            _bits[ i ] = 0;
          }
          if( endWordBit != 0 ) {
            _bits[ endWord ] &= ~((1 << endWordBit) - 1);
          }
        }
        else {
          _bits[ endWord ] &= ~((1 << endWordBit) - 1) | 
            ((1 << startWordBit) - 1);
        }
      }
      return this;
    }
    
    /**
     * All bits are set to 0 (false).
     */
    public function clear() : Bitset
    {
      for ( var i : int = 0 ; i < _bits.length ; i += 1 ) {
        _bits[ i ] = 0;
      }
      return this;
    }
    
    /**
     * All bits are set to the complement of their value.
     */
    public function flip() : Bitset
    {
      for ( var i : int = 0 ; i < _bits.length ; i += 1 ) {
        _bits[ i ] = ~_bits[ i ];
      }
      _trim();
      return this;
    }
    
    /**
     * Sets bit at $index to the complement of its value.
     */
    public function flipAt( $index : int ) : Bitset
    {
      const vindex : int = $index / _BITS_PER_WORD,
        bindex : int = $index % _BITS_PER_WORD;
      if (( _bits[ vindex ] & ( 1 << bindex )) == 0 ) {
        _bits[ vindex ] |= ( 1 << bindex );
      }
      else {
        _bits[ vindex ] &= ~( 1 << bindex );        
      }
      return this;
    }
    
    /**
     * Sets all bits between $from(inclusive) and $to(exclusive) to the complement of their values.
     */
    public function flipRange( $from : int, $to : int ) : Bitset
    {
      const bitDis : int = $to - $from,
        startWord : int = $from / _BITS_PER_WORD,
        startWordBit : int = $from % _BITS_PER_WORD,
        endWord : int = ( $to / _BITS_PER_WORD ),
        endWordBit : int = ( $to % _BITS_PER_WORD );
        
      if ( startWord < endWord ) {  
        if( startWordBit != 0 ) {
          _bits[ startWord ] = (~_bits[ startWord ] & 
            ~((1 << startWordBit) - 1)) |
            (_bits[ startWord ] & ((1 << startWordBit) - 1));
        }
        else {
          _bits[ startWord ] = ~_bits[ startWord ];
        }
        for ( var i : int = startWord + 1 ; i < endWord ; i += 1 ) {
          _bits[ i ] = ~_bits[ i ];
        }
        if( endWordBit != 0 ) {
          _bits[ endWord ] = (~_bits[ endWord ] & 
            ((1 << endWordBit) - 1)) |
            (_bits[ endWord ] & ~((1 << endWordBit) - 1));
        }
      }
      else {
        _bits[ endWord ] = 
          (_bits[ endWord ] & ~((1 << endWordBit) - 1)) |
          ((~_bits[ endWord ] & ((1 << endWordBit) - 1)) &
          ~((1 << startWordBit)-1)) |
          (_bits[ endWord ] & ((1 << startWordBit) - 1));
      }
      return this;
    }
    
    /**
     * If at least one of the bits is set to true returns true, otherwise false.
     */
    public function any() : Boolean
    {
      for ( var i : int = 0 ; i < _bits.length ; i += 1 ) {
        if ( _bits[ i ] != 0 ) {
          return true;
        }
      }
      return false;
    }
    
    /**
     * If all of the bits are set to false returns true, otherwise false.
     */
    public function none() : Boolean
    {
      return !any();
    }
    
    override public function isEmpty() : Boolean
    {
      return _len == 0;
    }

    override public function iterator( $position : int = 0 ) : Iterator 
    {
      return new _BitsetIterator( _bits, _len, $position );
    }
    
    override public function reverseIterator( $position : int = 0 ) : ReverseIterator
    {
      return new _BitsetReverseIterator( _bits, _len, $position );
    }
    
    override public function foreach( $func : Function, $this : * = null ) : void 
    {
      var i : int, j : int;
      const l : int = _bits.length;
      for ( i = 0 ; i < l - 1 ; i += 1 ) {
        for ( j = 0 ; j < _BITS_PER_WORD ; j += 1 ) {
          $func.call( $this, ( _bits[ i ] & ( 1 << j )) != 0 );
        }
      }
      for ( ; i < l ; i += 1 ) {
        const k : int = _len % _BITS_PER_WORD;
        for ( j = 0 ; j < k ; j += 1 ) {
          $func.call( $this, ( _bits[ i ] & ( 1 << j )) != 0 );
        }
      }
    }
    
    
    /**
     * Returns size of this Bitset, highest index of the last value plus one.
     */
    override public function get length() : int 
    {
      return _len;
    }
    
    /**
     * Returns the number of bits of space actually in use by this BitSet to represent bit values.
     */
    public function get capacity() : int
    {
      return _BITS_PER_WORD * _bits.length;
    }
    
    /**
     * Returns the number of bits set to true.
     */
    public function count() : int
    {
      var v : int = 0, i : int, wordValue : int;
      for ( i = _bits.length - 1 ; 0 <= i ; i -= 1 ) {
        for ( wordValue = _bits[ i ] ; wordValue != 0 ; wordValue >>>= 4 ) {
          v += _BITS_PER_HEX[ wordValue & 0xF ];
        }
      }
      return v;
    }
    
    public function clone() : Bitset
    {
      const bs : Bitset = new Bitset();
      for each( var v : int in _bits ) {
        bs._bits.push( v );
      }
      bs._len = _len;
      return bs;
    }
    
    /**
     * Performs a logical OR of this bit set with the bit set argument.
     */
    public function or( $rhs : Bitset ) : Bitset
    {
      _procOpLenghtAndCapacity( $rhs );
      for ( var i : int = 0 ; i < $rhs._bits.length ; i += 1 ) {
        _bits[ i ] |= $rhs._bits[ i ];
      }
      _trim();
      return this;
    }
    
    /**
     * Performs a logical AND of this target bit set with the argument bit set.
     */
    public function and( $rhs : Bitset ) : Bitset
    {
      _procOpLenghtAndCapacity( $rhs );
      for ( var i : int = 0 ; i < $rhs._bits.length ; i += 1 ) {
        _bits[ i ] &= $rhs._bits[ i ];
      }
      return this;
    }
    
    /**
     * Performs a logical XOR of this bit set with the bit set argument.
     */
    public function xor( $rhs : Bitset ) : Bitset
    {
      _procOpLenghtAndCapacity( $rhs );
      for ( var i : int = 0 ; i < $rhs._bits.length ; i += 1 ) {
        _bits[ i ] ^= $rhs._bits[ i ];
      }
      _trim();
      return this;
    }
    
    /**
     * Performs left shift operator equivalence (<<=) on this Bitset.
     */
    public function shiftLeft( $n : int ) : Bitset
    {
      const len : int = _bits.length,
        wordShiftCount : int = $n / _BITS_PER_WORD,      
        bitShiftCount : int = $n % _BITS_PER_WORD;
      var i : int; 
      if( wordShiftCount > 0 ) {
        for ( i = len - 1 ; i >= 0 ; i -= 1 ) {
          _bits[ i ] = i - wordShiftCount >= 0 ?
            _bits[ i - wordShiftCount ] : 0;
        }
      }
      if( bitShiftCount > 0 ) {
        for ( i = len - 1 ; i > 0 ; i -= 1 ) {
          _bits[ i ] = ( _bits[ i ] << bitShiftCount ) |
            ( _bits[ i - 1 ] >>> ( _BITS_PER_WORD - bitShiftCount));
        }
        _bits[ 0 ] <<= bitShiftCount;
      }
      _trim();
      return this;
    }
    
    /**
     * Performs right shift operator equivalence (>>>=) on this Bitset.
     */
    public function shiftRight( $n : int ) : Bitset
    {      
      const len : int = _bits.length,
        wordShiftCount : int = $n / _BITS_PER_WORD,      
        bitShiftCount : int = $n % _BITS_PER_WORD;
      var i : int; 
      if( wordShiftCount > 0 ) {
        for ( i = 0 ; i < len ; i += 1 ) {
          _bits[ i ] = i + wordShiftCount < len ?
            _bits[ i + wordShiftCount ] : 0;
        }
      }
      if( bitShiftCount > 0 ) {
        for ( i = 0 ; i < len - 1 ; i += 1 ) {
          _bits[ i ] = ( _bits[ i ] >>> bitShiftCount ) | 
            (_bits[ i + 1 ] << ( _BITS_PER_WORD - bitShiftCount ));
        }
        _bits[ len - 1 ] >>>= bitShiftCount;
      }
      return this;
    }
    
    public function toString() : String
    {
      const len : int = _bits.length;
      var str : String = "";      
      if ( _len > 0 ) {
        const mod : int = _len % _BITS_PER_WORD; 
        const bs : int = mod == 0 ? _BITS_PER_WORD : mod;
        var i : int, j : int;
        for ( i = bs - 1 ; i >= 0 ; i -= 1 ) {
          str += ( _bits[ len - 1 ] & ( 1 << i )) != 0 ? "1" : "0";
        }
        for ( i = len - 2 ; i >= 0 ; i -= 1 ) {
          for ( j = _BITS_PER_WORD - 1 ; j >= 0 ; j -= 1 ) {
            str += ( _bits[ i ] & ( 1 << j )) != 0 ? "1" : "0";
          }
        }
      } 
      return str;
    }
    
    private function _nextClearPositive( $from : int ) : int
    {
      const blen : int = _bits.length;
      const startWord : int = $from / _BITS_PER_WORD,
        startWordBit : int = $from % _BITS_PER_WORD,
        endWord : int = _len / _BITS_PER_WORD,
        endWordBit : int = _len % _BITS_PER_WORD;
      var i : int, j : int;
      if( startWord < endWord ) {
        if (( _bits[ startWord ] | ((1 << startWordBit)-1)) != -1 ) {
          for ( i = startWordBit ; i < _BITS_PER_WORD ; i += 1 ) {
            if (( _bits[ startWord ] & ( 1 << i )) == 0 ) {
                return startWord * _BITS_PER_WORD + i;
            }
          }
        }
        for ( i = startWord + 1 ; i < blen - 1 ; i += 1 ) {
          if ( _bits[ i ] != -1 ) {
            for ( j = 0 ; j < _BITS_PER_WORD ; j += 1 ) {
              if (( _bits[ i ] & ( 1 << j )) == 0 ) {
                return i * _BITS_PER_WORD + j;
              }
            }
          }
        }
        if ( endWordBit != 0 ) {
          if (( _bits[ blen - 1 ] | ~((1 << endWordBit)-1)) != -1 ) {
            for ( i = 0 ; i < endWordBit ; i += 1 ) {
              if (( _bits[ blen - 1 ] & ( 1 << i )) == 0 ) {
                return (blen - 1) * _BITS_PER_WORD + i;
              }
            }
          }
          return -1;
        }
        else {
          if ( _bits[ blen - 1 ] != -1 ) {
            for ( i = 0 ; i < _BITS_PER_WORD ; i += 1 ) {
              if (( _bits[ blen - 1 ] & ( 1 << i )) == 0 ) {
                return (blen - 1) * _BITS_PER_WORD + i;
              }
            }
          }
          return -1;
        }
      }
      else {
        for ( i = startWordBit ; i < endWordBit ; i += 1 ) {
          if (( _bits[ blen - 1 ] & ( 1 << i )) == 0 ) {
            return (blen - 1) * _BITS_PER_WORD + i;
          }
        }
        return -1;
      }
    }
    
    private function _nextClearNegative( $from : int ) : int
    {
      const blen : int = _bits.length;
      const startWord : int = 0,
        startWordBit : int = 0,
        endWord : int = ( _len + $from ) / _BITS_PER_WORD,
        endWordBit : int = ( _len + $from ) % _BITS_PER_WORD;
      var i : int, j : int;
      if ( startWord < endWord ) {
        if (( _bits[ endWord ] | ~((1 << endWordBit) | ((1 << endWordBit) - 1))) != -1 ) {
          for ( i = endWordBit ; i >= 0 ; i -= 1 ) {
            if (( _bits[ endWord ] & ( 1 << i )) == 0 ) {
              return ( endWord * _BITS_PER_WORD ) + i;
            }
          }
        }
        for ( i = endWord - 1 ; i > 0 ; i -= 1 ) {
          if ( _bits[ i ] != -1 ) {
            for ( j = _BITS_PER_WORD - 1 ; j >= 0 ; j -= 1 ) {
              if (( _bits[ i ] & ( 1 << j )) == 0 ) {
                return ( i * _BITS_PER_WORD ) + j;
              }
            }
          }
        }
        if ( _bits[ 0 ] != -1 ) {
          for ( i = _BITS_PER_WORD - 1 ; i >= 0 ; i -= 1 ) {
              if (( _bits[ 0 ] & ( 1 << i )) == 0 ) {
                return i;
              }
          }
        }
        return -1;
      }        
      else {
        if (( _bits[ endWord ] | ~((1 << endWordBit) | ((1 << endWordBit) - 1))) != -1 ) {
          for ( i = endWordBit ; i >= 0 ; i -= 1 ) {
            if (( _bits[ 0 ] & ( 1 << i )) == 0 ) {
              return i;
            }
          }
        }
        return -1;          
      }
    }
    
    private function _nextSetPositive( $from : int ) : int
    {
      const blen : int = _bits.length;
      const startWord : int = $from / _BITS_PER_WORD,
        startWordBit : int = $from % _BITS_PER_WORD,
        endWord : int = _len / _BITS_PER_WORD,
        endWordBit : int = _len % _BITS_PER_WORD;
      var i : int, j : int;
      if( startWord < endWord ) {
        if (( _bits[ startWord ] & ~((1 << startWordBit)-1)) != 0 ) {
          for ( i = startWordBit ; i < _BITS_PER_WORD ; i += 1 ) {
            if (( _bits[ startWord ] & ( 1 << i )) != 0 ) {
                return startWord * _BITS_PER_WORD + i;
            }
          }
        }
        for ( i = startWord + 1 ; i < blen - 1 ; i += 1 ) {
          if ( _bits[ i ] != 0 ) {
            for ( j = 0 ; j < _BITS_PER_WORD ; j += 1 ) {
              if (( _bits[ i ] & ( 1 << j )) != 0 ) {
                return i * _BITS_PER_WORD + j;
              }
            }
          }
        }
        if ( endWordBit != 0 ) {
          if (( _bits[ blen - 1 ] & ((1 << endWordBit)-1)) != 0 ) {
            for ( i = 0 ; i < endWordBit ; i += 1 ) {
              if (( _bits[ blen - 1 ] & ( 1 << i )) != 0 ) {
                return (blen - 1) * _BITS_PER_WORD + i;
              }
            }
          }
          return -1;
        }
        else {
          if ( _bits[ blen - 1 ] != 0 ) {
            for ( i = 0 ; i < _BITS_PER_WORD ; i += 1 ) {
              if (( _bits[ blen - 1 ] & ( 1 << i )) != 0 ) {
                return (blen - 1) * _BITS_PER_WORD + i;
              }
            }
          }
          return -1;
        }
      }
      else {
        for ( i = startWordBit ; i < endWordBit ; i += 1 ) {
          if (( _bits[ blen - 1 ] & ( 1 << i )) != 0 ) {
            return (blen - 1) * _BITS_PER_WORD + i;
          }
        }
        return -1;
      }
    }
    
    private function _nextSetNegative( $from : int ) : int
    {
      const blen : int = _bits.length;
      const startWord : int = 0,
        startWordBit : int = 0,
        endWord : int = ( _len + $from ) / _BITS_PER_WORD,
        endWordBit : int = ( _len + $from ) % _BITS_PER_WORD;
      var i : int, j : int;
      if ( startWord < endWord ) {
        if (( _bits[ endWord ] & ((1 << endWordBit) | ((1 << endWordBit) - 1))) != -1 ) {
          for ( i = endWordBit ; i >= 0 ; i -= 1 ) {
            if (( _bits[ endWord ] & ( 1 << i )) != 0 ) {
              return ( endWord * _BITS_PER_WORD ) + i;
            }
          }
        }
        for ( i = endWord - 1 ; i > 0 ; i -= 1 ) {
          if ( _bits[ i ] != 0 ) {
            for ( j = _BITS_PER_WORD - 1 ; j >= 0 ; j -= 1 ) {
              if (( _bits[ i ] & ( 1 << j )) != 0 ) {
                return ( i * _BITS_PER_WORD ) + j;
              }
            }
          }
        }
        if ( _bits[ 0 ] != 0 ) {
          for ( i = _BITS_PER_WORD - 1 ; i >= 0 ; i -= 1 ) {
              if (( _bits[ 0 ] & ( 1 << i )) != 0 ) {
                return i;
              }
          }
        }
        return -1;
      }
      else {
        if (( _bits[ endWord ] & ((1 << endWordBit) | ((1 << endWordBit) - 1))) != 0 ) {
          for ( i = endWordBit ; i >= 0 ; i -= 1 ) {
            if (( _bits[ 0 ] & ( 1 << i )) != 0 ) {
              return i;
            }
          }
        }
        return -1;          
      }
    }
    
    private function _procOpLenghtAndCapacity( $bs : Bitset ) : void
    {
      const rc : int = Math.ceil( $bs._len / _BITS_PER_WORD );
      if ( _bits.length < rc ) {
        do {
          _bits.push( 0 );
        } while ( _bits.length != rc );
        _len = $bs._len;
      }
      else if ( _len < $bs._len ) {
        _len = $bs._len;        
      }
    }
    
    private function _trim() : void
    {
      const b : int = _len % _BITS_PER_WORD;
      if ( b != 0 ) {
        _bits[ _bits.length - 1 ] &= ( 1 << b ) - 1;
      }
    }
    
    private function _trimVector() : void
    {
      while ( Math.ceil( _len / _BITS_PER_WORD ) < _bits.length ) {        
        _bits.pop();
      }
    }

    private var _len : int = 0;
    private var _bits : Vector.< int >;   
    private static const _BITS_PER_HEX : Array = [ 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 ]; 
  }
}

import com.swlodarski.utils.Iterator;
import com.swlodarski.utils.ReverseIterator;

class _BitsetIterator extends Iterator
{
  public function _BitsetIterator( $bits : Vector.< int >, $len : int, $pos : int )
  {
    _bits = $bits;
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
    return int(( _bits[ int( _pos / _BITS_PER_WORD )] & ( 1 << ( _pos % _BITS_PER_WORD ))) != 0 );
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _BitsetIterator = $b as _BitsetIterator;
    return b && _bits == b._bits && _pos == b._pos;
  }
  
  private var _bits : Vector.< int >;
  private var _pos : int;  
  private var _len : int;
}

class _BitsetReverseIterator extends ReverseIterator
{ 
  public function _BitsetReverseIterator( $bits : Vector.< int >, $len : int, $pos : int )
  {
    _bits = $bits;
    _len = $len;
    _pos = $len - 1 - $pos;
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
    return int(( _bits[ int( _pos / _BITS_PER_WORD )] & ( 1 << ( _pos % _BITS_PER_WORD ))) != 0 );
  }
  
  override public function equals( $b : Iterator ) : Boolean 
  {
    const b : _BitsetReverseIterator = $b as _BitsetReverseIterator;
    return b && _bits == b._bits && _pos == b._pos;
  }
  
  private var _bits : Vector.< int >;
  private var _pos : int;  
  private var _len : int;
}

const _BITS_PER_WORD : int = 32;
