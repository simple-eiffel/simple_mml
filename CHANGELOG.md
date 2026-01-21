# Changelog

All notable changes to simple_mml will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- Void safety requires `[G -> detachable ANY]` (not `[G -> ANY]`) for compatibility with `model_equals (v1, v2: detachable ANY)`
