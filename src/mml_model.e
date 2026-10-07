note
	description: "[
		Mathematical models for Design by Contract.

		Base class for all MML types providing model equality operators.
		Adapted from ETH Zurich's base2 library for SCOOP compatibility.
	]"
	author: "Nadia Polikarpova (original), Larry Rix (SCOOP adaptation)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_MODEL

feature -- Comparison

	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		deferred
		end

	is_model_non_equal alias "|/=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically different from `other'?
		do
			Result := not is_model_equal (other)
		ensure
			definition: Result = not is_model_equal (other)
		end

	distinct_positions (a_items: READABLE_INDEXABLE [detachable separate ANY]): ARRAYED_LIST [INTEGER]
			-- Positions in `a_items' of the first occurrence of each distinct value (by `model_equals'),
			-- in order. Hashable values are bucketed by `hash_code' and compared only within their
			-- bucket; values that are models (model equality) or not hashable are compared with every
			-- kept value of their kind; values of different kinds are never equal (`~' needs the same
			-- type). The one place sets, sequences and maps find distinct values: a pairwise scan here
			-- took 25 s for 7,991 ids under contract checking (simple_prompter, 2026-10-07).
		local
			l_buckets: HASH_TABLE [ARRAYED_LIST [INTEGER], INTEGER]
			l_others, l_bucket: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create Result.make (a_items.upper - a_items.lower + 1)
			create l_buckets.make (Result.capacity.max (1))
			create l_others.make (0)
			from i := a_items.lower until i > a_items.upper loop
				if attached {HASHABLE} a_items [i] as al_h and then al_h.is_hashable and then not attached {MML_MODEL} a_items [i] then
					if attached l_buckets.item (al_h.hash_code) as al_bucket then
						if not across al_bucket as jc some model_equals (a_items [i], a_items [jc]) end then
							al_bucket.extend (i)
							Result.extend (i)
						end
					else
						create l_bucket.make (1)
						l_bucket.extend (i)
						l_buckets.put (l_bucket, al_h.hash_code)
						Result.extend (i)
					end
				elseif not across l_others as jc some model_equals (a_items [i], a_items [jc]) end then
					l_others.extend (i)
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			no_more: Result.count <= a_items.upper - a_items.lower + 1
			first_kept: a_items.upper >= a_items.lower implies (not Result.is_empty and then Result.first = a_items.lower)
		end

	frozen model_equals (v1, v2: detachable separate ANY): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- If they are models use model equality, otherwise object equality.
		do
			if attached {MML_MODEL} v1 as m1 and attached {MML_MODEL} v2 as m2 then
				Result := m1 |=| m2
			else
				Result := v1 ~ v2
			end
		ensure
			models_use_model_equality: (attached {MML_MODEL} v1 as m1 and attached {MML_MODEL} v2 as m2) implies Result = (m1 |=| m2)
			non_models_use_object_equality: (not attached {MML_MODEL} v1 or not attached {MML_MODEL} v2) implies Result = (v1 ~ v2)
		end

end
