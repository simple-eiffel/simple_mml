# S02: CLASS CATALOG - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Core Classes

### MML_MODEL (deferred)
- **Purpose**: Base class defining model equality
- **Role**: Abstract interface for all MML types
- **Key Features**:
  - `is_model_equal` alias `|=|`: Model equality
  - `is_model_non_equal` alias `|/=|`: Model inequality
  - `model_equals`: Compare any two values using model semantics

### MML_SEQUENCE [G -> detachable separate ANY]
- **Purpose**: Finite ordered sequences (1-indexed)
- **Role**: Model arrays and lists
- **Key Features**:
  - `item` alias `[]`: Element access
  - `extended` alias `&`: Add to end
  - `concatenation` alias `+`: Combine sequences
  - `front`, `tail`, `interval`: Subsequences
  - `domain`, `range`: Index set and value set

### MML_SET [G -> detachable separate ANY]
- **Purpose**: Finite sets (no duplicates)
- **Role**: Model mathematical sets
- **Key Features**:
  - `has` alias `[]`: Membership test
  - `extended` alias `&`: Add element
  - `union` alias `+`: Set union
  - `intersection` alias `*`: Set intersection
  - `difference` alias `-`: Set difference
  - `is_subset_of` alias `<=`: Subset test

### MML_BAG [G -> detachable separate ANY]
- **Purpose**: Finite multisets (duplicates allowed)
- **Role**: Model collections with counts
- **Key Features**:
  - `occurrences`: Count of element
  - `extended`: Add element
  - `removed`: Remove one occurrence
  - `sum`, `difference`: Bag operations

### MML_MAP [K -> detachable separate ANY, V -> detachable separate ANY]
- **Purpose**: Finite key-value mappings
- **Role**: Model dictionaries/tables
- **Key Features**:
  - `item` alias `[]`: Value for key
  - `extended`: Add key-value pair
  - `domain`: Set of keys
  - `range`: Set of values

### MML_RELATION [G -> detachable separate ANY, H -> detachable separate ANY]
- **Purpose**: Binary relations
- **Role**: Model relationships between values
- **Key Features**:
  - `has`: Pair membership
  - `image`: Values related to a value
  - `inverse`: Reversed relation

### MML_INTERVAL
- **Purpose**: Integer intervals [lower, upper]
- **Role**: Model index ranges, domains
- **Key Features**:
  - `has` alias `[]`: Membership test
  - `from_range`: Create from bounds
  - Set operations (union, etc.)
