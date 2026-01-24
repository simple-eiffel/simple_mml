# 7S-02: STANDARDS - simple_mml


**Date**: 2026-01-23

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Applicable Standards

### ETH Zurich base2 Library
- **Source**: ETH Zurich, Chair of Software Engineering
- **Author**: Nadia Polikarpova
- **Relevance**: Original MML implementation
- **Relationship**: simple_mml adapted for SCOOP

### Mathematical Set Theory
- **Standard**: ZFC set theory
- **Relevance**: Semantics of set/sequence/relation operations
- **Implementation**: Practical finite approximations

### Eiffel Design by Contract
- **Standard**: ECMA-367, OOSC2
- **Relevance**: Intended use for contracts
- **Alignment**: Designed for use in require/ensure/invariant

## Key Mathematical Concepts

### Model Equality
- Distinct from object identity (=)
- Distinct from object equality (~)
- Mathematical equality for model values
- Operators: |=| (equal), |/=| (not equal)

### Immutability
- All operations return new instances
- No mutation methods
- Safe for use in contracts (no side effects)

### SCOOP Compatibility
- Generic constraint: G -> detachable separate ANY
- Allows use with separate objects
- Thread-safe by immutability

## Coding Standards

- Pure query semantics (no side effects)
- Full contract coverage
- Explicit preconditions for operations
- Postconditions express mathematical properties
