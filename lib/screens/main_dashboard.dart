import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:breaker_pro/dataclass/notification_utils.dart';
import 'package:breaker_pro/notification_service.dart';
import 'package:breaker_pro/screens/qr_screen.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import '../dataclass/part.dart';
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
  late String temp;
  Map responseJson = {};
  bool isUploading = false;
  @override
  void initState() {
    // upload();
    initialiseLog();
    partsList = PartsList();
    fetchSelectListNetwork();
    fetchPartsListNetwork();

    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => checkLogin());
  }

  @override
  void dispose() {
    PartsList.prefs!.setInt('partCount', PartsList.partCount);
    PartsList.prefs!.setInt('vehicleCount', PartsList.vehicleCount);
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
                Fluttertoast.showToast(
                    msg: "Please wait while creating zip...");
                Directory externalDirectory = AppConfig.externalDirectory!;
                String platform = "";
                if(Platform.isAndroid){
                  platform = "Android";
                }
                else{
                  platform = "iOS";
                }
                var encoder = ZipFileEncoder();
                encoder.create(
                    "${externalDirectory.parent.path}/ExportedLogs/${platform}Logger${DateFormat('dd_MM_yyyy').format(DateTime.now())}.zip");

                // if (Platform.isIOS) {
                //   externalDirectory = await getApplicationDocumentsDirectory();
                //   externalDirectory = Directory(
                //       "${externalDirectory.parent.path}/Library/Application Support/Logs");
                //   encoder.create(
                //       "${externalDirectory.path}/Logger${DateFormat('dd_MM_yyyy').format(DateTime.now())}.zip");
                //
                //   await encoder.addDirectory(
                //       Directory("${externalDirectory.path}"),
                //       includeDirName: false);
                // } else {
                //   externalDirectory = await getExternalStorageDirectory();
                //   encoder.create(
                //       "${externalDirectory!.path}/Logger${DateFormat('dd_MM_yyyy').format(DateTime.now())}.zip");
                //
                //   await encoder.addDirectory(
                //       Directory("${externalDirectory.path}/MyLogs/Logs"),
                //       includeDirName: false);
                // }
                // print(externalDirectory.listSync(recursive: true));
                await encoder.addDirectory(Directory(externalDirectory.path),
                    includeDirName: false);
                encoder.close();
                await ShareExtend.share(encoder.zipPath, "file",subject: "BreakerPRO - $platform App Debug Logs \nClient Id: ${AppConfig.clientId} \nUserName: ${AppConfig.username}",extraText: "Send the logs for better issue tracking.");
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
              onPressed: () async {
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => super.widget));
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => QrScreen()));
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
                              icon: const Icon(Icons.chat,color: Colors.white,),
                              label: const Text("LIVE CHAT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
                              icon: const Icon(Icons.whatsapp,color: Colors.white,),
                              label: const Text("WhatsApp Chat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.greenWhatsapp,
                                textStyle: const TextStyle(fontSize: 14),
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
                          Text(AppConfig.appVersion,style: TextStyle(fontWeight: FontWeight.bold),),                        ],
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
                      if (index == 0 || index == 1) {
                        if (PartsList.cachedVehicle != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const VehicleDetailsScreen(),
                          ))
                              //     .then((value) {
                              //   Navigator.of(context).pushAndRemoveUntil(
                              //       MaterialPageRoute(
                              //           builder: (_) => MainDashboard()),
                              //       (Route r) => false);
                              // })
                              ;
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
                    child: PartsList.cachedVehicle != null && index == 0
                        ? Column(
                            children: [
                              cardView(index),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      Box<Part> box =
                                          await Hive.openBox('partListBox');
                                      Box<Part> box1 = await Hive.openBox(
                                          'selectPartListBox');
                                      await box.clear();
                                      await box1.clear();
                                      setState(() {
                                        MainDashboardUtils.titleList[0] =
                                            "Add & Manage Breaker";
                                        PartsList.cachedVehicle = null;
                                        PartsList.prefs!.remove('vehicle');
                                        PartsList.prefs!.remove('partList');
                                        PartsList.prefs!.remove('selectedList');
                                        PartsList.recall = false;
                                        ImageList.vehicleImgList = [];
                                        ImageList.partImageList = [];
                                        PartsList.selectedPartList = [];

                                        fetchPartsListNetwork();
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

  createMenuList(String title, List<String> menu, Map responseJson) {
    List l = responseJson[title];
    menu.clear();
    menu = List<String>.generate(l.length, (index) => l[index]);
    return menu;
  }

  fetchSelectListNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PartsList.prefs = prefs;
    if (prefs.getInt('partCount') != null) {
      PartsList.partCount = prefs.getInt('partCount')! + 1;
    }
    if (prefs.getInt('vehicleCount') != null) {
      PartsList.vehicleCount = prefs.getInt('vehicleCount')! + 1;
    }
    Map response;

    if (prefs.getString('selectList') == null) {
      AuthUtils.showLoadingDialog(context);
      await ApiConfig.fetchParamsFromStorage();
      var q = ApiConfig.baseQueryParams;
      // q['index'] = "1";
      response =
          await ApiCall.get(ApiConfig.baseUrl + ApiConfig.apiSelectList, q);

      final File file = File(
          '${AppConfig.externalDirectory!.path}/LOGGER${DateFormat("ddMMyy").format(DateTime.now())}.txt');
      await file.writeAsString(
          "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} SELECT LIST ${ApiConfig.baseUrl + ApiConfig.apiSelectList} Success $response\n",
          mode: FileMode.append);

      List responseList = response['selects'] as List;
      for (Map a in responseList) {
        if (a['SelectList'] != "MODEL") {
          if (responseJson[a['SelectList']] == null) {
            if (a['SelectValue'] != "No Value") {
              responseJson[a['SelectList']] = [a['SelectValue']];
            }
          } else {
            responseJson[a['SelectList']]?.add(a['SelectValue']);
          }
        }
        else {
          if (responseJson[a['RelatedValue']] == null) {
            responseJson[a['RelatedValue']] = [a['SelectValue']];
          } else {
            responseJson[a['RelatedValue']]?.add(a['SelectValue']);
          }
        }
      }
      String user = jsonEncode(responseJson);
      prefs.setString('selectList', user);
      Navigator.pop(context);
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String response = prefs.getString('selectList').toString();
      responseJson = jsonDecode(response);

    }
    AppConfig.postageOptionsList = createMenuList('POSTAGE', AppConfig.postageOptionsList, responseJson);

    // await upload();
    await upload();

    if (prefs.getString('vehicle') != null) {
      print("From cache ${prefs.getString('vehicle')}");
      Vehicle v = Vehicle();
      Map<String, dynamic> map = Map<String, dynamic>.from(
          jsonDecode(prefs.getString('vehicle')!) as Map<dynamic, dynamic>);
      v.fromJson(map);
      List a = map['Images'];
      PartsList.cachedVehicle = v;
      ImageList.vehicleImgList =
          List<String>.generate(a.length, (index) => a[index]);
      String model = v.model == "" ? "Model" : v.model;
      MainDashboardUtils.titleList[0] = "Resume Work ( ${v.make}-$model )";

      setState(() {});
    }
  }

  fetchPartsListNetwork() async {
    PartsList.selectedPartList = [];
    PartsList.partList = [];
    PartsList.uploadPartList = [];
    print("Fetching Parts List");
    Box<Part> box = await Hive.openBox('partListBox');
    if (box.isNotEmpty) {
      PartsList.partList = box.values.toList();
    } else {
      print(" empyt");
    }

    Box<Part> box1 = await Hive.openBox('selectPartListBox');
    if (box1.isNotEmpty) {
      PartsList.selectedPartList = box1.values.toList();
    } else {
      print(" empyt");
    }
    Map<String, dynamic> queryParams = ApiConfig.baseQueryParams;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('partList') != null) {
    //   Map<String, List> map = Map<String, List>.from(
    //       jsonDecode(prefs.getString('partList')!) as Map<dynamic, dynamic>);
    //   print("Cached ${map}");
    //   // print("Cached ${l}");
    // }

    queryParams['index'] = "0";
    if (PartsList.partList.isEmpty) {
      bool b = await partsList.loadParts(
          ApiConfig.baseUrl + ApiConfig.apiPartList, queryParams);
      if (b) {
        setState(() {});
      }
    }
  }

  Future<void> upload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('uploadQueue') == null){
      return;
    }
    Map<String, dynamic> map = Map<String, dynamic>.from(
        jsonDecode(prefs.getString('uploadQueue').toString()) as Map<dynamic, dynamic>);
    List t = List.generate(
        map['uploadQueue'].length, (index) => map['uploadQueue'][index]);
    PartsList.uploadQueue = List.generate(
        map['uploadQueue'].length, (index) => map['uploadQueue'][index]);

    var connectivityResult = await (Connectivity().checkConnectivity());
    if(!(connectivityResult == ConnectivityResult.ethernet ||connectivityResult == ConnectivityResult.mobile ||connectivityResult == ConnectivityResult.wifi) ){
      print("Returned ${connectivityResult.name}");
      return;
    }
    if(isUploading){
      return;
    }
    isUploading = true;

    for (String vehicleString in PartsList.uploadQueue) {
      print("Uploadinggg");
      print(vehicleString);
      print(prefs.getString(vehicleString));
      Vehicle v = Vehicle();
      if (prefs.getString(vehicleString) != null) {
        Map<String, dynamic> map = Map<String, dynamic>.from(
            jsonDecode(prefs.getString(vehicleString)!)
                as Map<dynamic, dynamic>);
        v.fromJson(map);
        List a = map['Images'];
        print("Images ss $a");
        ImageList.uploadVehicleImgList =
            List<String>.generate(a.length, (index) => a[index]);
        // v.imgList = List.from(ImageList.uploadVehicleImgList);
        bool isVehicleUpload = await VehicleRepository.uploadVehicle(v);
        bool isPartUpload = false;
        bool isPhotoUpload = false;

        await VehicleRepository.fileUpload(v);
        Box<Part> box1 = await Hive.openBox('uploadPartListBox');
        if (box1.isNotEmpty) {
          PartsList.uploadPartList = [];
          PartsList.selectedPartList = box1.values.toList();
          for (Part part in PartsList.selectedPartList) {
            if (part.forUpload) {
              PartsList.uploadPartList.add(part);
            }
          }
        } else {
          print(" empty part list");
        }

        print("Upload Part List ${PartsList.uploadPartList}");

        if(PartsList.uploadPartList.isNotEmpty){
          isPartUpload = await PartRepository.uploadParts(
              PartsList.uploadPartList, v.vehicleId, v.model);
          isPhotoUpload = await PartRepository.fileUpload(
              PartsList.uploadPartList, v.vehicleId, v.model);
        }else{
          isPartUpload = true;
          isPhotoUpload = true;
        }


        if (isVehicleUpload && isPhotoUpload && isPartUpload) {
          t.remove(vehicleString);
          bool b = await prefs.setString('uploadQueue', jsonEncode({'uploadQueue': t}));
          print("Removed Vehicle: $b");

          PartsList.uploadPartList = [];
          PartsList.selectedPartList = [];
          PartsList.cachedVehicle = null;
          prefs.setBool('uploadParts', false);
          ImageList.partImageList = [];
          fetchPartsListNetwork();
          NotificationService().instantNofitication("Upload Complete",playSound: true);
          MainDashboardUtils.titleList[0] = "Add & Manage Breaker";
          await PartsList.prefs!.remove(vehicleString);
          await prefs.remove('vehicle');
          Box<Part> box = await Hive.openBox('partListBox');
          Box<Part> box1 = await Hive.openBox('selectPartListBox');
          Box<Part> box2 = await Hive.openBox('uploadPartListBox');
          MainDashboardUtils.titleList[0] = "Add & Manage Breaker";
          await box.clear();
          await box1.clear();
          await box2.clear();
          setState(() {});
        }
      }
    }

    isUploading = false;

    // bool? vUpload = prefs.getBool('uploadVehicle');
    // bool? pUpload = prefs.getBool('uploadParts');
    // Vehicle? v = PartsList.cachedVehicle;
    // print("VV: ${PartsList.cachedVehicle!.imgList}");
    // if (vUpload == true) {
    //   setState(() {
    //     MainDashboardUtils.titleList[0] = "Add Breaker";
    //     PartsList.cachedVehicle = null;
    //     PartsList.recall = false;
    //   });
    //   bool r = await VehicleRepository.uploadVehicle(v!);
    //
    //   await VehicleRepository.fileUpload(v);
    //   if (r) {
    //     setState(() {
    //       PartsList.cachedVehicle = null;
    //       prefs.setBool('uploadVehicle', false);
    //       MainDashboardUtils.titleList[0] = "Add Breaker";
    //       PartsList.cachedVehicle = null;
    //       PartsList.prefs!.remove('vehicle');
    //       PartsList.recall = false;
    //       ImageList.vehicleImgList = [];
    //     });
    //   }
    //   if (pUpload == false || pUpload == null) {
    //     NotificationService().instantNofitication("Upload Complete");
    //   }
    // }
    // if (pUpload == true) {
    //   bool r = await PartRepository.uploadParts(
    //       PartsList.uploadPartList!, v!.vehicleId);
    //   await PartRepository.fileUpload(PartsList.uploadPartList!, v!.vehicleId);
    //   if (r) {
    //     PartsList.uploadPartList = [];
    //     PartsList.selectedPartList = [];
    //     prefs.setBool('uploadParts', false);
    //     ImageList.partImageList = [];
    //     fetchPartsListNetwork();
    //     NotificationService().instantNofitication("Upload Complete");
    //   }
    // }
  }

  checkConnectivity() async{
    var connectivityResult = await Connectivity().checkConnectivity();
    if(!(connectivityResult == ConnectivityResult.ethernet ||connectivityResult == ConnectivityResult.mobile ||connectivityResult == ConnectivityResult.wifi) ){
      AppConfig.isConnected = false;
    }
    else{
      AppConfig.isConnected = true;
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
    String result = await AuthRepository.login(
        ApiConfig.baseUrl + ApiConfig.apiLogin, ApiConfig.baseQueryParams);
    temp = result;
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> initialiseLog() async {
    // await FlutterLogs.initLogs(
    //     logLevelsEnabled: [
    //       LogLevel.INFO,
    //       LogLevel.WARNING,
    //       LogLevel.ERROR,
    //       LogLevel.SEVERE
    //     ],
    //     timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    //     directoryStructure: DirectoryStructure.FOR_DATE,
    //     logTypesEnabled: [
    //       "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
    //       "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
    //       "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}"
    //     ],
    //     logFileExtension: LogFileExtension.TXT,
    //     logsWriteDirectoryName: "MyLogs",
    //     logsExportDirectoryName: "MyLogs/Exported",
    //     logsExportZipFileName:
    //         "Logger${DateFormat('dd_MM_YYYY').format(DateTime.now())}",
    //     debugFileOperations: true,
    //     isDebuggable: true);
  }

}
