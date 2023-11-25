import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<Application> apps = [];
  final PageController _drawerController =
      PageController(initialPage: 0, keepPage: true);
  final PageController _pageController =
      PageController(initialPage: 1, keepPage: true);
  String _searchText = "";
  bool loading = true;
  getApps() async {
    apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    loading = false;
    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset < -50) {
        _drawerController.animateToPage(0,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
    getApps();
    super.initState();
  }

  List<Widget> showApp(String appname) {
    return [
      for (var app in apps)
        if (app.appName.toLowerCase().startsWith(appname.toLowerCase()))
          Column(children: [
            app is ApplicationWithIcon
                ? Center(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: MemoryImage(app.icon),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => DeviceApps.openApp(app.packageName),
                          borderRadius: BorderRadius.circular(90),
                          splashColor: Colors.black,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ])
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Application> showingApps = apps
      ..sort((a, b) => a.appName.compareTo(b.appName));

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: loading
            ? const SizedBox.shrink()
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        body: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/logo.jpg",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PageView(
                        pageSnapping: true,
                        controller: _drawerController,
                        scrollDirection: Axis.vertical,
                        children: [
                          Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Stack(children: [
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(90),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            showApp("phone")[0],
                                            showApp("chrome")[0],
                                            showApp("google play")[0],
                                            showApp("photos")[0],
                                            showApp("camera")[0],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                          ClipRRect(
                            child: Scaffold(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              body: BackdropFilter(
                                blendMode: BlendMode.srcOver,
                                filter: ImageFilter.blur(
                                  sigmaX: 10.0,
                                  sigmaY: 10.0,
                                ),
                                child: SafeArea(
                                  child: ListView(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(8),
                                    children: [
                                      // const Padding(
                                      //   padding: EdgeInsets.all(8.0),
                                      //   child: Text(
                                      //     "Samir Launcher",
                                      //     style: TextStyle(
                                      //       fontSize: 30,
                                      //     ),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: TextField(
                                            onChanged: (text) {
                                              setState(() {
                                                _searchText = text;
                                              });
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.search),
                                              hintText: "Search...",
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GridView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4),
                                        children: [
                                          for (var app in showingApps)
                                            if (app.appName
                                                .toLowerCase()
                                                .startsWith(
                                                    _searchText.toLowerCase()))
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () =>
                                                      DeviceApps.openApp(
                                                          app.packageName),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        app
                                                                is ApplicationWithIcon
                                                            ? Center(
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundImage:
                                                                      MemoryImage(
                                                                          app.icon),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            app.appName,
                                                            style:
                                                                const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
