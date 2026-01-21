note
	description: "Test application for simple_mml"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running simple_mml tests...%N%N")
			passed := 0
			failed := 0

			run_sequence_tests
			run_set_tests
			run_interval_tests
			run_bag_tests
			run_map_tests
			run_relation_tests

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_sequence_tests
		do
			create lib_tests
			run_test (agent lib_tests.test_sequence_empty, "test_sequence_empty")
			run_test (agent lib_tests.test_sequence_singleton, "test_sequence_singleton")
			run_test (agent lib_tests.test_sequence_extend, "test_sequence_extend")
			run_test (agent lib_tests.test_sequence_front_tail, "test_sequence_front_tail")
			run_test (agent lib_tests.test_sequence_concatenation, "test_sequence_concatenation")
			run_test (agent lib_tests.test_sequence_prepend, "test_sequence_prepend")
			run_test (agent lib_tests.test_sequence_equality, "test_sequence_equality")
		end

	run_set_tests
		do
			run_test (agent lib_tests.test_set_empty, "test_set_empty")
			run_test (agent lib_tests.test_set_singleton, "test_set_singleton")
			run_test (agent lib_tests.test_set_no_duplicates, "test_set_no_duplicates")
			run_test (agent lib_tests.test_set_union, "test_set_union")
			run_test (agent lib_tests.test_set_intersection, "test_set_intersection")
			run_test (agent lib_tests.test_set_difference, "test_set_difference")
		end

	run_interval_tests
		do
			run_test (agent lib_tests.test_interval_range, "test_interval_range")
			run_test (agent lib_tests.test_interval_membership, "test_interval_membership")
			run_test (agent lib_tests.test_interval_union, "test_interval_union")
		end

	run_bag_tests
		do
			run_test (agent lib_tests.test_bag_empty, "test_bag_empty")
			run_test (agent lib_tests.test_bag_occurrences, "test_bag_occurrences")
			run_test (agent lib_tests.test_bag_union, "test_bag_union")
		end

	run_map_tests
		do
			run_test (agent lib_tests.test_map_empty, "test_map_empty")
			run_test (agent lib_tests.test_map_update, "test_map_update")
			run_test (agent lib_tests.test_map_remove, "test_map_remove")
			run_test (agent lib_tests.test_map_override, "test_map_override")
		end

	run_relation_tests
		do
			run_test (agent lib_tests.test_relation_empty, "test_relation_empty")
			run_test (agent lib_tests.test_relation_multi_valued, "test_relation_multi_valued")
			run_test (agent lib_tests.test_relation_image, "test_relation_image")
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
