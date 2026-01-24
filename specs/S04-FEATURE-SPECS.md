# S04: FEATURE SPECIFICATIONS - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## MML_MODEL Features

| Feature | Type | Description |
|---------|------|-------------|
| is_model_equal |=| | Query | Model equality (deferred) |
| is_model_non_equal |/=| | Query | Model inequality |
| model_equals | Query | Compare any values with model semantics |

## MML_SEQUENCE Features

### Properties
| Feature | Type | Description |
|---------|------|-------------|
| has | Query | Is element contained? |
| is_empty | Query | Is sequence empty? |
| is_constant | Query | All values equal to c? |
| for_all | Query | Does predicate hold for all? |
| exists | Query | Does predicate hold for any? |

### Element Access
| Feature | Type | Description |
|---------|------|-------------|
| item [] | Query | Value at position (1-indexed) |
| first | Query | First element |
| last | Query | Last element |

### Conversion
| Feature | Type | Description |
|---------|------|-------------|
| domain | Query | Set of indexes (MML_INTERVAL) |
| range | Query | Set of values (MML_SET) |
| to_bag | Query | Convert to bag |

### Measurement
| Feature | Type | Description |
|---------|------|-------------|
| count # | Query | Number of elements |
| occurrences | Query | Count of element |

### Decomposition
| Feature | Type | Description |
|---------|------|-------------|
| but_first | Query | Sequence without first |
| but_last | Query | Sequence without last |
| front | Query | Prefix up to n |
| tail | Query | Suffix from n |
| interval | Query | Subsequence [l, u] |
| removed_at | Query | Without element at i |

### Modification (return new)
| Feature | Type | Description |
|---------|------|-------------|
| extended & | Query | With x appended |
| extended_at | Query | With x at position i |
| prepended | Query | With x prepended |
| concatenation + | Query | Combined with other |
| replaced_at | Query | With x at position i |

## MML_SET Features

### Properties
| Feature | Type | Description |
|---------|------|-------------|
| has [] | Query | Membership test |
| is_empty | Query | Is set empty? |
| for_all | Query | Predicate holds for all? |
| exists | Query | Predicate holds for any? |

### Elements
| Feature | Type | Description |
|---------|------|-------------|
| any_item | Query | Arbitrary element |
| count # | Query | Cardinality |

### Comparison
| Feature | Type | Description |
|---------|------|-------------|
| is_model_equal |=| | Query | Same elements? |
| is_subset_of <= | Query | Subset test |
| is_superset_of >= | Query | Superset test |
| disjoint | Query | No common elements? |

### Modification (return new)
| Feature | Type | Description |
|---------|------|-------------|
| extended & | Query | With x added |
| removed / | Query | With x removed |
| union + | Query | Elements in either |
| intersection * | Query | Elements in both |
| difference - | Query | Elements in this not other |
| sym_difference ^ | Query | Elements in one but not both |
| filtered | | Query | Elements satisfying predicate |
| mapped | Query | Elements with function applied |

## MML_INTERVAL Features

| Feature | Type | Description |
|---------|------|-------------|
| from_range | Creation | Create [lower, upper] |
| has [] | Query | Integer in range? |
| lower | Query | Lower bound |
| upper | Query | Upper bound |
| count | Query | Number of integers |
| is_empty | Query | Empty interval? |
