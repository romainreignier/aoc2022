use bufio;
use fmt;
use io;
use os;
use strconv;
use strings;

fn only_unique(b: []u8) bool = {
	for (let i = 0z; i < len(b); i += 1) {
		for (let j = 0z; j < len(b); j += 1) {
			if (i != j) {
				if (b[i] == b[j]) {
					return false;
				};
			};
		};
	};
	return true;
};

fn add(b: []u8, n: u8) void = {
	for (let i = 1z; i < len(b); i += 1) {
		b[i-1] = b[i];
	};
	b[len(b)-1] = n;
};

export fn main() void = {
	const line = match (bufio::read_line(os::stdin)) {
	case let l: []u8 => yield l;
	case io::EOF => return;
	case io::error =>
		fmt::fatalf("read_line error");
	};
	defer free(line);
	let buf: [14]u8 = [0...];

	for (let i = 0z; i < len(line); i += 1) {
		if (i < len(buf)) {
			buf[i] = line[i];
		} else {
			if (only_unique(buf)) {
				fmt::print(i + 1)!;
				return;
			} else {
				add(buf, line[i]);
				if (only_unique(buf)) {
					fmt::print(i + 1)!;
					return;
				};
			};
		};
	};
};

@test fn only_unique() void = {
	assert(only_unique([1u8, 2, 3, 4]));
	assert(!only_unique([1u8, 1, 3, 4]));
};

@test fn add() void = {
	let a = [1u8, 2, 3, 4];
	add(a, 5);
	for (let i = 0z; i < len(a); i+= 1) {
		assert(a[i] == i + 2);
	};
};

