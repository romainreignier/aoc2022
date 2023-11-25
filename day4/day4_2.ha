use bufio;
use fmt;
use io;
use os;
use strconv;
use strings;

type bounds = struct {
	b1: int,
	b2: int,
	b3: int,
	b4: int,
};

fn get_bounds(line: str) bounds = {
	const intervals = strings::split(line, ",");
	defer free(intervals);
	const i1 = intervals[0];
	const i2 = intervals[1];
	const b1 = strings::split(i1, "-");
	const b2 = strings::split(i2, "-");
	return bounds {
		b1 = strconv::stoi(b1[0]) as int,
		b2 = strconv::stoi(b1[1]) as int,
		b3 = strconv::stoi(b2[0]) as int,
		b4 = strconv::stoi(b2[1]) as int,
	};
};

export fn main() void = {
	let overlaps: int = 0;

	for (true) {
		const line = match (bufio::read_line(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("read_line error");
		};
		if (len(line) > 0) {
			const b = get_bounds(line);
			if (
				(b.b3 >= b.b1 && b.b3 <= b.b2)
				||
				(b.b1 >= b.b3 && b.b1 <= b.b4)
			) {
				overlaps += 1;
			};
		};
	};

	fmt::printf("{}", overlaps)!;
};

