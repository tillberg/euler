
class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end

problem = ARGV[0].to_i

desc = ''
sol = ''

case problem
  
  
when 1
  desc = 'Add all the natural numbers below one thousand that are multiples of 3 or 5.'
  sol = (1...1000).to_a.find_all {|x| x % 3 == 0 || x % 5 == 0 }.sum



end

puts
puts '    Problem: ' + problem.to_s
puts 'Description: ' + desc
puts '   Solution: ' + sol.to_s
puts