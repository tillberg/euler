require "util.rb"
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
  digits = ('73167176531330624919225119674426574742355349194934' +
            '96983520312774506326239578318016984801869478851843' +
            '85861560789112949495459501737958331952853208805511' +
            '12540698747158523863050715693290963295227443043557' +
            '66896648950445244523161731856403098711121722383113' +
            '62229893423380308135336276614282806444486645238749' +
            '30358907296290491560440772390713810515859307960866' +
            '70172427121883998797908792274921901699720888093776' +
            '65727333001053367881220235421809751254540594752243' +
            '52584907711670556013604839586446706324415722155397' +
            '53697817977846174064955149290862569321978468622482' +
            '83972241375657056057490261407972968652414535100474' +
            '82166370484403199890008895243450658541227588666881' +
            '16427171479924442928230863465674813919123162824586' +
            '17866458359124566529476545682848912883142607690042' +
            '24219022671055626321111109370544217506941658960408' +
            '07198403850962455444362981230987879927244284909188' +
            '84580156166097919133875499200524063689912560717606' +
            '05886116467109405077541002256983155200055935729725' +
            '71636269561882670428252483600823257530420752963450')
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
  grid = ['08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08',
          '49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00',
          '81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65',
          '52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91',
          '22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80',
          '24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50',
          '32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70',
          '67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21',
          '24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72',
          '21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95',
          '78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92',
          '16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57',
          '86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58',
          '19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40',
          '04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66',
          '88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69',
          '04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36',
          '20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16',
          '20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54',
          '01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48']
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
