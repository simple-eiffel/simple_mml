# 7S-06: SIZING - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Codebase Metrics

### Source Files
- **Total Classes**: 9
- **Main Source**: 7 classes in src/
- **Testing**: 2 classes in testing/

### Lines of Code
- MML_MODEL: ~50 LOC
- MML_SEQUENCE: ~400 LOC
- MML_SET: ~310 LOC
- MML_BAG: ~250 LOC
- MML_MAP: ~300 LOC
- MML_RELATION: ~250 LOC
- MML_INTERVAL: ~200 LOC
- **Total**: ~1760 LOC

### Complexity Assessment

| Component | Complexity | Rationale |
|-----------|------------|-----------|
| MML_MODEL | Low | Abstract base, simple equality |
| MML_SEQUENCE | Medium | Many operations, indexing |
| MML_SET | Medium | Set operations, uniqueness |
| MML_BAG | Low | Simpler than set |
| MML_MAP | Medium | Key-value relationships |
| MML_RELATION | Medium | Binary relation operations |
| MML_INTERVAL | Low | Simple integer range |

## Performance Characteristics

### Memory Usage
- Each modification creates new storage
- O(n) space per operation (copy)
- Suitable for contract use, not bulk data

### Time Complexity
- Most operations O(n)
- Designed for clarity, not speed
- Contract assertions should be small

### Scalability
- Works for typical contract sizes (< 1000 elements)
- Not recommended for large collections
- Use standard library for performance

## Build Metrics

- Compile time: ~5 seconds
- Test suite: ~30 tests
- Dependencies: base only

## Feature Count

| Class | Features |
|-------|----------|
| MML_MODEL | 3 |
| MML_SEQUENCE | 25 |
| MML_SET | 20 |
| MML_BAG | 15 |
| MML_MAP | 18 |
| MML_RELATION | 15 |
| MML_INTERVAL | 12 |
