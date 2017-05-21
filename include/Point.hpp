/*
 *          File: Point.h
 * Last Modified: February 19, 2000
 *         Topic: Writing Make Files
 *        Source: https://www.cs.bu.edu/teaching/cpp/writing-makefiles/
 * --------------------------------------------------------------------
 */

#ifndef _POINT_HPP
#define _POINT_HPP

class Point {
  public:
    Point();
    Point(int xval, int yval);
    void move(int dx, int dy);
    int get_x() const;
    int get_y() const;

  private:
    int x, y;
};

#endif
