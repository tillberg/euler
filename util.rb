class Array
  def sum
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end

  def mult
    inject( nil ) { |sum,x| sum ? sum*x : x }
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
    invdivs = divs.map{|d| self / d}.reverse
    invdivs.pop if invdivs.last == maxcheck # Avoid double-counting the square root
    divs.concat(invdivs)
  end
  
  def is_prime
    return false if self == 1
    maxcheck = (self ** 0.5).floor
    (2..maxcheck).each{|n| return false if self % n == 0}
    true
  end
  
  def is_even
    self & 1 == 0
  end
end

