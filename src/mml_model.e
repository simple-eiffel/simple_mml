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
