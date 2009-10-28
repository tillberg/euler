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
when 25
  desc = 'What is the first term in the Fibonacci sequence to contain 1000 digits?'
  fib = [1, 2]
  n = 3
  while true
    nxt = fib[-2..-1].sum
    n += 1
    break if nxt.to_s.length >= 1000
    fib.push(nxt)
  end
  sol = n
when 26
  desc = 'Find the value of d < 1000 for which 1/d contains the longest recurring cycle.'
  def divide(num, divisor, history)
    return 0 if num == 0
    key = [num, divisor]
    return history.length - history[key] if history.key?key
    history[key] = history.length
    digit = (num * 10 / divisor).floor
    rem = num * 10 - digit * divisor
    divide(rem, divisor, history)
  end
  class Integer
    def inv_cycle_length
      divide(1, self, {})
    end
  end
  cycles = (1..1000).map{|n| n.inv_cycle_length}
  sol = 1 + (cycles.index cycles.max)
when 27
  desc = 'Find a quadratic formula that produces the maximum number of primes for consecutive values of n.'
  def num_consec_primes(a, b)
    n = 0
    while (n**2 + a * n + b).is_prime
      n += 1
    end
    n
  end
  # The elegant way would be to iterate through an array of all 4 million factor combos, 
  # but it takes too long (a minute or so) to build that array.
  rng = (-999..999)
  max_consec = 0
  max_factors = [0, 0]
  rng.each{|a|
    rng.each{|b| 
      num_consec = num_consec_primes(a, b)
      if num_consec > max_consec
        max_consec = num_consec
        max_factors = [a, b]
      end
    }
  }
  sol = max_factors.mult
when 28
  desc = 'What is the sum of both diagonals in a 1001 by 1001 spiral?'
  max = 1001
  rng = (2..((max+1)/2)).map{|n| n * 2 - 1}
  sol = 1 + rng.map{|n| (n**2 + (n-2)**2 + n) / 2 * 4}.sum
when 29
  desc = 'How many distinct terms are in the sequence generated by a**b for 2 ≤ a ≤ 100 and 2 ≤ b ≤ 100?'
  ab = []
  (2..100).each{|a| (2..100).each{|b| ab.push([a, b])}}
  sol = ab.map{|p| p[0] ** p[1]}.uniq.length
when 30
  desc = 'Find the sum of all the numbers that can be written as the sum of fifth powers of their digits.'
  sol = (2...1000000).find_all{|n| n == n.digits.map{|d| d**5}.sum}.sum
when 31
  desc = 'Investigating combinations of English currency denominations.'
  val = [5, 10, 20, 50, 100]
  max = val.map{|v| 0..(200 / v)}
  sol = 1 + max.explode.map{|counts| max2 = ((200 - counts.prod(val).sum) / 2).floor; [max2 + 1, 0].max}.sum
when 32
  desc = 'Find the sum of all numbers that can be written as pandigital products.'
  factors = [0..10000, 0..100].explode + [0..1000, 0..1000].explode # This is just a wild shot
  sol = factors.map{|f, g| prod = f * g; digits = f.digits + g.digits + prod.digits; (digits.sort.to_s == '123456789' ? prod : 0)}.uniq.sum
when 33
  desc = 'Discover all the fractions with an unorthodox cancelling method.'
  fractions = [10..99, 10..99].explode
  all = fractions.find_all{|n, d| ns = n.digits; ds = d.digits; n < d && (n * ds[1] == ns[0] * d) && (ns[1] == ds[0]) && (ds[1] != ns[1])}
  prod = [1, 1]
  all.each{|f| prod = prod.prod f}
  class Array
    def reduced
      gcd = self[0].gcd self[1]
      [self[0] / gcd, self[1] / gcd]
    end
  end
  sol = prod.reduced[1]
when 34
  desc = 'Find the sum of all numbers which are equal to the sum of the factorial of their digits.'
  # The range is arbitrary ... I tried 100x higher too but this was sufficient
  sol = (10..100000).find_all{|n| n == n.digits.map{|d| d.factorial}.sum}.sum
when 35
  desc = 'How many circular primes are there below one million?'
  class Integer
    def rotate_digits(n = 1)
      return self if n < 1
      digits = self.digits
      (digits[n..-1] + digits[0..n-1]).to_s.to_i
    end
  end
  sol = (0...1000000).find_all{|n| len = n.digits.length; (0...len).find_all{|m| n.rotate_digits(m).is_prime}.length == len}.length
when 36
  desc = 'Find the sum of all numbers less than one million, which are palindromic in base 10 and base 2.'
  sol = (1...1000000).find_all{|n| d = n.to_s; b = n.to_s(2); (d == d.reverse && b == b.reverse)}.sum
when 37
  desc = 'Find the sum of all eleven primes that are both truncatable from left to right and right to left.'
  # Again, the range here is arbitrary.  I just increased it till I got all eleven.
  sol = (11..1000000).find_all{|n| len = n.digits.length; (n.is_prime && (1..(len-1)).find_all{|t| n.digits[t..-1].to_s.to_i.is_prime && n.digits[0...-t].to_s.to_i.is_prime}.length == (len - 1))}.sum
when 38
  desc = 'What is the largest 1 to 9 pandigital that can be formed by multiplying a fixed number by 1, 2, 3, ... ?'
  # This would be made cleaner by combining the map and find_all function for the outer loop (instead of the the prods.length > 0 switch at the end)
  sol = (1...100000).map{|n| prods = (2..8).map{|d| (1..d).map{|f| (f * n).to_s}.to_s.to_i }.find_all{|p| p.digits.sort.to_s == '123456789'}; prods.length > 0 ? prods.max : 0 }.max
when 39
  desc = 'If p is the perimeter of a right angle triangle, {a, b, c}, which value, for p ≤ 1000, has the most solutions?'
  # I need to optimize this, based on the idea that if I know p and a, I can calculate b and c.
  # a**2 + b**2 == c**2, a + b + c = p => c = p - a - b.  a**2 + b**2 == (p - a - b)**2 == p**2 + a**2 + b**2 - 2p*a - 2p*b + 2a*b
  # => 2(a-p)*b + (p**2 - 2p*a) == 0 => 2(a-p)*b == 2p*a - p**2 => b == (p**2 - 2*p*a) / (2*p - 2*a) 
  low = 3
  num = (low..1000).map{|p| rng = (1..(p-2)).find_all{|a| b = (p**2 - 2*p*a).to_f / (2*p - 2*a); b = [0, b.round].max; a <= b && a**2 + b**2 == (p - a - b)**2 }.length}
  sol = low + num.index(num.max)
when 40
  desc = 'Finding the nth digit of the fractional part of the irrational number.'
  # Form a string of all the digits (beyond 1000000 digits)
  d = (1..200000).to_a.to_s
  # Pick out the desired digits and take their product
  sol = (0..6).map{|n| d.slice(10**n - 1, 1).to_i}.mult
when 41
  desc = 'What is the largest n-digit pandigital prime that exists?'
  # Build a list of all 1..9-digit pandigitals, then find the max prime (a.k.a. Optimus Prime? eh?)
  pandigitals = (1..9).map{|d| (1..d).to_a.permutation.to_a.map{|arr| arr.to_s.to_i} }.sum
  sol = pandigitals.find_all{|n| n.is_prime}.max
when 42
  desc = 'How many triangle words does the list of common English words contain?'
  words = open('words.txt') {|f| eval '[' + f.read + ']' }
  trinums = Set.new((1..50).map{|n| n*(n+1)/2}) # The first 50 should be sufficient
  sol = words.find_all{|w| trinums.member?(w.chars.map{|c| c[0] - ?A + 1}.sum)}.length
when 43
  desc = 'Find the sum of all pandigital numbers with an unusual sub-string divisibility property.'
  # Find all 0..9 pandigitals that don't have 0 as the leading digit
  maxd = 9
  nums = (0..maxd).to_a.permutation.to_a.map{|arr| arr.to_s.to_i}.find_all{|n| n >= 10**maxd}
  class Integer
    @@primes_for_isweird = (1..17).find_all{|n| n.is_prime}
    def is_weird(maxd)
      (1..(maxd-2)).all?{|m| self.digits[m..(m+2)].to_s.to_i % @@primes_for_isweird[m-1] == 0}
    end
  end
  sol = nums.find_all{|n| n.is_weird(maxd)}.sum
when 44
  desc = 'Find the smallest pair of pentagonal numbers whose sum and difference is pentagonal.'
  pent = (1..3000).map{|n| n*(3*n - 1)/2}
  set = Set.new(pent)
  sol = [pent, pent].mv_find_all{|a, b| a > b and set.member?(a - b) and set.member?(a + b)}[0].diff
when 45
  desc = 'After 40755, what is the next triangle number that is also pentagonal and hexagonal?'
  tri = Set.new((1..100000).map{|n| n*(n+1)/2})
  pent = Set.new((1..100000).map{|n| n*(3*n-1)/2})
  hex = (144..1000000).find{|n| v = n*(2*n - 1); tri.member?v and pent.member?v}
  sol = hex*(2*hex - 1)
when 46
  desc = 'What is the smallest odd composite that cannot be written as the sum of a prime and twice a square?'
  sol = (2..100000).find{|n| n.is_odd && !n.is_prime && !(1..((n**0.5).floor)).any?{|a| (n - 2*a**2).is_prime}}
when 47
  desc = 'Find the first four consecutive integers to have four distinct primes factors.'
  class Integer
    # Memoization makes this easier to write elegantly and efficiently
    @@mem_num_uf = {}
    def num_uf
      return @@mem_num_uf[self] if @@mem_num_uf.member?self
      @@mem_num_uf[self] = self.factors.uniq.length
    end
  end
  sol = (1..10000000).find{|n| (0...4).all?{|m| (n+m).num_uf == 4}}
when 48
  desc = 'Find the last ten digits of 1**1 + 2**2 + ... + 1000**1000.'
  sol = (1..1000).map{|n| n**n}.sum.digits[-10..-1].to_s.to_i
when 49
  desc = 'Find arithmetic sequences, made of prime terms, whose four digits are permutations of each other.'
  
when 50
  desc = 'Which prime, below one-million, can be written as the sum of the most consecutive primes?'
    
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
