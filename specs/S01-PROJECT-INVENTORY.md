# S01: PROJECT INVENTORY - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Project Structure

```
simple_mml/
  src/
    mml_model.e                # Base class for model equality
    mml_sequence.e             # Finite sequences
    mml_set.e                  # Finite sets
    mml_bag.e                  # Finite multisets
    mml_map.e                  # Finite mappings
    mml_relation.e             # Binary relations
    mml_interval.e             # Integer intervals
  testing/
    test_app.e                 # Test application entry
    lib_tests.e                # Test suite
  research/                    # 7S research documents
  specs/                       # Specification documents
  simple_mml.ecf               # Library ECF configuration
```

## File Counts

| Category | Count |
|----------|-------|
| Source (.e) | 9 |
| Configuration (.ecf) | 1 |
| Documentation (.md) | 15+ |

## Dependencies

### simple_* Ecosystem
- (none - self-contained)

### ISE Libraries
- base (ARRAYED_LIST)

## Build Targets

| Target | Type | Purpose |
|--------|------|---------|
| simple_mml | library | Reusable library |
| simple_mml_tests | executable | Test suite |

## Version

Current: 1.0 (adapted from ETH base2)
