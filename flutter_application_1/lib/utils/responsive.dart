import 'package:flutter/material.dart';

/// Responsive utility class for managing different screen sizes
class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if device is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Check if device is tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// Get responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(12.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  /// Get responsive font size
  static double responsiveFontSize(BuildContext context, 
      {double mobile = 14, double tablet = 16, double desktop = 18}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get device orientation
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
}

/// Responsive grid widget that adapts columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double mobileColumns;
  final double tabletColumns;
  final double desktopColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    late double columns;
    
    if (Responsive.isDesktop(context)) {
      columns = desktopColumns;
    } else if (Responsive.isTablet(context)) {
      columns = tabletColumns;
    } else {
      columns = mobileColumns;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns.toInt(),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive column that shows as row on desktop
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool forceColumn; // Force column layout on all devices

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.forceColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    // Use column on mobile, row on tablet/desktop (unless forced)
    if (isMobile || forceColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    }
  }
}

/// Responsive container with adaptive padding and sizing
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double maxWidth;
  final BoxBorder? border;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.maxWidth = 600,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? Responsive.responsivePadding(context);
    final margin = this.margin ?? Responsive.responsivePadding(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        border: border,
      ),
      constraints: BoxConstraints(
        maxWidth: Responsive.isDesktop(context) 
            ? maxWidth 
            : double.infinity,
      ),
      child: child,
    );
  }
}

/// Build a responsive widget using LayoutBuilder
/// Selects mobile/tablet/desktop layout based on screen width
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, BoxConstraints) mobileBuild;
  final Widget Function(BuildContext, BoxConstraints) tabletBuild;
  final Widget Function(BuildContext, BoxConstraints) desktopBuild;

  const ResponsiveBuilder({
    super.key,
    required this.mobileBuild,
    required this.tabletBuild,
    required this.desktopBuild,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Responsive.isDesktop(context)) {
          return desktopBuild(context, constraints);
        } else if (Responsive.isTablet(context)) {
          return tabletBuild(context, constraints);
        } else {
          return mobileBuild(context, constraints);
        }
      },
    );
  }
}

/// Get responsive dimensions based on current screen size
Map<String, double> getResponsiveDimensions(BuildContext context) {
  final screenWidth = Responsive.screenWidth(context);
  final screenHeight = Responsive.screenHeight(context);

  late double containerWidth;
  late double containerHeight;
  late double padding;
  late double fontSize;
  late int crossAxisCount;

  if (Responsive.isMobile(context)) {
    containerWidth = screenWidth * 0.9;
    containerHeight = screenHeight * 0.6;
    padding = 12.0;
    fontSize = 14.0;
    crossAxisCount = 1;
  } else if (Responsive.isTablet(context)) {
    containerWidth = screenWidth * 0.85;
    containerHeight = screenHeight * 0.7;
    padding = 16.0;
    fontSize = 16.0;
    crossAxisCount = 2;
  } else {
    containerWidth = 1000.0;
    containerHeight = screenHeight * 0.8;
    padding = 24.0;
    fontSize = 18.0;
    crossAxisCount = 3;
  }

  return {
    'containerWidth': containerWidth,
    'containerHeight': containerHeight,
    'padding': padding,
    'fontSize': fontSize,
    'crossAxisCount': crossAxisCount.toDouble(),
    'screenWidth': screenWidth,
    'screenHeight': screenHeight,
  };
}

/// Responsive auth form wrapper with adaptive padding and constraints
class ResponsiveAuthForm extends StatelessWidget {
  final Widget Function(BoxConstraints) formBuilder;

  const ResponsiveAuthForm({
    super.key,
    required this.formBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = Responsive.isMobile(context);

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 32.0,
                  vertical: isSmallScreen ? 16.0 : 24.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? double.infinity : 500.0,
                    ),
                    child: formBuilder(constraints),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Responsive spacer widget
class ResponsiveSpacer extends StatelessWidget {
  final double mobileHeight;
  final double tabletHeight;
  final double desktopHeight;

  const ResponsiveSpacer({
    super.key,
    this.mobileHeight = 8.0,
    this.tabletHeight = 12.0,
    this.desktopHeight = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    late double height;
    
    if (Responsive.isDesktop(context)) {
      height = desktopHeight;
    } else if (Responsive.isTablet(context)) {
      height = tabletHeight;
    } else {
      height = mobileHeight;
    }

    return SizedBox(height: height);
  }
}
