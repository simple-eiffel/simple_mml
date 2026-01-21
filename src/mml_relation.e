note
	description: "[
		Finite mathematical relations.

		Immutable relation type for use in Design by Contract specifications.
		Relations are sets of pairs; unlike maps, the same left element can appear multiple times.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_RELATION [G, H]

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
			-- Create an empty relation.
		do
			create lefts.make (0)
			create rights.make (0)
		end

	singleton (x: G; y: H)
			-- Create a relation with just one pair <`x', `y'>.
		do
			create lefts.make (1)
			lefts.extend (x)
			create rights.make (1)
			rights.extend (y)
		end

feature -- Properties

	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related to `y'?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > lefts.count or Result
			loop
				if model_equals (lefts.i_th (i), x) and model_equals (rights.i_th (i), y) then
					Result := True
				end
				i := i + 1
			end
		end

	is_empty: BOOLEAN
			-- Is relation empty?
		do
			Result := lefts.is_empty
		end

feature -- Sets

	domain: MML_SET [G]
			-- The set of left components.
		local
			new_storage: ARRAYED_LIST [G]
			i, j: INTEGER
			found: BOOLEAN
		do
			create new_storage.make (lefts.count)
			from i := 1 until i > lefts.count loop
				found := False
				from j := 1 until j > new_storage.count or found loop
					if model_equals (lefts.i_th (i), new_storage.i_th (j)) then
						found := True
					end
					j := j + 1
				end
				if not found then
					new_storage.extend (lefts.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_list (new_storage)
		end

	range: MML_SET [H]
			-- The set of right components.
		local
			new_storage: ARRAYED_LIST [H]
			i, j: INTEGER
			found: BOOLEAN
		do
			create new_storage.make (rights.count)
			from i := 1 until i > rights.count loop
				found := False
				from j := 1 until j > new_storage.count or found loop
					if model_equals (rights.i_th (i), new_storage.i_th (j)) then
						found := True
					end
					j := j + 1
				end
				if not found then
					new_storage.extend (rights.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_list (new_storage)
		end

	image_of (x: G): MML_SET [H]
			-- Set of values related to `x'.
		do
			Result := image (create {MML_SET [G]}.singleton (x))
		end

	image (subdomain: MML_SET [G]): MML_SET [H]
			-- Set of values related to any value in `subdomain'.
		do
			Result := restricted (subdomain).range
		end

feature -- Measurement

	count: INTEGER
			-- Cardinality.
		do
			Result := lefts.count
		end

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this relation contain the same pairs as `other'?
		local
			i: INTEGER
		do
			if attached {MML_RELATION [G, H]} other as rel and then count = rel.count then
				from
					Result := True
					i := 1
				until
					i > lefts.count or not Result
				loop
					Result := rel [lefts.i_th (i), rights.i_th (i)]
					i := i + 1
				end
			end
		end

feature -- Modification

	extended (x: G; y: H): MML_RELATION [G, H]
			-- Current relation extended with pair (`x', `y') if absent.
		local
			new_lefts: ARRAYED_LIST [G]
			new_rights: ARRAYED_LIST [H]
			i: INTEGER
		do
			if not Current [x, y] then
				create new_lefts.make (lefts.count + 1)
				from i := 1 until i > lefts.count loop
					new_lefts.extend (lefts.i_th (i))
					i := i + 1
				end
				new_lefts.extend (x)
				create new_rights.make (rights.count + 1)
				from i := 1 until i > rights.count loop
					new_rights.extend (rights.i_th (i))
					i := i + 1
				end
				new_rights.extend (y)
				create Result.make_from_lists (new_lefts, new_rights)
			else
				Result := Current
			end
		ensure
			has_pair: Result [x, y]
		end

	removed (x: G; y: H): MML_RELATION [G, H]
			-- Current relation with pair (`x', `y') removed if present.
		local
			new_lefts: ARRAYED_LIST [G]
			new_rights: ARRAYED_LIST [H]
			i: INTEGER
			found: BOOLEAN
		do
			create new_lefts.make (lefts.count)
			create new_rights.make (rights.count)
			from
				i := 1
			until
				i > lefts.count
			loop
				if not found and then model_equals (lefts.i_th (i), x) and then model_equals (rights.i_th (i), y) then
					found := True
					-- Skip this pair
				else
					new_lefts.extend (lefts.i_th (i))
					new_rights.extend (rights.i_th (i))
				end
				i := i + 1
			end
			if found then
				create Result.make_from_lists (new_lefts, new_rights)
			else
				Result := Current
			end
		ensure
			not_has_pair: not Result [x, y]
		end

	restricted alias "|" (subdomain: MML_SET [G]): MML_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
		local
			new_lefts: ARRAYED_LIST [G]
			new_rights: ARRAYED_LIST [H]
			i: INTEGER
		do
			create new_lefts.make (lefts.count)
			create new_rights.make (rights.count)
			from
				i := 1
			until
				i > lefts.count
			loop
				if subdomain [lefts.i_th (i)] then
					new_lefts.extend (lefts.i_th (i))
					new_rights.extend (rights.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_lists (new_lefts, new_rights)
		end

	inverse: MML_RELATION [H, G]
			-- Relation that consists of inverted pairs from `Current'.
		do
			create Result.make_from_lists (rights.twin, lefts.twin)
		end

	union alias "+" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other'.
		local
			new_lefts: ARRAYED_LIST [G]
			new_rights: ARRAYED_LIST [H]
			i: INTEGER
			temp_result: MML_RELATION [G, H]
		do
			-- Start with current minus other (to avoid duplicates)
			temp_result := Current - other
			-- Then add all of other
			create new_lefts.make (temp_result.lefts.count + other.lefts.count)
			create new_rights.make (temp_result.rights.count + other.rights.count)
			from i := 1 until i > temp_result.lefts.count loop
				new_lefts.extend (temp_result.lefts.i_th (i))
				i := i + 1
			end
			from i := 1 until i > temp_result.rights.count loop
				new_rights.extend (temp_result.rights.i_th (i))
				i := i + 1
			end
			from i := 1 until i > other.lefts.count loop
				new_lefts.extend (other.lefts.i_th (i))
				i := i + 1
			end
			from i := 1 until i > other.rights.count loop
				new_rights.extend (other.rights.i_th (i))
				i := i + 1
			end
			create Result.make_from_lists (new_lefts, new_rights)
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in both `Current' and `other'.
		local
			new_lefts: ARRAYED_LIST [G]
			new_rights: ARRAYED_LIST [H]
			i: INTEGER
		do
			create new_lefts.make (lefts.count)
			create new_rights.make (rights.count)
			from
				i := 1
			until
				i > lefts.count
			loop
				if other [lefts.i_th (i), rights.i_th (i)] then
					new_lefts.extend (lefts.i_th (i))
					new_rights.extend (rights.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_lists (new_lefts, new_rights)
		end

	difference alias "-" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in `Current' but not in `other'.
		local
			new_lefts: ARRAYED_LIST [G]
			new_rights: ARRAYED_LIST [H]
			i: INTEGER
		do
			create new_lefts.make (lefts.count)
			create new_rights.make (rights.count)
			from
				i := 1
			until
				i > lefts.count
			loop
				if not other [lefts.i_th (i), rights.i_th (i)] then
					new_lefts.extend (lefts.i_th (i))
					new_rights.extend (rights.i_th (i))
				end
				i := i + 1
			end
			create Result.make_from_lists (new_lefts, new_rights)
		end

	sym_difference alias "^" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other', but not in both.
		do
			Result := (Current + other) - (Current * other)
		end

feature {MML_MODEL} -- Implementation

	lefts: ARRAYED_LIST [G]
			-- Storage for the left components of pairs.

	rights: ARRAYED_LIST [H]
			-- Storage for the right components of pairs.

	make_from_lists (ls: ARRAYED_LIST [G]; rs: ARRAYED_LIST [H])
			-- Create with predefined lists.
		require
			same_count: ls.count = rs.count
		do
			lefts := ls
			rights := rs
		end

invariant
	same_count: lefts.count = rights.count

end
