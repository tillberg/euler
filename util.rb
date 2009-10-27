class Array
  def sum
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end

  def mult
    inject( nil ) { |sum,x| sum ? sum*x : x }
  end
  
  def prod(b = self)
    (0...self.length).map{|i| self[i] * b[i]}
  end
  
  def appendprod(c = self)
    r = []
    self.each{|a| c.each{|b| r.push(a + [b])}}
    r
  end
  
  def mv_find_all
    # Multivariable find_all
    @vs = []
    def iter(l, r)
      if r.length > 1
        r[0].each{|n| iter(l + [n], r[1..-1]){|n| yield n}}
      else
        r[0].each{|n| v = l + [n]; @vs.push(v) if yield v}
      end
    end
    iter([], self){|n| yield n}
    @vs
  end
  
  def explode
    r = self[0].map{|n| [n]}
    s = self[1..-1]
    while s.length > 0
      r = r.appendprod(s[0])
      s = s[1..-1]
    end
    r
  end
end

class Integer
  def factors
    n = self
    div = 2
    factors = []
    while n > 1
      while n % div == 0
        n /= div
        factors.push(div)
      end
      div += 1
    end
    factors
  end
  
  def divisors
    maxcheck = (self ** 0.5).floor
    divs = (1..maxcheck).find_all{|d| self % d == 0}
    invdivs = divs.map{|d| self / d}
    invdivs.pop if invdivs.last == maxcheck # Avoid double-counting the square root
    divs.concat(invdivs.reverse)
  end
  
  def proper_divisors
    self.divisors[0...-1]
  end
  
  @@was_prime = {}
  def is_prime
    return false if self <= 1
    return @@was_prime[self] if @@was_prime.key?self
    maxcheck = (self ** 0.5).floor
    @@was_prime[self] = false # This is worse than not being thread-safe
    (2..maxcheck).each{|n| return false if self % n == 0}
    @@was_prime[self] = true
  end
  
  def is_even
    self & 1 == 0
  end
  
  def is_odd
    self & 1 == 1
  end
  
  def digits
    self.to_s.split('').map{|c| c.to_i}
  end
  
  def factorial
    return 1 if self <= 1
    self * (self - 1).factorial
  end
  
  def is_square
    # This is probably not a perfect implementation, but seems to work somewhat - depends greatly on how (** 0.5) is implemented in terms of rounding and accuracy.
    (self ** 0.5).floor ** 2 == self
  end
end



