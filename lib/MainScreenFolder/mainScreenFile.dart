import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodistan/MainScreenFolder/address_screen.dart';
import 'package:foodistan/cart_screens/login_pay_cart_screen_main.dart';
import 'package:foodistan/functions/location_functions.dart';
import 'package:foodistan/functions/order_functions.dart';
import 'package:foodistan/profile/user_profile.dart';
import 'package:foodistan/widgets/location_bottam_sheet_widget.dart';
import 'package:foodistan/widgets/order_placed_screen.dart';
import '../feedback.dart';
import '../scanner.dart';
import 'AppBar/AppBarFile.dart';
import 'Test.dart';
import 'HomeScreenFile.dart';
import 'package:foodistan/Data/data.dart';
import 'Location/LocationMap.dart';
import 'AppBar/LocationPointsSearch.dart';
import 'package:foodistan/foodistaan_custom_icon_icons.dart';
import 'package:foodistan/global/global_variables.dart' as global;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var currentLocation = null;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  int currentIndex = 0;
  int inx = 0;
  bool once = false;
  String? userNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  var Screens = [
    HomeScreen(), //HomeScreenFile
    CartScreenMainLogin(),
    ScannerScreen(),
    UserProfile(),
  ];

  Widget build(BuildContext context) {
    var h1 = MediaQuery.of(context).size.height;
    var w1 = MediaQuery.of(context).size.width;
    final Color selected = Color.fromRGBO(247, 193, 43, 1);
    final Color unselected = Colors.grey;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
          _pageController.jumpToPage(currentIndex);
        }),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: unselected,
        selectedItemColor: selected,
        backgroundColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'Images/bottomhome.svg',
              color: currentIndex == 0 ? selected : unselected,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'Images/bottomcart.svg',
                    color: currentIndex == 1 ? selected : unselected,
                  ),
                ),
                // ValueListenableBuilder(
                //     valueListenable: global.totalItemsInCart,
                //     builder: (context, value, child) {
                //       if (global.totalItemsInCart.value > 0)
                //         return Positioned(
                //           left: 20,
                //           bottom: 20,
                //           child: CircleAvatar(
                //             maxRadius: 8,
                //             backgroundColor: Colors.red,
                //             child: Center(
                //                 child: Text(
                //                     global.totalItemsInCart.value.toString(),
                //                     style: TextStyle(
                //                         color: Colors.white,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 10))),
                //           ),
                //         );
                //       else
                //         return Container(
                //           height: 0,
                //           width: 0,
                //         );
                //     })
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'Images/bottomscan.svg',
              color: currentIndex == 2 ? selected : unselected,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'Images/bottomprofile.svg',
              color: currentIndex == 3 ? selected : unselected,
            ),
            label: 'Profile',
          ),
        ],
      ),
      appBar: currentIndex == 0
          ? PreferredSize(
              preferredSize:
                  Size.fromHeight(h1 * 0.15), // here the desired height
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Container(
                        height: h1 / 25,
                        width: w1,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () async {
                                    showBarModalBottomSheet(
                                        duration: Duration(milliseconds: 300),
                                        bounce: true,
                                        backgroundColor: Colors.black,
                                        context: context,
                                        builder: (context) => Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            child: LocationBottomSheetWidget(
                                              isAddingAddress: false,
                                            )));
                                  },
                                  child: Location(),
                                )),
                            Expanded(flex: 1, child: Points()),
                          ],
                        ),
                      ),
                    ),
                    Search(
                      searchTask: () {
                        showSearch(
                            context: context,
                            delegate: DataSearch(file: Data.restaurants));
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: Screens,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: OrderFunction().fetchCurrentOrder(userNumber),
            ),
          )
        ],
      ),
    );
  }
}
