use bufio;
use fmt;
use io;
use os;
use strings;
use strconv;

fn get_priority_from_rune(r: rune) int = {
	const rs: [_]rune = [r];
	const c = strings::fromrunes(rs);
	const ustr = strings::toutf8(c);
	const r = ustr[0]: int;
	if (r >= 'A' && r <= 'Z') {
		return r - 'A' + 27;
	};
	if (r >= 'a' && r <= 'z') {
		return r - 'a' + 1;
	};
	fmt::fatalf("rune {} not handled as priority", r);
};

fn split_line(line: str) (str, str) = {
	const c1 = strings::sub(line, 0, len(line)/2);
	const c2 = strings::sub(line, len(line)/2, strings::end);
	return (c1, c2);
};

fn get_shared_item(c1: str, c2: str) rune = {
	const c1u = strings::runes(c1);
	const c2u = strings::runes(c2);
	for (let i = 0z; i < len(c1u); i += 1) {
		for (let j = 0z; j < len(c2u); j += 1) {
			if (c1u[i] == c2u[j]) {
				return c1u[i];
			};
		};
	};
	fmt::fatalf("No similar object found in {} and {}", c1, c2);
};

export fn main() void = {
	let priorities: int = 0;

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		if (len(line) > 0) {
			const (c1, c2) = split_line(line);
			const shared = get_shared_item(c1, c2);
			const priority = get_priority_from_rune(shared);
			priorities += priority;
		};
	};

	fmt::printf("{}", priorities)!;
};

