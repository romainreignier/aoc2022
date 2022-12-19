use bufio;
use fmt;
use io;
use os;
use slices;
use strconv;
use strings;

fn print_stacks(s: [][]u8) void = {
	fmt::println("Print stacks:")!;
	for (let i = 0z; i < len(s); i += 1) {
		fmt::fprintfln(os::stderr, "- stack {}: {}", i+1,
			strings::fromutf8(s[i]) as str)!;
	};
};

export fn main() void = {
	let lines: []str = [];
	defer strings::freeall(lines);

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield l;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		defer free(line);
		if (len(line) > 0) {
			append(lines,
				strings::dup(strings::fromutf8(line) as str));
		} else {
			break;
		};
	};

	let stacks: [][]u8 = [];

	const splits = strings::split(lines[len(lines)-2], " ");
	defer free(splits);
	for (let i = 0z; i < len(splits); i+=1) {
		append(stacks, []);
	};
	for (let i = (len(lines) - 2): int; i >= 0; i -= 1) {
		for (let j = 0z; j < len(splits); j += 1) {
			const l = strings::toutf8(lines[i]);
			const c = l[1+j*4];
			if (c != ' ') {
				append(stacks[j], c);
			};
		};
	};

	print_stacks(stacks);

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield l;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		defer free(line);
		if (len(line) > 0) {
			const instructions_splits =
				strings::split(strings::fromutf8(line) as str, " ");
			defer free(instructions_splits);
			const nb = strconv::stoz(instructions_splits[1]) as size;
			const from = strconv::stoz(instructions_splits[3]) as size - 1;
			const to = strconv::stoz(instructions_splits[5]) as size - 1;

			fmt::fprintfln(os::stderr,
				"Move {} elem from {} to {}", nb, from + 1, to + 1)!;

			for (let i = 0z; i < nb; i += 1) {
				if (len(stacks[from]) > 0) {
					slices::appendto(&stacks[to]: *[]void, size(u8), &stacks[from][len(stacks[from])-1]);
					slices::deletefrom(&stacks[from]: *[]void, size(u8), len(stacks[from])-1, len(stacks[from]));
				};
			};
			//print_stacks(stacks);
		};
	};

	let t: []u8 = [];
	for (let i = 0z; i < len(stacks); i += 1) {
		append(t, stacks[i][len(stacks[i]) - 1]);
	};

	fmt::printfln("{}", strings::fromutf8(t) as str)!;
	free(t);

	for (let i = 0z; i < len(stacks); i += 1) {
		free(stacks[i]);
	};
	free(stacks);
};

