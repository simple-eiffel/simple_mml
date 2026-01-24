# S07: SPECIFICATION SUMMARY - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Library Identity

- **Name**: simple_mml
- **Version**: 1.0
- **Category**: Foundation / Contract Support
- **Status**: Production
- **Origin**: Adapted from ETH Zurich base2

## Purpose Statement

simple_mml provides immutable mathematical model types for Design by Contract, enabling precise specification of before/after states in Eiffel contracts with SCOOP compatibility.

## Key Capabilities

1. **Model Types**
   - MML_SEQUENCE: Ordered sequences
   - MML_SET: Unique element sets
   - MML_BAG: Multisets with duplicates
   - MML_MAP: Key-value mappings
   - MML_RELATION: Binary relations
   - MML_INTERVAL: Integer ranges

2. **Model Equality**
   - |=| operator for mathematical equality
   - Distinct from object equality
   - Consistent across all model types

3. **Immutable Operations**
   - All modifications return new instances
   - Safe for use in contracts
   - No side effects

4. **SCOOP Compatibility**
   - Generic constraint allows separate types
   - Thread-safe by immutability

## Architecture Summary

- **Pattern**: Immutable value objects
- **Storage**: ARRAYED_LIST (internal)
- **Dependencies**: base library only

## Quality Attributes

| Attribute | Target |
|-----------|--------|
| Correctness | Mathematical precision |
| Immutability | 100% (no mutation) |
| Thread Safety | Inherent (immutable) |
| Clarity | Contract-friendly |

## API Surface

### Model Equality
- `|=|` (is_model_equal)
- `|/=|` (is_model_non_equal)
- `model_equals`

### Common Operations
- `has`, `is_empty`, `count`
- `for_all`, `exists`
- Creation: `default_create`, `singleton`
