import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:breaker_pro/notification_service.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_logs/flutter_logs.dart';
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
import '../dataclass/image_list.dart';
import '../dataclass/parts_list.dart';
import '../dataclass/vehicle.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  late PartsList partsList;
  late Timer timer;
  @override
  void initState() {
    initialiseLog();
    partsList = PartsList();
    fetchSelectListNetwork();
    fetchPartsListNetwork();
    upload();
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => checkLogin());
  }

  @override
  void dispose() {
    Hive.close();
    timer.cancel();
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
                Directory? externalDirectory;

                if (Platform.isIOS) {
                  externalDirectory = await getApplicationDocumentsDirectory();
                } else {
                  externalDirectory = await getExternalStorageDirectory();
                }
                print(externalDirectory);
                var encoder = ZipFileEncoder();
                encoder.create(
                    "${externalDirectory!.path}/Logger${DateFormat('dd_MM_yyyy').format(DateTime.now())}.zip");

                await encoder.addDirectory(
                    Directory("${externalDirectory.path}/MyLogs/Logs"),
                    includeDirName: false);
                // }

                // for (var path in files) {
                //   final byteData = await rootBundle.load('$path');
                //   final file =
                //       File('${(await getTemporaryDirectory()).path}/$path');
                //   file.createSync(recursive: true);
                //   await file.writeAsBytes(byteData.buffer.asUint8List(
                //       byteData.offsetInBytes, byteData.lengthInBytes));
                //   encoder.addFile(file);
                // }
                encoder.close();
                // File f = File(encoder.zipPath);
                // print(f.path);
                await ShareExtend.share(encoder.zipPath, "file");
              },
              icon: Icon(
                Icons.share,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () => {
                    // openAlreadyActiveDialogue(
                    //     context, ApiConfig.baseQueryParams)
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
              onPressed: () async => {
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
                        if (PartsList.uploadVehicle != null) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => const VehicleDetailsScreen(),
                          ))
                              .then((value) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => MainDashboard()),
                                (Route r) => false);
                          });
                        } else {
                          MainDashboardUtils.functionList[index]!(
                              context, partsList);
                        }
                      } else if (index == 1) {
                        MainDashboardUtils.functionList[index]!(
                            context, partsList);
                      } else {
                        MainDashboardUtils.functionList[index]!(context);
                      }
                    },
                    child: PartsList.uploadVehicle != null && index == 0
                        ? Column(
                            children: [
                              cardView(index),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        MainDashboardUtils.titleList[0] =
                                            "Add Breaker";
                                        PartsList.uploadVehicle = null;
                                        PartsList.prefs!.remove('vehicle');
                                        PartsList.recall = false;
                                        ImageList.vehicleImgList = [];
                                        ImageList.partImageList = [];
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.black26,
                                      minimumSize:
                                          const Size.fromHeight(50), // NEW
                                    ),
                                    child: Text(
                                      "RESET",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal),
                                    )),
                              )
                            ],
                          )
                        : cardView(index)));
          }),
    );
  }

  Widget cardView(int index) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(children: [
              // Details
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                        child: Text(
                          MainDashboardUtils.titleList[index],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          MainDashboardUtils.subtitleList[index],
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
            ])));
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
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const LoginScreen(
                    noLogin: false,
                  )),
          (route) => false);
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

  logoutAnotherDevice(Map<String, dynamic> queryParams) async {
    AuthUtils.showLoadingDialog(context);
    final logoutParams = {
      'clientid': queryParams['clientid'],
      'username': queryParams['username']
    };
    String result = await AuthRepository.logout(
        ApiConfig.baseUrl + ApiConfig.apiLogin, logoutParams);
    if (result == "Successful Logout") {
      print("Logout");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const LoginScreen(
                    noLogin: false,
                  )),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const LoginScreen(
                    noLogin: false,
                  )),
          (route) => false);
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
    PartsList.prefs = prefs;
    Map response;

    if (prefs.getString('selectList') == null) {
      AuthUtils.showLoadingDialog(context);
      await ApiConfig.fetchParamsFromStorage();
      var q = ApiConfig.baseQueryParams;
      // q['index'] = "1";
      response =
          await ApiCall.get(ApiConfig.baseUrl + ApiConfig.apiSelectList, q);

      FlutterLogs.logToFile(
          logFileName: "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
          overwrite: false,
          logMessage:
              "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} SELECT LIST $ApiConfig.baseUrl + ApiConfig.apiSelectList Success $response\n");

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

    if (prefs.getString('vehicle') != null) {
      print(prefs.getString('vehicle'));
      Vehicle v = Vehicle();
      Map<String, String> map = Map<String, String>.from(
          jsonDecode(prefs.getString('vehicle').toString()));
      v.fromJson(map);
      PartsList.uploadVehicle = v;
      String model = v.model == "" ? "Model" : v.model;
      MainDashboardUtils.titleList[0] = "Resume Work ( ${v.make}-${model} )";
      setState(() {});
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
    Vehicle? v = PartsList.uploadVehicle;
    print("VV: ${PartsList.uploadVehicle!.imgList}");
    if (vUpload == true) {
      setState(() {
        MainDashboardUtils.titleList[0] = "Add Breaker";
        PartsList.uploadVehicle = null;
        PartsList.prefs!.remove('vehicle');
        PartsList.recall = false;
      });
      bool r = await VehicleRepository.uploadVehicle(v!);

      await VehicleRepository.fileUpload(v);
      if (r) {
        setState(() {
          PartsList.uploadVehicle = null;
          prefs.setBool('uploadVehicle', false);
          MainDashboardUtils.titleList[0] = "Add Breaker";
          PartsList.uploadVehicle = null;
          PartsList.prefs!.remove('vehicle');
          PartsList.recall = false;
          ImageList.vehicleImgList = [];
        });
      }
      if (pUpload == false || pUpload == null) {
        NotificationService().instantNofitication("Upload Complete");
      }
    }
    if (pUpload == true) {
      bool r = await PartRepository.uploadParts(
          PartsList.uploadPartList!, v!.vehicleId);
      await PartRepository.fileUpload(PartsList.uploadPartList!, v!.vehicleId);
      if (r) {
        PartsList.uploadPartList = [];
        prefs.setBool('uploadParts', false);
        ImageList.partImageList = [];
        fetchPartsListNetwork();
        NotificationService().instantNofitication("Upload Complete");
      }
    }
  }

  login(Map<String, dynamic> queryParams) async {
    final String result = await AuthRepository.login(
        ApiConfig.baseUrl + ApiConfig.apiLogin, queryParams);

    if (result == 'Login Successfully') {
      await ApiConfig.uploadParamsToStorage(queryParams);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainDashboard()),
          (Route r) => false);
    } else if (result == 'User Active on Another Device') {
      Fluttertoast.showToast(msg: "User Active on Another Device");
      await openAlreadyActiveDialogue(context, queryParams);
    } else {
      Fluttertoast.showToast(
          msg: "User Account Doesn't Exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainDashboard()),
          (Route r) => false);
    }
  }

  Future<void> checkLogin() async {
    // Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiLogin);
    // uri = uri.replace(queryParameters: ApiConfig.baseQueryParams);
    // final response = await http.get(uri, headers: ApiConfig.headers);
    // String responseBody = utf8.decoder.convert(response.bodyBytes);
    // final Map<String, dynamic> responseJson = json.decode(responseBody);
    // String result = responseJson['result'];
    String result = await AuthRepository.login(
        ApiConfig.baseUrl + ApiConfig.apiLogin, ApiConfig.baseQueryParams);

    if (result == 'User Active on Another Device') {
      print(result);
      timer.cancel();
      openAlreadyActiveDialogue(context, ApiConfig.baseQueryParams);
    }
  }

  openAlreadyActiveDialogue(
      BuildContext context, Map<String, dynamic> queryParams) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: ElevatedButton.icon(
        onPressed: () {
          MainDashboardUtils.openUrl("https://breakerpro.co.uk/whatsapp");
        },
        icon: const Icon(Icons.whatsapp),
        label: const Text("Whatsapp Chat"),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.greenWhatsapp,
          textStyle: const TextStyle(fontSize: 15),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => const LoginScreen(
                      noLogin: false,
                    )),
            (route) => false);
      },
    );
    Widget logoutButton = TextButton(
      onPressed: () {
        logoutAnotherDevice(queryParams);
      },
      child: const Text("LOGOUT"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "The App User is Already Active on Another Device",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Do you want to Log Out of the other device and Log In on this device?",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Please contact us if you require an additional mobile app subscription for this devide.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
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

  Future<void> initialiseLog() async {
    await FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
        logTypesEnabled: [
          "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
          "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
          "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}"
        ],
        logFileExtension: LogFileExtension.TXT,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        logsExportZipFileName:
            "Logger${DateFormat('dd_MM_YYYY').format(DateTime.now())}",
        debugFileOperations: true,
        isDebuggable: true);
  }
}
