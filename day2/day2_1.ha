use bufio;
use fmt;
use io;
use os;
use strconv;
use strings;

type role = enum {
	ROCK,
	PAPER,
	SCISSORS,
};

type result = enum {
	WON,
	DRAW,
	LOST,
};

fn role_from_rune(r: rune) role = {
	switch (r) {
	case 'A' => return role::ROCK;
	case 'B' => return role::PAPER;
	case 'C' => return role::SCISSORS;
	case 'X' => return role::ROCK;
	case 'Y' => return role::PAPER;
	case 'Z' => return role::SCISSORS;
	case => yield;
	};
	fmt::fatalf("Unknown role: {}", r);
};


fn get_roles(line: str) (role, role) = {
	const runes = strings::runes(line);
	const p1 = runes[0];
	const p2 = runes[2];
	return (role_from_rune(p1), role_from_rune(p2));
};

fn get_role_score(r: role) int = {
	switch (r) {
	case role::ROCK => return 1;
	case role::PAPER => return 2;
	case role::SCISSORS => return 3;
	};
};

fn get_result_score(r: result) int = {
	switch (r) {
	case result::WON => return 6;
	case result::DRAW => return 3;
	case result::LOST => return 0;
	};
};

fn get_result(r1: role, r2: role) result = {
	switch (r2) {
	case role::ROCK => {
		switch (r1) {
		case role::ROCK => return result::DRAW;
		case role::PAPER => return result::LOST;
		case role::SCISSORS => return result::WON;
		};
	};
	case role::PAPER => {
		switch (r1) {
		case role::ROCK => return result::WON;
		case role::PAPER => return result::DRAW;
		case role::SCISSORS => return result::LOST;
		};
	};
	case role::SCISSORS => {
		switch (r1) {
		case role::ROCK => return result::LOST;
		case role::PAPER => return result::WON;
		case role::SCISSORS => return result::DRAW;
		};
	};
	};
};

fn compute_score(r1: role, r2: role) int = {
	const role_score = get_role_score(r2);
	const result = get_result(r1, r2);
	const result_score = get_result_score(result);
	return role_score + result_score;
};

export fn main() void = {
	let score: i64 = 0;

	for (true) {
		const line = match (bufio::scanline(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("scanline error");
		};
		if (len(line) > 0) {
			const (r1, r2) = get_roles(line);
			const local_score = compute_score(r1, r2);
			score += local_score;
		};
	};

	fmt::printf("{}", score)!;
};

