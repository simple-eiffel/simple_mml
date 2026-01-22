# Changelog

All notable changes to simple_mml will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-01-22

### Changed
- Generic constraints updated from `[G -> detachable ANY]` to `[G -> detachable separate ANY]`
- `model_equals` signature updated to `(v1, v2: detachable separate ANY)`

### Fixed
- VUAR(2) type conformance errors when consumer libraries use simple_mml with SCOOP enabled
- Consumer libraries like proven_fetch can now use MML types without compilation errors

### Technical Notes
- The `separate` keyword is required for SCOOP compatibility in consumer libraries
- simple_mml compiles without these constraints, but consumers with `concurrency=scoop` would fail
- This is a non-breaking change for consumers already using detachable types

## [1.0.0] - 2025-01-21

### Added
- Initial release of simple_mml
- MML_MODEL base class with model equality operator `|=|`
- MML_SET for finite mathematical sets
- MML_SEQUENCE for ordered collections
- MML_BAG for multisets with counted duplicates
- MML_MAP for key-value pairs
- MML_RELATION for multi-valued relations
- MML_INTERVAL for integer ranges
- Full void safety with `[G -> detachable ANY]` constraints
- SCOOP compatibility
- 26 unit tests, all passing
- 57 internal contract assertions

### Technical Notes
- Adapted from ETH Zurich's base2 library
- Void safety requires detachable constraint for compatibility with `model_equals`
