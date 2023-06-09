import 'package:breaker_pro/api/login_repository.dart';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_config.dart';
import '../dataclass/part.dart';
import '../my_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.noLogin}) : super(key: key);
  final bool noLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: BorderSide(width: 2, color: MyTheme.materialColor));
  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: BorderSide(width: 2, color: MyTheme.blue));

  late TextEditingController clientIdController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  late String deviceId;
  late String deviceName;
  late String osVersion;
  late String appVersion;
  late Map<String, dynamic> queryParams;

  @override
  void initState() {
    if (widget.noLogin) {
      loginFromCache();
    }
    clientIdController = TextEditingController(
        text: ApiConfig.baseQueryParams['clientid'] ?? "");
    usernameController = TextEditingController(
        text: ApiConfig.baseQueryParams['username'] ?? "");
    passwordController = TextEditingController(
        text: ApiConfig.baseQueryParams['password'] ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Container(
              width: 160,
              height: 160,
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset('assets/logo_breaker_pro.png')),
          // Credentials
          Column(
            children: [
              // Client ID
              Container(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: TextField(
                  controller: clientIdController,
                  style: TextStyle(color: MyTheme.materialColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.fingerprint,
                        color: MyTheme.black,
                      ),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: focusedBorder,
                      labelText: 'Client ID',
                      labelStyle: TextStyle(color: MyTheme.black54)),
                ),
              ),
              // User Name
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: usernameController,
                  style: TextStyle(color: MyTheme.materialColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box_rounded,
                      color: MyTheme.black,
                    ),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: focusedBorder,
                    labelText: 'User Name',
                    labelStyle: TextStyle(color: MyTheme.black54),
                  ),
                ),
              ),
              // Password
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: passwordController,
                  style: TextStyle(color: MyTheme.materialColor),
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: MyTheme.black,
                      ),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: focusedBorder,
                      labelText: 'Password',
                      labelStyle: TextStyle(color: MyTheme.black54)),
                ),
              ),
              // Log In Button
              Container(
                height: 70,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ElevatedButton(
                  onPressed: loginFromUser,
                  child: Text(
                    "LOG IN",
                    style: TextStyle(fontSize: 30, color: MyTheme.white),
                  ),
                ),
              ),
              // Forgot Password
              TextButton(
                onPressed: () {
                  showForgotDialog();
                },
                child: Text(
                  'Forgot Your Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: MyTheme.grey),
                ),
              ),
              // Contact Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () => {
                          MainDashboardUtils.openUrl(
                              "https://breakerpro.co.uk/livechat")
                        },
                        icon: Icon(Icons.email, color: MyTheme.white),
                        label: Text(
                          "Live Chat",
                          style: TextStyle(
                            color: MyTheme.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                            backgroundColor: MyTheme.redLiveChat),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () => {
                          MainDashboardUtils.openUrl(
                              "https://breakerpro.co.uk/whatsapp")
                        },
                        icon: Icon(
                          Icons.message,
                          color: MyTheme.white,
                        ),
                        label: Text(
                          "WhatsApp Chat",
                          style: TextStyle(
                            color: MyTheme.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          backgroundColor: MyTheme.greenWhatsapp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //Footer
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(AppConfig.rightsInfo),
                  Text(AppConfig.appVersion,style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(AppConfig.updateDate),
                ],
              ),
            ),
          )
          //Footer
        ],
      ),
    );
  }

  login(Map<String, dynamic> queryParams) async {
    AuthUtils.showLoadingDialog(context);

    final String result = await AuthRepository.login(
        ApiConfig.baseUrl + ApiConfig.apiLogin, queryParams);

    if (result == 'Login Successfully') {
      await ApiConfig.uploadParamsToStorage(queryParams);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MainDashboard(),
      ));
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
      Navigator.of(context).pop();
    }
  }

  loginFromUser() async {
    if (clientIdController.text.isEmpty ) {
      Fluttertoast.showToast(msg: "Please enter Client ID");
      return;
    }
    if (usernameController.text.isEmpty ) {
      Fluttertoast.showToast(msg: "Please enter User Name");
      return;
    }
    if (passwordController.text.isEmpty ) {
      Fluttertoast.showToast(msg: "Please enter Password");
      return;
    }
    queryParams = {
      "clientid": clientIdController.text.toString(),
      "username": usernameController.text.toString(),
      "password": passwordController.text.toString(),
      "deviceid": AppConfig.deviceId,
      "SyncDeviceLists": "SYNC",
      "appversion": AppConfig.appVersion,
      "osversion": AppConfig.osVersion,
      "devicename": AppConfig.deviceName,
    };

    if(AppConfig.clientId != clientIdController.text.toString()){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('selectList');
      PartsList.partList.clear();
      Box<Part> box = await Hive.openBox('partsBox');
      await box.clear();
      await box.close();
      print("CLEARED LIST");
    }

    print("Query Params from user");
    await login(queryParams);
  }

  loginFromCache() async {
    if (await ApiConfig.fetchParamsFromStorage()) {
      await login(ApiConfig.baseQueryParams);
    }
  }

  openAlreadyActiveDialogue(
      BuildContext context, Map<String, dynamic> queryParams) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    Widget logoutButton = TextButton(
      onPressed: () {
        logout(queryParams);
      },
      child: const Text("LOGOUT"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("The App User is Already Active on Another Device"),
      content: const Text(
          "Do you want to Log Out of the other device and Log In on this device?"),
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

  logout(Map<String, dynamic> queryParams) async {
    Navigator.of(context).pop();
    final logoutParams = {
      'clientid': queryParams['clientid'],
      'username': queryParams['username']
    };
    String result = await AuthRepository.logout(
        ApiConfig.baseUrl + ApiConfig.apiLogin, logoutParams);
    if (result == "Successful Logout") {
      print("Logout");
      Navigator.of(context).pop();
      await login(queryParams);
    } else {
      Navigator.of(context).pop();
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

  Future<void> showForgotDialog() async {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.warning_rounded,size: 35,),
          Text("Forgot Password",style: TextStyle(fontSize: 20),),
        ],
      ), 
      content: const Text(
          "Please contact BreakerPRO administrator to reset your password.",style: TextStyle(fontSize: 16),),
      actions: [
        okButton,
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
}
