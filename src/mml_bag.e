note
	description: "[
		Finite mathematical bags (multisets).

		Immutable bag type for use in Design by Contract specifications.
		Bags can contain multiple occurrences of the same element.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_BAG [G -> detachable separate ANY]

inherit
	MML_MODEL
		redefine
			default_create
		end

create
	default_create,
	singleton,
	multiple

create {MML_MODEL}
	make_from_lists,
	make_from_list

feature {NONE} -- Initialization

	default_create
			-- Create an empty bag.
		do
			create keys.make (0)
			create values.make (0)
			count := 0
		end

	singleton (x: G)
			-- Create a bag that contains a single occurrence of `x'.
		do
			multiple (x, 1)
		end

	multiple (x: G; n: INTEGER)
			-- Create a bag that contains `n' occurrences of `x'.
		require
			n_positive: n >= 0
		do
			if n = 0 then
				default_create
			else
				create keys.make (1)
				keys.extend (x)
				create values.make (1)
				values.extend (n)
				count := n
			end
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := occurrences (x) > 0
		end

	is_empty: BOOLEAN
			-- Is bag empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: INTEGER): BOOLEAN
			-- Are all occurrence counts equal to `c'?
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > values.count or not Result loop
				if values.i_th (i) /= c then
					Result := False
				end
				i := i + 1
			end
		end

feature -- Sets

	domain: MML_SET [G]
			-- Set of values that occur at least once.
		do
			create Result.make_from_list (keys.twin)
		end

feature -- Measurement

	occurrences alias "[]" (x: G): INTEGER
			-- How many times `x' appears.
		local
			i: INTEGER
		do
			i := index_of (x)
			if i > 0 then
				Result := values.i_th (i)
			end
		end

	count alias "#": INTEGER
			-- Total number of elements.

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this bag contain the same elements the same number of times as `other'?
		local
			i: INTEGER
		do
			if attached {MML_BAG [G]} other as bag and then count = bag.count then
				from
					Result := True
					i := 1
				until
					i > keys.count or not Result
				loop
					Result := bag [keys.i_th (i)] = values.i_th (i)
					i := i + 1
				end
			end
		end

feature -- Modification

	extended alias "&" (x: G): MML_BAG [G]
			-- Current bag extended with one occurrence of `x'.
		do
			Result := extended_multiple (x, 1)
		ensure
			one_more: Result [x] = occurrences (x) + 1
		end

	extended_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag extended with `n' occurrences of `x'.
		require
			n_non_negative: n >= 0
		local
			new_keys: ARRAYED_LIST [G]
			new_values: ARRAYED_LIST [INTEGER]
			i, j: INTEGER
		do
			if n > 0 then
				i := index_of (x)
				if i > 0 then
					new_keys := keys
					new_values := values.twin
					new_values.put_i_th (new_values.i_th (i) + n, i)
				else
					create new_keys.make (keys.count + 1)
					from j := 1 until j > keys.count loop
						new_keys.extend (keys.i_th (j))
						j := j + 1
					end
					new_keys.extend (x)
					create new_values.make (values.count + 1)
					from j := 1 until j > values.count loop
						new_values.extend (values.i_th (j))
						j := j + 1
					end
					new_values.extend (n)
				end
				create Result.make_from_lists (new_keys, new_values, count + n)
			else
				Result := Current
			end
		end

	removed alias "/" (x: G): MML_BAG [G]
			-- Current bag with one occurrence of `x' removed if present.
		do
			Result := removed_multiple (x, 1)
		end

	removed_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag with at most `n' occurrences of `x' removed if present.
		require
			n_non_negative: n >= 0
		local
			new_keys: ARRAYED_LIST [G]
			new_values: ARRAYED_LIST [INTEGER]
			i, j: INTEGER
		do
			i := index_of (x)
			if n = 0 or i = 0 then
				Result := Current
			elseif values.i_th (i) <= n then
				-- Remove the key entirely
				create new_keys.make (keys.count - 1)
				create new_values.make (values.count - 1)
				from j := 1 until j > keys.count loop
					if j /= i then
						new_keys.extend (keys.i_th (j))
						new_values.extend (values.i_th (j))
					end
					j := j + 1
				end
				create Result.make_from_lists (new_keys, new_values, count - values.i_th (i))
			else
				new_values := values.twin
				new_values.put_i_th (new_values.i_th (i) - n, i)
				create Result.make_from_lists (keys, new_values, count - n)
			end
		end

	removed_all (x: G): MML_BAG [G]
			-- Current bag with all occurrences of `x' removed.
		do
			Result := removed_multiple (x, occurrences (x))
		end

	restricted alias "|" (subdomain: MML_SET [G]): MML_BAG [G]
			-- Bag that consists of all elements of `Current' that are in `subdomain'.
		local
			new_keys: ARRAYED_LIST [G]
			new_values: ARRAYED_LIST [INTEGER]
			i, n: INTEGER
		do
			create new_keys.make (keys.count)
			create new_values.make (values.count)
			from
				i := 1
				n := 0
			until
				i > keys.count
			loop
				if subdomain [keys.i_th (i)] then
					new_keys.extend (keys.i_th (i))
					new_values.extend (values.i_th (i))
					n := n + values.i_th (i)
				end
				i := i + 1
			end
			create Result.make_from_lists (new_keys, new_values, n)
		end

	union alias "+" (other: MML_BAG [G]): MML_BAG [G]
			-- Bag that contains all elements from `other' and `Current'.
		local
			new_keys: ARRAYED_LIST [G]
			new_values: ARRAYED_LIST [INTEGER]
			i, k: INTEGER
		do
			create new_keys.make (keys.count + other.keys.count)
			create new_values.make (values.count + other.values.count)
			-- Copy current
			from i := 1 until i > keys.count loop
				new_keys.extend (keys.i_th (i))
				i := i + 1
			end
			from i := 1 until i > values.count loop
				new_values.extend (values.i_th (i))
				i := i + 1
			end
			-- Merge other
			from
				i := 1
			until
				i > other.keys.count
			loop
				k := index_of_in_list (other.keys.i_th (i), new_keys)
				if k > 0 then
					new_values.put_i_th (new_values.i_th (k) + other.values.i_th (i), k)
				else
					new_keys.extend (other.keys.i_th (i))
					new_values.extend (other.values.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_lists (new_keys, new_values, count + other.count)
		end

	difference alias "-" (other: MML_BAG [G]): MML_BAG [G]
			-- Current bag with all occurrences of values from `other' removed.
		local
			new_keys: ARRAYED_LIST [G]
			new_values: ARRAYED_LIST [INTEGER]
			i, k, c: INTEGER
		do
			create new_keys.make (keys.count)
			create new_values.make (values.count)
			from
				i := 1
			until
				i > keys.count
			loop
				k := other [keys.i_th (i)]
				if k < values.i_th (i) then
					new_keys.extend (keys.i_th (i))
					new_values.extend (values.i_th (i) - k)
					c := c + values.i_th (i) - k
				end
				i := i + 1
			end
			create Result.make_from_lists (new_keys, new_values, c)
		end

feature {MML_MODEL} -- Implementation

	keys: ARRAYED_LIST [G]
			-- Element storage.

	values: ARRAYED_LIST [INTEGER]
			-- Occurrences storage.

	make_from_lists (ks: ARRAYED_LIST [G]; vs: ARRAYED_LIST [INTEGER]; n: INTEGER)
			-- Create with predefined lists and count.
		require
			same_count: ks.count = vs.count
		do
			keys := ks
			values := vs
			count := n
		end

	make_from_list (a_list: ARRAYED_LIST [G])
			-- Create bag from list (counting occurrences).
		local
			i: INTEGER
		do
			create keys.make (a_list.count)
			create values.make (a_list.count)
			count := 0
			from
				i := 1
			until
				i > a_list.count
			loop
				add_occurrence (a_list.i_th (i))
				i := i + 1
			end
		end

feature {NONE} -- Implementation helpers

	index_of (x: G): INTEGER
			-- Index of `x' in keys, or 0 if not found.
		do
			Result := index_of_in_list (x, keys)
		end

	index_of_in_list (x: G; a_list: ARRAYED_LIST [G]): INTEGER
			-- Index of `x' in `a_list', or 0 if not found.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_list.count or Result > 0
			loop
				if model_equals (x, a_list.i_th (i)) then
					Result := i
				end
				i := i + 1
			end
		end

	add_occurrence (x: G)
			-- Add one occurrence of `x' to current bag (used during construction).
		local
			i: INTEGER
		do
			i := index_of (x)
			if i > 0 then
				values.put_i_th (values.i_th (i) + 1, i)
			else
				keys.extend (x)
				values.extend (1)
			end
			count := count + 1
		end

invariant
	same_count: keys.count = values.count

end
