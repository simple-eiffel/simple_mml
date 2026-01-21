note
	description: "[
		Closed integer intervals.

		Specialized set type for contiguous integer ranges.
		More efficient than general sets for integer domain operations.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_INTERVAL

inherit
	MML_SET [INTEGER]
		redefine
			has,
			is_model_equal,
			is_subset_of,
			disjoint
		end

create
	default_create,
	singleton,
	from_range,
	from_tuple

create {MML_MODEL}
	make_from_list

convert
	singleton ({INTEGER}),
	from_tuple ({TUPLE [min: INTEGER; max: INTEGER]})

feature {NONE} -- Initialization

	from_range (l, u: INTEGER)
			-- Create interval [l, u].
		local
			i: INTEGER
			new_storage: ARRAYED_LIST [INTEGER]
		do
			if l <= u then
				create new_storage.make (u - l + 1)
				from
					i := l
				until
					i > u
				loop
					new_storage.extend (i)
					i := i + 1
				end
				storage := new_storage
			else
				create storage.make (0)
			end
		ensure
			empty_when_invalid: l > u implies is_empty
			has_bounds: l <= u implies (has (l) and has (u))
			correct_count: l <= u implies count = u - l + 1
		end

	from_tuple (t: TUPLE [l: INTEGER; u: INTEGER])
			-- Create interval [l, u].
		do
			from_range (t.l, t.u)
		end

feature -- Access

	lower: INTEGER
			-- Lower bound.
		require
			not_empty: not is_empty
		do
			Result := storage.first
		ensure
			definition: Result = storage.first
		end

	upper: INTEGER
			-- Upper bound.
		require
			not_empty: not is_empty
		do
			Result := storage.last
		ensure
			definition: Result = storage.last
		end

feature -- Properties

	has alias "[]" (x: INTEGER): BOOLEAN
			-- Is `x' contained?
		do
			Result := not is_empty and then (lower <= x and x <= upper)
		ensure then
			efficient_check: Result = (not is_empty and then (lower <= x and x <= upper))
		end

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this set contain same elements as `other'?
		do
			if attached {MML_INTERVAL} other as interval then
				if is_empty then
					Result := interval.is_empty
				else
					Result := not interval.is_empty and then (lower = interval.lower and upper = interval.upper)
				end
			else
				Result := Precursor (other)
			end
		end

	is_subset_of alias "<=" (other: MML_SET [INTEGER]): BOOLEAN
			-- Does `other' have all elements of `Current'?
		do
			if attached {MML_INTERVAL} other as interval then
				Result := is_empty or else (not interval.is_empty and then (interval.lower <= lower and upper <= interval.upper))
			else
				Result := Precursor (other)
			end
		end

	disjoint (other: MML_SET [INTEGER]): BOOLEAN
			-- Do no elements of `other' occur in `Current'?
		do
			if attached {MML_INTERVAL} other as interval then
				Result := (is_empty or interval.is_empty) or else (interval.upper < lower or upper < interval.lower)
			else
				Result := Precursor (other)
			end
		end

feature -- Modification

	interval_union alias "|+|" (other: MML_INTERVAL): MML_INTERVAL
			-- Minimal interval that includes this interval and `other'.
		do
			if is_empty then
				Result := other
			elseif other.is_empty then
				Result := Current
			else
				create Result.from_range (lower.min (other.lower), upper.max (other.upper))
			end
		ensure
			includes_current: not is_empty implies Result >= Current
			includes_other: not other.is_empty implies Result >= other
		end

end
