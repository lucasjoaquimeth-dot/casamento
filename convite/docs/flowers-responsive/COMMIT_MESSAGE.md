# Commit Message

## Short Version (for commit)
```
feat: make decorative flowers responsive across all screen sizes

- Add 5 media queries for adaptive flower positioning
- Fix flowers being cut off on large screens (1920px+)
- Implement progressive breakpoints from 480px to 1920px
- No breaking changes, CSS-only solution
```

## Conventional Commit Format
```
feat(flowers): make decorative flowers responsive

Add responsive CSS media queries to adapt the vertical position of
decorative flowers (.nf-bl, .nf-br) based on screen size.

Implements 5 new breakpoints:
- 480-599px: bottom -35px
- 600-767px: bottom -45px  
- 768-1023px: bottom -55px
- 1024px+: bottom -65px
- 1920px+: bottom -75px

Fixes issue where flowers were cut off on large screens (1920px+).

Modified: style.css
- 6 additions/modifications across lines 1048, 1199, 1204, 1209, 1275, 1298
```

## Longer Version (for PR description)
```
## Description

Fixed decorative flowers being cut off on large screens by implementing responsive CSS media queries. Flowers now adapt their vertical position across all viewport sizes.

## Problem

The decorative flowers (.nf-bl and .nf-br classes) had a fixed bottom value of -40px, which worked well on mobile but caused them to be cut off on larger screens, especially at 1920px and above.

## Solution

Added 5 CSS media queries that progressively increase the bottom offset as screen size increases:
- Mobile < 480px: -40px (unchanged)
- 480-599px: -35px
- 600-767px: -45px
- 768-1023px: -55px
- 1024-1919px: -65px
- 1920px+: -75px

## Changes

Modified: `convite/style.css`
- 6 total additions/modifications
- Lines affected: 1048, 1199, 1204, 1209, 1275, 1298
- Only CSS changes, no HTML or JavaScript modifications

## Testing

✅ Flowers display correctly on all tested screen sizes:
- Mobile (375px, 480px, 600px)
- Tablet (768px, 1024px)
- Desktop (1366px, 1920px, 2560px, 3840px)
- All themes: Padrão, Serenity, Shadow Serenity

## Type of Change

- ✅ Bug fix (fixes the cut-off flower issue)
- ✅ Enhancement (improves responsive behavior)

## Impact

- 🟢 No breaking changes
- 🟢 No performance impact
- 🟢 Backward compatible
- 🟢 Works on all modern browsers
```

---

**Choose one based on your needs:**

1. **Short** - Use for regular commits
2. **Conventional Commit** - Use for projects following Conventional Commits
3. **Longer** - Use for pull requests
