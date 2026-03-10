# Migration Guide: Converting to Responsive Layouts

This guide shows how to convert existing static layouts to responsive layouts using Rows, Columns, and Containers.

---

## Step 1: Import Responsive Utilities

Add this import to any file where you want to use responsive design:

```dart
import 'package:flutter/material.dart';
import 'utils/responsive.dart';
```

---

## Example 1: Converting a Simple Container

### Before (Static)
```dart
Container(
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.all(16),
  color: Colors.blue[100],
  child: Text('Hello World'),
)
```

### After (Responsive)
```dart
Container(
  padding: EdgeInsets.all(
    Responsive.isMobile(context) ? 8 : 16,
  ),
  margin: EdgeInsets.all(
    Responsive.isMobile(context) ? 8 : 16,
  ),
  color: Colors.blue[100],
  child: Text('Hello World'),
)
```

### Or Using Helper
```dart
ResponsiveContainer(
  padding: Responsive.responsivePadding(context),
  backgroundColor: Colors.blue[100],
  child: Text('Hello World'),
)
```

---

## Example 2: Converting Text with Fixed Font Size

### Before (Static)
```dart
Text(
  'Title',
  style: const TextStyle(fontSize: 24),
)
```

### After (Responsive)
```dart
Text(
  'Title',
  style: TextStyle(
    fontSize: Responsive.responsiveFontSize(context,
        mobile: 18,
        tablet: 20,
        desktop: 24),
  ),
)
```

---

## Example 3: Converting a Row/Column Layout

### Before (Static - Always Row)
```dart
Row(
  children: [
    Expanded(child: Widget1()),
    SizedBox(width: 16),
    Expanded(child: Widget2()),
  ],
)
```

### After (Responsive - Column on Mobile)
```dart
Responsive.isMobile(context)
    ? Column(
        children: [
          Widget1(),
          const SizedBox(height: 16),
          Widget2(),
        ],
      )
    : Row(
        children: [
          Expanded(child: Widget1()),
          const SizedBox(width: 16),
          Expanded(child: Widget2()),
        ],
      )
```

### Or Using Helper
```dart
ResponsiveRow(
  children: [
    Expanded(child: Widget1()),
    Expanded(child: Widget2()),
  ],
)
```

---

## Example 4: Converting a Grid Layout

### Before (Static - 2 columns always)
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) => ItemWidget(),
  itemCount: items.length,
)
```

### After (Responsive - 1 on mobile, 2 on tablet, 3 on desktop)
```dart
late int columns;
if (Responsive.isDesktop(context)) {
  columns = 3;
} else if (Responsive.isTablet(context)) {
  columns = 2;
} else {
  columns = 1;
}

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) => ItemWidget(),
  itemCount: items.length,
)
```

### Or Using Helper
```dart
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  spacing: 16,
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

---

## Example 5: Converting Button Styling

### Before (Static)
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  ),
  child: const Text('Action'),
)
```

### After (Responsive)
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(
      horizontal: Responsive.isMobile(context) ? 16 : 32,
      vertical: Responsive.isMobile(context) ? 12 : 16,
    ),
  ),
  child: const Text('Action'),
)
```

---

## Example 6: Converting Full-Width Components

### Before (Static)
```dart
Widget buildScoreCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(child: Team1()),
        SizedBox(width: 40, child: VS()),
        Expanded(child: Team2()),
      ],
    ),
  );
}
```

### After (Responsive - Vertical on small screens)
```dart
Widget buildScoreCard(BuildContext context) {
  final isMobile = Responsive.isMobile(context);
  
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(isMobile ? 12 : 16),
    child: isMobile
        ? Column(
            children: [
              Team1(),
              const SizedBox(height: 16),
              VS(),
              const SizedBox(height: 16),
              Team2(),
            ],
          )
        : Row(
            children: [
              Expanded(child: Team1()),
              SizedBox(width: isMobile ? 30 : 40, child: VS()),
              Expanded(child: Team2()),
            ],
          ),
  );
}
```

---

## Example 7: Converting List/Scrollable Layouts

### Before (Static)
```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: items.map((item) => ItemWidget(item)).toList(),
  ),
)
```

### After (Responsive - Scroll on mobile, grid on desktop)
```dart
if (Responsive.isMobile(context))
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: items.map((item) => ItemWidget(item)).toList(),
    ),
  )
else
  ResponsiveGrid(
    tabletColumns: 2,
    desktopColumns: 4,
    children: items.map((item) => ItemWidget(item)).toList(),
  )
```

---

## Example 8: Converting Form Layouts

### Before (Static)
```dart
Form(
  child: Column(
    children: [
      TextFormField(decoration: InputDecoration(labelText: 'Name')),
      const SizedBox(height: 16),
      TextFormField(decoration: InputDecoration(labelText: 'Email')),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Submit'),
      ),
    ],
  ),
)
```

### After (Responsive)
```dart
Form(
  child: ResponsiveContainer(
    maxWidth: 600,
    padding: EdgeInsets.all(
      Responsive.isMobile(context) ? 16 : 32,
    ),
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Name'),
        ),
        ResponsiveSpacer(
          mobileHeight: 12,
          tabletHeight: 16,
          desktopHeight: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
        ),
        ResponsiveSpacer(
          mobileHeight: 16,
          tabletHeight: 20,
          desktopHeight: 24,
        ),
        SizedBox(
          width: Responsive.isMobile(context) ? double.infinity : null,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Submit'),
          ),
        ),
      ],
    ),
  ),
)
```

---

## Example 9: Converting Card Layouts

### Before (Static)
```dart
Card(
  margin: const EdgeInsets.all(16),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Title', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text('Description'),
      ],
    ),
  ),
)
```

### After (Responsive)
```dart
Card(
  margin: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 16),
  child: Padding(
    padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 16),
    child: Column(
      children: [
        Text(
          'Title',
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 16, tablet: 18, desktop: 20),
          ),
        ),
        SizedBox(
          height: Responsive.isMobile(context) ? 4 : 8,
        ),
        Text('Description'),
      ],
    ),
  ),
)
```

---

## Example 10: Converting Complex Layouts

### Before (Static - Always single column)
```dart
Column(
  children: [
    Header(),
    Sidebar(),
    Content(),
  ],
)
```

### After (Responsive - Two column on desktop)
```dart
Responsive.isMobile(context)
    ? Column(
        children: [
          Header(),
          Sidebar(),
          Content(),
        ],
      )
    : Column(
        children: [
          Header(),
          Row(
            children: [
              SizedBox(
                width: 250,
                child: Sidebar(),
              ),
              Expanded(child: Content()),
            ],
          ),
        ],
      )
```

---

## Migration Checklist

When converting a widget to responsive design:

- [ ] Import `responsive.dart`
- [ ] Identify fixed values (padding, margins, font sizes, widths)
- [ ] Replace fixed values with responsive equivalents
- [ ] Test on mobile screen size
- [ ] Test on tablet screen size
- [ ] Test on desktop screen size
- [ ] Test in landscape orientation
- [ ] Update any hardcoded spacing values
- [ ] Check text readability at all sizes
- [ ] Verify button/touch target sizes (min 48x48dp)

---

## Common Patterns to Convert

| Pattern | Old Way | New Way |
|---------|---------|---------|
| Fixed padding | `padding: EdgeInsets.all(16)` | `padding: Responsive.responsivePadding(context)` |
| Fixed font size | `fontSize: 24` | `fontSize: Responsive.responsiveFontSize(context, mobile: 18, tablet: 20, desktop: 24)` |
| Always Row | `Row(children: [...])` | `ResponsiveRow(children: [...])` |
| Fixed columns | `crossAxisCount: 2` | Use `ResponsiveGrid` or conditional logic |
| Fixed width | `SizedBox(width: 200)` | `Expanded(child: ...)` |
| Always scrollable | `SingleChildScrollView(...)` | Conditional based on `isMobile` |

---

## Best Practices for Migration

1. **Start with utilities** - Import `responsive.dart` first
2. **Cache values** - Don't call `Responsive.isMobile()` multiple times
3. **Use helpers** - `ResponsiveContainer`, `ResponsiveRow`, `ResponsiveGrid`
4. **Test frequently** - Migrate one section at a time
5. **Keep values consistent** - Use same mobile/tablet/desktop values across similar widgets
6. **Prioritize mobile** - Design for mobile first, then enhance for larger screens
7. **Use semantic naming** - Keep responsive values clear in code

---

## Performance Tips During Migration

- Extract responsive widgets to separate classes to avoid unnecessary rebuilds
- Cache computed responsive values
- Use `const` constructors where possible
- Avoid calling Responsive methods multiple times in build
- Use `ListView.builder` instead of `ListView` for long lists

---

## Example: Complete Widget Migration

### Before
```dart
class ScoreCard extends StatelessWidget {
  final String team1;
  final String team2;
  final int score1;
  final int score2;

  const ScoreCard({
    required this.team1,
    required this.team2,
    required this.score1,
    required this.score2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(team1, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(score1.toString(), style: const TextStyle(fontSize: 48)),
            ],
          ),
          const Text('VS', style: TextStyle(fontSize: 18)),
          Column(
            children: [
              Text(team2, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(score2.toString(), style: const TextStyle(fontSize: 48)),
            ],
          ),
        ],
      ),
    );
  }
}
```

### After
```dart
class ScoreCard extends StatelessWidget {
  final String team1;
  final String team2;
  final int score1;
  final int score2;

  const ScoreCard({
    required this.team1,
    required this.team2,
    required this.score1,
    required this.score2,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      margin: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isMobile && MediaQuery.of(context).size.width < 400
          ? Column(
              children: [
                _buildTeamSection(context, team1, score1),
                const SizedBox(height: 16),
                const Text('VS'),
                const SizedBox(height: 16),
                _buildTeamSection(context, team2, score2),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamSection(context, team1, score1),
                const Text('VS'),
                _buildTeamSection(context, team2, score2),
              ],
            ),
    );
  }

  Widget _buildTeamSection(BuildContext context, String team, int score) {
    return Column(
      children: [
        Text(
          team,
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 14, tablet: 16, desktop: 18),
          ),
        ),
        SizedBox(height: Responsive.isMobile(context) ? 4 : 8),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 36, tablet: 42, desktop: 48),
          ),
        ),
      ],
    );
  }
}
```

---

## Next Steps

1. Start with one widget at a time
2. Follow the examples above
3. Test on multiple screen sizes
4. Update documentation as you go
5. Share learnings with your team

Happy migrating!
