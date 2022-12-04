#!/bin/sh

for d in day*; do
	cd "$d" || exit
	for i in 1 2; do
		filename="${d}_${i}.ha"
		echo "Running $filename"
		res_example=$(hare run "$filename" < example)
		expected_res_example=$(cat example_"$i")
		if [ "$res_example" = "$expected_res_example" ]; then
			echo "  - example ok"
		else
			echo "  - example fail"
		fi
		res_input=$(hare run "$filename" < input)
		expected_res_input=$(cat input_"$i")
		if [ "$res_input" = "$expected_res_input" ]; then
			echo "  - input ok"
		else
			echo "  - input fail"
		fi
	done
	cd ..
done
