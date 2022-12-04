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

fn get_common_item(l1: str, l2: str, l3: str) rune = {
	const l1u = strings::runes(l1);
	const l2u = strings::runes(l2);
	const l3u = strings::runes(l3);
	for (let i = 0z; i < len(l1u); i += 1) {
		for (let j = 0z; j < len(l2u); j += 1) {
			if (l1u[i] == l2u[j]) {
				for (let k = 0z; k < len(l3u); k += 1) {
					if (l1u[i] == l3u[k]) {
						return l1u[i];
					};
				};
			};
		};
	};
	fmt::fatalf("No similar object found in {}, {} and {}", l1, l2, l3);
};

export fn main() void = {
	fmt::println("Day 3 2")!;

	let priorities: int = 0;

	for (true) {
		const l1 = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		const l2 = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		const l3 = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		const common = get_common_item(l1, l2, l3);
		const priority = get_priority_from_rune(common);
		priorities += priority;
	};

	fmt::printfln("Sum priorities = {}", priorities)!;
};

