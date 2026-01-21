<p align="center">
  <img src="docs/images/logo.png" alt="simple_mml logo" width="200">
</p>

<h1 align="center">simple_mml</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_mml/">Documentation</a> •
  <a href="https://github.com/simple-eiffel/simple_mml">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

**Mathematical Model Library for Design by Contract specifications** — Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 7 classes
- **83 tests total**
  - 57 internal (DBC contract assertions)
  - 26 external (AutoTest unit tests)

## Overview

simple_mml provides immutable mathematical model types for use in Design by Contract specifications. These classes allow you to express precise postconditions using mathematical concepts like sets, sequences, bags, maps, and relations.

Adapted from ETH Zurich's base2 library, simple_mml is fully void-safe and SCOOP-compatible. The library uses `[G -> detachable ANY]` generic constraints to ensure compatibility with the model equality operator in void-safe mode.

The key insight is that model objects are transient—constructed within contract expressions from already-attached source data. They mirror safe structures for mathematical comparison, enabling postconditions like `model |=| old model & x` that precisely specify state changes.

## Quick Start

```eiffel
class STACK [G -> detachable ANY]
feature
    model: MML_SEQUENCE [G]
        -- Mathematical model of stack contents.

    push (x: G)
            -- Push `x` onto stack.
        do
            -- implementation
        ensure
            model_extended: model |=| old model & x
        end

    pop
            -- Remove top element.
        require
            not_empty: not model.is_empty
        do
            -- implementation
        ensure
            model_reduced: model |=| old model.but_last
        end
end
```

## API Reference

### MML_MODEL

| Feature | Description |
|---------|-------------|
| `is_model_equal alias "\|=\|"` | Model equality comparison |
| `model_equals (v1, v2)` | Compare two values for model equality |

### MML_SET [G]

| Feature | Description |
|---------|-------------|
| `default_create` | Create empty set |
| `singleton (x)` | Create set containing only `x` |
| `has alias "[]" (x)` | Is `x` contained? |
| `count alias "#"` | Cardinality |
| `extended alias "&" (x)` | Set with `x` added |
| `removed alias "/" (x)` | Set with `x` removed |
| `union alias "+" (other)` | Set union |
| `intersection alias "*" (other)` | Set intersection |
| `difference alias "-" (other)` | Set difference |
| `is_subset_of alias "<=" (other)` | Subset test |

### MML_SEQUENCE [G]

| Feature | Description |
|---------|-------------|
| `default_create` | Create empty sequence |
| `singleton (x)` | Create sequence with one element |
| `item alias "[]" (i)` | Value at position `i` |
| `count alias "#"` | Number of elements |
| `first`, `last` | First/last element |
| `extended alias "&" (x)` | Sequence with `x` appended |
| `prepended (x)` | Sequence with `x` at front |
| `concatenation alias "+" (other)` | Concatenate sequences |
| `but_first`, `but_last` | Remove first/last element |
| `is_prefix_of alias "<=" (other)` | Prefix test |

### MML_BAG [G]

| Feature | Description |
|---------|-------------|
| `default_create` | Create empty bag |
| `singleton (x)` | Create bag with one occurrence of `x` |
| `occurrences alias "[]" (x)` | Count of `x` in bag |
| `count alias "#"` | Total element count |
| `extended alias "&" (x)` | Bag with one more `x` |
| `removed alias "/" (x)` | Bag with one less `x` |
| `union alias "+" (other)` | Bag union (sum counts) |
| `difference alias "-" (other)` | Bag difference |

### MML_MAP [K, V]

| Feature | Description |
|---------|-------------|
| `default_create` | Create empty map |
| `singleton (k, v)` | Create map with one pair |
| `item alias "[]" (k)` | Value for key `k` |
| `domain` | Set of keys |
| `range` | Set of values |
| `updated (k, v)` | Map with `k` mapped to `v` |
| `removed (k)` | Map without key `k` |
| `override alias "+" (other)` | Override with other map |

### MML_RELATION [G, H]

| Feature | Description |
|---------|-------------|
| `default_create` | Create empty relation |
| `singleton (x, y)` | Create relation with one pair |
| `has alias "[]" (x, y)` | Is `x` related to `y`? |
| `domain` | Set of left components |
| `range` | Set of right components |
| `image_of (x)` | Set of values related to `x` |
| `extended (x, y)` | Relation with pair added |
| `removed (x, y)` | Relation with pair removed |
| `inverse` | Inverted relation |

### MML_INTERVAL

| Feature | Description |
|---------|-------------|
| `from_range (l, u)` | Create interval [l, u] |
| `has alias "[]" (i)` | Is `i` in interval? |
| `lower`, `upper` | Bounds |
| `count alias "#"` | Number of integers |

## Features

- ✅ Model equality operator `|=|` for contract comparisons
- ✅ Immutable types—all modifications return new objects
- ✅ Full set/sequence/bag/map/relation operations
- ✅ 1-indexed sequences (Eiffel convention)
- ✅ Design by Contract throughout
- ✅ Void-safe (`[G -> detachable ANY]` constraints)
- ✅ SCOOP-compatible

## Installation

### Using as ECF Dependency

Add to your `.ecf` file:

```xml
<library name="simple_mml" location="$SIMPLE_LIBS/simple_mml/simple_mml.ecf"/>
```

### Environment Setup

Set the `SIMPLE_LIBS` environment variable:
```bash
export SIMPLE_LIBS=/path/to/simple/libraries
```

## Dependencies

| Library | Purpose |
|---------|---------|
| base | ARRAYED_LIST for internal storage |

## Technical Note: Void Safety

simple_mml uses `[G -> detachable ANY]` generic constraints. This is required because `model_equals` accepts `detachable ANY` parameters:

```eiffel
frozen model_equals (v1, v2: detachable ANY): BOOLEAN
```

Without this constraint, passing generic type `G` to `detachable ANY` triggers VUAR(2) errors in void-safe mode. The constraint `[G -> detachable ANY]` explicitly declares that G can be either attached or detachable, making it compatible with the comparison function.

Note: `[G -> ANY]` (attached) does NOT solve this—the constraint must match the detachability of the target parameter type.

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.
