# 7S-04: SIMPLE-STAR - simple_mml

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mml

## Ecosystem Dependencies

### Required simple_* Libraries

| Library | Purpose | Version |
|---------|---------|---------|
| (none) | Self-contained | - |

### ISE Base Libraries Used

| Library | Purpose |
|---------|---------|
| base | ARRAYED_LIST for storage |

## Integration Points

### No External Dependencies
- simple_mml is intentionally self-contained
- Can be used in any Eiffel project
- Pure mathematical semantics

### Used By Other simple_* Libraries

| Library | Usage |
|---------|-------|
| simple_mock | Model views of expectations/requests |
| simple_test | Contract verification |
| Any library | DBC specifications |

## Ecosystem Fit

### Category
Foundation / Contract Support

### Phase
Phase 4 - Production ready

### Maturity
Production-ready

### Role in Ecosystem
- Foundation for DBC-style development
- Model types for specifications
- Reference for mathematical precision

## Usage Patterns

### In Contracts
```eiffel
feature
  add (x: G)
    ensure
      model_extended: model.count = old model.count + 1
      model_has_x: model.has (x)
    end

  model: MML_SEQUENCE [G]
    -- Model view of internal state
```

### Set Operations
```eiffel
set1 + set2  -- union
set1 * set2  -- intersection
set1 - set2  -- difference
set1 <= set2 -- subset
```

### Sequence Operations
```eiffel
seq & x      -- extend
seq + other  -- concatenation
seq [i]      -- element access
seq.front(n) -- prefix
seq.tail(n)  -- suffix
```
