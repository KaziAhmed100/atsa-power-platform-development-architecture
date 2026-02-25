# Power Fx Patterns — Role-Based UI + Navigation

## Goal
Tailor the app experience based on staff permissions while keeping the UI simple.

## Pattern 1: Role Lookup on App Start
- OnStart:
  - Query StaffUsers table by current user's email
  - Store Role in a global variable

## Pattern 2: Hide/Disable Actions by Role
- Example actions to restrict:
  - Delete lead/applicant
  - Edit sensitive fields
  - Batch email access

Use:
- `DisplayMode.Disabled` for buttons
- Conditional visibility for admin-only controls

## Pattern 3: Consistent Navigation Pattern
- Home screen contains large navigation tiles (modules)
- Each module has:
  - List screen
  - Details/profile screen
  - Communication screen

## Pattern 4: Tabbed Details Screen
Split large datasets into logical tabs for readability and speed.
