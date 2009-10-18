require "util.rb"
require 'data.rb'
require 'pp'
require 'matrix'

problem = ARGV[0].to_i

desc = nil
sol = nil

case problem
when 1
  desc = 'Add all the natural numbers below one thousand that are multiples of 3 or 5.'
  sol = (1...1000).to_a.find_all {|x| x % 3 == 0 || x % 5 == 0 }.sum
when 2
  desc = 'Find the sum of all the even-valued terms in the Fibonacci sequence which do not exceed four million.'
  fib = [1, 2]
  while true
    nxt = fib[-2..-1].sum
    break if nxt > 4000000
    fib.push(nxt)
  end
  sol = fib.find_all {|x| x % 2 == 0}.sum
when 3
  desc = 'Find the largest prime factor of a composite number.'
  sol = 600851475143.factors.max
when 4
  desc = 'Find the largest palindrome made from the product of two 3-digit numbers.'
  rng = 100..999
  prods = []
  rng.each {|n| prods.concat(rng.map{|x| x * n})}
  sol = prods.find_all{|n| n.to_s == n.to_s.reverse}.max
when 5
  desc = 'What is the smallest number divisible by each of the numbers 1 to 20?'
  rng = 1..20
  # For a minor optimization, we'll only check multiples of the product of the primes
  step = rng.find_all{|n| n.is_prime}.mult
  n = step
  n += step while rng.find_all{|d| n % d != 0}.length != 0
  sol = n
when 6
  desc = 'What is the difference between the sum of the squares and the square of the sums?'
  rng = (1..100).to_a
  sol = rng.sum ** 2 - rng.map{|n| n ** 2}.sum
when 7
  desc = 'Find the 10001st prime.'
  n = 1
  10001.times{n += 1; n += 1 while not n.is_prime}
  sol = n
when 8
  desc = 'Discover the largest product of five consecutive digits in the 1000-digit number.'
  digits = @digits_8
  dig = 5
  sol = (0..(digits.length - dig)).map{|d| digits[d...(d + dig)].split('').map{|v| v.to_i}.mult }.max
when 9
  desc = 'Find the only Pythagorean triplet, {a, b, c}, for which a + b + c = 1000.'
  sum = 1000
  (1...sum).each{|a| 
    (1...a).each{|b|
      c = sum - a - b
      if a**2 + b**2 == c**2
        sol = a * b * c
      end
    }
  }
when 10
  desc = 'Calculate the sum of all the primes below two million.'
  sol = (1...2000000).find_all{|n| n.is_prime}.sum
when 11
  desc = 'What is the greatest product of four numbers on the same straight line in the 20 by 20 grid?'
  grid = @grid_11
  mat = Matrix.rows(grid.map{|row| row.split(' ').map{|n| n.to_i}})
  len = 4
  rngl = 0...(20-(len-1))
  rngl2 = (len-1)...20
  rng = 0...20
  vert = rng.map{|i| rngl.map{|j| mat[i,j] * mat[i,j+1] * mat[i,j+2] * mat[i,j+3] }.max}.max
  horz = rngl.map{|i| rng.map{|j| mat[i,j] * mat[i+1,j] * mat[i+2,j] * mat[i+3,j] }.max}.max
  diag = rngl.map{|i| rngl.map{|j| mat[i,j] * mat[i+1,j+1] * mat[i+2,j+2] * mat[i+3,j+3]}.max}.max
  diag2 = rngl2.map{|i| rngl.map{|j| mat[i,j] * mat[i-1,j+1] * mat[i-2,j+2] * mat[i-3,j+3]}.max}.max
  sol = [vert, horz, diag, diag2].max
when 12
  desc = 'What is the value of the first triangle number to have over five hundred divisors?'
  n = 0
  sum = 0
  while sum.divisors.length <= 500
    n += 1
    sum += n
  end
  sol = sum
when 13
  desc = 'Find the first ten digits of the sum of one-hundred 50-digit numbers.'
  nums = @text_13.split(' ').map{|s| s.strip.to_i}
  sol = nums.sum.to_s[0...10]
when 14
  desc = 'Find the longest sequence using a starting number under one million.'
  class Integer
    # Use memoization for a dramatic speedup
    @@seqlens = {}
    def seqlen
      return @@seqlens[self] if @@seqlens.key?self
      return 1 if self <= 1
      len = 1 + (self.is_even ? (self / 2).seqlen : (3 * self + 1).seqlen)
      @@seqlens[self] = len
    end
  end
  seqlens = (0...1000000).map{|n| n.seqlen}
  sol = seqlens.index seqlens.max
when 15
  desc = 'Starting in the top left corner in a 20 by 20 grid, how many routes are there to the bottom right corner?'
  
end

if desc == nil or sol == nil then
  puts 'That problem number does not yet have a solution.'
else
  puts
  puts '    Problem: ' + problem.to_s
  puts 'Description: ' + desc
  puts '   Solution: ' + sol.to_s
  puts  
end
