require "util.rb"

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
  num = 0
  10001.times{n += 1; n += 1 while not n.is_prime}
  sol = n
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
