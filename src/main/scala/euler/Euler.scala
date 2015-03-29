
package euler

import scala.collection.mutable._
import scala.math.BigInt
import collection.mutable

object Euler {
  var desc = ""
  def main(args: Array[String]) = {
    val problemNumber = 67 //args.head.toInt
    val start = System.currentTimeMillis
    val solution = euler(problemNumber)
    val totalTime = System.currentTimeMillis - start
    println("Problem " + problemNumber)
    println(desc)
    println("Solution: " + solution + " (" + totalTime + " ms)")
  }
  def euler(i: Int) = i match {
    case 1 =>
      desc = "Add all the natural numbers below one thousand that are multiples of 3 or 5."
      (1 until 1000).filter(i => i % 3 == 0 || i % 5 == 0).sum
    case 2 =>
      desc = "Find the sum of all the even-valued terms in the Fibonacci sequence which do not exceed four million."
      even(fib.takeWhile(_ <= 4000000)).sum
    case 3 =>
      desc = "Find the largest prime factor of a composite number."
      factors(600851475143L).max
    case 4 =>
      desc = "Find the largest palindrome made from the product of two 3-digit numbers."
      val rng = 100 until 1000
      (for (x <- rng; y <- rng if isPalindrome(x * y)) yield x * y).max
    case 5 =>
      desc = "What is the smallest number divisible by each of the numbers 1 to 20?"
      val rng = 2 to 20
      val step = (2 to 20).filter(isPrime(_)).product
      fromBy(step, step).find(n => rng.forall(i => n % i == 0)).get
    case 6 =>
      desc = "What is the difference between the sum of the squares and the square of the sums?"
      val rng = 1 to 100
      (rng.sum * rng.sum) - rng.map(r => r * r).sum
    case 7 =>
      desc = "Find the 10001st prime."
      primes(10000)
    case 8 =>
      desc = "Discover the largest product of five consecutive digits in the 1000-digit number."
      val C = 5
      val digits = EulerData.digits_8.toArray map (_.toString) map parseInt
      val num = digits.length
      (0 until C).map(i => digits.slice(i, num - C + i)).reduceRight((a, b) => a.zip(b).map(e => e._1 * e._2)).max
    case 9 =>
      desc = "Find the only Pythagorean triplet, {a, b, c}, for which a + b + c = 1000."
      def isPyTrip(i: Int, j: Int) = {
        val k = 1000 - i - j
        i * i + j * j == k * k
      }
      (for (x <- 1 to 998; y <- x to (1000 - x) if isPyTrip(x, y)) yield x * y * (1000 - x - y)).head
    case 10 =>
      desc = "Calculate the sum of all the primes below two million."
      primes.takeWhile(_ < 2000000).map(BigInt(_)).sum
    case 11 =>
      desc = "What is the greatest product of four numbers on the same straight line in the 20 by 20 grid?"
      val grid = EulerData.grid_11
      val size = 20
      val lineLength = 4
      def getProduct(pt: (Int, Int), direction: (Int, Int)) = {
        val (x, y) = pt
        val (dx, dy) = direction
        val endX = x + (lineLength - 1) * dx
        val endY = y + (lineLength - 1) * dy
        if (endX >= 0 && endX < size && endY >= 0 && endY < size) {
          def valAt(i: Int) = grid(x + i * dx)(y + i * dy)
          (0 until lineLength).map(valAt).product
        } else {
          0
        }
      }
      val starts = (0 until size).flatMap(x => (0 until size).map(y => (x, y)))
      val directions = (-1 to 1).flatMap(x => (-1 to 1).map(y => (x, y)))
        .filter(direction => direction._1 != 0 || direction._2 != 0)
      starts.flatMap(pt => directions.map(direction => getProduct(pt, direction))).max
    case 12 =>
      desc = "What is the value of the first triangle number to have over five hundred divisors?"
      triangle.find(numDivisors(_) > 500).get
    case 13 =>
      desc = "Find the first ten digits of the sum of one-hundred 50-digit numbers."
      EulerData.digits_13.split('\n').map(BigInt(_)).sum.toString().substring(0, 10)
    case 14 =>
      desc = "Find the longest sequence using a starting number under one million."
      var seqLens = mutable.HashMap[Long, Long]()
      def seqLen(m: Long): Long = m match {
        case 1 => 1
        case n =>
          seqLens.get(n) match {
            case Some(x) => x
            case None =>
              val l = 1 + (n & 1 match {
                case 0 => seqLen(n / 2)
                case 1 => seqLen(3 * n + 1)
              })
              seqLens += ((n, l))
              l
          }
      }
      val list = (1 until 1000000).map(seqLen(_))
      val max = list.max
      list.indexOf(max)
    case 15 =>
      desc = "Starting in the top left corner in a 20 by 20 grid, how many routes are there to the bottom right corner?"
      val size = 20
      var memoized = mutable.HashMap[(Int, Int), Long]()
      def numPaths(x: Int, y: Int): Long = {
        if (x == size && y == size) return 1
        val pt = (x, y)
        memoized.get(pt) match {
          case Some(n) => n
          case None =>
            val n = (if (x < size) numPaths(x + 1, y) else 0) + (if (y < size) numPaths(x, y + 1) else 0)
            memoized += ((pt, n))
            n
        }
      }
      numPaths(0, 0)
    case 16 =>
      desc = "What is the sum of the digits of the number 2**1000?"
      BigInt(2).pow(1000).toString().map(parseInt).sum
    case 17 =>
      desc = "How many letters would be needed to write all the numbers in words from 1 to 1000?"
      val words = Array("", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen")
      val decades = Array("", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety")
      def numInWords(n: Int): String = {
        var str = ""
        if (n == 1000) return "one thousand"
        val nMod100 = n % 100
        if (n >= 100) {
          str += words(n / 100) + " hundred"
          if (nMod100 > 0) {
            str += " and"
          }
        }
        if (nMod100 >= 20) {
          str += " " + decades(nMod100 / 10)
        }
        str += " " + (if (nMod100 >= 20) words(n % 10) else words(nMod100))
        str
      }
      (1 to 1000).map(numInWords).map(_.replace(" ", "")).map(_.length).sum
    case 18 =>
      desc = "Find the maximum sum travelling from the top of the triangle to the base."
      Common.maxTriangleSum(EulerData.grid_18)
    case 19 =>
      desc = "How many Sundays fell on the first of the month during the twentieth century?"

    case 20 =>
      desc = "Find the sum of digits in 100!"

    case 21 =>
      desc = "Evaluate the sum of all amicable pairs under 10000."

    case 22 =>
      desc = "What is the total of all the name scores in the file of first names?"

    case 23 =>
      desc = "Find the sum of all the positive integers which cannot be written as the sum of two abundant numbers."

    case 24 =>
      desc = "What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?"

    case 25 =>
      desc = "What is the first term in the Fibonacci sequence to contain 1000 digits?"

    case 26 =>
      desc = "Find the value of d < 1000 for which 1/d contains the longest recurring cycle."

    case 27 =>
      desc = "Find a quadratic formula that produces the maximum number of primes for consecutive values of n."

    case 28 =>
      desc = "What is the sum of both diagonals in a 1001 by 1001 spiral?"

    case 29 =>
      desc = "How many distinct terms are in the sequence generated by a**b for 2 ≤ a ≤ 100 and 2 ≤ b ≤ 100?"

    case 30 =>
      desc = "Find the sum of all the numbers that can be written as the sum of fifth powers of their digits."

    case 31 =>
      desc = "Investigating combinations of English currency denominations."

    case 32 =>
      desc = "Find the sum of all numbers that can be written as pandigital products."

    case 33 =>
      desc = "Discover all the fractions with an unorthodox cancelling method."

    case 34 =>
      desc = "Find the sum of all numbers which are equal to the sum of the factorial of their digits."

    case 35 =>
      desc = "How many circular primes are there below one million?"

    case 36 =>
      desc = "Find the sum of all numbers less than one million, which are palindromic in base 10 and base 2."

    case 37 =>
      desc = "Find the sum of all eleven primes that are both truncatable from left to right and right to left."

    case 38 =>
      desc = "What is the largest 1 to 9 pandigital that can be formed by multiplying a fixed number by 1, 2, 3, ... ?"

    case 39 =>
      desc = "If p is the perimeter of a right angle triangle, {a, b, c}, which value, for p ≤ 1000, has the most solutions?"

    case 40 =>
      desc = "Finding the nth digit of the fractional part of the irrational number."

    case 41 =>
      desc = "What is the largest n-digit pandigital prime that exists?"

    case 42 =>
      desc = "How many triangle words does the list of common English words contain?"

    case 43 =>
      desc = "Find the sum of all pandigital numbers with an unusual sub-string divisibility property."

    case 44 =>
      desc = "Find the smallest pair of pentagonal numbers whose sum and difference is pentagonal."

    case 45 =>
      desc = "After 40755, what is the next triangle number that is also pentagonal and hexagonal?"

    case 46 =>
      desc = "What is the smallest odd composite that cannot be written as the sum of a prime and twice a square?"

    case 47 =>
      desc = "Find the first four consecutive integers to have four distinct primes factors."

    case 48 =>
      desc = "Find the last ten digits of 1**1 + 2**2 + ... + 1000**1000."

    case 49 =>
      desc = "Find arithmetic sequences, made of prime terms, whose four digits are permutations of each other."

    case 50 =>
      desc = "Which prime, below one-million, can be written as the sum of the most consecutive primes?"

    case 51 =>
      desc = "Find the smallest prime which, by changing the same part of the number, can form eight different primes."

    case 52 =>
      desc = "Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x, contain the same digits in some order."

    case 53 =>
      desc = "How many values of C(n,r), for 1 ≤ n ≤ 100, exceed one-million?"

    case 54 =>
      desc = "How many hands did player one win in the game of poker?"

    case 55 =>
      desc = "How many Lychrel numbers are there below ten-thousand?"

    case 56 =>
      desc = "Considering natural numbers of the form, a**b, finding the maximum digital sum."

    case 57 =>
      desc = "Investigate the expansion of the continued fraction for the square root of two."

    case 58 =>
      desc = "Investigate the number of primes that lie on the diagonals of the spiral grid."

    case 59 =>
      desc = "Using a brute force attack, can you decrypt the cipher using XOR encryption?"

    case 60 =>
      desc = "Find a set of five primes for which any two primes concatenate to produce another prime."

    case 61 =>
      desc = "Find the sum of the only set of six 4-digit figurate numbers with a cyclic property."

    case 62 =>
      desc = "Find the smallest cube for which exactly five permutations of its digits are cube."

    case 63 =>
      desc = "How many n-digit positive integers exist which are also an nth power?"

    case 64 =>
      desc = "How many continued fractions for N ≤ 10000 have an odd period?"

    case 65 =>
      desc = "Find the sum of digits in the numerator of the 100th convergent of the continued fraction for e."

    case 66 =>
      desc = "Investigate the Diophantine equation x2 − Dy2 = 1."

    case 67 =>
      desc = "Using an efficient algorithm find the maximal sum in the triangle?"
      Common.maxTriangleSum(EulerData.grid_67)
    case 68 =>
      desc = "What is the maximum 16-digit string for a \"magic\" 5-gon ring?"

    case 69 =>
      desc = "Find the value of n ≤ 1,000,000 for which n/φ(n) is a maximum."

    case 70 =>
      desc = "Investigate values of n for which φ(n) is a permutation of n."

    case 71 =>
      desc = "Listing reduced proper fractions in ascending order of size."

    case 72 =>
      desc = "How many elements would be contained in the set of reduced proper fractions for d ≤ 1,000,000?"

    case 73 =>
      desc = "How many fractions lie between 1/3 and 1/2 in a sorted set of reduced proper fractions?"

    case 74 =>
      desc = "Determine the number of factorial chains that contain exactly sixty non-repeating terms."

    case 75 =>
      desc = "Find the number of different lengths of wire can that can form a right angle triangle in only one way."

    case 76 =>
      desc = "How many different ways can one hundred be written as a sum of at least two positive integers?"

    case 77 =>
      desc = "What is the first value which can be written as the sum of primes in over five thousand different ways?"

    case 78 =>
      desc = "Investigating the number of ways in which coins can be separated into piles."

    case 79 =>
      desc = "By analysing a user\"s login attempts, can you determine the secret numeric passcode?"

    case 80 =>
      desc = "Calculating the digital sum of the decimal digits of irrational square roots."

    case 81 =>
      desc = "Find the minimal path sum from the top left to the bottom right by moving right and down."

    case 82 =>
      desc = "Find the minimal path sum from the left column to the right column."

    case 83 =>
      desc = "Find the minimal path sum from the top left to the bottom right by moving left, right, up, and down."

    case 84 =>
      desc = "In the game, Monopoly, find the three most popular squares when using two 4-sided dice."

    case 85 =>
      desc = "Investigating the number of rectangles in a rectangular grid."

    case 86 =>
      desc = "Exploring the shortest path from one corner of a cuboid to another."

    case 87 =>
      desc = "Investigating numbers that can be expressed as the sum of a prime square, cube, and fourth power?"

    case 88 =>
      desc = "Exploring minimal product-sum numbers for sets of different sizes."

    case 89 =>
      desc = "Develop a method to express Roman numerals in minimal form."

    case 90 =>
      desc = "An unexpected way of using two cubes to make a square."

    case 91 =>
      desc = "Find the number of right angle triangles in the quadrant."

    case 92 =>
      desc = "Investigating a square digits number chain with a surprising property."

    case 93 =>
      desc = "Using four distinct digits and the rules of arithmetic, find the longest sequence of target numbers."

    case 94 =>
      desc = "Investigating almost equilateral triangles with integral sides and area."

    case 95 =>
      desc = "Find the smallest member of the longest amicable chain with no element exceeding one million."

    case 96 =>
      desc = "Devise an algorithm for solving Su Doku puzzles."

    case 97 =>
      desc = "Find the last ten digits of the non-Mersenne prime: 28433 × 27830457 + 1."

    case 98 =>
      desc = "Investigating words, and their anagrams, which can represent square numbers."

    case 99 =>
      desc = "Which base/exponent pair in the file has the greatest numerical value?"

    case 100 =>
      desc = "Finding the number of blue discs for which there is 50% chance of taking two blue."
  }


  def fromBy(n: Int, step: Int): Stream[Int] = n #:: fromBy(n + step, step)
  def from(n: Int): Stream[Int] = n #:: from(n + 1)
  lazy val fib: Stream[Int] = 0 #:: 1 #:: fib.zip(fib.tail).map(p => p._1 + p._2)
  val naturals = 1 to Int.MaxValue
  lazy val lazyNaturals: Stream[Int] = from(1)
  def triangleGen(last: Int, step: Int): Stream[Int] = (last + step) #:: triangleGen(last + step, step + 1)
  lazy val triangle = triangleGen(0, 1)
  def factors(num: Long) = {
    val fac = ListBuffer[Int]()
    var i = 2
    var n = num
    while ( n > 1 ) {
      if ( n % i == 0 ) {
        fac.append(i)
        n /= i
      } else {
        i += 1
      }
    }
    fac
  }
  def even(t: Stream[Int]) = t.filter(_ % 2 == 0)
  def isPalindrome(n: Int) = n.toString.reverse == n.toString
  def isPrime(n: Long) = factors(n).length == 1
  def numDivisors(n: Long) = {
    listToCountedMap(factors(n)).values.map(_ + 1).product
  }
  def listToCountedMap(s: mutable.Traversable[Int]) = {
    s.foldRight(mutable.HashMap[Int, Int]())({ (r, acc) =>
      acc += ((r, acc.get(r) match {
        case None => 1
        case Some(n) => n + 1
      }))
    })
  }
  def sieve(s: Stream[Int]): Stream[Int] = Stream.cons(s.head, sieve(s.tail filter { _ % s.head != 0 }))
  lazy val primes: Stream[Int] = sieve(from(2)) /*2 #:: primes.map(prev => {
    var n = prev + 1
    val _primes = primes.takeWhile( i => i * i <= prev * 3 / 2 )
    while ( _primes.exists( n % _ == 0 ) ) { n += 1 }
    n
  })*/
  def parseInt(s:String) = Integer.parseInt(s, 10)
  def parseInt(s:Char) = Integer.parseInt(s.toString, 10)
}

//Euler.main(args)
