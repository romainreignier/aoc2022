use bufio;
use fmt;
use io;
use os;
use sort;
use strconv;
use strings;

fn icmp(a: const *void, b: const *void) int = {
	const a = *(a: const *int), b = *(b: const *int);
	return if (a < b) -1
		else if (a > b) 1
		else 0;
};

export fn main() void = {
	let calories: []i64 = [];
	defer free(calories);

	let local_max: i64 = 0;

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		if (len(line) == 0) {
			append(calories, local_max);
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

	sort::sort(calories, size(i64), &icmp);
	let total: i64 = 0;
	total += calories[len(calories) - 1];
	total += calories[len(calories) - 2];
	total += calories[len(calories) - 3];

	fmt::printf("{}", total)!;
};

