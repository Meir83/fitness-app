# Handoff: PUSH — Calisthenics App for Beginners (Android)

## Overview
PUSH is a calisthenics (bodyweight) training app aimed at **teenagers who are just starting to train**. It guides a beginner from onboarding through daily bodyweight workouts (push-ups, pull-up progressions, planks, dips, etc.), tracks streaks/XP/levels for motivation, and celebrates completed sessions. This package covers **8 screens** that form the core loop: onboarding → home → browse/library → active workout → rest → completion → progress, plus a profile screen.

Target platform: **Android phone** (designed at a 300×700 logical frame; production target is a standard Android viewport, e.g. ~412×892 dp). The aesthetic is "Direction A — PUSH": dark, energetic, gamified, single electric-lime accent.

## About the Design Files
The file in this bundle — `Workout App.dc.html` — is a **design reference created in HTML**. It is a prototype showing intended look, layout, copy, and motion. **It is not production code to copy directly.**

The task is to **recreate these designs in the target codebase's environment** using its established patterns and libraries. If building natively, that means Android (Jetpack Compose / Material 3) or React Native / Flutter as appropriate. If no environment exists yet, choose the most appropriate framework for an Android-first mobile app and implement the designs there. Use the HTML only to read exact colors, spacing, type, and behavior.

> Note: the HTML uses a canvas layout that places all 8 phone frames side-by-side for review. In the real app these are **separate screens/routes**, not one scrolling page.

## Fidelity
**High-fidelity (hifi).** Final colors, typography, spacing, and interaction intent are specified. Recreate the UI faithfully using the codebase's component library, matching the hex values, type ramp, and radii below. Exercise demo imagery is shown as **striped placeholders** — those are intentional slots for real assets (animated exercise demos / illustrations), not final art.

---

## Design Tokens

### Color
| Token | Hex | Use |
|---|---|---|
| `bg` | `#0E100D` | App background (near-black, warm green tint) |
| `surface` | `#181B16` | Cards, chips, list items |
| `surface-alt` | `#171A14` / `#1C2018` | Striped placeholder stripes |
| `track` | `#23271F` | Progress-bar tracks, inactive day cells, inactive chart bars |
| `track-muted` | `#3a4326` | "rest day" chart bars (dim lime-green) |
| `border` | `rgba(255,255,255,0.06–0.09)` | Hairline borders on cards/frames |
| `accent` | `#C9F24A` | Primary accent (electric lime) — CTAs, rings, active states, data |
| `accent-grad` | `linear-gradient(135deg,#C9F24A,#a8d633)` | Streak/celebration surfaces, avatar |
| `on-accent` | `#10140A` | Text/icons on lime |
| `on-accent-dim` | `#46580f` / `#2C3A0F` | Secondary text on lime |
| `text` | `#F3F5EF` | Primary text |
| `text-2` | `#C7CCC0` | Secondary text |
| `text-muted` | `#7E837A` | Tertiary/meta text |
| `text-disabled` | `#5A5F54` | Inactive nav icons/labels |

Single-accent system: lime is the only chromatic color. Everything else is the warm near-black neutral ramp. Do not introduce additional hues.

### Typography
Two families (Google Fonts):
- **Space Grotesk** — display/headings, big numbers, button labels, brand. Weights 500/600/**700**.
- **Hanken Grotesk** — body, labels, meta. Weights 400/500/**600**/700/800.

Type ramp (logical px at the 300-wide frame — scale proportionally to the real device width):
| Role | Family | Size | Weight | Notes |
|---|---|---|---|---|
| Screen title | Space Grotesk | 25–26 | 700 | e.g. "Library", "Progress", "What's your goal?" |
| Greeting | Space Grotesk | 25 | 700 | line-height 1.08 |
| Hero number (reps) | Space Grotesk | 62 | 700 | line-height 0.9 |
| Big number (streak) | Space Grotesk | 48 | 700 | |
| Timer | Space Grotesk | 50 | 700 | |
| Stat value | Space Grotesk | 19–20 | 700 | |
| Button label | Space Grotesk | 14–15 | 700 | |
| Body | Hanken Grotesk | 13 | 500–600 | |
| Meta / caption | Hanken Grotesk | 10–12 | 600 | |
| Overline | Hanken Grotesk | 10–11 | 700–800 | uppercase, letter-spacing 0.1–0.14em |
| Nav label | Hanken Grotesk | 9 | 600–700 | |

### Spacing
Screen horizontal padding: **18px** (20px on onboarding/complete). Vertical gaps between blocks: **13–14px**. Card inner padding: **14–17px**. Button padding: **13–15px** vertical.

### Radius
- Phone frame: `34px`
- Hero / large cards: `20–22px`
- Standard cards / chips containers: `14–18px`
- Pills / filter chips: `20px` (fully rounded)
- Small thumbnails / icon tiles: `9–11px`
- Progress-bar tracks: `3–4px`

### Shadow
- Frame: `0 30px 70px rgba(0,0,0,0.45)` (review-canvas only; not needed in-app)
- Glow on active streak dot: `0 0 7px → 16px #C9F24A` (pulsing, see motion)

### Iconography
Icons are minimal geometric primitives (circle, rounded square, diamond, ascending bars, chevron, X, checkmark, back arrow, gear, search). Replace with the codebase's icon set; keep them simple/monoline. Stroke weight ~1.5–1.8 at 14px.

---

## Bottom Navigation (shared)
4-tab gesture-style bar on Home, Library, Progress. Tabs: **Home / Train / Library / Progress**.
- Active: icon + label in `accent` `#C9F24A`.
- Inactive: icon outline + label in `text-disabled` `#5A5F54`.
- Top hairline border `rgba(255,255,255,0.07)`, padding `9px 14px 12px`.
- Icons: Home = rounded square; Train = circle; Library = rounded rect; Progress = 3 ascending bars.

**Active workout, Rest, Complete, Onboarding, and Profile have NO bottom nav** — they are focused/sub flows. Profile and the close-able screens use a top bar with a back arrow / close X instead.

Status bar (top of every screen): time `9:30` left; signal bars + battery right, in `text` color. This is OS chrome — use the real system status bar in production.

---

## Screens / Views

### 1. Onboarding (goal selection)
- **Purpose**: First-run. Pick a primary training goal to shape the plan.
- **Layout**: Vertical, 20px padding. Top row: "PUSH" wordmark (Space Grotesk 700, letter-spacing 0.16em, lime) + "Skip" (muted). Below: a **3-segment step indicator** (first segment lime & wide ~flex 2, rest `track`). Title "What's your goal?" (Space Grotesk 26/700). Subtitle (muted 13). Then a vertical list of **4 goal cards** (gap 11px). Sticky **Continue** button at bottom.
- **Goal cards**: row = `surface` bg, radius 16, padding 14, left icon tile (34px) + label (flex) + optional check. **Selected** card: bg `rgba(201,242,74,0.09)`, `1.5px solid #C9F24A` border, trailing 20px lime check circle with `#10140A` checkmark. Goals/copy: "Build real strength" (selected), "My first pull-up", "Get lean & athletic", "Build a daily habit". Icon tiles vary shape (square, ring, diamond, rounded outline).
- **Continue**: full-width lime, `#10140A` text, radius 16, label "Continue" + right-arrow (arrow nudges, see motion).

### 2. Home (dashboard)
- **Purpose**: Daily landing — resume/start today's workout, see streak & week.
- **Layout**: padding 18, gaps 14. Header row: left = overline date "TUE 24 JUN" + greeting "Let's go, Leo." (Space Grotesk 25/700); right = **level ring** (56px). Then streak chip → hero card → week strip. Bottom nav (Home active).
- **Level ring**: 56px circle, `conic-gradient(#C9F24A 0deg 232deg, #23271F 232deg 360deg)` with a 44px `bg` inner disc holding "L4" (Space Grotesk 16/700) + "ROOKIE" (7px overline muted).
- **Streak chip**: `surface`, radius 13, padding 10×13. Pulsing 8px lime dot + "12-day streak" + right-aligned "Best 18".
- **Hero card (today)**: full lime `#C9F24A`, radius 22, padding 17. Overline "TODAY · PUSH DAY" (`#46580f`). Title "Foundations Push" (Space Grotesk 23/700, `#10140A`). Meta row "6 moves / 28 min / Beginner". CTA: inner button bg `#10140A`, lime text, "Start workout" + nudging arrow.
- **Week strip**: header "This week" + "4 of 7". Row of 7 day cells (26px, radius 9): done = solid lime; today (Fri) = lime outline; future = `track`. Labels M T W T F S S.

### 3. Library (browse)
- **Purpose**: Browse skill paths and workouts; filter by category.
- **Layout**: padding 18, gaps 13. Title "Library". Search field (`surface`, radius 13, search icon + placeholder "Search moves & workouts"). **Filter chip row** (horizontal): "Skills" (active, lime/`#10140A`), "Push", "Pull", "Core" (inactive `surface` pills). Section "Skill paths": 2-up cards. Section "Workouts": vertical list. Bottom nav (Library active).
- **Skill-path card**: `surface`, radius 16. Top 64px striped placeholder. Body: title (e.g. "First Pull-up"), thin progress track with lime fill (First Pull-up 40%, Handstand 15%), "% there" caption.
- **Workout row**: `surface`, radius 14, padding 10. 46px striped thumb + title + "28 min · Beginner" meta + **difficulty pips** (3 dots, filled lime = level). Items: "Foundations Push" (1/3), "Core Crusher" (2/3).

### 4. Profile
- **Purpose**: Identity, level/XP, badges, and settings entry points.
- **Layout**: padding 18, gaps 14. Top bar: back arrow (left, in `surface` circle) + "Profile" + gear (right). Identity row: 62px lime-gradient avatar with initial "L" + name "Leo Martins" (Space Grotesk 19/700) + "Level 4 · Rookie" (lime) + "Joined Mar 2026" (muted). **XP card**: "Level 5 · Mover" + "320 / 500 XP" with lime fill bar at 64%. Stat triplet: Streak 12 / Workouts 38 / Badges 6. **Badges** row (5 circles): 3 earned (lime gradient) labeled "7-day / 100 reps / Early bird", 2 locked (dashed `#3a4034` outline) "Pull-up / 30-day". Settings list (`surface`, divided rows, chevrons): "My goal → Strength", "Reminders → 9:00 AM", "Account & settings". No bottom nav.

### 5. Active workout (in-progress)
- **Purpose**: Perform the current exercise set, log reps.
- **Layout**: padding 18, gaps 14. Top row: close X (`surface` circle) + "FOUNDATIONS PUSH" overline + elapsed timer "12:40" (lime). Workout progress: thin track 50% lime + "Move 3 of 6". **Demo area**: 188px striped placeholder labeled "PUSH-UP · DEMO" (slot for animated demo). Exercise name "Push-ups" (Space Grotesk 27/700) + "Set 2 of 3 · chest & triceps". **Big rep target**: "12" (Space Grotesk 62/700, lime, gently pulsing) + "reps". **Set tracker**: 3 equal tiles — Set 1 "12 ✓" (done), Set 2 "now" (lime filled = current), Set 3 "—" (pending). Footer: 54px "60s" rest button + full-width lime "Done — log set".

### 6. Rest timer
- **Purpose**: Timed rest between sets with a preview of what's next.
- **Layout**: centered column. Top row: close X + "FOUNDATIONS PUSH" overline. "REST" overline (lime, letter-spacing 0.2em). **Countdown ring**: 200px. SVG: track circle (`#23271F`, stroke 10) + lime progress circle (stroke 10, round caps, `stroke-dasharray:427`, rotated -90°, animating depletion). Center: "0:45" (Space Grotesk 50/700) + "until next set". Two equal buttons: "+15s" and "Skip" (`surface` outline). Bottom **"Up next"** card: 46px striped thumb + "UP NEXT" overline + "Incline rows · 10 reps".
- In production the ring should reflect the real remaining time; the 45s depletion is the visual model.

### 7. Workout complete (celebration)
- **Purpose**: Reward completion; show summary and streak bump.
- **Layout**: centered column, padding 20. **Badge**: 104px ring that draws on entry (lime over `track`), with a 54px lime disc + `#10140A` checkmark that pops in (~0.5s delay). Title "Workout complete!" (Space Grotesk 26/700, centered). Subtitle "Nice work, Leo. Foundations Push done." **Summary triplet**: Duration "26:40" / Total reps "132" / XP "+120" (XP value in lime). **Streak banner**: lime-gradient card, radius 16 — dark tile w/ pulsing lime dot + "Streak extended! / 12 → 13 days" + big "13". Footer: lime "Finish" + ghost (transparent, hairline border) "Share progress".

### 8. Progress & stats
- **Purpose**: Long-term motivation — streak, weekly volume, totals, PRs.
- **Layout**: padding 18, gaps 13. Title "Progress". **Streak hero**: lime-gradient card — "12" (Space Grotesk 48) + "DAY STREAK" + right side "Best 18" with 4 vertical marks (3 solid, 1 dim). **Weekly bar chart**: `surface` card titled "Reps this week", 78px tall, 7 bars (`flex-end` aligned columns, each column stretched to full height with `justify-content:flex-end`; bar height = % of column). Lime bars; rest days use `track-muted` `#3a4326`. Heights M→S: 42/65/50/30/88/55/20%. **Stat triplet**: Total reps "4,820" / Workouts "38" / Trained "10h". **Personal bests**: 3 labeled rows (Push-ups 24 @75%, Pull-ups 5 @30%, Plank 90s @60%) — label + lime fill track + value. Bottom nav (Progress active).

> **Chart-bar implementation note (important):** percentage-height/width bars must have a parent with a resolved size. In the HTML, each chart column is stretched (`align-self:stretch` + `justify-content:flex-end`) so the `%`-height bar resolves correctly. Reproduce that constraint in your layout system, or compute bar sizes from data directly.

---

## Interactions & Behavior
- **Navigation**: Onboarding → Home (after Continue). Home "Start workout" → Active. Active "Done — log set" advances set; after final set → Rest; Rest "Skip"/expiry → next move's Active; last move done → Workout complete. Complete "Finish" → Home (or Progress). Bottom-nav tabs switch top-level sections. Avatar/gear → Profile; back arrow returns.
- **Active workout state**: current move index (3/6), current set (2/3), per-set logged reps, elapsed time, rest duration.
- **Rest timer**: counts down real seconds; "+15s" adds time; "Skip" ends immediately; auto-advances at 0.
- **Streak logic**: increments on first completed workout of a day; "Best" tracks max. Completion screen shows `current → current+1`.
- **XP/levels**: workouts award XP (+120 shown); XP fills toward next level threshold (320/500); level label updates (Rookie → Mover…).

## Motion (micro-interactions)
All subtle; durations short; respect `prefers-reduced-motion`.
| Element | Animation | Spec |
|---|---|---|
| Active streak dot | `pushPulse` glow | box-shadow 7px↔16px lime, 2s ease-in-out infinite |
| Big rep number | `repPop` | scale 1↔1.045, 2.6s ease-in-out infinite |
| CTA arrows (Continue, Start) | `nudge` | translateX 0↔3px, 1.6s ease-in-out infinite |
| Rest ring | `ringDeplete` | stroke-dashoffset 0→427, 45s linear (drive from real time in prod) |
| Complete ring | `ringDraw` | stroke-dashoffset 427→0, ~1.1s ease-out, once |
| Complete checkmark | `popIn` | scale 0.4→1 + fade, 0.5s, 0.5s delay, once |

> The progress/skill **fill bars and chart bars are intentionally NOT animated from zero** — their size is their resting state. (A scale-from-0 load animation was deliberately removed because it can leave bars collapsed if the animation clock doesn't advance.) If you add an entrance animation, animate opacity or a wrapper, never the bar's own scale-from-0.

## State Management
Suggested state per area: `onboarding.selectedGoal`; `user {name, level, xp, xpToNext, streak, bestStreak, badges[], joinDate}`; `today {workout, moves[], durationEst}`; `session {moveIndex, setIndex, reps[], elapsedSec, restRemainingSec, status}`; `library {filter, skillPaths[], workouts[]}`; `progress {weeklyReps[7], totals, personalBests[]}`. Data fetching: today's plan, library catalog, and progress history would come from a backend/local store — all hard-coded in the prototype.

## Assets
- **No bitmap/vector art assets** are bundled. Every image area is a **striped placeholder** marked with a monospace label (e.g. "PUSH-UP · DEMO", workout/skill thumbs). These are slots for **real exercise demo media** (looping clips or illustrations) you'll supply. Avatar uses an initial on a lime gradient (swap for a real photo when available).
- **Fonts**: Space Grotesk + Hanken Grotesk (Google Fonts). Bundle equivalents or the platform's closest match.
- **Icons**: replace the inline primitive SVGs with your icon library.

## Files
- `Workout App.dc.html` — the full 8-screen hi-fi prototype (open in a browser to inspect exact values, copy, and motion). All 8 frames are laid out on one review canvas; treat each labeled frame (01 Onboarding … 08 Progress) as a separate screen.
