use fmt;
use bufio;
use io;
use os;
use strings;
use strconv;

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
	case => yield;
	};
	fmt::fatalf("Unknown role: {}", r);
};

fn expected_result_from_rune(r: rune) result = {
	switch (r) {
	case 'X' => return result::LOST;
	case 'Y' => return result::DRAW;
	case 'Z' => return result::WON;
	// Default case, should not happen, added for the switch to be exhaustive
	case => return result::LOST;
	};
};

fn get_roles(line: str) (role, result) = {
	const runes = strings::torunes(line);
	const role_1 = runes[0];
	const expected_result = runes[2];
	return (role_from_rune(role_1), expected_result_from_rune(expected_result));
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

fn get_role_from_result(r1: role, r2: result) role = {
	switch (r2) {
	case result::WON => {
		switch (r1) {
		case role::ROCK => return role::PAPER;
		case role::PAPER => return role::SCISSORS;
		case role::SCISSORS => return role::ROCK;
		};
	};
	case result::DRAW => return r1;
	case result::LOST => {
		switch (r1) {
		case role::ROCK => return role::SCISSORS;
		case role::PAPER => return role::ROCK;
		case role::SCISSORS => return role::PAPER;
		};
	};
	};
};

fn compute_score(r1: role, expected_result: result) int = {
	const role_2 = get_role_from_result(r1, expected_result);
	const role_score = get_role_score(role_2);
	const result_score = get_result_score(expected_result);
	return role_score + result_score;
};

export fn main() void = {
	let score: i64 = 0;

	for (true) {
		const line = match (bufio::read_line(os::stdin)) {
		case let l: []u8 => yield strings::fromutf8(l)!;
		case io::EOF => break;
		case io::error =>
			fmt::fatalf("read_line error");
		};
		if (len(line) > 0) {
			const (r1, r2) = get_roles(line);
			const local_score = compute_score(r1, r2);
			score += local_score;
		};
	};

	fmt::printf("{}", score)!;
};

