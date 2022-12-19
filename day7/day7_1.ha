use bufio;
use fmt;
use io;
use os;
use strconv;
use strings;

type dir = struct {
	name: str,
	dir_size: int,
	level: int,
	parent: nullable *dir,
};

export fn main() void = {
	let dirs: []dir = [];
	let current_dir: nullable *dir = null;
	let is_listing = false;
	let current_level = 0;

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield l;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		defer free(line);
		let line_str = strings::fromutf8(line)!;
		if (len(line_str) > 0) {
			let splits = strings::split(line_str, " ");
			defer free(splits);
			if (strings::compare(splits[0], "$") == 0) {
				if (strings::compare(splits[1], "cd") == 0) {
					is_listing = false;
					if (strings::compare(splits[2], "..") == 0) {
						current_level -= 1;
						fmt::fprintln(os::stderr, "cd ..")!;
						match (current_dir) {
							case let c: *dir => {
								let parent = c.parent: *dir;
								fmt::fprintfln(os::stderr, "  cur dir name: {} size: {}", c.name, c.dir_size)!;
								fmt::fprintfln(os::stderr, "  parent dir name: {} size: {}", parent.name, parent.dir_size)!;
								parent.dir_size += c.dir_size;
								c = parent;
							};
						};
					} else {
						current_level += 1;
						fmt::fprintfln(os::stderr, "cd {}", splits[2])!;
						const d = dir { name = strings::dup(splits[2]), dir_size = 0, level = current_level, parent = current_dir };
						append(dirs, d);
						current_dir = &dirs[len(dirs)-1];
					};
				} else if (strings::compare(splits[1], "ls") == 0) {
					is_listing = true;
					fmt::fprintln(os::stderr, "ls")!;
				};
			} else if (is_listing) {
				if (strings::compare(splits[0], "dir") == 0) {
					fmt::fprintfln(os::stderr, "dir {}", splits[1])!;
				} else {
					let filename = splits[1];
					let filesize = strconv::stoi(splits[0]) as int;
					fmt::fprintfln(os::stderr, "{} {}", filename, filesize)!;
					match (current_dir) {
						case let c: *dir => c.dir_size += filesize;
					};
				};
			};
		};
	};

	fmt::fprintln(os::stderr, "\nDirectories sizes:")!;
	for (let i = 0z; i < len(dirs); i += 1) {
		fmt::fprintfln(os::stderr, "- {}: {}", dirs[i].name, dirs[i].dir_size)!;
	};

	// fmt::printf("{}", max)!;
};
