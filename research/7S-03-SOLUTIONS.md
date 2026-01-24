# 7S-03: SOLUTIONS - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Alternative Solutions Evaluated

### 1. Use Standard Library Collections
- **Approach**: ARRAYED_LIST, HASH_TABLE in contracts
- **Pros**: Already available
- **Cons**: Mutable, object semantics not mathematical
- **Decision**: Rejected - doesn't express intent

### 2. Original ETH base2 Library
- **Source**: ETH Zurich
- **Pros**: Well-designed, proven
- **Cons**: Not SCOOP-compatible, separate library
- **Decision**: Adapt for SCOOP

### 3. Custom Immutable Collections
- **Approach**: Build from scratch
- **Pros**: Full control
- **Cons**: Duplicate effort, miss proven design
- **Decision**: Rejected - base2 is well-designed

### 4. Adapted base2 for SCOOP (Chosen)
- **Approach**: Take base2 design, add SCOOP constraints
- **Pros**: Proven design + SCOOP safety
- **Cons**: Maintenance of adaptation
- **Decision**: Implemented

## Architecture Decisions

### Generic Constraint
```eiffel
class MML_SEQUENCE [G -> detachable separate ANY]
```
- Allows any type including separate
- Supports SCOOP concurrent access
- Detachable for flexibility

### Model Equality
- Abstract in MML_MODEL base class
- Each subclass implements |=|
- model_equals helper for mixed comparisons

### Internal Storage
- ARRAYED_LIST for sequences, sets, bags
- Hidden from clients
- Operations create new storage

## Technology Stack

- Pure Eiffel
- Base library only
- No external dependencies
