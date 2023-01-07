import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:breaker_pro/api/api_config.dart';
import 'package:breaker_pro/api/vehicle_repository.dart';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/screens/login_screen.dart';
import 'package:breaker_pro/screens/notification_screen.dart';
import 'package:breaker_pro/screens/settings_screen.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:breaker_pro/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_call.dart';
import '../api/login_repository.dart';
import '../api/parts_repository.dart';
import '../app_config.dart';
import '../dataclass/parts_list.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  late PartsList partsList;
  @override
  void initState() {
    partsList = PartsList();
    fetchSelectListNetwork();
    fetchPartsListNetwork();
    upload();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Image.asset('assets/logo_breaker_pro.png'),
        ),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => const SettingsScreen()))
                  },
              icon: Icon(
                Icons.settings,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () => {openLogoutDialog(context)},
              icon: Icon(
                Icons.logout,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () async {
                Directory? appDocDirectory =
                    await getExternalStorageDirectory();
                print(appDocDirectory);
                var encoder = ZipFileEncoder();
                encoder.create(
                    "${appDocDirectory!.path}/Logger${DateFormat('dd_MM_yyyy').format(DateTime.now())}.zip");

                var assets = await rootBundle.loadString('AssetManifest.json');
                Map json = jsonDecode(assets);
                List files = json.keys
                    .where((element) => element.startsWith('assets/logger/'))
                    .toList();

                for (var path in files) {
                  final byteData = await rootBundle.load('$path');
                  final file =
                      File('${(await getTemporaryDirectory()).path}/$path');
                  file.createSync(recursive: true);
                  await file.writeAsBytes(byteData.buffer.asUint8List(
                      byteData.offsetInBytes, byteData.lengthInBytes));
                  encoder.addFile(file);
                }
                encoder.close();
                File f = File(encoder.zipPath);
                ShareExtend.share(f.path, "file");
              },
              icon: Icon(
                Icons.share,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationScreen()))
                  },
              icon: Icon(
                Icons.notifications,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () {
                MainDashboardUtils.openUrl("https://breakerpro.co.uk/livechat");
              },
              icon: Icon(
                Icons.chat,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget))
                  },
              icon: Icon(
                Icons.refresh,
                color: MyTheme.white,
              )),
        ],
      ),
      body: ListView.builder(
          itemCount: MainDashboardUtils.titleList.length + 1,
          itemBuilder: (context, index) {
            if (index == MainDashboardUtils.titleList.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Live Chat
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                MainDashboardUtils.openUrl(
                                    "https://breakerpro.co.uk/livechat");
                              },
                              icon: const Icon(Icons.chat),
                              label: const Text("Live Chat"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.redLiveChat,
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        // Whatsapp
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                MainDashboardUtils.openUrl(
                                    "https://breakerpro.co.uk/whatsapp");
                              },
                              icon: const Icon(Icons.whatsapp),
                              label: const Text("Whatsapp Chat"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.greenWhatsapp,
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(AppConfig.rightsInfo),
                          Text("version $AppConfig.appVersion"),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: GestureDetector(
                    onTap: () {
                      print(index);
                      if (index == 0) {
                        MainDashboardUtils.functionList[index]!(
                            context, partsList);
                      } else if (index == 1) {
                        MainDashboardUtils.functionList[index]!(
                            context, partsList);
                      } else {
                        MainDashboardUtils.functionList[index]!(context);
                      }
                    },
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(children: [
                              // Details
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 10),
                                        child: Text(
                                          MainDashboardUtils.titleList[index],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // Subtitle
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          MainDashboardUtils
                                              .subtitleList[index],
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Icon
                              Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  height: 80,
                                  width: 80,
                                  child: MainDashboardUtils.imageList[index])
                            ])))));
          }),
    );
  }

  logout() async {
    AuthUtils.showLoadingDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    final logoutParams = {
      'clientid': ApiConfig.baseQueryParams['clientid'],
      'username': ApiConfig.baseQueryParams['username']
    };
    String result = await AuthRepository.logout(
        ApiConfig.baseUrl + ApiConfig.apiLogin, logoutParams);
    if (result == "Successful Logout") {
      print("Logout");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (builder) => LoginScreen()));
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Failed to Logout",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  openLogoutDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget logoutButton = TextButton(
      onPressed: logout,
      child: const Text("LOGOUT"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        logoutButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  fetchSelectListNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map response;
    if (prefs.getString('selectList') == null) {
      AuthUtils.showLoadingDialog(context);
      await ApiConfig.fetchParamsFromStorage();
      var q = ApiConfig.baseQueryParams;
      q['index'] = "1";
      response =
          await ApiCall.get(ApiConfig.baseUrl + ApiConfig.apiSelectList, q);

      List responseList = response['selects'] as List;
      Map<String, dynamic> m = {};
      for (Map a in responseList) {
        if (a['SelectList'] != "MODEL") {
          if (m[a['SelectList']] == null) {
            if (a['SelectValue'] != "No Value") {
              m[a['SelectList']] = [a['SelectValue']];
            }
          } else {
            m[a['SelectList']]?.add(a['SelectValue']);
          }
        } else {
          if (m[a['RelatedValue']] == null) {
            m[a['RelatedValue']] = [a['SelectValue']];
          } else {
            m[a['RelatedValue']]?.add(a['SelectValue']);
          }
        }
      }
      String user = jsonEncode(m);
      prefs.setString('selectList', user);
      Navigator.pop(context);
    }
  }

  fetchPartsListNetwork() async {
    print("Fetching Parts List");
    Map<String, dynamic> queryParams = ApiConfig.baseQueryParams;
    queryParams['index'] = "0";
    bool b = await partsList.loadParts(
        ApiConfig.baseUrl + ApiConfig.apiPartList, queryParams);
    if (b) {
      setState(() {});
    }
  }

  Future<void> upload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? vUpload = prefs.getBool('uploadVehicle');
    bool? pUpload = prefs.getBool('uploadParts');
    if (pUpload == true) {
      bool r = await PartRepository.uploadParts(PartsList.uploadPartList);
      if (r) {
        prefs.setBool('uploadParts', false);
      }
    }
    if (vUpload == true) {
      bool r = await VehicleRepository.uploadVehicle(PartsList.uploadVehicle);
      // await VehicleRepository.fileUpload(PartsList.uploadVehicle);
      if (r) {
        prefs.setBool('uploadVehicle', false);
      }
    }
  }
}
