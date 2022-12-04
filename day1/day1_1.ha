use bufio;
use fmt;
use io;
use os;
use strconv;
use strings;

export fn main() void = {
	let max: i64 = 0;
	let local_max: i64 = 0;

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		if (len(line) == 0) {
			if (local_max > max) {
				max = local_max;
			};
			local_max = 0;
		} else {
			const cal = match (strconv::stoi64(line)) {
			case let c: i64 => yield c;
			case strconv::invalid =>
				fmt::fatalf("Invalid convertion from {} to i64", line);
			case strconv::overflow =>
					fmt::fatalf("Overflow convertion from {} to i64", line);
			};
			local_max += cal;
		};
	};

	fmt::printf("{}", max)!;
};

