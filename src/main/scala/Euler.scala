
package euler

import scala.collection.TraversableLike
import scala.collection.mutable._
import scala.math.BigInt

object Euler {
  var desc = ""
  def main(args: Array[String]) = {
    val start = System.currentTimeMillis
    var solution = euler(args.head)
    val totalTime = System.currentTimeMillis - start
    //println(desc)
    println("Scala Solution: " + euler(args.head) + " (" + totalTime + " ms)")
  }
  def euler(i: Int) = i match {
    case 1 => {
      desc = "Add all the natural numbers below one thousand that are multiples of 3 or 5."
      (1 until 1000).filter(i => i % 3 == 0 || i % 5 == 0).sum
    }
    case 2 => {
      desc = "Find the sum of all the even-valued terms in the Fibonacci sequence which do not exceed four million."
      even(fib.takeWhile(_ <= 4000000)).sum
    }
    case 3 => {
      desc = "Find the largest prime factor of a composite number."
      factors(600851475143L).max
    }
    case 4 => {
      desc = "Find the largest palindrome made from the product of two 3-digit numbers."
      val rng = 100 until 1000
      (for (x <- rng; y <- rng if isPalindrome(x * y)) yield x * y).max
    }
    case 5 => {
      desc = "What is the smallest number divisible by each of the numbers 1 to 20?"
      val rng = 2 to 20
      val step = (2 to 20).filter(isPrime(_)).reduceLeft(_ * _)
      fromBy(step, step).find(n => rng.forall(i => n % i == 0)).get
    }
    case 6 => {
      desc = "What is the difference between the sum of the squares and the square of the sums?"
      val rng = 1 to 100
      (rng.sum * rng.sum) - rng.map(r=>r*r).sum
    }
    case 7 => {
      desc = "Find the 10001st prime."
      primes(10000)
    }
    case 8 => {
      desc = "Discover the largest product of five consecutive digits in the 1000-digit number."
      val C = 5
      val digits = EulerData.digits_8.toArray map (_.toString) map parseInt
      val num = digits.length
      (0 until C).map(i => digits.slice(i, num - C + i)).reduceRight((a, b) => a.zip(b).map(e => e._1 * e._2)).max
    }
    case 9 => {
      desc = "Find the only Pythagorean triplet, {a, b, c}, for which a + b + c = 1000."
      def isPyTrip(i: Int, j: Int) = {
        val k = 1000 - i - j
        i * i + j * j == k * k
      }
      (for (x <- 1 to 998; y <- x to (1000 - x) if isPyTrip(x, y)) yield x * y * (1000 - x - y)).head
    }
    case 10 => {
      desc = "Calculate the sum of all the primes below two million."
      primes.takeWhile(_ < 2000000).map(BigInt(_)).sum
    }
    case 11 => {
      desc = "What is the greatest product of four numbers on the same straight line in the 20 by 20 grid?"
      // Skipping this.  This one is annoying
    }
    case 12 => {
      desc = "What is the value of the first triangle number to have over five hundred divisors?"
      triangle.find(numDivisors(_) > 500).get
    }
  }
  
  def fromBy(n: Int, step: Int): Stream[Int] = n #:: fromBy(n + step, step)
  def from(n: Int): Stream[Int] = n #:: from(n + 1)
  lazy val fib: Stream[Int] = 0 #:: 1 #:: fib.zip(fib.tail).map(p => p._1 + p._2)
  val naturals = (1 to Int.MaxValue)
  lazy val lazyNaturals: Stream[Int] = from(1)
  def triangleGen(last: Int, step: Int): Stream[Int] = (last + step) #:: triangleGen(last + step, step + 1)
  lazy val triangle = triangleGen(0, 1)
  def factors(num: Long) = {
    var fac = ListBuffer[Int]()
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
  def listToCountedMap(s: Traversable[Int]) = {
    s.foldRight(HashMap[Int, Int]())({ (r, acc) =>
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
  implicit def string2Int(s: String): Int = augmentString(s).toInt
  def parseInt(s:String) = Integer.parseInt(s, 10)
}

//Euler.main(args)
