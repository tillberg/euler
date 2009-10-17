class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end

def prime_factors(n)
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

