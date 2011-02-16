jruby euler.rb $1
scalac -d classes *.scala
scala -cp classes euler.Euler $1
