require 'rubygems'
require 'util'
require 'data'
require 'pp'
require 'matrix'
require 'set'

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
  # I think this is just simple combinatorics, but let's just solve it recursively for fun (with memoization for efficiency)
  @paths_mem = {}
  def paths(i, j, size)
    return 1 if i == size and j == size
    key = [i, j, size]
    return @paths_mem[key] if @paths_mem.key?key
    @paths_mem[key] = ((i < size) ? paths(i+1, j, size) : 0) + ((j < size) ? paths(i, j+1, size) : 0)
  end
  sol = paths(0, 0, 20)
when 16
  desc = 'What is the sum of the digits of the number 2**1000?'
  sol = (2**1000).digits.sum
when 17
  desc = 'How many letters would be needed to write all the numbers in words from 1 to 1000?'
  class Integer
    def inwords
      return 'one thousand' if self == 1000
      digits = self.digits
      words = ['', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen']
      decades = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety']
      str = []
      str.push(words[digits[-3]] + ' hundred') if digits.length >= 3
      str.push('and') if digits.length >= 3 and (digits[-1] != 0 or digits[-2] != 0)
      str.push(decades[digits[-2]]) if digits.length >= 2 and digits[-2] > 1
      str.push(words[digits[-1] + (digits[-2] == 1 ? 10 : 0)]) if (digits[-1] != 0 or (digits.length >= 2 and digits[-2] == 1))
      str.join(' ')
    end
  end
  sol = (1..1000).to_a.map{|n| n.inwords.gsub(' ', '').length}.sum
when 18
  desc = 'Find the maximum sum travelling from the top of the triangle to the base.'
  @rows = @triangle_17.split(/\n/).map{|s| s.split.map{|n| n.to_i}}
  @maxsums = {}
  def maxsum(row, col)
    return 0 if row >= @rows.length
    key = [row, col]
    return @maxsums[key] if @maxsums.key?key
    @maxsums[key] = @rows[row][col] + [maxsum(row+1, col), maxsum(row+1, col+1)].max
  end
  sol = maxsum(0, 0)
when 19
  desc = 'How many Sundays fell on the first of the month during the twentieth century?'
  sol = (1901..2000).map{|year| (1..12).find_all{|month| DateTime.new(year, month, 1).wday == 0 }.length}.sum
when 20
  desc = 'Find the sum of digits in 100!'
  sol = 100.factorial.digits.sum
when 21
  desc = 'Evaluate the sum of all amicable pairs under 10000.'
  class Integer
    def sum_proper_divisors
      return 1 if self == 1
      self.divisors.sum - self
    end
    def is_amicable
      sum = self.sum_proper_divisors
      sum != self and self == sum.sum_proper_divisors
    end
  end
  sol = (2...10000).find_all{|n| n.is_amicable}.sum
when 22
  desc = 'What is the total of all the name scores in the file of first names?'
  names = open('names.txt') {|f| eval '[' + f.read + ']' }.sort
  values = names.map{|name| name.chars.map{|n| n[0] - ?A + 1}.sum}
  sol = values.enum_with_index.map{|v, i| v * (i + 1)}.sum
when 23
  desc = 'Find the sum of all the positive integers which cannot be written as the sum of two abundant numbers.'
  class Integer
    def is_abundant
      self.proper_divisors.sum > self
    end
  end
  top = 28123
  abun = (2..top).find_all{|n| n.is_abundant}
  abunset = Set.new(abun)
  sol = (1..top).find_all{|n| abun.find_all{|i| abunset.include?(n - i)}.length == 0}.sum
when 24
  desc = 'What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?'
  class Array
    def permutations
      return [self] if size < 2
      perm = []
      each { |e| (self - [e]).permutations.each { |p| perm << ([e] + p) } }
      perm
    end
  end
  perms = '0123456789'.chars.to_a.permutations.map{|arr| arr.to_s}.sort
  sol = perms[999999]
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
