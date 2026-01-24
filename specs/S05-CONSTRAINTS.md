# S05: CONSTRAINTS - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Technical Constraints

### Platform
- **OS**: Cross-platform
- **Compiler**: EiffelStudio 25.02+
- **Concurrency**: SCOOP compatible

### Dependencies
- Eiffel base library only
- ARRAYED_LIST for internal storage

## Design Constraints

### Immutability
- All modification operations return new instances
- No in-place mutation
- Original objects always unchanged

### SCOOP Compatibility
- Generic constraint: `G -> detachable separate ANY`
- Allows use with separate objects
- Thread-safe by immutability

### 1-Based Indexing
- Sequences indexed from 1 (Eiffel convention)
- Domain is [1, count]

### Finite Collections
- All collections are finite
- Bounded by available memory
- No lazy/infinite structures

## Semantic Constraints

### Model Equality
- Not same as object identity (=)
- Not same as object equality (~)
- Compares mathematical values
- Reflexive, symmetric, transitive

### Set Uniqueness
- MML_SET contains no duplicates
- Adding existing element is no-op
- Comparison via model_equals

### Sequence Ordering
- Elements maintain insertion order
- Indexed access is position-based
- Concatenation preserves order

## Performance Constraints

### Not Optimized
- Designed for clarity, not speed
- O(n) for most operations
- Copies on every modification

### Intended Use
- Contract specifications (require/ensure/invariant)
- Model queries returning current state
- Small collections (< 1000 typical)

### Not Recommended For
- Large data processing
- Performance-critical paths
- Main program data structures

## Known Limitations

1. **Memory Overhead**
   - Each operation allocates new storage
   - GC pressure with many operations

2. **No Persistence**
   - In-memory only
   - No serialization support

3. **Limited Optimization**
   - No structural sharing
   - No lazy evaluation
