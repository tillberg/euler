#!/bin/sh
exec scala "$0" "$@"
!#

import scala.collection.TraversableLike
import scala.collection.mutable._

class RichStream[A](str: =>Stream[A]) {
  def ::(hd: A) = Stream.cons(hd, str)
}
implicit def streamToRichStream[A](str: =>Stream[A]) = new RichStream(str)
implicit def string2Int(s: String): Int = augmentString(s).toInt

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
      val step = rng.filter(isPrime(_)).reduceLeft(_ * _)
      naturals.map(_ * step).find(n => rng.forall(i => n % i == 0)).get
    }
  }
  
  
  lazy val fib: Stream[Int] = 0 :: 1 :: fib.zip(fib.tail).map(p => p._1 + p._2)
  lazy val naturals: Stream[Int] = 1 :: naturals.map(_ + 1)
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
}

Euler.main(args)
