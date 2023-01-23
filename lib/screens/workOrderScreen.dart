import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:breaker_pro/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:breaker_pro/screens/workOrderScreen2.dart';

class WorkOrderScreen extends StatefulWidget {
  const WorkOrderScreen({Key? key}) : super(key: key);

  @override
  State<WorkOrderScreen> createState() => _WorkOrderScreenState();
}

class _WorkOrderScreenState extends State<WorkOrderScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedValue;
  TextStyle customTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: MyTheme.materialColor);
  late AnimationController _controller;
  final BottomDrawerController _controller1 = BottomDrawerController();
  final BottomDrawerController _controller2 = BottomDrawerController();

  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  String? predefinedValue;
  String? partTypeValue;

  late List<String> columnList = ['WO NUMBER', 'WO TYPE', 'WO DATETIME', 'WO DETAILS', 'WO CUSTOMERDETAILS', 'WO DELIVERYDETAILS', 'WO SHIPPINGDETAILS','WO VEHICLEDETAILS','WO PARTID', 'WO PARTNAME', 'WO PARTLOCATION', 'WO TRACKING'];

  List<DropdownMenuItem<String>> preDefinedDropDownItems = [];

  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2, color: MyTheme.blue));
  bool selectAll = false;
  final double _headerHeight = 60.0;
  final double _bodyHeight = 300.0;
  String search = "";
  double endValue = 0;
  bool isEdit=true;
  int? selectedRadio;
  int index=0;


  @override
  void initState() {
    super.initState();

    for (String item in columnList) {
      preDefinedDropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: [
        GestureDetector(
          onTap: () {
            _controller1.close();
          },
          child: Scaffold(
            // appBar: PreferredSize(
            //   preferredSize: Size.fromHeight(100),
            //   child:
            //   AppBar(
            //
            //     backgroundColor: MyTheme.materialColor,
            //     elevation: 0,
            //     leading: IconButton(
            //       icon: Icon(Icons.arrow_back, color: MyTheme.white),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //     ),
            //     actions: <Widget>[
            //       Expanded(
            //         child: Padding(
            //           padding: EdgeInsets.only(left: 60, top: 15),
            //           child: Text(
            //             'Work Orders',
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.w700),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: IconButton(
            //                   onPressed: () {},
            //                   icon: Icon(
            //                     Icons.refresh_sharp,
            //                     color: MyTheme.white,
            //                   )),
            //             ),
            //             Expanded(
            //               flex: 2,
            //               child: DropdownButtonFormField(
            //                 value: _selectedValue,
            //                 hint: Text(
            //                   'Picking',
            //                   style: TextStyle(color: MyTheme.white,
            //                       fontSize: 18
            //                   ),
            //
            //                 ),
            //                 dropdownColor: MyTheme.materialColor,
            //                 alignment: Alignment.centerRight,
            //                 icon: Icon(
            //                   Icons.keyboard_arrow_down,
            //                   color: MyTheme.white,
            //                 ),
            //                 items: [
            //                   DropdownMenuItem(
            //                     value: 'Picking',
            //                     child: Text('Picking',
            //                     style: TextStyle(
            //                       color: MyTheme.white
            //                     ),
            //                     ),
            //                   ),
            //                   DropdownMenuItem(
            //                     value: 'Packing',
            //                     child: Text('Packing',
            //                       style: TextStyle(
            //                           color: MyTheme.white
            //                       ),),
            //                   ),
            //                   DropdownMenuItem(
            //                     value: 'Dispatch',
            //                     child: Text('Dispatch',
            //                       style: TextStyle(
            //                           color: MyTheme.white
            //                       ),),
            //                   ),
            //                   // Additional options...
            //                 ],
            //                 onChanged: (value) {
            //                   setState(() {
            //                     _selectedValue = value;
            //                   });
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ) ,
            // ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

            floatingActionButton: !isEdit ?Container(
              color: MyTheme.materialColor,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: (){
                  customAlertField('Change Work Order Status');
                },
                child: Text(
                  "Batch Mark Status",
                  style: TextStyle(color: MyTheme.white),
                ),
              )
            ):Container(),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: MyTheme.materialColor,
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: MyTheme.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text('Work Orders'),
                  actions: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 60, top: 15),
                        child: Text(
                          'Work Orders',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: endValue)
                                  .animate(_controller),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      endValue = 1;
                                    });
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {
                                        endValue = 0;
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.refresh_sharp,
                                    color: MyTheme.white,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.materialColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.materialColor))),
                              value: _selectedValue,
                              hint: Text(
                                'Picking',
                                style: TextStyle(
                                    color: MyTheme.white, fontSize: 18),
                              ),
                              dropdownColor: MyTheme.materialColor,
                              alignment: Alignment.centerRight,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: MyTheme.white,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'Picking',
                                  child: Text(
                                    'Picking',
                                    style: TextStyle(color: MyTheme.white),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Packing',
                                  child: Text(
                                    'Packing',
                                    style: TextStyle(color: MyTheme.white),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Dispatch',
                                  child: Text(
                                    'Dispatch',
                                    style: TextStyle(color: MyTheme.white),
                                  ),
                                ),
                                // Additional options...
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                  bottom: AppBar(
                    backgroundColor: MyTheme.materialColor,
                    actions: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,bottom: 5),
                          child: TextField(
                            decoration: InputDecoration(
                                focusColor: Colors.white,
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Type Keyword here',
                                hintStyle: TextStyle(),
                                prefixIcon: Icon(Icons.search),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 4, color: MyTheme.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 4, color: MyTheme.white))),
                          ),
                        ),
                      ),
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isEdit=!isEdit;
                                });
                                // if(isEdit==false){

                                //   _controller2.open();
                                // }
                              },
                              icon: isEdit ? Icon(Icons.edit,size: 35,) : Icon(Icons.clear,size: 35,),
                          )),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                _controller1.open();
                              },
                              child: Transform.scale(
                                child: Image.asset(
                                    'assets/compareArrowsUpDown.png'),
                                scale: 0.8,
                              )))
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Table(
                      columnWidths:  {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(3),
                  3:FlexColumnWidth(2)
                  },
                      border: TableBorder.all(
                          width: 1, color: Colors.black45), //table border
                      children:createTable()
                      // [
                      //   TableRow(
                      //       children: [
                      //         TableCell(
                      //             child: Text("Invoice Details",
                      //                 style: customTextStyle)),
                      //         TableCell(
                      //             child: Text(
                      //           "Date",
                      //           style: customTextStyle,
                      //         )),
                      //         TableCell(
                      //             child: Text(
                      //           "Order Details",
                      //           style: customTextStyle,
                      //         )),
                      //         TableCell(
                      //             child: Text(
                      //           "Location",
                      //           style: customTextStyle,
                      //         ))
                      //       ],
                      //       decoration: BoxDecoration(
                      //           color: Color.fromRGBO(238, 180, 22, .1))),
                      //   TableRow(
                      //       children: [
                      //         TableCell(child: Text("1.")),
                      //         TableCell(child: Text("Krishna Karki")),
                      //         TableCell(child: Text("Nepal, Kathmandu")),
                      //         TableCell(child: Text("Nepal"))
                      //       ],
                      //       decoration: BoxDecoration(
                      //           color: Color.fromRGBO(238, 180, 22, .1))),
                      // ],
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
        _buildBottomDrawer(context),
      ]),
    );
  }

  List<TableRow> createTable() {
    List<TableRow> rows = [];
    rows.add(
      TableRow(
        children: [
          TableCell(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Invoice Details",
                    style: customTextStyle),
              )),
          TableCell(
              child: Text(
                "Date",
                style: customTextStyle,
              )),
          TableCell(
              child: Text(
                "Order Details",
                style: customTextStyle,
              )),
          TableCell(
              child: Text(
                "Location",
                style: customTextStyle,
              ))
        ],
        decoration: BoxDecoration(
            color: Color.fromRGBO(238, 180, 22, .1))),
    );
    for (int i = 0; i < 100; ++i) {
      rows.add(
          TableRow(children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkOrderScreen2()));
          },
          child: !isEdit? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex:1,
                child: Checkbox(
                  value: isEdit,
                  onChanged: (bool? value) {
                    setState(() {
                      isEdit = value!;
                    });
                  },
                ),
              ),

              Expanded(flex:1,child: Text("Invoice Details ",)),

            ],
          ): Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Invoice Details'),
          )
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkOrderScreen2()));
          },
            child: Text("Date ")),
        GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkOrderScreen2()));
            },
            child: Text("Order Details")),
        GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkOrderScreen2()));
            },
            child: Text("Location"))
      ],
              decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 180, 22, .1)) )
      );
    }
    return rows;
  }


  Future<dynamic> customAlertField(String title){
    return showDialog(context: context, builder: (context)=>AlertDialog(
      scrollable: true,
      title: Center(
        child: Text(title,
          style: TextStyle(
              color: MyTheme.materialColor
          ),
        ),
      ),
      content:SizedBox(
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [

            RadioListTile(
              value: 0,
              groupValue: selectedRadio,
              onChanged: (val) =>setState(() {
                selectedRadio=val!;
              }),
              title: Text('Mark as Picked'),
            ),
            RadioListTile(
              value: 1,
              groupValue: selectedRadio,
              onChanged: (val) =>setState(() {
                selectedRadio=val!;
              }),
              title: Text('Mark as Packed'),
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedRadio,
              onChanged: (val) =>setState(() {
                selectedRadio=val!;
              }),
              title: Text('Mark as Dispatched'),
            ),
            SizedBox(height: 10,),
            if(selectedRadio==0) TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Colors.grey
                  )
                ),
                labelText: 'Enter Comments'
              ) ,
            )
            else if(selectedRadio==1) TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Colors.grey
                      )
                  ),
                  labelText: 'Enter Comments'
              ) ,
            )
            else SingleChildScrollView(
              child: Wrap(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey
                              )
                          ),
                          labelText: 'Enter Comments'
                      ) ,
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey
                              )
                          ),
                          labelText: 'Enter Courier'
                      ) ,
                    ),
                    Container(
                      height:10 ,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey
                              )
                          ),
                          labelText: 'Enter Tracking'
                      ) ,
                    )
                  ],
                ),
            )
      ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,

      actions: <Widget>[

        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            color: MyTheme.materialColor,
            padding: const EdgeInsets.all(14),
            child: Center(child: Text("OK",style: TextStyle(color: Colors.white,fontSize: 16))),
          ),
        ),

      ],
    ),
    );
  }

  Widget _buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: 0,
      drawerHeight: _bodyHeight,
      controller: _controller1,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 60,
          spreadRadius: 0,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }

  Widget _buildBottomDrawerHead(BuildContext context) {
    return Container(
      height: _headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          ),
          Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () {
                setState(() {
                  print(predefinedValue);
                  _controller1.close();
                });
              },
              child: Text(
                "APPLY FILTER",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          ),
          Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () {
                _controller1.close();
              },
              child: Text(
                "CLOSE",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    return Scaffold(
      body: Container(
        height: _bodyHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "Sort Option",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              customTextField(
                  "Column List", preDefinedDropDownItems, predefinedValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(String title,
      List<DropdownMenuItem<String>> dropdownItems, String? selectedItem1) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: textEdgeInsetsGeometry,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          DropdownButtonFormField(
            isExpanded: true,
            value: selectedItem1,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedItem1 = value;
                switch (title) {
                  case 'Pre Defined List':
                    {
                      predefinedValue = value;
                    }
                    break;
                  case 'Part Type':
                    {
                      partTypeValue = value;
                    }
                    break;
                }
              });
            },
            decoration: InputDecoration(
                hintText: selectedItem1,
                enabledBorder: border,
                focusedBorder: border),
          ),
        ],
      ),
    );
  }
}
