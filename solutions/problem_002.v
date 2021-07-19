module main

// Minimum and maximum of the given input array
fn minmax(data []f64) (f64, f64) {
	if data.len == 0 {
		return 0.0, 0.0
	}
	mut max := data[0]
	mut min := data[0]
	for v in data[1..] {
		if v > max {
			max = v
		}
		if v < min {
			min = v
		}
	}
	return min, max
}
