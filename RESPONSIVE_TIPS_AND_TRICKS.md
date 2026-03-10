# Responsive Layout Tips & Tricks

Quick tips and tricks for working with responsive layouts in Flutter.

---

## 🚀 Quick Tips

### Tip 1: Use MediaQuery for One-Off Checks
```dart
// Quick screen width check
if (MediaQuery.of(context).size.width < 600) {
  // Mobile
} else {
  // Tablet/Desktop
}
```

### Tip 2: Create Helper Variables
```dart
@override
Widget build(BuildContext context) {
  final isMobile = Responsive.isMobile(context);
  final isTablet = Responsive.isTablet(context);
  final screenWidth = Responsive.screenWidth(context);
  
  // Use these variables throughout the build method
  // Avoid calling Responsive methods multiple times
}
```

### Tip 3: Use Golden Ratio for Proportional Layouts
```dart
// For 3-column layouts
Row(
  children: [
    Expanded(flex: 2, child: MainContent()),
    Expanded(flex: 1, child: Sidebar()),
  ],
)
```

### Tip 4: Minimum Touch Target Size
```dart
// Flutter recommends 48x48 dp minimum for touch targets
ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16, // Ensures minimum 48dp height
    ),
  ),
  child: Text('Tap Me'),
)
```

### Tip 5: Use Flexible > Expanded When You Need Space
```dart
// Flexible: Takes available space but can shrink
Row(
  children: [
    Flexible(child: LongText()), // Can shrink if needed
    ActionButton(),
  ],
)

// Expanded: Always takes available space
Row(
  children: [
    Expanded(child: Widget()),
    Expanded(child: Widget()),
  ],
)
```

---

## 🎯 Layout Techniques

### Technique 1: Breakpoint-Based Layout
```dart
Widget buildLayout(BuildContext context) {
  if (Responsive.isMobile(context)) {
    return MobileLayout();
  } else if (Responsive.isTablet(context)) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

### Technique 2: Conditional Widget Wrapping
```dart
// Wrap widgets conditionally based on screen size
Widget buildContent(BuildContext context) {
  final content = Column(
    children: [Widget1(), Widget2()],
  );
  
  return Responsive.isMobile(context)
      ? content
      : Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: content,
        );
}
```

### Technique 3: Responsive Aspect Ratio
```dart
// Maintain aspect ratio while being responsive
AspectRatio(
  aspectRatio: 16 / 9,
  child: Container(
    color: Colors.blue,
    child: Image.network(
      'url',
      fit: BoxFit.cover,
    ),
  ),
)
```

### Technique 4: Responsive Stack Overlay
```dart
// Stack that adapts positioning based on screen size
Stack(
  children: [
    Background(),
    Positioned(
      top: Responsive.isMobile(context) ? 8 : 16,
      right: Responsive.isMobile(context) ? 8 : 16,
      child: CloseButton(),
    ),
  ],
)
```

### Technique 5: Responsive SlideTransition
```dart
// Animation that works at different scales
SlideTransition(
  position: animation.drive(
    Tween<Offset>(
      begin: Offset(Responsive.isMobile(context) ? 0 : -1, 0),
      end: Offset.zero,
    ),
  ),
  child: Widget(),
)
```

---

## 🎨 Styling Tips

### Responsive Colors
```dart
// Slightly different colors based on brightness
Color getContainerColor(BuildContext context) {
  if (Responsive.isMobile(context)) {
    return Colors.blue[100]!;
  } else if (Responsive.isTablet(context)) {
    return Colors.blue[50]!;
  } else {
    return Colors.blue[25]!;
  }
}
```

### Responsive Border Radius
```dart
// Larger radius on larger screens
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      Responsive.isMobile(context) ? 4 : 12,
    ),
  ),
)
```

### Responsive Elevation
```dart
// More elevation on larger screens for depth
Card(
  elevation: Responsive.isMobile(context) ? 2 : 4,
  child: content,
)
```

### Responsive Shadow
```dart
// Bigger shadow on desktop
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        blurRadius: Responsive.isMobile(context) ? 2 : 8,
        spreadRadius: Responsive.isMobile(context) ? 0 : 2,
      ),
    ],
  ),
)
```

---

## 📱 Mobile-First Development

### Start Mobile, Then Enhance
```dart
// 1. Design for mobile (smallest screen)
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      MobileLayout(),
    ],
  );
}

// 2. Enhance for tablets
// 3. Enhance for desktop
```

### Use SafeArea for Notches
```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [...],
    ),
  ),
)
```

### Avoid Horizontal Scrolling
```dart
// Bad: Forces horizontal scroll on mobile
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [...]),
)

// Good: Stack vertically on mobile
Responsive.isMobile(context)
    ? Column(children: [...])
    : Row(children: [...])
```

---

## 🧪 Testing Tips

### Test Different Orientations
```dart
// Portrait
flutter run

// Landscape (rotate device/emulator)
# Emulator: Press R or use settings
```

### Test Without Scaling
```bash
# Run without device scaling
flutter run --no-fast-start
```

### Create Test Scenarios
```dart
// Create a test widget that shows all sizes
class ResponsivePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 300,
          child: Column(children: [...]),
        ),
        Container(
          width: 700,
          child: Column(children: [...]),
        ),
        Container(
          width: 1200,
          child: Column(children: [...]),
        ),
      ],
    );
  }
}
```

---

## ⚡ Performance Tricks

### Cache Responsive Values
```dart
// BAD - Calls Responsive methods multiple times
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      if (Responsive.isMobile(context)) MobileWidget(),
      SizedBox(height: Responsive.isMobile(context) ? 8 : 16),
      if (Responsive.isMobile(context)) MobileWidget2(),
    ],
  );
}

// GOOD - Cache at top
@override
Widget build(BuildContext context) {
  final isMobile = Responsive.isMobile(context);
  
  return Column(
    children: [
      if (isMobile) MobileWidget(),
      SizedBox(height: isMobile ? 8 : 16),
      if (isMobile) MobileWidget2(),
    ],
  );
}
```

### Extract Responsive Widgets
```dart
// Extract to separate widget to avoid full rebuild
class ResponsivePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? MobileLayout()
        : DesktopLayout();
  }
}
```

### Use const Constructor
```dart
// Use const where possible
const Container(
  child: Text('Static content'),
)
```

---

## 🎭 Common Patterns Quick Ref

### Pattern: Center Max Width
```dart
Center(
  child: Container(
    constraints: BoxConstraints(
      maxWidth: Responsive.isDesktop(context) ? 1200 : double.infinity,
    ),
    child: content,
  ),
)
```

### Pattern: Responsive Padding Container
```dart
Padding(
  padding: Responsive.responsivePadding(context),
  child: content,
)
```

### Pattern: Mobile Drawer, Desktop Sidebar
```dart
Scaffold(
  appBar: AppBar(title: Text('App')),
  drawer: Responsive.isMobile(context) ? Drawer(...) : null,
  body: Row(
    children: [
      if (!Responsive.isMobile(context))
        NavigationSidebar(),
      Expanded(child: MainContent()),
    ],
  ),
)
```

### Pattern: Mobile Bottom Sheet, Desktop Dialog
```dart
showDialog(
  context: context,
  builder: (_) => Responsive.isMobile(context)
      ? Dialog(
          insetPadding: EdgeInsets.all(0),
          child: DialogContent(),
        )
      : AlertDialog(
          content: DialogContent(),
        ),
)
```

### Pattern: Responsive List/Grid
```dart
Responsive.isMobile(context)
    ? ListView.builder(
        itemBuilder: (context, i) => Item(),
      )
    : ResponsiveGrid(
        tabletColumns: 2,
        desktopColumns: 4,
        children: [...],
      )
```

---

## 🐛 Common Issues & Solutions

### Issue: Text Overflows on Small Screens
**Solution:**
```dart
Text(
  'Long text',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

### Issue: Images Stretched on Wide Screens
**Solution:**
```dart
Image.network(
  url,
  fit: BoxFit.cover,
  height: 300,
)
```

### Issue: Buttons Too Small to Tap
**Solution:**
```dart
// Ensure minimum 48x48 dp
SizedBox(
  height: 48,
  width: double.infinity,
  child: ElevatedButton(...),
)
```

### Issue: Content Looks Crowded
**Solution:**
```dart
// Add responsive spacing
ResponsiveSpacer(
  mobileHeight: 8,
  tabletHeight: 12,
  desktopHeight: 16,
)
```

### Issue: AppBar Too Cluttered on Mobile
**Solution:**
```dart
AppBar(
  title: Text('App'),
  actions: [
    if (!Responsive.isMobile(context))
      TextButton(label: Text('Menu')),
    if (Responsive.isMobile(context))
      IconButton(icon: Icon(Icons.menu)),
  ],
)
```

---

## 📚 Debugging Tips

### Show Screen Info
```dart
// Add this temporarily to see screen dimensions
@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      YourWidget(),
      Positioned(
        top: 16,
        right: 16,
        child: Container(
          color: Colors.black87,
          padding: EdgeInsets.all(8),
          child: Text(
            'W: ${Responsive.screenWidth(context).toStringAsFixed(0)}\n'
            'H: ${Responsive.screenHeight(context).toStringAsFixed(0)}\n'
            '${Responsive.isMobile(context) ? 'Mobile' : Responsive.isTablet(context) ? 'Tablet' : 'Desktop'}',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    ],
  );
}
```

### Use Different Background Colors
```dart
// Temporarily use different colors to see layout structure
Container(
  color: Responsive.isMobile(context) 
      ? Colors.red[100] 
      : Colors.blue[100],
  child: content,
)
```

### Log Breakpoints
```dart
@override
Widget build(BuildContext context) {
  final isMobile = Responsive.isMobile(context);
  
  if (isMobile) {
    print('Device changed to Mobile');
  }
  
  return YourWidget();
}
```

---

## 🎯 Best Practices Summary

1. ✅ Start mobile-first
2. ✅ Cache responsive values
3. ✅ Use responsive utilities
4. ✅ Extract responsive components
5. ✅ Test on multiple devices
6. ✅ Test landscape orientation
7. ✅ Maintain minimum touch sizes
8. ✅ Use SafeArea
9. ✅ Avoid hardcoded dimensions
10. ✅ Document your breakpoints

---

## Resources

- [Flutter Responsive Documentation](https://flutter.dev/docs/development/ui/layout)
- [MediaQuery API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
- [Expanded Widget](https://api.flutter.dev/flutter/widgets/Expanded-class.html)
- [Flexible Widget](https://api.flutter.dev/flutter/widgets/Flexible-class.html)

Happy responsive coding! 🚀
