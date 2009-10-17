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
  sol = prime_factors(600851475143).max
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
