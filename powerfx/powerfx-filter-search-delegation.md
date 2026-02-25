# Power Fx Patterns — Filtering, Search, and Delegation

## Goal
Keep list screens fast and scalable by using delegation-friendly queries and minimizing client-side filtering.

## Pattern 1: Delegation-Friendly Search (StartsWith)
Instead of `Search()` on large datasets, use `StartsWith()` (when the data source supports delegation).

Example:
- Search by last name prefix, then refine.

## Pattern 2: Optional Filters With Defaults
Use variables to hold filter selections and apply only when set.

Pseudo-pattern:
- If dropdown is blank, do not filter by that field.

## Pattern 3: Sort + Pagination Experience
- Provide newest-first default ordering.
- Avoid nested Sort/Filter chains where possible.

## Pattern 4: Index-like fields for reporting
- Store normalized fields (e.g., StatusId not StatusText)
- Use lookups only for display

## UI Guidance
- Provide a “Clear Filters” button to reset all filter variables.
- Keep key columns on the list screen so staff can triage quickly.
