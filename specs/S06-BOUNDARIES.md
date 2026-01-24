# S06: BOUNDARIES - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## System Boundaries

```
+------------------+               +------------------+
|   Application    | <----------> |   simple_mml     |
|   Contracts      |   Queries    |   Model Types    |
+------------------+               +------------------+
        |                                 |
        v                                 v
+------------------+               +------------------+
|   Runtime        |               |   ARRAYED_LIST   |
|   Assertions     |               |   (internal)     |
+------------------+               +------------------+
```

## External Interfaces

### Input Boundaries

| Interface | Format | Source |
|-----------|--------|--------|
| Element values | Any Eiffel type | Application |
| Predicates | PREDICATE agents | Application |
| Functions | FUNCTION agents | Application |

### Output Boundaries

| Interface | Format | Destination |
|-----------|--------|-------------|
| Model values | MML_* instances | Application |
| Booleans | Query results | Application |
| Elements | Retrieved values | Application |

## Class Hierarchy

```
MML_MODEL (deferred)
    |
    +-- MML_SEQUENCE [G]
    |
    +-- MML_SET [G]
    |
    +-- MML_BAG [G]
    |
    +-- MML_MAP [K, V]
    |
    +-- MML_RELATION [G, H]
    |
    +-- MML_INTERVAL
```

## Type Boundaries

### Generic Constraints
- All generic types: `G -> detachable separate ANY`
- Allows any Eiffel type
- Supports SCOOP separate objects

### Model Equality Boundary
- MML types use model equality (|=|)
- Non-MML types use object equality (~)
- Mixed comparisons handled by model_equals

## Trust Boundaries

### Trusted
- Eiffel runtime
- Base library collections
- Contract assertions

### Untrusted
- Element values (may be Void if detachable)
- Predicate/function agents (may have side effects)

## Versioning

- Library version: 1.0
- Based on: ETH base2
- Eiffel compatibility: ECMA-367
