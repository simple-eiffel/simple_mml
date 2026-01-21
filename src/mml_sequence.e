note
	description: "[
		Finite mathematical sequences.

		Immutable sequence type for use in Design by Contract specifications.
		All modification operations return new sequences rather than mutating state.
		Sequences are 1-indexed.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_SEQUENCE [G -> detachable ANY]

inherit
	MML_MODEL
		redefine
			default_create
		end

create
	default_create,
	singleton

create {MML_MODEL}
	make_from_list

feature {NONE} -- Initialization

	default_create
			-- Create an empty sequence.
		do
			create storage.make (0)
		ensure then
			empty: is_empty
		end

	singleton (x: G)
			-- Create a sequence with one element `x'.
		do
			create storage.make (1)
			storage.extend (x)
		ensure
			one_element: count = 1
			has_x: item (1) = x
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		local
			i: INTEGER
		do
			from i := 1 until i > storage.count or Result loop
				if model_equals (x, storage.i_th (i)) then
					Result := True
				end
				i := i + 1
			end
		end

	is_empty: BOOLEAN
			-- Is the sequence empty?
		do
			Result := storage.is_empty
		end

	is_constant (c: G): BOOLEAN
			-- Are all values equal to `c'?
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > storage.count or not Result loop
				if not model_equals (c, storage.i_th (i)) then
					Result := False
				end
				i := i + 1
			end
		end

	for_all (test: PREDICATE [INTEGER, G]): BOOLEAN
			-- Does `test' hold for all index-value pairs?
		require
			test_has_two_args: test.open_count = 2
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > storage.count or not Result loop
				if not test.item ([i, storage.i_th (i)]) then
					Result := False
				end
				i := i + 1
			end
		end

	exists (test: PREDICATE [INTEGER, G]): BOOLEAN
			-- Does `test' hold for any index-value pair?
		require
			test_has_two_args: test.open_count = 2
		local
			i: INTEGER
		do
			from i := 1 until i > storage.count or Result loop
				if test.item ([i, storage.i_th (i)]) then
					Result := True
				end
				i := i + 1
			end
		end

feature -- Elements

	item alias "[]" (i: INTEGER): G
			-- Value at position `i'.
		require
			in_domain: domain [i]
		do
			Result := storage.i_th (i)
		end

feature -- Conversion

	domain: MML_INTERVAL
			-- Set of indexes.
		do
			create Result.from_range (1, count)
		end

	range: MML_SET [G]
			-- Set of values.
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count)
			across storage as ic loop
				if not across new_storage as jc some model_equals (ic, jc) end then
					new_storage.extend (ic)
				end
			end
			create Result.make_from_list (new_storage)
		end

	to_bag: MML_BAG [G]
			-- Bag of sequence values.
		do
			create Result.make_from_list (storage.twin)
		end

feature -- Measurement

	count alias "#": INTEGER
			-- Number of elements.
		do
			Result := storage.count
		end

	occurrences (x: G): INTEGER
			-- How many times does `x' occur?
		do
			across storage as ic loop
				if model_equals (x, ic) then
					Result := Result + 1
				end
			end
		end

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this sequence contain the same elements in the same order as `other'?
		do
			if attached {MML_SEQUENCE [G]} other as sequence then
				Result := (count = sequence.count) and then (Current <= sequence)
			end
		end

	is_prefix_of alias "<=" (other: MML_SEQUENCE [G]): BOOLEAN
			-- Is this sequence a prefix of `other'?
		local
			i: INTEGER
		do
			Result := count <= other.count
			from
				i := 1
			until
				i > count or not Result
			loop
				Result := model_equals (item (i), other.item (i))
				i := i + 1
			end
		end

feature -- Decomposition

	first: G
			-- First element.
		require
			non_empty: not is_empty
		do
			Result := item (1)
		end

	last: G
			-- Last element.
		require
			non_empty: not is_empty
		do
			Result := item (count)
		end

	but_first: MML_SEQUENCE [G]
			-- Current sequence without the first element.
		require
			not_empty: not is_empty
		do
			Result := interval (2, count)
		end

	but_last: MML_SEQUENCE [G]
			-- Current sequence without the last element.
		require
			not_empty: not is_empty
		do
			Result := interval (1, count - 1)
		end

	front (upper: INTEGER): MML_SEQUENCE [G]
			-- Prefix up to `upper'.
		do
			Result := interval (1, upper)
		end

	tail (lower: INTEGER): MML_SEQUENCE [G]
			-- Suffix from `lower'.
		do
			Result := interval (lower, count)
		end

	interval (lower, upper: INTEGER): MML_SEQUENCE [G]
			-- Subsequence from `lower' to `upper'.
		local
			l, u, i: INTEGER
			new_storage: ARRAYED_LIST [G]
		do
			l := lower.max (1)
			u := upper.min (count).max (l - 1)
			create new_storage.make (u - l + 1)
			from
				i := l
			until
				i > u
			loop
				new_storage.extend (storage.i_th (i))
				i := i + 1
			end
			create Result.make_from_list (new_storage)
		end

	removed_at (i: INTEGER): MML_SEQUENCE [G]
			-- Current sequence with element at position `i' removed.
		require
			in_domain: domain [i]
		local
			j: INTEGER
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count - 1)
			from
				j := 1
			until
				j > storage.count
			loop
				if j /= i then
					new_storage.extend (storage.i_th (j))
				end
				j := j + 1
			end
			create Result.make_from_list (new_storage)
		end

feature -- Modification

	extended alias "&" (x: G): MML_SEQUENCE [G]
			-- Current sequence extended with `x' at the end.
		do
			Result := extended_at (count + 1, x)
		ensure
			count_incremented: Result.count = count + 1
			last_is_x: Result.last = x
		end

	extended_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' inserted at position `i'.
		require
			valid_position: 1 <= i and i <= count + 1
		local
			j: INTEGER
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count + 1)
			from j := 1 until j > storage.count loop
				if j = i then
					new_storage.extend (x)
				end
				new_storage.extend (storage.i_th (j))
				j := j + 1
			end
			if i = storage.count + 1 then
				new_storage.extend (x)
			end
			create Result.make_from_list (new_storage)
		ensure
			count_incremented: Result.count = count + 1
			element_inserted: Result.item (i) = x
		end

	prepended (x: G): MML_SEQUENCE [G]
			-- Current sequence prepended with `x' at the beginning.
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count + 1)
			new_storage.extend (x)
			across storage as ic loop
				new_storage.extend (ic)
			end
			create Result.make_from_list (new_storage)
		ensure
			count_incremented: Result.count = count + 1
			first_is_x: Result.first = x
		end

	concatenation alias "+" (other: MML_SEQUENCE [G]): MML_SEQUENCE [G]
			-- The concatenation of the current sequence and `other'.
		local
			new_storage: ARRAYED_LIST [G]
		do
			if is_empty then
				Result := other
			elseif other.is_empty then
				Result := Current
			else
				create new_storage.make (count + other.count)
				across storage as ic loop
					new_storage.extend (ic)
				end
				across other.storage as ic loop
					new_storage.extend (ic)
				end
				create Result.make_from_list (new_storage)
			end
		ensure
			count_sum: Result.count = count + other.count
		end

	replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' at position `i'.
		require
			in_domain: domain [i]
		local
			new_storage: ARRAYED_LIST [G]
		do
			new_storage := storage.twin
			new_storage.put_i_th (x, i)
			create Result.make_from_list (new_storage)
		ensure
			same_count: Result.count = count
			element_replaced: Result.item (i) = x
		end

feature {MML_MODEL} -- Implementation

	storage: ARRAYED_LIST [G]
			-- Element storage.

	make_from_list (a_list: ARRAYED_LIST [G])
			-- Create with a predefined list.
		do
			storage := a_list
		end

invariant
	storage_exists: storage /= Void

end
