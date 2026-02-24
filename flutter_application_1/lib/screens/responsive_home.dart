import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Mobile UI"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [

              // HEADER
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 32 : 16),
                color: Colors.blue[100],
                child: Text(
                  "Welcome to Responsive Design",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // MAIN CONTENT
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 12),
                  child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 2 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isTablet ? 1.5 : 1,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              "Card ${index + 1}",
                              style: TextStyle(
                                fontSize: isTablet ? 22 : 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // FOOTER
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}