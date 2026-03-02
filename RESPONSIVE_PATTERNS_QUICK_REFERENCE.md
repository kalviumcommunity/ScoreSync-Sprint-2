# Responsive Layout Patterns - Quick Reference

## Quick Implementation Checklist

- [ ] Use `Responsive` utility class for screen detection
- [ ] Use `ResponsiveContainer` for adaptive padding/margins
- [ ] Use `ResponsiveRow` for flexible Row/Column switching
- [ ] Use `ResponsiveGrid` for multi-column layouts
- [ ] Use `Expanded`/`Flexible` for space distribution
- [ ] Use `ResponsiveSpacer` for adaptive spacing
- [ ] Test on mobile, tablet, and desktop screen sizes
- [ ] Use appropriate font sizes for readability

---

## Pattern 1: Basic Responsive Container

### Before (Not Responsive)
```dart
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(16),
  child: Text('Static layout'),
)
```

### After (Responsive)
```dart
ResponsiveContainer(
  padding: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 16),
  margin: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 16),
  child: Text('Adaptive layout'),
)
```

---

## Pattern 2: Column vs Row Layout

### Before (Not Responsive)
```dart
Row(
  children: [
    Expanded(child: Widget1()),
    Expanded(child: Widget2()),
  ],
)
```

### After (Responsive)
```dart
ResponsiveRow(
  children: [
    Expanded(child: Widget1()),
    Expanded(child: Widget2()),
  ],
)

// Or manual control:
Responsive.isMobile(context)
  ? Column(children: [Widget1(), Widget2()])
  : Row(children: [Widget1(), Widget2()])
```

---

## Pattern 3: Responsive Grid

### Before (Not Responsive)
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemBuilder: (context, index) => CardWidget(),
)
```

### After (Responsive)
```dart
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  children: items,
)

// Or manual:
late int columns;
if (Responsive.isDesktop(context)) {
  columns = 4;
} else if (Responsive.isTablet(context)) {
  columns = 2;
} else {
  columns = 1;
}

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
  ),
  itemBuilder: (context, index) => CardWidget(),
)
```

---

## Pattern 4: Responsive Font Sizes

### Before (Not Responsive)
```dart
Text(
  'Title',
  style: TextStyle(fontSize: 24),
)
```

### After (Responsive)
```dart
Text(
  'Title',
  style: TextStyle(
    fontSize: Responsive.responsiveFontSize(context,
      mobile: 20,
      tablet: 24,
      desktop: 28,
    ),
  ),
)
```

---

## Pattern 5: Flexible Layout with Space Distribution

### Before (Not Responsive)
```dart
Row(
  children: [
    SizedBox(width: 200, child: Widget1()),
    SizedBox(width: 200, child: Widget2()),
  ],
)
```

### After (Responsive)
```dart
Row(
  children: [
    Expanded(flex: 1, child: Widget1()),
    Expanded(flex: 1, child: Widget2()),
  ],
)

// Or with different proportions:
Row(
  children: [
    Expanded(flex: 2, child: Widget1()),
    Expanded(flex: 1, child: Widget2()),
  ],
)
```

---

## Pattern 6: Adaptive Padding and Spacing

### Before (Not Responsive)
```dart
Padding(
  padding: EdgeInsets.all(16),
  child: child,
)
```

### After (Responsive)
```dart
Padding(
  padding: Responsive.responsivePadding(context),
  child: child,
)

// Or custom:
Padding(
  padding: EdgeInsets.all(
    Responsive.isMobile(context) ? 8 : 16,
  ),
  child: child,
)
```

---

## Pattern 7: Max Width on Desktop

### Before (Not Responsive)
```dart
Container(
  width: double.infinity,
  child: child,
)
```

### After (Responsive)
```dart
Center(
  child: Container(
    constraints: BoxConstraints(
      maxWidth: Responsive.isDesktop(context) ? 1200 : double.infinity,
    ),
    child: child,
  ),
)

// Or using ResponsiveContainer:
ResponsiveContainer(
  maxWidth: 1200,
  child: child,
)
```

---

## Pattern 8: Conditional Widget Display

### Before (Not Responsive)
```dart
Container(child: Widget1())
```

### After (Responsive)
```dart
if (Responsive.isMobile(context))
  MobileWidget()
else if (Responsive.isTablet(context))
  TabletWidget()
else
  DesktopWidget()
```

---

## Pattern 9: Horizontal Scrolling vs Grid

### Before (Not Responsive)
```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [...]),
)
```

### After (Responsive)
```dart
if (Responsive.isMobile(context))
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [...]),
  )
else
  ResponsiveGrid(
    tabletColumns: 2,
    desktopColumns: 4,
    children: [...],
  )
```

---

## Pattern 10: Multi-Line Layout with Wrap

### Before (Not Responsive)
```dart
Row(
  spacing: 16,
  children: [...],
)
```

### After (Responsive)
```dart
Wrap(
  spacing: Responsive.isMobile(context) ? 8 : 16,
  runSpacing: Responsive.isMobile(context) ? 8 : 12,
  children: [...],
)
```

---

## Common Widget Combinations

### Responsive Card List
```dart
ResponsiveContainer(
  child: ResponsiveGrid(
    mobileColumns: 1,
    tabletColumns: 2,
    desktopColumns: 3,
    children: items.map((item) => CardWidget(item)).toList(),
  ),
)
```

### Responsive Hero Section
```dart
ResponsiveContainer(
  maxWidth: 1200,
  child: ResponsiveRow(
    children: [
      Expanded(child: HeadlineText()),
      Expanded(child: HeroImage()),
    ],
  ),
)
```

### Responsive Form
```dart
ResponsiveContainer(
  maxWidth: 600,
  padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 32),
  child: Column(
    children: [
      FormField1(),
      ResponsiveSpacer(),
      FormField2(),
      ResponsiveSpacer(),
      SubmitButton(),
    ],
  ),
)
```

---

## Performance Tips

1. **Cache responsive values**
   ```dart
   @override
   Widget build(BuildContext context) {
     final isMobile = Responsive.isMobile(context);
     // Use isMobile multiple times instead of calling repeatedly
   }
   ```

2. **Avoid unnecessary rebuilds**
   ```dart
   // Good: Extract to separate widget
   class ResponsivePart extends StatelessWidget {
     // This widget rebuilds when needed
   }
   
   // Bad: Inline Responsive checks cause full rebuild
   @override
   Widget build(BuildContext context) {
     if (Responsive.isMobile(context)) ... // Full widget rebuilds
   }
   ```

3. **Use ListView.builder for long lists**
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   ```

4. **Avoid nested scrolling**
   ```dart
   // Bad:
   SingleChildScrollView(
     child: Column(
       children: [
         ListView(...), // Nested scroll
       ],
     ),
   )
   
   // Good:
   RefreshIndicator(
     onRefresh: () async {},
     child: ListView.builder(...),
   )
   ```

---

## Testing Responsive Layouts

### Using Device Emulator
```bash
# Run on different screen sizes
flutter run -d "Pixel 4"
flutter run -d "iPad Pro"

# Or rotate device
# Press 'r' to restart, 'R' for hot reload
```

### Using Device Preview (Dev)
```dart
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}
```

### Manual Screen Size Testing
```dart
// Add debug info
Container(
  child: Column(
    children: [
      Text('Width: ${Responsive.screenWidth(context)}'),
      Text('Height: ${Responsive.screenHeight(context)}'),
      Text('Type: ${Responsive.isMobile(context) ? 'Mobile' : 'Tablet/Desktop'}'),
    ],
  ),
)
```

---

## Common Mistakes to Avoid

❌ **Don't:** Use hardcoded dimensions
```dart
SizedBox(width: 200, child: widget)
```

✅ **Do:** Use Expanded/Flexible
```dart
Expanded(flex: 1, child: widget)
```

---

❌ **Don't:** Ignore screen orientation
```dart
// May break in landscape
```

✅ **Do:** Check orientation
```dart
if (Responsive.isLandscape(context))
  // Landscape layout
```

---

❌ **Don't:** Use fixed padding everywhere
```dart
padding: EdgeInsets.all(16)
```

✅ **Do:** Use responsive padding
```dart
padding: Responsive.responsivePadding(context)
```

---

❌ **Don't:** Create widgets with static sizes
```dart
Container(width: 100, height: 100, child: widget)
```

✅ **Do:** Create adaptive widgets
```dart
AspectRatio(
  aspectRatio: 1,
  child: widget,
)
```

---

## Summary

| Screen Type | Max Width | Columns | Font Size |
|-------------|-----------|---------|-----------|
| Mobile      | < 600dp   | 1       | Small     |
| Tablet      | 600-900dp | 2       | Medium    |
| Desktop     | > 900dp   | 3+      | Large     |

Using these patterns ensures your app looks great on all devices!
