# ICS Format Specification

Complete reference for the iCalendar format (RFC 5545) used by the ICS Generator skill.

## Table of Contents

1. [VCALENDAR Properties](#1-vcalendar-properties)
2. [VEVENT Properties](#2-vevent-properties)
3. [VALARM Properties](#3-valarm-properties)
4. [VTIMEZONE Properties](#4-vtimezone-properties)
5. [RRULE Syntax](#5-rrule-syntax)
6. [ATTENDEE and ORGANIZER](#6-attendee-and-organizer)
7. [UID Generation](#7-uid-generation)
8. [Timezone Definitions](#8-timezone-definitions)
9. [Validation Checklist](#9-validation-checklist)

---

## 1. VCALENDAR Properties

| Property | Required | Value | Description |
|----------|----------|-------|-------------|
| `VERSION` | Yes | `2.0` | iCalendar version |
| `PRODID` | Yes | `-//Claude//ICS Generator//EN` | Product identifier |
| `CALSCALE` | No | `GREGORIAN` | Calendar scale (default) |
| `METHOD` | No | `PUBLISH`, `REQUEST`, `REPLY`, `CANCEL` | iTIP method |

### METHOD values
- `PUBLISH` — Default. Publishing events (no scheduling)
- `REQUEST` — Sending a meeting request to attendees
- `REPLY` — Responding to a meeting request
- `CANCEL` — Cancelling a previously sent request

---

## 2. VEVENT Properties

### Required Properties

| Property | Format | Description |
|----------|--------|-------------|
| `DTSTART` | See Date/Time formats | Event start |
| `DTEND` or `DURATION` | See Date/Time / Duration formats | Event end |
| `SUMMARY` | Free text (escaped) | Event title |
| `UID` | `<uuid4>@claude.ai` | Globally unique identifier |
| `DTSTAMP` | `YYYYMMDDTHHMMSSZ` (UTC) | Timestamp of creation |

### Optional Properties

| Property | Format | Description |
|----------|--------|-------------|
| `DESCRIPTION` | Free text (escaped) | Event body/notes |
| `LOCATION` | Free text (escaped) | Event location |
| `GEO` | `lat;lon` | Geographic coordinates |
| `URL` | URI | Related URL |
| `ORGANIZER` | `mailto:` URI with params | Event organizer |
| `ATTENDEE` | `mailto:` URI with params | Invited attendee (repeatable) |
| `STATUS` | `CONFIRMED`, `TENTATIVE`, `CANCELLED` | Event status |
| `TRANSP` | `OPAQUE`, `TRANSPARENT` | Time transparency (busy/free) |
| `CLASS` | `PUBLIC`, `PRIVATE`, `CONFIDENTIAL` | Access classification |
| `CATEGORIES` | Comma-separated text | Event categories |
| `PRIORITY` | `0`-`9` | Priority (1=highest, 9=lowest, 0=undefined) |
| `SEQUENCE` | Integer | Revision sequence number |
| `CREATED` | `YYYYMMDDTHHMMSSZ` | Date event was created |
| `LAST-MODIFIED` | `YYYYMMDDTHHMMSSZ` | Date event was last modified |
| `RRULE` | Recurrence rule | Recurrence pattern |
| `EXDATE` | Date/time list | Excluded recurrence dates |
| `RDATE` | Date/time list | Additional recurrence dates |
| `RECURRENCE-ID` | Date/time | Identifies a specific recurrence instance |

### Date/Time Formats

| Type | Format | Example |
|------|--------|---------|
| Local with timezone | `DTSTART;TZID=<tz>:YYYYMMDDTHHMMSS` | `DTSTART;TZID=America/New_York:20250115T140000` |
| All-day | `DTSTART;VALUE=DATE:YYYYMMDD` | `DTSTART;VALUE=DATE:20250115` |
| UTC | `DTSTART:YYYYMMDDTHHMMSSZ` | `DTSTART:20250115T190000Z` |

### Duration Format

```
P[n]W                    → weeks
P[n]D                    → days
PT[n]H                   → hours
PT[n]M                   → minutes
PT[n]S                   → seconds
P[n]DT[n]H[n]M[n]S      → combined
```

| Example | Meaning |
|---------|---------|
| `PT30M` | 30 minutes |
| `PT1H` | 1 hour |
| `PT1H30M` | 1 hour 30 minutes |
| `PT2H15M` | 2 hours 15 minutes |
| `P1D` | 1 day |
| `P1W` | 1 week |
| `P1DT2H` | 1 day and 2 hours |

### STATUS Values

| Value | Description |
|-------|-------------|
| `CONFIRMED` | Event is confirmed |
| `TENTATIVE` | Event is tentative |
| `CANCELLED` | Event has been cancelled |

---

## 3. VALARM Properties

Alarms are nested inside VEVENT blocks.

| Property | Required | Format | Description |
|----------|----------|--------|-------------|
| `ACTION` | Yes | `DISPLAY`, `AUDIO`, `EMAIL` | Alarm type |
| `TRIGGER` | Yes | Duration (relative) or `VALUE=DATE-TIME` (absolute) | When to trigger |
| `DESCRIPTION` | Yes (for DISPLAY) | Free text | Alarm message |
| `SUMMARY` | For EMAIL | Free text | Email subject |
| `ATTENDEE` | For EMAIL | `mailto:` URI | Email recipient |
| `REPEAT` | No | Integer | Number of additional repeats |
| `DURATION` | With REPEAT | Duration | Interval between repeats |

### TRIGGER formats

| Type | Format | Example |
|------|--------|---------|
| Before event | `-P<duration>` | `TRIGGER:-PT15M` |
| After event start | `P<duration>` | `TRIGGER:PT0S` (at start) |
| Absolute | `TRIGGER;VALUE=DATE-TIME:YYYYMMDDTHHMMSSZ` | `TRIGGER;VALUE=DATE-TIME:20250115T130000Z` |

### Multiple alarms

You can include multiple VALARM blocks in a single VEVENT:
```
BEGIN:VALARM
TRIGGER:-P1D
ACTION:DISPLAY
DESCRIPTION:Event tomorrow
END:VALARM
BEGIN:VALARM
TRIGGER:-PT15M
ACTION:DISPLAY
DESCRIPTION:Event starting soon
END:VALARM
```

---

## 4. VTIMEZONE Properties

### Structure

```
BEGIN:VTIMEZONE
TZID:<timezone-id>
BEGIN:STANDARD
DTSTART:<transition-date>
RRULE:<annual-recurrence>
TZOFFSETFROM:<offset-before>
TZOFFSETTO:<offset-after>
TZNAME:<abbreviation>
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:<transition-date>
RRULE:<annual-recurrence>
TZOFFSETFROM:<offset-before>
TZOFFSETTO:<offset-after>
TZNAME:<abbreviation>
END:DAYLIGHT
END:VTIMEZONE
```

### VTIMEZONE Sub-Properties

| Property | Required | Description |
|----------|----------|-------------|
| `TZID` | Yes | Timezone identifier (e.g., `America/New_York`) |
| `DTSTART` | Yes | Date/time of transition start |
| `RRULE` | No | Annual recurrence of transition |
| `TZOFFSETFROM` | Yes | UTC offset before transition |
| `TZOFFSETTO` | Yes | UTC offset after transition |
| `TZNAME` | No | Abbreviation (e.g., `EST`, `EDT`) |

---

## 5. RRULE Syntax

### Full syntax
```
RRULE:FREQ=<freq>;INTERVAL=<n>;COUNT=<n>;UNTIL=<datetime>;BYDAY=<days>;
  BYMONTH=<months>;BYMONTHDAY=<days>;BYHOUR=<hours>;BYMINUTE=<mins>;
  BYSETPOS=<pos>;WKST=<day>
```

### Parameters

| Parameter | Values | Description |
|-----------|--------|-------------|
| `FREQ` | `SECONDLY`, `MINUTELY`, `HOURLY`, `DAILY`, `WEEKLY`, `MONTHLY`, `YEARLY` | Recurrence frequency (required) |
| `INTERVAL` | Positive integer | Interval between recurrences (default: 1) |
| `COUNT` | Positive integer | Total number of occurrences |
| `UNTIL` | UTC datetime (`YYYYMMDDTHHMMSSZ`) | End date for recurrence (exclusive with COUNT) |
| `BYDAY` | `SU`, `MO`, `TU`, `WE`, `TH`, `FR`, `SA` (comma-separated) | Days of the week |
| `BYMONTHDAY` | 1-31 or -1 to -31 | Days of the month |
| `BYMONTH` | 1-12 (comma-separated) | Months of the year |
| `BYHOUR` | 0-23 (comma-separated) | Hours of the day |
| `BYMINUTE` | 0-59 (comma-separated) | Minutes of the hour |
| `BYSETPOS` | Integer (1-366 or -1 to -366) | Position in set (e.g., -1 for "last") |
| `WKST` | `SU`, `MO` | Week start day (default: `MO`) |

### BYDAY with ordinal prefix (MONTHLY/YEARLY only)

| Value | Meaning |
|-------|---------|
| `1MO` | First Monday |
| `2TU` | Second Tuesday |
| `3WE` | Third Wednesday |
| `4TH` | Fourth Thursday |
| `-1FR` | Last Friday |
| `-2SA` | Second-to-last Saturday |

### Pattern Examples

| Description | RRULE |
|-------------|-------|
| Every day | `FREQ=DAILY` |
| Every 3 days | `FREQ=DAILY;INTERVAL=3` |
| Every weekday (M-F) | `FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR` |
| Every week on Monday | `FREQ=WEEKLY;BYDAY=MO` |
| Every 2 weeks on Tuesday and Thursday | `FREQ=WEEKLY;INTERVAL=2;BYDAY=TU,TH` |
| Every month on the 15th | `FREQ=MONTHLY;BYMONTHDAY=15` |
| Every month on the 1st and 15th | `FREQ=MONTHLY;BYMONTHDAY=1,15` |
| First Monday of every month | `FREQ=MONTHLY;BYDAY=1MO` |
| Last Friday of every month | `FREQ=MONTHLY;BYDAY=-1FR` |
| Second Tuesday of every month | `FREQ=MONTHLY;BYDAY=2TU` |
| Every 3 months (quarterly) | `FREQ=MONTHLY;INTERVAL=3` |
| Every year on March 15 | `FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15` |
| Every year on the last day of the month | `FREQ=MONTHLY;BYMONTHDAY=-1` |
| Every 2 weeks for 10 times | `FREQ=WEEKLY;INTERVAL=2;COUNT=10` |
| Every week until June 30, 2025 | `FREQ=WEEKLY;UNTIL=20250630T235959Z` |
| Mon/Wed/Fri every week | `FREQ=WEEKLY;BYDAY=MO,WE,FR` |

### EXDATE — Exclude Specific Occurrences

Exclude individual dates from a recurring event:
```
EXDATE;TZID=America/New_York:20250218T100000
EXDATE;TZID=America/New_York:20250527T100000
```

Or comma-separated on one line:
```
EXDATE;TZID=America/New_York:20250218T100000,20250527T100000
```

For all-day recurring events:
```
EXDATE;VALUE=DATE:20250218
```

### RDATE — Add Extra Occurrences

Add occurrences that don't fit the RRULE pattern:
```
RDATE;TZID=America/New_York:20250305T100000
```

---

## 6. ATTENDEE and ORGANIZER

### ORGANIZER
```
ORGANIZER;CN=John Doe:mailto:john@example.com
```

### ATTENDEE Parameters

| Parameter | Values | Description |
|-----------|--------|-------------|
| `CN` | Display name | Common name |
| `ROLE` | `CHAIR`, `REQ-PARTICIPANT`, `OPT-PARTICIPANT`, `NON-PARTICIPANT` | Role in event |
| `PARTSTAT` | `NEEDS-ACTION`, `ACCEPTED`, `DECLINED`, `TENTATIVE`, `DELEGATED` | Participation status |
| `RSVP` | `TRUE`, `FALSE` | Request RSVP |
| `CUTYPE` | `INDIVIDUAL`, `GROUP`, `RESOURCE`, `ROOM`, `UNKNOWN` | Calendar user type |
| `DELEGATED-FROM` | `mailto:` URI | Delegated from |
| `DELEGATED-TO` | `mailto:` URI | Delegated to |
| `MEMBER` | `mailto:` URI | Group membership |
| `DIR` | URI | Directory entry |
| `SENT-BY` | `mailto:` URI | Sent on behalf of |

### Full ATTENDEE Examples

Required participant:
```
ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;
 CN=Jane Smith:mailto:jane@example.com
```

Optional participant:
```
ATTENDEE;ROLE=OPT-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;
 CN=Bob Jones:mailto:bob@example.com
```

Room resource:
```
ATTENDEE;CUTYPE=ROOM;ROLE=NON-PARTICIPANT;PARTSTAT=ACCEPTED;
 CN=Conference Room A:mailto:room-a@example.com
```

Already accepted:
```
ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;
 CN=Alice Brown:mailto:alice@example.com
```

---

## 7. UID Generation

Every VEVENT must have a globally unique UID. Use UUID v4 format with the `@claude.ai` domain:

```
UID:<uuid-v4>@claude.ai
```

### Strategy
- Generate a fresh UUID v4 for each event
- Never reuse UIDs across events
- The `@claude.ai` domain suffix ensures global uniqueness
- For multiple events in one file, each event gets its own UID

### Examples
```
UID:550e8400-e29b-41d4-a716-446655440000@claude.ai
UID:6ba7b810-9dad-11d1-80b4-00c04fd430c8@claude.ai
UID:f47ac10b-58cc-4372-a567-0e02b2c3d479@claude.ai
```

---

## 8. Timezone Definitions

Include the appropriate VTIMEZONE block for any timezone referenced in event properties. Place all VTIMEZONE blocks before any VEVENT blocks.

### US Timezones

#### America/New_York (Eastern)
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

#### America/Chicago (Central)
```
BEGIN:VTIMEZONE
TZID:America/Chicago
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0500
TZOFFSETTO:-0600
TZNAME:CST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0600
TZOFFSETTO:-0500
TZNAME:CDT
END:DAYLIGHT
END:VTIMEZONE
```

#### America/Denver (Mountain)
```
BEGIN:VTIMEZONE
TZID:America/Denver
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0600
TZOFFSETTO:-0700
TZNAME:MST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0700
TZOFFSETTO:-0600
TZNAME:MDT
END:DAYLIGHT
END:VTIMEZONE
```

#### America/Los_Angeles (Pacific)
```
BEGIN:VTIMEZONE
TZID:America/Los_Angeles
BEGIN:STANDARD
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0700
TZOFFSETTO:-0800
TZNAME:PST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0800
TZOFFSETTO:-0700
TZNAME:PDT
END:DAYLIGHT
END:VTIMEZONE
```

#### America/Phoenix (Arizona — no DST)
```
BEGIN:VTIMEZONE
TZID:America/Phoenix
BEGIN:STANDARD
DTSTART:19700101T000000
TZOFFSETFROM:-0700
TZOFFSETTO:-0700
TZNAME:MST
END:STANDARD
END:VTIMEZONE
```

#### Pacific/Honolulu (Hawaii — no DST)
```
BEGIN:VTIMEZONE
TZID:Pacific/Honolulu
BEGIN:STANDARD
DTSTART:19700101T000000
TZOFFSETFROM:-1000
TZOFFSETTO:-1000
TZNAME:HST
END:STANDARD
END:VTIMEZONE
```

### International Timezones

#### Europe/London (GMT/BST)
```
BEGIN:VTIMEZONE
TZID:Europe/London
BEGIN:STANDARD
DTSTART:19701025T020000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
TZOFFSETFROM:+0100
TZOFFSETTO:+0000
TZNAME:GMT
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700329T010000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
TZOFFSETFROM:+0000
TZOFFSETTO:+0100
TZNAME:BST
END:DAYLIGHT
END:VTIMEZONE
```

#### Europe/Paris (CET/CEST)
```
BEGIN:VTIMEZONE
TZID:Europe/Paris
BEGIN:STANDARD
DTSTART:19701025T030000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
TZNAME:CET
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:19700329T020000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:CEST
END:DAYLIGHT
END:VTIMEZONE
```

#### Asia/Tokyo (JST — no DST)
```
BEGIN:VTIMEZONE
TZID:Asia/Tokyo
BEGIN:STANDARD
DTSTART:19700101T000000
TZOFFSETFROM:+0900
TZOFFSETTO:+0900
TZNAME:JST
END:STANDARD
END:VTIMEZONE
```

---

## 9. Validation Checklist

Before writing any `.ics` file, verify all of the following:

### File Structure
1. File begins with `BEGIN:VCALENDAR` and ends with `END:VCALENDAR`
2. `VERSION:2.0` is present
3. `PRODID:-//Claude//ICS Generator//EN` is present
4. All VTIMEZONE blocks appear before VEVENT blocks
5. Every `BEGIN:` has a matching `END:`

### Event Properties
6. Every VEVENT has a unique `UID` in the format `<uuid4>@claude.ai`
7. Every VEVENT has `DTSTAMP` set to current UTC time
8. Every VEVENT has `DTSTART`
9. Every VEVENT has either `DTEND` or `DURATION` (not both)
10. `DTEND` is after `DTSTART`
11. All-day events use `VALUE=DATE` format (no time component)
12. All-day `DTEND` is exclusive (day after the last day of the event)

### Timezone
13. Every `TZID` referenced in event properties has a matching VTIMEZONE block
14. Default timezone is `America/New_York` unless user specified otherwise

### Formatting
15. Text values are properly escaped (`\\`, `\;`, `\,`, `\n`)
16. No blank lines between properties within a component
17. Lines do not exceed 75 octets (fold if necessary)
18. `UNTIL` values in RRULE use UTC format with `Z` suffix
