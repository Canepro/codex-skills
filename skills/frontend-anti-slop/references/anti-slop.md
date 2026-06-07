# Frontend Anti-Slop Reference

Use this reference when a UI feels generic, overdecorated, or model-generated. It is a catalogue of patterns to challenge, not a rigid style guide.

## Core Test

Ask:

- What is the user trying to decide or do here?
- Does the layout make that easier?
- Does each visual surface carry product meaning?
- Would this still work with real data, long labels, empty states, errors, and mobile width?
- Does the existing design system already have a better answer?

If the UI choice cannot answer those questions, remove or simplify it.

## Common AI UI Failure Modes

### Decorative Structure

- hero sections inside operational screens
- floating shells around sidebars or page content
- cards inside cards
- right rails that repeat summary content
- metric grids without a task model
- fake charts used to fill space
- activity feeds without actionable content
- empty panels kept for symmetry

### Visual Noise

- glows, blur haze, glass panels, dramatic shadows, and gradient borders used as default styling
- pill-shaped controls repeated across every control type
- oversized radii on cards, buttons, panels, and inputs at the same time
- decorative badges on ordinary labels
- icon backgrounds on every small action
- hover movement that shifts layout or draws attention without adding clarity

### Weak Information Hierarchy

- every panel has equal weight
- headings describe mood instead of function
- secondary copy explains obvious UI behavior
- primary actions are visually quieter than decorative status
- data labels and values are hard to compare
- charts, counters, and tables do not share a clear reading order

### Generic Product Voice

- "command center", "live pulse", "operational clarity", "unlock insights", or similar mood labels without product meaning
- section notes that explain the UI instead of the domain
- empty-state copy that reassures instead of giving the next action
- onboarding copy that promises value before the UI proves it

## Better Defaults

- Use layout to expose the workflow, not to show design effort.
- Prefer one strong content area over many equal panels.
- Use tables and lists for comparison. Use cards for repeated objects with meaningful boundaries.
- Keep headings functional: object, state, action, or decision.
- Put controls near the state they affect.
- Make empty states honest: what happened, why, what to do next.
- Make destructive or sensitive actions visually and spatially distinct.
- Use color to encode state or hierarchy, not to decorate all surfaces.
- Keep animation short, local, and explanatory.

## Modern Layout Guidance

- Use intrinsic layout first: grid, flex, minmax, clamp, aspect-ratio, and sane min/max widths.
- Use container queries when a component must adapt to the space its parent gives it.
- Avoid viewport-only breakpoints for reusable components.
- Give fixed-format UI stable dimensions so labels, hover states, loading states, or data changes do not resize the layout unexpectedly.
- Design overflow intentionally for tables, tabs, filters, and toolbars.
- Test narrow, common laptop, and wide desktop widths before calling the layout done.

## Accessibility And Interaction

- Preserve visible focus and keyboard reachability.
- Keep targets large enough for pointer and touch use.
- Use text or structure as well as color for state.
- Check contrast before treating a palette as acceptable.
- Keep forms predictable: clear labels, local errors, and specific recovery actions.
- Avoid heavy animations, rerenders, and client work on frequent interactions.

## Palette Guidance

Do not ban a color family globally. Judge whether the palette fits the product and has enough contrast.

Challenge:
- default blue-purple SaaS gradients
- dark navy dashboards with cyan accents used without product reason
- beige or cream themes used as fake warmth
- one-accent UIs where every element competes
- muted text that looks refined but fails readability

Prefer:
- product-owned tokens
- restrained accent use
- clear state colors
- enough neutral contrast for long sessions
- palettes that work in real lighting and on lower-quality displays

## Implementation Checklist

Before finishing:

- The primary task is clearer than before.
- The layout works at desktop and mobile widths.
- No meaningful text overlaps or clips.
- Dynamic content has a planned layout path.
- Focus, contrast, labels, and target size have been checked.
- There is no fake data or filler UI unless explicitly marked as mock content.
- The change fits the existing component system.

## Concrete Defaults

Use these when the existing system gives no answer. They are conservative and rarely wrong. Override when the product calls for it.

### Spacing

- Scale: 4, 8, 12, 16, 24, 32, 48
- Pick one base unit (usually 4 or 8) and stay on it
- Section padding on dashboards: 16 to 24
- Card padding: 16 to 24
- Form field vertical gap: 12 to 16

### Radii

- 4 to 8px for most surfaces
- Same role, same radius (do not mix 4px buttons with 16px buttons)
- 0px is also a valid choice for tables, sidebars, and dense work surfaces
- Reserve 12 to 16px for marketing or empty-state surfaces, not operational UI

### Typography

- Body: 14px, line-height 1.5
- Label: 12 to 13px, line-height 1.4
- Section heading: 16 to 18px, line-height 1.3
- Page title: 20 to 24px, line-height 1.2
- Bump higher only on marketing or empty-state surfaces
- Max two weights per surface (regular and semibold is enough)

### Component Heights

- Form controls: 32 to 40px
- Buttons: match the form controls in the same group
- Table rows: 36 to 44px
- Toolbar height: 40 to 48px

### Color

- One accent for primary action
- One color for destructive
- State colors (success, warning, info, danger) used only where state changes meaning
- Neutral text on neutral background, no decorative tint on body text

### Motion

- 150 to 200ms on frequent interactions
- ease-out for entrances, ease-in for exits
- Opacity and transform only on hover, click, focus
- Never animate margin, width, or anything that triggers layout

### Shadow

- One elevation level per page when possible
- Two is the cap
- No shadow on dense surfaces (tables, sidebars, toolbars)

### Content Width

- Prose: about 72ch
- Forms: 480 to 640px
- Data tables: full width with horizontal scroll for overflow

## Bad-To-Good Library

These are the surfaces where AI-generated UI most often defaults to slop. Each entry shows the templated version and the version with the AI tells removed. Use them as pattern matches, not as required output.

### Dashboard Header

Bad:
```
[gradient banner] Good morning, Vincent!
Here is what is happening across your account today.
[8 metric cards in a 4x2 grid, equal weight, all with sparklines]
```

Good:
```
Inbox  ·  87 open  ·  3 escalated      [New ticket]
[real list of open tickets, sortable, with status, owner, age]
```

Why: the dashboard's job is "what needs my attention now," not "make me feel welcome." Lead with the work.

### Empty State

Bad:
```
Nothing here yet!
Your workspace is ready for action. Start building something amazing.
[decorative illustration]
```

Good:
```
No tickets assigned to you.
[Create ticket]   [Pick from queue]
```

Why: empty states should explain what is empty and offer the next action.

### Settings Page

Bad:
```
[card] Account Settings [icon]
  [nested card] Profile
    [field] Name
  [nested card] Email
```

Good:
```
Settings
  Profile
    Name           [____________]   Save
    Email          [____________]   Save
  Notifications
    Email digest   [toggle]
    Push           [toggle]
```

Why: settings are forms. Cards inside cards is hierarchy debt, not structure.

### List Or Table

Bad:
```
[card] [card] [card] [card] [card]
(each row is a card with shadow, padding, hover-lift, icon background)
```

Good:
```
| Status | Title              | Owner    | Updated |
| ------ | ------------------ | -------- | ------- |
| Open   | Login fails on iOS | M. Diaz  | 2h ago  |
```

Why: comparison work calls for tables. Cards belong to repeated objects with rich content, not to rows in a list.

### Form

Bad:
```
[wide card] Tell us about yourself
  Your name (this helps us personalize your experience)
  [extra-tall input with 16px radius]
  Your email (we will never spam you, promise)
  [extra-tall input]
  [pill button] Continue your journey
```

Good:
```
Name      [_________________]
Email     [_________________]
                     [Cancel] [Save]
```

Why: forms should be quiet. Labels above inputs, predictable spacing, one primary action.

### Confirmation Modal

Bad:
```
[centered modal with backdrop blur, oversized header, large icon top-left]
Are you absolutely sure you want to do this?
This action cannot be undone, and we want to make sure you have considered it.
[Cancel]                                          [I understand, delete it]
```

Good:
```
Delete project "billing-api"?
This removes 12 services and 4 dashboards. Cannot be undone.
                                                [Cancel]  [Delete]
```

Why: confirmations should state the concrete consequence and end with a verb-led button.

### Sidebar Navigation

Bad:
```
[gradient sidebar]
  ✨ Dashboard
  📊 Analytics
  💬 Messages (12)
  🎯 Goals
  ⚙️ Settings
```

Good:
```
Dashboard
Tickets        87
Customers
Reports
Settings
```

Why: emoji icons add noise without aiding scan. Counts only where they encode real state.

### Loading State

Bad:
```
[centered spinner] Loading your amazing dashboard...
```

Good:
```
[skeleton rows matching the table that will appear]
```

Why: skeletons preserve layout, prevent jump, and tell the user what is coming. Spinners with copy are filler.

### Toast Or Success Notification

Bad:
```
[gradient toast top-right] Awesome! Your changes have been saved successfully!
```

Good:
```
Saved.   Undo
```

Why: success notifications should be small, neutral, and offer an action when one makes sense.

### Page With Tabs

Bad:
```
[card]
  [pill tab group, 16px radius] Overview | Activity | Settings
  [content area inside another card]
```

Good:
```
Overview  Activity  Settings
─────────
content
```

Why: tabs are navigation. A stack of cards around tabs hides the structure tabs already provide.

## Reference Products For Restrained UI

When you need a mental model for restrained, work-first design, look at the default views (not marketing pages) of products like Linear, Stripe Dashboard, Vercel Dashboard, GitHub, and Notion. They favor density over decoration, tables over cards, and copy that names the work rather than greeting the user.

These are reference points for the shape, not for the brand. Borrow the restraint, not the palette.
