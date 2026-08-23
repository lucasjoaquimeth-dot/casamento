# Header Responsivity Test Guide

## Quick Testing Instructions

### 1. **Open the Site**
```
Open convite/index.html in a modern web browser
```

### 2. **Test Different Screen Sizes**
Use Chrome DevTools or Firefox DevTools to test responsive design:

#### **Ultra-Wide Desktop (1920px+)**
- Resize browser to 1920px or wider
- **Expected:**
  - Large, bold header with plenty of spacing
  - Theme button with full "Tema" label visible
  - Decorative flowers prominent
  - Header padding comfortable (14px top/bottom, 40px sides)

#### **Desktop (1024px–1919px)**
- Resize browser to 1200px
- **Expected:**
  - Good spacing, readable text
  - Theme button with "Tema" label visible
  - Medium-sized flowers
  - Gap between "Mayane & Lucas" and date: 18px

#### **Tablets (768px–1023px)**
- Resize browser to 900px
- **Expected:**
  - Still comfortable to read
  - Theme button with "Tema" label visible
  - Fonts scale smoothly
  - No text overlap with button

#### **Large Smartphones (600px–767px)**
- Resize browser to 700px
- **Expected:**
  - Header text still readable
  - Theme button with label: "Tema" visible
  - Button positioned cleanly without overlap
  - Smaller fonts, tighter spacing

#### **Medium Smartphones (480px–599px)**
- Resize browser to 540px
- **Expected:**
  - **Theme button label disappears** (shows icon only)
  - Icon still clickable and visible
  - Header text compact but readable
  - Text does NOT overlap with button

#### **Small Smartphones (≤479px)**
- Resize browser to 375px
- **Expected:**
  - **Very compact header**
  - Theme button is **icon-only** (just the 4 dots)
  - Text sizes minimized
  - No overlap between any elements
  - Separator line thinner

### 3. **Test Theme Toggle Button**
- Click the theme button at each breakpoint
- **Expected:**
  - Button rotates smoothly
  - Theme changes apply
  - Button remains visible and clickable
  - No overlap with "Mayane & Lucas" text

### 4. **Test Scroll Behavior**
- Scroll down the page at multiple breakpoints
- **Expected:**
  - Header stays fixed at top
  - Header does not get cut off
  - All content visible below header
  - Button remains accessible

### 5. **Test All Three Themes**
Click theme button multiple times to cycle through:
- **Default** (blue tones)
- **Serenity** (soft blue-grays)
- **Shadow Serenity** (dark theme)

**Expected for each theme:**
- Responsive rules apply equally
- No overlap issues
- Colors/theme apply correctly
- Button visibility consistent

### 6. **Test Flower Animations**
Hover over the flowers in the header corners
- **Expected:**
  - Flowers scale smoothly
  - Animation smooth across all breakpoints
  - No jittering or overlap with text

### 7. **Browser DevTools Checklist**

#### Chrome DevTools:
```
1. Open DevTools (F12)
2. Click Toggle Device Toolbar (Ctrl+Shift+M)
3. Test each preset:
   - iPhone SE (375px)
   - iPhone 12 (390px)
   - iPad (768px)
   - iPad Pro (1024px)
4. Manually test other widths: 480px, 600px, 900px, 1200px, 1920px
```

#### Firefox DevTools:
```
1. Open DevTools (F12)
2. Click Responsive Design Mode (Ctrl+Shift+M)
3. Test with Edit Type dropdown
```

### 8. **Specific Issues to Watch For**

❌ **Problem: Theme button overlaps "Mayane & Lucas" text**
- Solution: Should never happen now due to `padding-right: calc(24px + button-space)`
- If occurs: Check if header's `padding-right` is being overridden

❌ **Problem: Header gets cut off when scrolling**
- Solution: Header has `position: fixed; top: 0; left: 0; right: 0;`
- If occurs: Check for z-index conflicts

❌ **Problem: Theme label shows when it shouldn't (mobile)**
- Solution: Should be `display: none` on breakpoints ≤599px
- If occurs: Check media query specificity

❌ **Problem: Text sizes too large on mobile**
- Solution: Use `clamp(min, fluid, max)` for scaling
- If occurs: Check clamp values are correct

## Desktop Testing at Specific Breakpoints

### Command Line (VS Code Terminal):
```bash
# No command needed - just use browser DevTools

# Or test in browser console:
# getComputedStyle(document.querySelector('.site-header-name')).fontSize
```

## Expected Font Sizes (samples)

| Breakpoint | Device | Header Name | Header Date | Button |
|------------|--------|-------------|-------------|--------|
| 320px | iPhone SE | 18px | 7px | 6px (icon only) |
| 480px | Galaxy S21 | 20px | 8px | 7px (icon only) |
| 600px | iPad Mini | 24px | 9px | 8px + label |
| 768px | iPad | 26px | 10px | 9px + label |
| 1024px | iPad Pro | 28px | 11px | 10px + label |
| 1920px | 4K Monitor | 32px | 12px | 11px + label |

## Notes

- **clamp() function**: `clamp(min, fluid, max)` ensures smooth scaling
  - Min: Smallest acceptable size
  - Fluid: Percentage of viewport (vw)
  - Max: Largest acceptable size

- **Absolute Positioning**: Theme button uses `position: absolute; right: Xpx;`
  - This prevents text reflow
  - Header padding reserves space

- **Responsive Padding**: `calc(24px + 140px)` accounts for button space
  - Adjusts at each breakpoint

## Success Criteria ✓

All of these should be true:
- [ ] No text overlap on any screen size
- [ ] Theme button visible and clickable at all sizes
- [ ] Header stays fixed when scrolling
- [ ] Text scales fluidly between breakpoints
- [ ] Theme label hidden on small phones
- [ ] Responsive padding prevents overflow
- [ ] All themes display correctly
- [ ] Flowers scale appropriately
- [ ] No console errors
- [ ] Smooth transitions between viewport sizes
