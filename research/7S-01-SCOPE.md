# 7S-01: SCOPE - simple_mml


**Date**: 2026-01-23

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Problem Statement

Design by Contract requires mathematical precision in specifications. Standard Eiffel collections are mutable, making them unsuitable for expressing contracts about before/after states. The MML (Mathematical Model Library) provides immutable mathematical types for precise contract specification.

## Library Purpose

simple_mml provides immutable mathematical types for DBC:

1. **MML_SEQUENCE** - Ordered finite sequences (1-indexed)
2. **MML_SET** - Finite sets with no duplicates
3. **MML_BAG** - Multisets allowing duplicates
4. **MML_MAP** - Finite key-value mappings
5. **MML_RELATION** - Binary relations
6. **MML_INTERVAL** - Integer intervals
7. **MML_MODEL** - Base class for model equality

## Target Users

- Eiffel developers writing precise contracts
- Library authors specifying data structure behavior
- Anyone using Design by Contract rigorously

## Scope Boundaries

### In Scope
- Immutable mathematical collections
- Model equality operators (|=|, |/=|)
- Set operations (union, intersection, difference)
- Sequence operations (concatenation, slicing)
- Quantifiers (for_all, exists)
- SCOOP compatibility

### Out of Scope
- Mutable data structures (use standard library)
- Infinite collections
- Lazy evaluation
- Performance optimization (clarity over speed)

## Success Metrics

- 100% immutability (no mutation operations)
- Full model equality support
- SCOOP-safe (separate ANY constraint)
