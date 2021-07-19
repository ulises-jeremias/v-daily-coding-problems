// This problem was asked by Nvidia.
// You are given a list of N points (x1, y1), (x2, y2), ..., (xN, yN) representing
// a polygon. You can assume these points are given in order; that is, you can
// construct the polygon by connecting point 1 to point 2, point 2 to point 3, and
// so on, finally looping around to connect point N to point 1.
// Determine if a new point p lies inside this polygon. (If p is on the boundary of
// the polygon, you should return False).

// input example: [{0, 0}, {10, 0}, {10, 10}, {0, 10}]

module main

import math { max, min }

const inf = 1 << 30

// Point represents a tuple with data x, y
struct Point {
	x f64
	y f64
}

// is_on_segment returns for a given three colinear points p, r, q
// if the point q lies on line segment `pr`
fn (q Point) is_on_segment(p Point, r Point) bool {
	return q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) && q.y <= max(p.y, r.y)
		&& q.y >= min(p.y, r.y)
}

// triplet_orientation returns the orientation of ordered triplet (p, q, r).
// 0 --> p, q and r are colinear
// 1 --> Clockwise
// 2 --> Counterclockwise
fn triplet_orientation(p Point, q Point, r Point) int {
	val := (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
	if val == 0 {
		return 0
	}
	return if val > 0 { 1 } else { 2 }
}

// segments_intersect returns true if line segment 'p1q1'
// and 'p2q2' intersect.
fn segments_intersect(p1 Point, q1 Point, p2 Point, q2 Point) bool {
	// Find the four orientations needed for general and
	// special cases
	o1 := triplet_orientation(p1, q1, p2)
	o2 := triplet_orientation(p1, q1, q2)
	o3 := triplet_orientation(p2, q2, p1)
	o4 := triplet_orientation(p2, q2, q1)

	// General case
	if o1 != o2 && o3 != o4 {
		return true
	}

	// Special Cases
	// - p1, q1 and p2 are colinear and p2 lies on segment p1q1
	// - p1, q1 and p2 are colinear and q2 lies on segment p1q1
	// - p2, q2 and p1 are colinear and p1 lies on segment p2q2
	// - p2, q2 and q1 are colinear and q1 lies on segment p2q2
	return (o1 == 0 && p2.is_on_segment(p1, q1))
		|| (o2 == 0 && q2.is_on_segment(p1, q1))
		|| (o3 == 0 && p1.is_on_segment(p2, q2))
		|| (o4 == 0 && q1.is_on_segment(p2, q2))
}

// is_inside_polygon returns if the point p lies inside the polygon
fn is_inside_polygon(polygon []Point, p Point) bool {
	n := polygon.len

	if n < 3 {
		return false
	}

	// this point represents a line segment from `p` to infinite
	edge := Point{
		x: inf
		y: p.y
	}

	mut count := 0
	mut i := 0

	// count intersections of the above line with sides of polygon
	for {
		next_idx := (i + 1) % n

		if segments_intersect(polygon[i], polygon[next_idx], p, edge) {
			if triplet_orientation(polygon[i], p, polygon[next_idx]) == 0 {
				return p.is_on_segment(polygon[i], polygon[next_idx])
			}

			count++
		}

		i = next_idx

		if i == 0 {
			break
		}
	}

	return count % 2 == 1
}

fn main() {
	polygon1 := [Point{0, 0}, Point{10, 0}, Point{10, 10}, Point{0, 10}]
	mut target := Point{20, 20}
	println(if is_inside_polygon(polygon1, target) { 'Yes' } else { 'No' })

	target = Point{5, 5}
	println(if is_inside_polygon(polygon1, target) { 'Yes' } else { 'No' })

	polygon2 := [Point{0, 0}, Point{5, 5}, Point{5, 0}]

	target = Point{3, 3}
	println(if is_inside_polygon(polygon2, target) { 'Yes' } else { 'No' })

	target = Point{5, 1}
	println(if is_inside_polygon(polygon2, target) { 'Yes' } else { 'No' })

	target = Point{8, 1}
	println(if is_inside_polygon(polygon2, target) { 'Yes' } else { 'No' })

	polygon3 := [Point{0, 0}, Point{10, 0}, Point{10, 10}, Point{0, 10}]
	target = Point{-1, 10}
	println(if is_inside_polygon(polygon3, target) { 'Yes' } else { 'No' })
}
