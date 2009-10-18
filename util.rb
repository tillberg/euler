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
  
  def is_prime
    maxcheck = (self ** 0.5).floor
    (2..maxcheck).each{|n| return false if self % n == 0}
    true
  end  
end

