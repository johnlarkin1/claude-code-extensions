---
name: ics-generator
description: Generate ICS calendar files (.ics) from natural language descriptions. Use when user wants to create calendar events, meetings, appointments, reminders, recurring events, or schedule items. Triggers on requests mentioning "calendar event", "ICS file", ".ics", "meeting invite", "appointment", "recurring event", "schedule", "RRULE", "reminder", "RSVP", "calendar invite", "block my calendar", or "add to calendar".
---

# ICS Calendar File Generator

Generate valid `.ics` (iCalendar RFC 5545) files from natural language event descriptions. Files open directly in Apple Calendar.

## Quick Start

Minimal valid single-event file:
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
DTSTART;TZID=America/New_York:20250115T140000
DTEND;TZID=America/New_York:20250115T150000
SUMMARY:Team Meeting
UID:550e8400-e29b-41d4-a716-446655440000@claude.ai
DTSTAMP:20250115T120000Z
END:VEVENT
END:VCALENDAR
```

## Workflow

1. **Parse** the user's natural language description for: title, date/time, duration, location, recurrence, attendees, reminders
2. **Resolve date references** like "next Tuesday", "this Friday at 3pm" relative to the current date
3. **Default timezone** to `America/New_York` unless the user specifies otherwise
4. **Generate a UUID v4** for the UID field: `<uuid4>@claude.ai`
5. **Set DTSTAMP** to the current UTC timestamp
6. **Build VEVENT block(s)** with all applicable properties
7. **Add VALARM** for reminders (default: 15 minutes before if not specified)
8. **Add RRULE** for recurring events
9. **Wrap in VCALENDAR** with standard headers
10. **Write** the `.ics` file to the current working directory and **open** it with `open <filename>.ics`

## Defaults

- **Timezone**: `America/New_York` (Eastern) — do NOT ask the user for timezone unless the event is clearly in another zone
- **Auto-open**: Always run `open <filename>.ics` after writing the file
- **Save location**: Current working directory
- **Duration**: 1 hour if not specified
- **Reminder**: 15 minutes before if not specified
- **Filename**: kebab-case from the event summary, e.g., `team-meeting.ics`

## VCALENDAR Wrapper

Every `.ics` file starts and ends with:
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
<VTIMEZONE blocks>
<VEVENT blocks>
END:VCALENDAR
```

## Date/Time Formats

### Timed events (with timezone)
```
DTSTART;TZID=America/New_York:20250115T140000
DTEND;TZID=America/New_York:20250115T150000
```

### All-day events (DATE only, no time component)
```
DTSTART;VALUE=DATE:20250115
DTEND;VALUE=DATE:20250116
```
Note: DTEND for all-day events is **exclusive** — a single all-day event on Jan 15 uses DTEND of Jan 16.

### UTC times
```
DTSTART:20250115T190000Z
```

## Event Properties

### Required
| Property | Description | Example |
|----------|-------------|---------|
| `DTSTART` | Start date/time | `DTSTART;TZID=America/New_York:20250115T140000` |
| `DTEND` or `DURATION` | End time or duration | `DTEND;TZID=America/New_York:20250115T150000` or `DURATION:PT1H` |
| `SUMMARY` | Event title | `SUMMARY:Team Standup` |
| `UID` | Unique identifier | `UID:550e8400-e29b-41d4-a716-446655440000@claude.ai` |
| `DTSTAMP` | Creation timestamp (UTC) | `DTSTAMP:20250115T120000Z` |

### Optional
| Property | Description | Example |
|----------|-------------|---------|
| `DESCRIPTION` | Event details/notes | `DESCRIPTION:Discuss Q1 roadmap` |
| `LOCATION` | Event location | `LOCATION:Conference Room A` |
| `URL` | Related link | `URL:https://meet.google.com/abc-defg-hij` |
| `ORGANIZER` | Event organizer | `ORGANIZER;CN=John:mailto:john@example.com` |
| `ATTENDEE` | Invited person | `ATTENDEE;ROLE=REQ-PARTICIPANT;RSVP=TRUE;CN=Jane:mailto:jane@example.com` |
| `STATUS` | Event status | `STATUS:CONFIRMED` (or `TENTATIVE`, `CANCELLED`) |
| `TRANSP` | Time transparency | `TRANSP:OPAQUE` (busy) or `TRANSP:TRANSPARENT` (free) |
| `CATEGORIES` | Event categories | `CATEGORIES:MEETING,WORK` |
| `PRIORITY` | Priority (0-9) | `PRIORITY:1` (1=highest, 9=lowest, 0=undefined) |

### DURATION format
```
DURATION:PT1H          → 1 hour
DURATION:PT30M         → 30 minutes
DURATION:PT1H30M       → 1 hour 30 minutes
DURATION:P1D           → 1 day
DURATION:P1W           → 1 week
```

## Text Escaping

Escape these characters in text property values:
- Backslash: `\\`
- Semicolon: `\;`
- Comma: `\,`
- Newline: `\n`

Example:
```
DESCRIPTION:Agenda:\n1. Review\n2. Planning\nLocation: Room 4\, Building A
```

## Reminders (VALARM)

Add inside a VEVENT block:
```
BEGIN:VALARM
TRIGGER:-PT15M
ACTION:DISPLAY
DESCRIPTION:Reminder
END:VALARM
```

### Common trigger durations
| Natural language | TRIGGER value |
|-----------------|---------------|
| At time of event | `TRIGGER:PT0S` |
| 5 minutes before | `TRIGGER:-PT5M` |
| 10 minutes before | `TRIGGER:-PT10M` |
| 15 minutes before | `TRIGGER:-PT15M` |
| 30 minutes before | `TRIGGER:-PT30M` |
| 1 hour before | `TRIGGER:-PT1H` |
| 2 hours before | `TRIGGER:-PT2H` |
| 1 day before | `TRIGGER:-P1D` |
| 1 week before | `TRIGGER:-P1W` |

## Recurring Events (RRULE)

Add an RRULE property to the VEVENT:
```
RRULE:FREQ=WEEKLY;BYDAY=TU,TH;COUNT=10
```

### Common patterns
| Pattern | RRULE |
|---------|-------|
| Every day | `RRULE:FREQ=DAILY` |
| Every weekday | `RRULE:FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR` |
| Every week | `RRULE:FREQ=WEEKLY` |
| Every 2 weeks | `RRULE:FREQ=WEEKLY;INTERVAL=2` |
| Every month (same date) | `RRULE:FREQ=MONTHLY` |
| Every month (e.g., 2nd Tuesday) | `RRULE:FREQ=MONTHLY;BYDAY=2TU` |
| Every year | `RRULE:FREQ=YEARLY` |
| Weekly until a date | `RRULE:FREQ=WEEKLY;UNTIL=20250630T235959Z` |
| Weekly for 10 occurrences | `RRULE:FREQ=WEEKLY;COUNT=10` |

### Excluding dates (EXDATE)
```
EXDATE;TZID=America/New_York:20250219T140000
EXDATE;TZID=America/New_York:20250226T140000
```

## Timezone Handling

### Default: America/New_York

Always include this VTIMEZONE block when using Eastern time:
```
BEGIN:VTIMEZONE
TZID:America/New_York
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
END:DAYLIGHT
END:VTIMEZONE
```

### Common timezone name mapping
| User says | TZID |
|-----------|------|
| Eastern, ET, EST, EDT | `America/New_York` |
| Central, CT, CST, CDT | `America/Chicago` |
| Mountain, MT, MST, MDT | `America/Denver` |
| Pacific, PT, PST, PDT | `America/Los_Angeles` |
| Arizona | `America/Phoenix` |
| Hawaii, HST | `Pacific/Honolulu` |
| London, GMT, BST | `Europe/London` |
| Paris, CET, CEST | `Europe/Paris` |
| Tokyo, JST | `Asia/Tokyo` |

See [references/ics-format.md](references/ics-format.md) for full VTIMEZONE definitions for all common timezones.

## Line Folding

Lines longer than 75 octets MUST be folded by inserting a CRLF followed by a single whitespace character (space or tab). In practice, keep property lines under 75 characters when possible.

```
DESCRIPTION:This is a very long description that would exceed the seventy-f
 ive octet limit so it is folded onto the next line with a leading space.
```

## Key Gotchas

1. **Line endings**: Use CRLF (`\r\n`) line endings throughout the file
2. **DTEND is exclusive**: An all-day event on Jan 15 needs `DTEND;VALUE=DATE:20250116`
3. **UID must be globally unique**: Always generate a fresh UUID v4 for each event
4. **DTSTAMP is required**: Always set to current UTC time
5. **VTIMEZONE must precede VEVENT**: Place timezone definitions before events in the file
6. **No trailing whitespace**: Lines must not end with spaces or tabs
7. **Property names are case-insensitive** but conventionally UPPERCASE
8. **Empty lines**: No blank lines allowed between properties within a component
9. **UNTIL in RRULE must be UTC**: `UNTIL=20250630T235959Z` (with Z suffix)
10. **Multi-value properties**: Use comma separation: `EXDATE;TZID=America/New_York:20250219T140000,20250226T140000`

## Complete Examples

### Simple meeting
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VTIMEZONE
TZID:America/New_York
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
DTSTART;TZID=America/New_York:20250115T140000
DTEND;TZID=America/New_York:20250115T150000
SUMMARY:Team Standup
DESCRIPTION:Weekly sync to review progress and blockers
LOCATION:Conference Room B
UID:a1b2c3d4-e5f6-7890-abcd-ef1234567890@claude.ai
DTSTAMP:20250115T120000Z
STATUS:CONFIRMED
TRANSP:OPAQUE
BEGIN:VALARM
TRIGGER:-PT15M
ACTION:DISPLAY
DESCRIPTION:Reminder
END:VALARM
END:VEVENT
END:VCALENDAR
```

### All-day event
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
DTSTART;VALUE=DATE:20250220
DTEND;VALUE=DATE:20250221
SUMMARY:Company Holiday
UID:b2c3d4e5-f6a7-8901-bcde-f12345678901@claude.ai
DTSTAMP:20250115T120000Z
TRANSP:TRANSPARENT
END:VEVENT
END:VCALENDAR
```

### Multi-day event
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
DTSTART;VALUE=DATE:20250310
DTEND;VALUE=DATE:20250313
SUMMARY:Team Offsite
DESCRIPTION:Annual team offsite in Austin
LOCATION:Austin\, TX
UID:c3d4e5f6-a7b8-9012-cdef-123456789012@claude.ai
DTSTAMP:20250115T120000Z
END:VEVENT
END:VCALENDAR
```

### Recurring weekly meeting with exceptions
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VTIMEZONE
TZID:America/New_York
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
DTSTART;TZID=America/New_York:20250107T100000
DTEND;TZID=America/New_York:20250107T103000
SUMMARY:1:1 with Manager
RRULE:FREQ=WEEKLY;BYDAY=TU;UNTIL=20250701T035959Z
EXDATE;TZID=America/New_York:20250218T100000
EXDATE;TZID=America/New_York:20250527T100000
UID:d4e5f6a7-b8c9-0123-defa-234567890123@claude.ai
DTSTAMP:20250115T120000Z
STATUS:CONFIRMED
BEGIN:VALARM
TRIGGER:-PT10M
ACTION:DISPLAY
DESCRIPTION:Reminder
END:VALARM
END:VEVENT
END:VCALENDAR
```

### Multiple events in one file
```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Claude//ICS Generator//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VTIMEZONE
TZID:America/New_York
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
TZNAME:EST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
TZNAME:EDT
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
DTSTART;TZID=America/New_York:20250120T090000
DTEND;TZID=America/New_York:20250120T091500
SUMMARY:Morning Standup
UID:e5f6a7b8-c9d0-1234-efab-345678901234@claude.ai
DTSTAMP:20250115T120000Z
BEGIN:VALARM
TRIGGER:-PT5M
ACTION:DISPLAY
DESCRIPTION:Reminder
END:VALARM
END:VEVENT
BEGIN:VEVENT
DTSTART;TZID=America/New_York:20250120T140000
DTEND;TZID=America/New_York:20250120T150000
SUMMARY:Design Review
LOCATION:Zoom
UID:f6a7b8c9-d0e1-2345-fabc-456789012345@claude.ai
DTSTAMP:20250115T120000Z
BEGIN:VALARM
TRIGGER:-PT15M
ACTION:DISPLAY
DESCRIPTION:Reminder
END:VALARM
END:VEVENT
END:VCALENDAR
```

## Reference

See [references/ics-format.md](references/ics-format.md) for complete property tables, full RRULE syntax, all timezone definitions, and the validation checklist.
