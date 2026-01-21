note
	description: "[
		Finite mathematical sets.

		Immutable set type for use in Design by Contract specifications.
		All modification operations return new sets rather than mutating state.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_SET [G -> detachable ANY]

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
			-- Create an empty set.
		do
			create storage.make (0)
		ensure then
			empty: is_empty
		end

	singleton (x: G)
			-- Create a set that contains only `x'.
		do
			create storage.make (1)
			storage.extend (x)
		ensure
			one_element: count = 1
			has_x: has (x)
		end

feature -- Properties

	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := across storage as ic some model_equals (x, ic) end
		end

	is_empty: BOOLEAN
			-- Is the set empty?
		do
			Result := storage.is_empty
		ensure
			count_zero: Result = (count = 0)
		end

	for_all (test: PREDICATE [G]): BOOLEAN
			-- Does `test' hold for all elements?
		require
			test_has_one_arg: test.open_count = 1
		do
			Result := across storage as ic all test.item ([ic]) end
		end

	exists (test: PREDICATE [G]): BOOLEAN
			-- Does `test' hold for at least one element?
		require
			test_has_one_arg: test.open_count = 1
		do
			Result := across storage as ic some test.item ([ic]) end
		end

feature -- Elements

	any_item: G
			-- Arbitrary element.
		require
			not_empty: not is_empty
		do
			Result := storage.first
		ensure
			element: has (Result)
		end

feature -- Measurement

	count alias "#": INTEGER
			-- Cardinality.
		do
			Result := storage.count
		end

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this set contain same elements as `other'?
		do
			if attached {MML_SET [G]} other as set then
				Result := (count = set.count) and then (Current <= set)
			end
		end

	is_subset_of alias "<=" (other: MML_SET [G]): BOOLEAN
			-- Does `other' have all elements of `Current'?
		do
			Result := for_all (agent other.has)
		ensure
			other_has_all: Result = for_all (agent other.has)
		end

	is_superset_of alias ">=" (other: MML_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `other'?
		do
			Result := other <= Current
		ensure
			other_is_subset: Result = (other <= Current)
		end

	disjoint (other: MML_SET [G]): BOOLEAN
			-- Do no elements of `other' occur in `Current'?
		do
			Result := not other.exists (agent has)
		ensure
			no_common_elements: Result = not other.exists (agent has)
		end

feature -- Modification

	extended alias "&" (x: G): MML_SET [G]
			-- Current set extended with `x' if absent.
		local
			new_storage: ARRAYED_LIST [G]
		do
			if not has (x) then
				create new_storage.make (storage.count + 1)
				across storage as ic loop
					new_storage.extend (ic)
				end
				new_storage.extend (x)
				create Result.make_from_list (new_storage)
			else
				Result := Current
			end
		ensure
			has_x: Result.has (x)
			has_old: for_all (agent Result.has)
		end

	removed alias "/" (x: G): MML_SET [G]
			-- Current set with `x' removed if present.
		local
			new_storage: ARRAYED_LIST [G]
		do
			if has (x) then
				create new_storage.make (storage.count - 1)
				across storage as ic loop
					if not model_equals (x, ic) then
						new_storage.extend (ic)
					end
				end
				create Result.make_from_list (new_storage)
			else
				Result := Current
			end
		ensure
			not_has_x: not Result.has (x)
		end

	union alias "+" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count + other.storage.count)
			across storage as ic loop
				new_storage.extend (ic)
			end
			across other.storage as ic loop
				if not has (ic) then
					new_storage.extend (ic)
				end
			end
			create Result.make_from_list (new_storage)
		ensure
			contains_current: Current <= Result
			contains_other: other <= Result
		end

	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `other'.
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count.min (other.storage.count))
			across storage as ic loop
				if other.has (ic) then
					new_storage.extend (ic)
				end
			end
			create Result.make_from_list (new_storage)
		ensure
			contained_in_current: Result <= Current
			contained_in_other: Result <= other
		end

	difference alias "-" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count)
			across storage as ic loop
				if not other.has (ic) then
					new_storage.extend (ic)
				end
			end
			create Result.make_from_list (new_storage)
		ensure
			contained_in_current: Result <= Current
			disjoint_from_other: Result.disjoint (other)
		end

	sym_difference alias "^" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		do
			Result := (Current + other) - (Current * other)
		ensure
			definition: Result |=| ((Current + other) - (Current * other))
		end

	filtered alias "|" (test: PREDICATE [G]): MML_SET [G]
			-- Set of all elements that satisfy `test'.
		require
			test_has_one_arg: test.open_count = 1
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count)
			across storage as ic loop
				if test.item ([ic]) then
					new_storage.extend (ic)
				end
			end
			create Result.make_from_list (new_storage)
		ensure
			subset: Result <= Current
			satisfies_test: Result.for_all (test)
		end

	mapped (f: FUNCTION [G, G]): MML_SET [G]
			-- Set of elements of `Current' with `f' applied to each of them.
		require
			f_has_one_arg: f.open_count = 1
		local
			new_storage: ARRAYED_LIST [G]
		do
			create new_storage.make (storage.count)
			across storage as ic loop
				new_storage.extend (f.item ([ic]))
			end
			create Result.make_from_list (new_storage)
		end

feature {MML_MODEL} -- Implementation

	storage: ARRAYED_LIST [G]
			-- Element storage.

	make_from_list (a_list: ARRAYED_LIST [G])
			-- Create with a predefined list.
		require
			no_duplicates: no_duplicates (a_list)
		do
			storage := a_list
		end

feature -- Implementation

	no_duplicates (a_list: ARRAYED_LIST [G]): BOOLEAN
			-- Are there no duplicate elements in `a_list'?
		local
			i, j: INTEGER
		do
			Result := True
			from i := 1 until i > a_list.count or not Result loop
				from j := i + 1 until j > a_list.count or not Result loop
					if model_equals (a_list.i_th (i), a_list.i_th (j)) then
						Result := False
					end
					j := j + 1
				end
				i := i + 1
			end
		end

end
