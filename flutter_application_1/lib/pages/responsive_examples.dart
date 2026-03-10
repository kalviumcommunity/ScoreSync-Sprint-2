import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// EXAMPLE 1: Two-Column Layout on Desktop, Single Column on Mobile
class TwoColumnLayout extends StatelessWidget {
  const TwoColumnLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return isMobile
        ? Column(
            children: [
              _buildLeftPanel(),
              const SizedBox(height: 16),
              _buildRightPanel(),
            ],
          )
        : Row(
            children: [
              Expanded(flex: 1, child: _buildLeftPanel()),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _buildRightPanel()),
            ],
          );
  }

  Widget _buildLeftPanel() {
    return Container(
      color: Colors.blue[100],
      padding: const EdgeInsets.all(16),
      child: const Text('Left Panel'),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: Colors.green[100],
      padding: const EdgeInsets.all(16),
      child: const Text('Right Panel'),
    );
  }
}

/// EXAMPLE 2: Flexible Width Container with Max Width
class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Responsive.isDesktop(context) ? 800 : double.infinity,
        ),
        padding: const EdgeInsets.all(16),
        color: Colors.amber[100],
        child: Column(
          children: [
            Text(
              'Max Width Container',
              style: TextStyle(
                fontSize: Responsive.responsiveFontSize(context,
                    mobile: 16, tablet: 18, desktop: 20),
              ),
            ),
            const SizedBox(height: 16),
            const Text('This container has a max width on desktop'),
          ],
        ),
      ),
    );
  }
}

/// EXAMPLE 3: Dynamic Padding and Spacing
class DynamicPaddingExample extends StatelessWidget {
  const DynamicPaddingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.responsivePadding(context);

    return Padding(
      padding: padding,
      child: Container(
        color: Colors.purple[100],
        padding: padding,
        child: const Text('Padding adapts to screen size'),
      ),
    );
  }
}

/// EXAMPLE 4: Responsive Grid List
class ResponsiveGridListExample extends StatelessWidget {
  const ResponsiveGridListExample({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(12, (index) => 'Item ${index + 1}');
    late int columns;

    if (Responsive.isDesktop(context)) {
      columns = 4;
    } else if (Responsive.isTablet(context)) {
      columns = 2;
    } else {
      columns = 1;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.teal[100 + (index % 5) * 100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(items[index]),
          ),
        );
      },
    );
  }
}

/// EXAMPLE 5: Responsive Row with Wrap
class ResponsiveWrapExample extends StatelessWidget {
  const ResponsiveWrapExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = ['Flutter', 'Responsive', 'Design', 'Layouts', 'Mobile'];

    return Wrap(
      spacing: Responsive.isMobile(context) ? 8 : 16,
      runSpacing: Responsive.isMobile(context) ? 8 : 12,
      children: tags
          .map(
            (tag) => Chip(
              label: Text(tag),
              backgroundColor: Colors.indigo[100],
            ),
          )
          .toList(),
    );
  }
}

/// EXAMPLE 6: Conditional Widget Display
class ConditionalDisplayExample extends StatelessWidget {
  const ConditionalDisplayExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Responsive.isMobile(context))
          Container(
            color: Colors.red[100],
            padding: const EdgeInsets.all(16),
            child: const Text('Mobile Only Content'),
          )
        else if (Responsive.isTablet(context))
          Container(
            color: Colors.orange[100],
            padding: const EdgeInsets.all(16),
            child: const Text('Tablet Only Content'),
          )
        else
          Container(
            color: Colors.green[100],
            padding: const EdgeInsets.all(16),
            child: const Text('Desktop Only Content'),
          ),
      ],
    );
  }
}

/// EXAMPLE 7: Responsive Cards in a Scrollable List
class ResponsiveCardListExample extends StatelessWidget {
  const ResponsiveCardListExample({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          6,
          (index) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 24,
              vertical: 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title ${index + 1}',
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(context,
                        mobile: 14, tablet: 16, desktop: 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a responsive card that adapts to screen size',
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(context,
                        mobile: 12, tablet: 13, desktop: 14),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// EXAMPLE 8: Dashboard Layout (Complex Responsive)
class ResponsiveDashboardExample extends StatelessWidget {
  const ResponsiveDashboardExample({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    if (isMobile) {
      // Mobile: Stack vertically
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildChartCard(),
            const SizedBox(height: 16),
            _buildListCard(),
          ],
        ),
      );
    } else if (isTablet) {
      // Tablet: 2x2 grid
      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildHeaderCard()),
                Expanded(child: _buildStatsCard()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildChartCard()),
                Expanded(child: _buildListCard()),
              ],
            ),
          ],
        ),
      );
    } else {
      // Desktop: Single row with proportional widths
      return SingleChildScrollView(
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildHeaderCard()),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildStatsCard()),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildChartCard()),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildListCard()),
          ],
        ),
      );
    }
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Header',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('Stats'),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('Chart'),
    );
  }

  Widget _buildListCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('List'),
    );
  }
}

/// EXAMPLE 9: Responsive FAB Position
class ResponsiveFABExample extends StatelessWidget {
  const ResponsiveFABExample({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Responsive FAB')),
      body: const Center(child: Text('Content here')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      // FAB position adapts to screen size
      floatingActionButtonLocation:
          isMobile ? FloatingActionButtonLocation.endFloat : null,
    );
  }
}

/// EXAMPLE 10: Responsive Form Layout
class ResponsiveFormExample extends StatelessWidget {
  const ResponsiveFormExample({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 600 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
