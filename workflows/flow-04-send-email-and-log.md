# Flow 04 — Send Email & Auto-Log to Timeline

## Purpose
Send an email to a person using an approved sending context and automatically store the email in the person’s communication history.

## Trigger
- Power Apps action: “Send Email”
- Used from Lead or Applicant communication screens

## Inputs
- PersonId (required)
- To, Cc (optional), Subject, Body (rich text allowed)
- Attachments (optional)
- Sending context: personal vs departmental (sanitized)

## Steps (High Level)
1. Validate To/Subject/Body and permission (role-based)
2. Send email via approved connector (not exported publicly)
3. Create Communications record:
   - Channel = Email
   - Direction = Outgoing
   - IsAutomated = false
4. Update LastContactedAt for Lead if relevant
5. Return success response to UI

## Error Handling
- If email send fails:
  - Create Communications record with failure status (optional)
  - Show error to UI and allow retry

## Data Written
- Communications, Leads (LastContactedAt)
