# Power Fx Patterns — Forms, Validation, and Patch()

## Goal
Create consistent form submission behavior with validation, error feedback, and safe Patch() logic.

## Pattern 1: Required Field Validation
- Validate before submit.
- Show a concise message per required field group.

Example checks:
- Require at least one contact method (email or phone)

## Pattern 2: Patch Parent then Patch Children
When saving a Person and then a Lead/Applicant:
1) Patch Person (or reuse existing PersonId)
2) Patch Lead/Applicant using returned PersonId

## Pattern 3: Protect Against Duplicate Submits
- Disable submit button while saving
- Use a context variable like `locSaving = true`

## Pattern 4: Capture Errors
Wrap Patch in IfError() and surface an end-user safe message while logging technical details separately.

## Pattern 5: Audit timestamps
Update `UpdatedAt` field on each save.
