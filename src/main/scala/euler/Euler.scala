
package euler

import scala.collection.mutable._
import scala.math.BigInt
import collection.mutable

object Euler {
  var desc = ""
  def main(args: Array[String]) = {
    val problemNumber = 16 //args.head.toInt
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
      (rng.sum * rng.sum) - rng.map(r=>r*r).sum
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
      // Skipping this.  This one is annoying
      val gridLines = EulerData.digits_11.split('\n')
      val grid = gridLines.map(_.split(' ').map(parseInt).toVector).toVector
      val size = 20
      val lineLength = 4
      def getProduct(pt: (Int, Int), direction: (Int, Int)) = {
        val (x, y) = pt
        val (dx, dy) = direction
        val endX = x + (lineLength - 1) * dx
        val endY = y + (lineLength - 1) * dy
        if (endX >= 0 && endX < size && endY >= 0 && endY < size) {
          def valAt(i:Int) = grid(x + i * dx)(y + i * dy)
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
                case 0 => seqLen( n / 2 )
                case 1 => seqLen( 3 * n + 1 )
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

    case 18 =>
      desc = "Find the maximum sum travelling from the top of the triangle to the base."

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
