module main

// Node handles a tree Node with values of type int
struct Node {
mut:
	val      int
	children []&Node
}

fn (n &Node) str() string {
	return '$n.val -> $n.children'
}

fn update_levels_dict(root Node, mut levels map[int][]int, level int) {
	if level !in levels {
		levels[level] = []int{}
	}

	levels[level] << root.val
	for child in root.children {
		update_levels_dict(child, mut levels, level + 1)
	}
}

fn is_symmetric(tree Node) bool {
	mut levels := map[int][]int{}
	update_levels_dict(tree, mut levels, 0)

	for level, arr in levels {
		if arr != arr.reverse() {
			return false
		}
	}

	return true
}

fn main() {
	e := &Node{
		val: 9
	}
	f := &Node{
		val: 9
	}
	d := &Node{
		val: 3
	}
	mut c := &Node{
		val: 3
		children: [e]
	}
	b := &Node{
		val: 5
		children: [f]
	}
	a := &Node{
		val: 4
		children: [c, b, d]
	}

	println(if is_symmetric(a) { '$a.str() is symmetric' } else { '$a.str() is not symmetric' })

	c.val = 4
	println(if is_symmetric(a) { '$a.str() is symmetric' } else { '$a.str() is not symmetric' })
}
