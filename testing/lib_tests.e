note
	description: "Tests for simple_mml library"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Sequence Tests

	test_sequence_empty
			-- Test empty sequence
		local
			seq: MML_SEQUENCE [INTEGER]
		do
			create seq
			assert ("empty_count", seq.count = 0)
			assert ("empty_is_empty", seq.is_empty)
		end

	test_sequence_singleton
			-- Test singleton sequence
		local
			seq: MML_SEQUENCE [INTEGER]
		do
			create seq.singleton (42)
			assert ("singleton_count", seq.count = 1)
			assert ("singleton_item", seq [1] = 42)
			assert ("singleton_first", seq.first = 42)
			assert ("singleton_last", seq.last = 42)
		end

	test_sequence_extend
			-- Test sequence extension
		local
			seq: MML_SEQUENCE [INTEGER]
		do
			create seq
			seq := seq & 1 & 2 & 3
			assert ("extend_count", seq.count = 3)
			assert ("extend_first", seq [1] = 1)
			assert ("extend_last", seq [3] = 3)
		end

	test_sequence_front_tail
			-- Test front and tail operations
		local
			seq, front_seq, tail_seq: MML_SEQUENCE [INTEGER]
		do
			create seq
			seq := seq & 1 & 2 & 3 & 4 & 5
			front_seq := seq.front (3)
			assert ("front_count", front_seq.count = 3)
			assert ("front_last", front_seq.last = 3)
			tail_seq := seq.tail (3)
			assert ("tail_count", tail_seq.count = 3)
			assert ("tail_first", tail_seq.first = 3)
		end

	test_sequence_concatenation
			-- Test sequence concatenation
		local
			s1, s2, s3: MML_SEQUENCE [INTEGER]
		do
			create s1.singleton (1)
			s1 := s1 & 2
			create s2.singleton (3)
			s2 := s2 & 4
			s3 := s1 + s2
			assert ("concat_count", s3.count = 4)
			assert ("concat_first", s3 [1] = 1)
			assert ("concat_last", s3 [4] = 4)
		end

	test_sequence_prepend
			-- Test prepend operation
		local
			seq: MML_SEQUENCE [INTEGER]
		do
			create seq.singleton (2)
			seq := seq.prepended (1)
			assert ("prepend_count", seq.count = 2)
			assert ("prepend_first", seq.first = 1)
		end

	test_sequence_equality
			-- Test sequence model equality
		local
			s1, s2, s3: MML_SEQUENCE [INTEGER]
		do
			create s1
			s1 := s1 & 1 & 2 & 3
			create s2
			s2 := s2 & 1 & 2 & 3
			create s3
			s3 := s3 & 1 & 2 & 4
			assert ("equal_sequences", s1 |=| s2)
			assert ("unequal_sequences", s1 |/=| s3)
		end

feature -- Set Tests

	test_set_empty
			-- Test empty set
		local
			s: MML_SET [INTEGER]
		do
			create s
			assert ("empty_set", s.is_empty)
			assert ("empty_count", s.count = 0)
		end

	test_set_singleton
			-- Test singleton set
		local
			s: MML_SET [INTEGER]
		do
			create s.singleton (42)
			assert ("has_element", s [42])
			assert ("set_count", s.count = 1)
		end

	test_set_no_duplicates
			-- Test that sets don't allow duplicates
		local
			s: MML_SET [INTEGER]
		do
			create s.singleton (1)
			s := s & 1  -- Add duplicate
			assert ("no_duplicate", s.count = 1)
			s := s & 2
			assert ("added_new", s.count = 2)
		end

	test_set_union
			-- Test set union
		local
			s1, s2, result_set: MML_SET [INTEGER]
		do
			create s1
			s1 := s1 & 1 & 2 & 3
			create s2
			s2 := s2 & 2 & 3 & 4
			result_set := s1 + s2
			assert ("union_count", result_set.count = 4)
			assert ("union_has_1", result_set [1])
			assert ("union_has_4", result_set [4])
		end

	test_set_intersection
			-- Test set intersection
		local
			s1, s2, result_set: MML_SET [INTEGER]
		do
			create s1
			s1 := s1 & 1 & 2 & 3
			create s2
			s2 := s2 & 2 & 3 & 4
			result_set := s1 * s2
			assert ("intersection_count", result_set.count = 2)
			assert ("intersection_has_2", result_set [2])
			assert ("intersection_has_3", result_set [3])
			assert ("intersection_not_1", not result_set [1])
		end

	test_set_difference
			-- Test set difference
		local
			s1, s2, result_set: MML_SET [INTEGER]
		do
			create s1
			s1 := s1 & 1 & 2 & 3
			create s2
			s2 := s2 & 2 & 3 & 4
			result_set := s1 - s2
			assert ("difference_count", result_set.count = 1)
			assert ("difference_has_1", result_set [1])
			assert ("difference_not_2", not result_set [2])
		end

feature -- Interval Tests

	test_interval_range
			-- Test interval creation
		local
			i: MML_INTERVAL
		do
			create i.from_range (1, 5)
			assert ("interval_count", i.count = 5)
			assert ("interval_lower", i.lower = 1)
			assert ("interval_upper", i.upper = 5)
		end

	test_interval_membership
			-- Test interval membership
		local
			i: MML_INTERVAL
		do
			create i.from_range (1, 5)
			assert ("has_1", i [1])
			assert ("has_3", i [3])
			assert ("has_5", i [5])
			assert ("not_has_0", not i [0])
			assert ("not_has_6", not i [6])
		end

	test_interval_union
			-- Test interval union
		local
			i1, i2, result_interval: MML_INTERVAL
		do
			create i1.from_range (1, 5)
			create i2.from_range (3, 7)
			result_interval := i1 |+| i2
			assert ("union_lower", result_interval.lower = 1)
			assert ("union_upper", result_interval.upper = 7)
		end

feature -- Bag Tests

	test_bag_empty
			-- Test empty bag
		local
			b: MML_BAG [STRING]
		do
			create b
			assert ("empty_bag", b.is_empty)
			assert ("empty_count", b.count = 0)
		end

	test_bag_occurrences
			-- Test bag occurrences
		local
			b: MML_BAG [STRING]
		do
			create b.singleton ("apple")
			assert ("one_apple", b ["apple"] = 1)
			b := b & "apple"
			assert ("two_apples", b ["apple"] = 2)
			assert ("total_count", b.count = 2)
			b := b & "banana"
			assert ("one_banana", b ["banana"] = 1)
			assert ("total_count_3", b.count = 3)
		end

	test_bag_union
			-- Test bag union
		local
			b1, b2, result_bag: MML_BAG [STRING]
		do
			create b1.singleton ("a")
			b1 := b1 & "a" & "b"
			create b2.singleton ("b")
			b2 := b2 & "b" & "c"
			result_bag := b1 + b2
			assert ("union_a", result_bag ["a"] = 2)
			assert ("union_b", result_bag ["b"] = 3)
			assert ("union_c", result_bag ["c"] = 1)
		end

feature -- Map Tests

	test_map_empty
			-- Test empty map
		local
			m: MML_MAP [STRING, INTEGER]
		do
			create m
			assert ("empty_map", m.is_empty)
			assert ("empty_count", m.count = 0)
		end

	test_map_update
			-- Test map update
		local
			m: MML_MAP [STRING, INTEGER]
		do
			create m
			m := m.updated ("one", 1)
			assert ("has_one", m.domain ["one"])
			assert ("value_one", m ["one"] = 1)
			m := m.updated ("two", 2)
			assert ("count_2", m.count = 2)
			-- Update existing key
			m := m.updated ("one", 100)
			assert ("updated_value", m ["one"] = 100)
			assert ("still_count_2", m.count = 2)
		end

	test_map_remove
			-- Test map removal
		local
			m: MML_MAP [STRING, INTEGER]
		do
			create m
			m := m.updated ("one", 1).updated ("two", 2).updated ("three", 3)
			assert ("count_3", m.count = 3)
			m := m.removed ("two")
			assert ("count_2", m.count = 2)
			assert ("not_has_two", not m.domain ["two"])
			assert ("has_one", m.domain ["one"])
			assert ("has_three", m.domain ["three"])
		end

	test_map_override
			-- Test map override
		local
			m1, m2, result_map: MML_MAP [STRING, INTEGER]
		do
			create m1
			m1 := m1.updated ("a", 1).updated ("b", 2)
			create m2
			m2 := m2.updated ("b", 20).updated ("c", 30)
			result_map := m1 + m2
			assert ("override_a", result_map ["a"] = 1)
			assert ("override_b", result_map ["b"] = 20)  -- from m2
			assert ("override_c", result_map ["c"] = 30)
		end

feature -- Relation Tests

	test_relation_empty
			-- Test empty relation
		local
			r: MML_RELATION [STRING, INTEGER]
		do
			create r
			assert ("empty_relation", r.is_empty)
			assert ("empty_count", r.count = 0)
		end

	test_relation_multi_valued
			-- Test that relations can have multiple values for same key
		local
			r: MML_RELATION [STRING, INTEGER]
		do
			create r
			r := r.extended ("a", 1)
			r := r.extended ("a", 2)  -- Same key, different value
			assert ("has_a_1", r ["a", 1])
			assert ("has_a_2", r ["a", 2])
			assert ("count_2", r.count = 2)
		end

	test_relation_image
			-- Test relation image
		local
			r: MML_RELATION [STRING, INTEGER]
			img: MML_SET [INTEGER]
		do
			create r
			r := r.extended ("a", 1).extended ("a", 2).extended ("b", 3)
			img := r.image_of ("a")
			assert ("image_count", img.count = 2)
			assert ("image_has_1", img [1])
			assert ("image_has_2", img [2])
			assert ("image_not_3", not img [3])
		end

end
