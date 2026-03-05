# Flutter Responsive Layouts Guide

## Overview

This guide explains how to design responsive layouts using Flutter's **Rows, Columns, and Containers** that work beautifully across mobile, tablet, and desktop devices.

## Screen Size Breakpoints

```
Mobile:   width < 600 dp
Tablet:   600 dp ≤ width < 900 dp
Desktop:  width ≥ 900 dp
```

## Core Responsive Widgets Created

### 1. **Responsive Utility Class** (`responsive.dart`)

```dart
// Check device type
Responsive.isMobile(context)
Responsive.isTablet(context)
Responsive.isDesktop(context)

// Get responsive values
Responsive.responsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18)
Responsive.responsivePadding(context)
Responsive.screenWidth(context)
Responsive.screenHeight(context)
```

### 2. **ResponsiveContainer**

A Container that adapts padding and sizing based on screen size:

```dart
ResponsiveContainer(
  padding: EdgeInsets.all(16), // Can be customized
  backgroundColor: Colors.white,
  borderRadius: 8.0,
  maxWidth: 600, // Max width on desktop
  child: Text('Adaptive container'),
)
```

**Features:**
- Responsive padding and margins
- Max width constraints on desktop
- Customizable border radius and background

### 3. **ResponsiveRow**

Shows as Column on mobile, Row on tablet/desktop:

```dart
ResponsiveRow(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(child: Text('Column 1')),
    Expanded(child: Text('Column 2')),
  ],
)
```

**Behavior:**
- Mobile: Vertical (Column)
- Tablet+: Horizontal (Row)
- Can force column with `forceColumn: true`

### 4. **ResponsiveGrid**

Adaptive grid with responsive column count:

```dart
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  spacing: 16,
  children: items,
)
```

### 5. **ResponsiveSpacer**

Spacing that adapts to screen size:

```dart
ResponsiveSpacer(
  mobileHeight: 8.0,
  tabletHeight: 12.0,
  desktopHeight: 16.0,
)
```

## Implementation Patterns

### Pattern 1: Responsive Font Sizes

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontSize: Responsive.responsiveFontSize(context,
        mobile: 14,
        tablet: 16,
        desktop: 20),
  ),
)
```

### Pattern 2: Responsive Padding/Margins

```dart
Container(
  padding: EdgeInsets.all(
    Responsive.isMobile(context) ? 8.0 : 16.0
  ),
  child: child,
)
```

### Pattern 3: Conditional Layout (Column vs Row)

```dart
ResponsiveRow(
  children: [
    Expanded(child: Widget1()),
    Expanded(child: Widget2()),
  ],
)
// Mobile: shows as column
// Tablet+: shows as row
```

### Pattern 4: Flexible vs Expanded

```dart
Row(
  children: [
    Expanded(
      flex: 2, // Takes 2/3 of space
      child: Widget1(),
    ),
    Expanded(
      flex: 1, // Takes 1/3 of space
      child: Widget2(),
    ),
  ],
)
```

### Pattern 5: Responsive Visibility

```dart
if (Responsive.isMobile(context))
  Text('Mobile only')
else if (Responsive.isTablet(context))
  Text('Tablet only')
else
  Text('Desktop only')
```

### Pattern 6: Screen Size Detection for Adjustments

```dart
final screenWidth = Responsive.screenWidth(context);
final screenHeight = Responsive.screenHeight(context);

if (screenWidth < 360) {
  // Extra small device
}
```

## Widget Examples

### Responsive Score Card

```dart
ResponsiveContainer(
  padding: EdgeInsets.all(isMobile ? 12 : 16),
  backgroundColor: Colors.white,
  child: ResponsiveRow(
    children: [
      Expanded(child: ScoreWidget()),
      Expanded(child: ScoreWidget()),
    ],
  ),
)
```

### Responsive Match List

```dart
if (isMobile)
  ListView.builder(
    itemBuilder: (context, i) => MatchCard(matches[i]),
  )
else if (isTablet)
  ResponsiveGrid(
    tabletColumns: 2,
    children: matches,
  )
else
  ResponsiveGrid(
    desktopColumns: 4,
    children: matches,
  )
```

### Responsive Sports Selection

```dart
ResponsiveSportsSelectionWidget(
  sports: ['Football', 'Basketball', ...],
  onSportSelected: (sport) {},
  selectedSport: selectedSport,
)
// Mobile: Horizontal scroll
// Tablet: 2 columns
// Desktop: 3-4 columns
```

## Best Practices

1. **Use Expanded/Flexible for space distribution**
   ```dart
   Row(
     children: [
       Expanded(child: Widget1()), // Takes remaining space
       SizedBox(width: 100, child: Widget2()), // Fixed width
     ],
   )
   ```

2. **Set reasonable max widths on desktop**
   ```dart
   ResponsiveContainer(
     maxWidth: 1200, // Prevents too wide layouts
     child: child,
   )
   ```

3. **Use SafeArea for notches**
   ```dart
   SafeArea(
     child: Column(children: [...]),
   )
   ```

4. **Test on multiple screen sizes**
   - Use Flutter's device preview
   - Test actual devices
   - Check landscape orientation

5. **Avoid hardcoded dimensions**
   ```dart
   // Bad
   SizedBox(width: 100)
   
   // Good
   Expanded(
     flex: 1,
     child: child,
   )
   ```

## Common Issues & Solutions

### Issue: Text overflow on small screens
**Solution:** Use `overflow: TextOverflow.ellipsis` and responsive font sizes

### Issue: Excessive spacing on large screens
**Solution:** Use `maxWidth` constraints and `ResponsiveContainer`

### Issue: Content crammed on mobile
**Solution:** Use `ResponsiveRow` to switch from Row to Column

### Issue: Images not scaling
**Solution:** Use `BoxFit.cover` or `BoxFit.contain` with `Container`

## Testing Responsive Layouts

### Using Flutter DevTools

```bash
flutter run --debug
# In DevTools, select different device profiles
```

### Using Device Emulator

```bash
# Mobile (Portrait)
flutter run

# Mobile (Landscape)
# Rotate device in emulator

# Tablet
# Use tablet emulator from AVD or iOS Simulator
```

## Performance Tips

1. Use `ListView` with `shrinkWrap: true` only when necessary
2. Use `SingleChildScrollView` for vertical scrolling
3. Avoid nested scrolling widgets
4. Cache responsive values at build time

```dart
@override
Widget build(BuildContext context) {
  final isMobile = Responsive.isMobile(context);
  // Use isMobile variable instead of calling multiple times
}
```

## Conclusion

Responsive design in Flutter is powerful and simple:

- **Use MediaQuery** to detect screen size
- **Use Expanded/Flexible** for proportional spacing
- **Use Container** for padding and decoration
- **Use Column/Row** for layout structure
- **Adapt font sizes and spacing** based on screen size
- **Test thoroughly** on different devices

This ensures your app looks great on all screen sizes!
