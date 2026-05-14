import 'package:flutter/material.dart';


class Mainlayout extends StatelessWidget {
  // static const primaryColor = Color.fromARGB(255, 5, 89, 106);
  // static const backgroundColor = Color(0xffffffff);
  // static const Color accentorange = Color(0xFFE88F09);
  // static const Color accentColor = Color.fromARGB(70, 5, 102, 122);

  // static const Color textTitleColor= Color(0xff2d2d2d);
  // static const Color textSubtitleColor = Color(0xf3f3f3f6);
  // static const Color inputFillColor = Color.fromARGB(143, 32, 49, 49);
  // static const Color InputBorderColor = Color(0xf3f6ffff);
  // static const Color labelColor = Color(0x80797979);

  static const primaryColor = Color(0xFF0F1923);
  static const backgroundColor = Color.fromRGBO(170, 129, 58, 1);
  static const Color accentorange = Color.fromARGB(249, 71, 64, 79);
  static const Color accentColor = Color.fromARGB(128, 1, 1, 1);

  static const Color textTitleColor= Color.fromARGB(255, 119, 71, 19);
  static const Color textSubtitleColor = Color(0xfefefefe);
  static const Color inputFillColor = Color.fromARGB(143, 32, 49, 49);
  static const Color InputBorderColor = Color(0xf3f6ffff);
  static const Color labelColor = Color(0x80797979);

  final Widget child;
  final String title;
  final bool showAppBar;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomNavigationBar;
  final bool showBackButton;
  final Widget? floatingActionButton; 
  final int currentIndex;
  final Function(int)? onBottomNavTap;

  const Mainlayout({
    super.key,
    required this.child,
    this.title = '',
    this.showAppBar = true,
    this.showBottomNavigationBar = true,
    this.actions,
    this.leading,
    this.floatingActionButton, 
    this.currentIndex = 0,
    this.onBottomNavTap,
    this.showBackButton = true
  });


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Mainlayout.primaryColor,
      appBar: showAppBar
          ? AppBar(
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: textSubtitleColor,
                
                ),
              ),
              centerTitle: true,
              leading: leading ?? (showBackButton && Navigator.canPop(context)
              ? Padding(
                padding: const EdgeInsets.all(8.0), 
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2), 
                  child: IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new, 
                      color: Colors.white,
                      size: 16, 
                    ),
                  ),
                ),
              )
              : null),
              actions: actions,
              backgroundColor: primaryColor,
            )
          : null,
      body: SafeArea(
        child: child
      ),
      bottomNavigationBar: showBottomNavigationBar
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onBottomNavTap,
              backgroundColor: primaryColor,
              selectedItemColor: backgroundColor,
              unselectedItemColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'Katalog'),
                BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
              ],
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}