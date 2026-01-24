# S03: CONTRACTS - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## MML_MODEL Contracts

### is_model_non_equal (other: MML_MODEL): BOOLEAN
```eiffel
ensure
  definition: Result = not is_model_equal (other)
```

### model_equals (v1, v2: detachable separate ANY): BOOLEAN
```eiffel
ensure
  models_use_model_equality: (attached {MML_MODEL} v1 as m1 and
    attached {MML_MODEL} v2 as m2) implies Result = (m1 |=| m2)
  non_models_use_object_equality: (not attached {MML_MODEL} v1 or
    not attached {MML_MODEL} v2) implies Result = (v1 ~ v2)
```

## MML_SEQUENCE Contracts

### default_create
```eiffel
ensure then
  empty: is_empty
```

### singleton (x: G)
```eiffel
ensure
  one_element: count = 1
  has_x: item (1) = x
```

### item (i: INTEGER): G
```eiffel
require
  in_domain: domain [i]
```

### first / last
```eiffel
require
  non_empty: not is_empty
```

### but_first / but_last
```eiffel
require
  not_empty: not is_empty
```

### extended (x: G): MML_SEQUENCE [G]
```eiffel
ensure
  count_incremented: Result.count = count + 1
  last_is_x: Result.last = x
```

### extended_at (i: INTEGER; x: G): MML_SEQUENCE [G]
```eiffel
require
  valid_position: 1 <= i and i <= count + 1
ensure
  count_incremented: Result.count = count + 1
  element_inserted: Result.item (i) = x
```

### concatenation (other: MML_SEQUENCE [G]): MML_SEQUENCE [G]
```eiffel
ensure
  count_sum: Result.count = count + other.count
```

### replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
```eiffel
require
  in_domain: domain [i]
ensure
  same_count: Result.count = count
  element_replaced: Result.item (i) = x
```

## MML_SET Contracts

### has (x: G): BOOLEAN
```eiffel
-- (query, no precondition)
```

### is_empty
```eiffel
ensure
  count_zero: Result = (count = 0)
```

### extended (x: G): MML_SET [G]
```eiffel
ensure
  has_x: Result.has (x)
  has_old: for_all (agent Result.has)
```

### removed (x: G): MML_SET [G]
```eiffel
ensure
  not_has_x: not Result.has (x)
```

### union (other: MML_SET [G]): MML_SET [G]
```eiffel
ensure
  contains_current: Current <= Result
  contains_other: other <= Result
```

### intersection (other: MML_SET [G]): MML_SET [G]
```eiffel
ensure
  contained_in_current: Result <= Current
  contained_in_other: Result <= other
```

### difference (other: MML_SET [G]): MML_SET [G]
```eiffel
ensure
  contained_in_current: Result <= Current
  disjoint_from_other: Result.disjoint (other)
```

## Class Invariants

### MML_SEQUENCE
```eiffel
invariant
  storage_exists: storage /= Void
```

### MML_SET (implicit)
- No duplicates in storage
