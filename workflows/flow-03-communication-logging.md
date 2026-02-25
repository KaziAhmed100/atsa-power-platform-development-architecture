# Flow 03 — Communication Logging (Manual Entry)

## Purpose
Allow staff to log communications that occurred outside the system (phone call, office visit, etc.) and attach them to a person/lead/applicant.

## Trigger
- Power Apps form submission: “Record New Communication”

## Inputs
- PersonId (required)
- Channel (Phone/Visit/Other)
- Notes/body text (sanitized)
- OccurredAt timestamp
- Optional RelatedLeadId / RelatedApplicantId

## Steps (High Level)
1. Validate required fields (PersonId, Channel, OccurredAt)
2. Create a Communications record
3. Update “LastContactedAt” on the related Lead (if present)
4. (Optional) update statuses if business rules require it

## Error Handling
- On failure: show error to user; log technical details separately

## Data Written
- Communications, Leads (LastContactedAt)
