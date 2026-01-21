note
	description: "[
		Finite mathematical maps (partial functions).

		Immutable map type for use in Design by Contract specifications.
		Maps associate keys with values; each key appears at most once.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_MAP [K, V]

inherit
	MML_MODEL
		redefine
			default_create
		end

create
	default_create,
	singleton

create {MML_MODEL}
	make_from_lists

feature {NONE} -- Initialization

	default_create
			-- Create an empty map.
		do
			create keys.make (0)
			create values.make (0)
		end

	singleton (k: K; x: V)
			-- Create a map with just one key-value pair <`k', `x'>.
		do
			create keys.make (1)
			keys.extend (k)
			create values.make (1)
			values.extend (x)
		end

feature -- Properties

	has (x: V): BOOLEAN
			-- Is value `x' contained?
		local
			i: INTEGER
		do
			from i := 1 until i > values.count or Result loop
				if model_equals (x, values.i_th (i)) then
					Result := True
				end
				i := i + 1
			end
		end

	is_empty: BOOLEAN
			-- Is map empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: V): BOOLEAN
			-- Are all values equal to `c'?
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > values.count or not Result loop
				if not model_equals (c, values.i_th (i)) then
					Result := False
				end
				i := i + 1
			end
		end

	for_all (test: PREDICATE [K, V]): BOOLEAN
			-- Does `test' hold for all key-value pairs?
		require
			test_has_two_args: test.open_count = 2
		local
			i: INTEGER
		do
			from
				i := 1
				Result := True
			until
				i > keys.count or not Result
			loop
				Result := test.item ([keys.i_th (i), values.i_th (i)])
				i := i + 1
			end
		end

	exists (test: PREDICATE [K, V]): BOOLEAN
			-- Does `test' hold for any key-value pair?
		require
			test_has_two_args: test.open_count = 2
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > keys.count or Result
			loop
				Result := test.item ([keys.i_th (i), values.i_th (i)])
				i := i + 1
			end
		end

feature -- Elements

	item alias "[]" (k: K): V
			-- Value associated with `k'.
		require
			in_domain: domain [k]
		local
			i: INTEGER
		do
			i := index_of_key (k)
			check key_found: i > 0 end
			Result := values.i_th (i)
		end

feature -- Conversion

	domain: MML_SET [K]
			-- Set of keys.
		do
			create Result.make_from_list (keys.twin)
		end

	range: MML_SET [V]
			-- Set of values.
		local
			new_storage: ARRAYED_LIST [V]
			i, j: INTEGER
			found: BOOLEAN
		do
			create new_storage.make (values.count)
			from i := 1 until i > values.count loop
				found := False
				from j := 1 until j > new_storage.count or found loop
					if model_equals (values.i_th (i), new_storage.i_th (j)) then
						found := True
					end
					j := j + 1
				end
				if not found then
					new_storage.extend (values.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_list (new_storage)
		end

	image (subdomain: MML_SET [K]): MML_SET [V]
			-- Set of values corresponding to keys in `subdomain'.
		do
			Result := restricted (subdomain).range
		end

	sequence_image (s: MML_SEQUENCE [K]): MML_SEQUENCE [V]
			-- Sequence of images of `s' elements under `Current'.
			-- (Skip elements of `s' that are not in domain of `Current').
		local
			new_storage: ARRAYED_LIST [V]
			i: INTEGER
		do
			create new_storage.make (s.count)
			from
				i := 1
			until
				i > s.count
			loop
				if domain [s [i]] then
					new_storage.extend (item (s [i]))
				end
				i := i + 1
			end
			create Result.make_from_list (new_storage)
		end

	to_bag: MML_BAG [V]
			-- Bag of map values.
		do
			create Result.make_from_list (values.twin)
		end

feature -- Measurement

	count: INTEGER
			-- Map cardinality.
		do
			Result := keys.count
		end

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this map contain the same key-value pairs as `other'?
		local
			i: INTEGER
		do
			if attached {MML_MAP [K, V]} other as map and then domain |=| map.domain then
				from
					Result := True
					i := 1
				until
					i > keys.count or not Result
				loop
					Result := model_equals (values.i_th (i), map [keys.i_th (i)])
					i := i + 1
				end
			end
		end

feature -- Modification

	updated (k: K; x: V): MML_MAP [K, V]
			-- Current map with `x' associated with `k'.
			-- If `k' already exists, the value is replaced, otherwise added.
		local
			i, j: INTEGER
			new_keys: ARRAYED_LIST [K]
			new_values: ARRAYED_LIST [V]
		do
			i := index_of_key (k)
			if i > 0 then
				new_values := values.twin
				new_values.put_i_th (x, i)
				create Result.make_from_lists (keys, new_values)
			else
				create new_keys.make (keys.count + 1)
				from j := 1 until j > keys.count loop
					new_keys.extend (keys.i_th (j))
					j := j + 1
				end
				new_keys.extend (k)
				create new_values.make (values.count + 1)
				from j := 1 until j > values.count loop
					new_values.extend (values.i_th (j))
					j := j + 1
				end
				new_values.extend (x)
				create Result.make_from_lists (new_keys, new_values)
			end
		ensure
			has_key: Result.domain [k]
			has_value: Result [k] = x
		end

	removed (k: K): MML_MAP [K, V]
			-- Current map without the key `k' and the corresponding value.
			-- If `k' doesn't exist, current map.
		local
			new_keys: ARRAYED_LIST [K]
			new_values: ARRAYED_LIST [V]
			i, j: INTEGER
		do
			i := index_of_key (k)
			if i > 0 then
				create new_keys.make (keys.count - 1)
				create new_values.make (values.count - 1)
				from j := 1 until j > keys.count loop
					if j /= i then
						new_keys.extend (keys.i_th (j))
						new_values.extend (values.i_th (j))
					end
					j := j + 1
				end
				create Result.make_from_lists (new_keys, new_values)
			else
				Result := Current
			end
		ensure
			not_has_key: not Result.domain [k]
		end

	restricted alias "|" (subdomain: MML_SET [K]): MML_MAP [K, V]
			-- Map that consists of all key-value pairs in `Current' whose key is in `subdomain'.
		local
			new_keys: ARRAYED_LIST [K]
			new_values: ARRAYED_LIST [V]
			i: INTEGER
		do
			create new_keys.make (keys.count)
			create new_values.make (values.count)
			from
				i := 1
			until
				i > keys.count
			loop
				if subdomain [keys.i_th (i)] then
					new_keys.extend (keys.i_th (i))
					new_values.extend (values.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_lists (new_keys, new_values)
		end

	override alias "+" (other: MML_MAP [K, V]): MML_MAP [K, V]
			-- Map that is equal to `other' on its domain and to `Current' on its domain minus the domain of `other'.
		local
			new_keys: ARRAYED_LIST [K]
			new_values: ARRAYED_LIST [V]
			i: INTEGER
		do
			create new_keys.make (keys.count + other.keys.count)
			create new_values.make (values.count + other.values.count)
			-- Add all from other first (these take precedence)
			from i := 1 until i > other.keys.count loop
				new_keys.extend (other.keys.i_th (i))
				i := i + 1
			end
			from i := 1 until i > other.values.count loop
				new_values.extend (other.values.i_th (i))
				i := i + 1
			end
			-- Add from current only if not in other
			from
				i := 1
			until
				i > keys.count
			loop
				if not other.domain [keys.i_th (i)] then
					new_keys.extend (keys.i_th (i))
					new_values.extend (values.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_lists (new_keys, new_values)
		end

	inverse: MML_RELATION [V, K]
			-- Relation consisting of inverted pairs from `Current'.
		do
			create Result.make_from_lists (values.twin, keys.twin)
		end

feature {MML_MODEL} -- Implementation

	keys: ARRAYED_LIST [K]
			-- Storage for keys.

	values: ARRAYED_LIST [V]
			-- Storage for values.

	make_from_lists (ks: ARRAYED_LIST [K]; vs: ARRAYED_LIST [V])
			-- Create with predefined lists.
		require
			same_count: ks.count = vs.count
		do
			keys := ks
			values := vs
		end

feature {NONE} -- Implementation helpers

	index_of_key (k: K): INTEGER
			-- Index of `k' in keys, or 0 if not found.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > keys.count or Result > 0
			loop
				if model_equals (k, keys.i_th (i)) then
					Result := i
				end
				i := i + 1
			end
		end

invariant
	same_count: keys.count = values.count

end
