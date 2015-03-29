package euler

import collection.mutable

object Common {
  def maxTriangleSum(grid: Vector[Vector[Int]]): Int = {
    val memoized = mutable.HashMap[(Int, Int), Int]()
    def maxSumFrom(pt: (Int, Int)): Int = {
      if (pt._2 >= grid.length) return 0
      memoized.get(pt) match {
        case Some(n) => n
        case None =>
          val max = grid(pt._2)(pt._1) + math.max(maxSumFrom((pt._1 + 1, pt._2 + 1)), maxSumFrom((pt._1, pt._2 + 1)))
          memoized.update(pt, max)
          max
      }
    }
    maxSumFrom((0, 0))
  }

}
