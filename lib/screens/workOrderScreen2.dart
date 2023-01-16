import 'package:flutter/material.dart';
import 'package:breaker_pro/screens/scanPart.dart';
import '../my_theme.dart';

class WorkOrderScreen2 extends StatefulWidget {
  const WorkOrderScreen2({Key? key}) : super(key: key);

  @override
  State<WorkOrderScreen2> createState() => _WorkOrderScreen2State();
}

class _WorkOrderScreen2State extends State<WorkOrderScreen2> {
  String? _selectedValue;
  int index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.materialColor,
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
          ),
        ),
        elevation: 0,
        title: Text('Work Order',style: TextStyle(color: Colors.white),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 20),
            child: Text('data',style: TextStyle(
                fontSize: 16,
                color: Colors.black
            ),),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text("STEERING RACK",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text("Order Details",style: TextStyle(
                    fontSize: 16
                ),),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text("Order Details no.",style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField('Date Time', '01/03/2022', MediaQuery.of(context).size.width*0.45),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.05,
                  ),
                  customTextField('Part Location', 'STEERING RACK - BAY 1 - SHELF 3', MediaQuery.of(context).size.width*0.45),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              customTextField('Work Order Details/Comments', 'ITEM ID:12134565789 BUYERS VEHICLE : BMW I3', MediaQuery.of(context).size.width*0.95),
              SizedBox(
                height: 20,
              ),
              customTextField('Customer Details', 'Gurjit ATWAL,.......ADDRESS', MediaQuery.of(context).size.width*0.95),
              SizedBox(
                height: 20,
              ),
              customTextField('Delivery Details', 'RAMUS PORSCHE.........DETAILS', MediaQuery.of(context).size.width*0.95),
              SizedBox(
                height: 20,
              ),
              customTextField('Shipping Details', 'UK_DPDNEXTDAY 03 Thursday, Mar 2022', MediaQuery.of(context).size.width*0.95),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80,right: 70),
                child: DropdownButtonFormField(

                  decoration: InputDecoration(
                      filled: true,
                      fillColor: MyTheme.materialColor,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.materialColor)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.white)
                      )
                  ),
                  value: _selectedValue,
                  hint: Text(
                    'Mark as Picked',
                    style: TextStyle(color: MyTheme.white,
                        fontSize: 14
                    ),

                  ),
                  dropdownColor: MyTheme.white,
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: MyTheme.white,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Mark as Picked',
                      child: Text('Mark as Picked',),

                      onTap: (){
                        setState(() {
                          index=0;
                        });
                      },
                    ),
                    DropdownMenuItem(
                      value: 'Mark as Packed',
                      child: Text('Mark as Packed',
                      ),
                      onTap: (){
                        setState((){
                          index=1;
                        });
                      },

                    ),
                    DropdownMenuItem(
                      value: 'Mark as Dispatched',
                      child: Text('Mark as Dispatched',
                      ),
                      onTap: (){
                        setState(() {
                          index=2;
                        });
                      },
                    ),
                    // Additional options...
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    switch(index){
                      case 0:
                        customAlertField("Mark as Picked");
                        // showDialog(context: context, builder: (context)=>AlertDialog(
                        //   scrollable: true,
                        //   title: Center(
                        //     child: Text("Mark as Picked",
                        //     style: TextStyle(
                        //       color: MyTheme.materialColor
                        //     ),
                        //     ),
                        //   ),
                        //   content:SizedBox(
                        //     width: double.infinity,
                        //     child: ListView(
                        //       shrinkWrap: true,
                        //       children: [
                        //         TextField(
                        //           decoration: InputDecoration(
                        //               hintText: 'Enter Comments'
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Row(
                        //
                        //           children: <Widget> [
                        //             Expanded(
                        //
                        //               child: TextField(
                        //
                        //                 decoration: InputDecoration(
                        //
                        //                     enabledBorder:  OutlineInputBorder(
                        //
                        //                       borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        //
                        //                     ),
                        //                   contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 26),
                        //                 ),
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child:TextButton(
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //                 child: Container(
                        //                   padding: EdgeInsets.only(left: 5),
                        //                   width: 100,
                        //                   height: 50,
                        //                   color: MyTheme.materialColor,
                        //                   child:Center(child: Text("SCAN PART", style: TextStyle(
                        //                     color: Colors.white
                        //                   ),)),
                        //                 ),
                        //               ),
                        //             )
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // actionsAlignment: MainAxisAlignment.center,
                        //   // Column(
                        //   //
                        //   //   children:<Widget> [
                        //   //     Expanded(
                        //   //       child: TextField(
                        //   //         decoration: InputDecoration(
                        //   //           hintText: 'Enter Comments'
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     Row(
                        //   //       children: <Widget> [
                        //   //         Expanded(
                        //   //           child: TextField(
                        //   //             decoration: InputDecoration(
                        //   //               enabledBorder:  OutlineInputBorder(
                        //   //                 borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        //   //
                        //   //               )
                        //   //             ),
                        //   //           ),
                        //   //         ),
                        //   //         Expanded(
                        //   //           child: ElevatedButton(
                        //   //
                        //   //               onPressed: (){},
                        //   //               child: Text('SCAN PART',
                        //   //               style: TextStyle(
                        //   //                 color: Colors.white
                        //   //               ),
                        //   //               ),
                        //   //           ),
                        //   //         )
                        //   //       ],
                        //   //     )
                        //   //   ],
                        //   // ),
                        //   actions: <Widget>[
                        //
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: Container(
                        //         width: 100,
                        //         color: MyTheme.materialColor,
                        //         padding: const EdgeInsets.all(14),
                        //         child: Center(child: Text("OKAY",style: TextStyle(color: Colors.white,fontSize: 16))),
                        //       ),
                        //     ),
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: Container(
                        //         width: 100,
                        //         color: MyTheme.materialColor,
                        //         padding: const EdgeInsets.all(14),
                        //         child: Center(child: Text("CANCEL",style: TextStyle(color: Colors.white,fontSize: 16),)),
                        //       ),
                        //     ),
                        //   ],
                        // ),);
                        break;
                      case 1:
                        customAlertField("Mark as Packed");

                        break;
                      case 2:
                        customAlertField2("Mark as Dispatched");
                        break;
                      default:

                    }

                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  Widget customTextField(String title, String content,double width){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(title,style: TextStyle(
            color: Colors.grey,
            fontSize: 12
        ),),
        SizedBox(
          height: 6,
        ),
        Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(content,),
          ),
          decoration: BoxDecoration(
            border:Border.all(
                color: Colors.grey,
                width: 2,
                style: BorderStyle.solid
            ),

          ),
        )
      ],
    );
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
            TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Comments'
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(

              children: <Widget> [
                Expanded(

                  child: TextField(

                    decoration: InputDecoration(

                      enabledBorder:  OutlineInputBorder(

                        borderSide: BorderSide(color: Colors.grey, width: 2.0),

                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 26),
                    ),
                  ),
                ),
                Expanded(
                  child:TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanPart()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      width: 100,
                      height: 50,
                      color: MyTheme.materialColor,
                      child:Center(child: Text("SCAN PART", style: TextStyle(
                          color: Colors.white
                      ),)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      // Column(
      //
      //   children:<Widget> [
      //     Expanded(
      //       child: TextField(
      //         decoration: InputDecoration(
      //           hintText: 'Enter Comments'
      //         ),
      //       ),
      //     ),
      //     Row(
      //       children: <Widget> [
      //         Expanded(
      //           child: TextField(
      //             decoration: InputDecoration(
      //               enabledBorder:  OutlineInputBorder(
      //                 borderSide: BorderSide(color: Colors.grey, width: 2.0),
      //
      //               )
      //             ),
      //           ),
      //         ),
      //         Expanded(
      //           child: ElevatedButton(
      //
      //               onPressed: (){},
      //               child: Text('SCAN PART',
      //               style: TextStyle(
      //                 color: Colors.white
      //               ),
      //               ),
      //           ),
      //         )
      //       ],
      //     )
      //   ],
      // ),
      actions: <Widget>[

        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            color: MyTheme.materialColor,
            padding: const EdgeInsets.all(14),
            child: Center(child: Text("OKAY",style: TextStyle(color: Colors.white,fontSize: 16))),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            color: MyTheme.materialColor,
            padding: const EdgeInsets.all(14),
            child: Center(child: Text("CANCEL",style: TextStyle(color: Colors.white,fontSize: 16),)),
          ),
        ),
      ],
    ),
    );
  }
  Future<dynamic> customAlertField2(String title){
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
            TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Comments'
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(

              children: <Widget> [
                Expanded(
                  flex: 9,
                  child: TextField(

                    decoration: InputDecoration(
                      hintText: 'Enter Courier',
                      enabledBorder:  OutlineInputBorder(

                        borderSide: BorderSide(color: Colors.grey, width: 2.0),

                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 26),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child:TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanPart()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      width: 200,
                      height: 50,
                      color: MyTheme.materialColor,
                      child:Center(child: Text("SCAN TRACKING", style: TextStyle(
                          color: Colors.white
                      ),)),
                    ),
                  ),
                )
              ],
            ),
            Expanded(

              child: TextField(

                decoration: InputDecoration(
                  hintText: 'Enter Tracking',
                  enabledBorder:  OutlineInputBorder(

                    borderSide: BorderSide(color: Colors.grey, width: 2.0),

                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 26),
                ),
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      // Column(
      //
      //   children:<Widget> [
      //     Expanded(
      //       child: TextField(
      //         decoration: InputDecoration(
      //           hintText: 'Enter Comments'
      //         ),
      //       ),
      //     ),
      //     Row(
      //       children: <Widget> [
      //         Expanded(
      //           child: TextField(
      //             decoration: InputDecoration(
      //               enabledBorder:  OutlineInputBorder(
      //                 borderSide: BorderSide(color: Colors.grey, width: 2.0),
      //
      //               )
      //             ),
      //           ),
      //         ),
      //         Expanded(
      //           child: ElevatedButton(
      //
      //               onPressed: (){},
      //               child: Text('SCAN PART',
      //               style: TextStyle(
      //                 color: Colors.white
      //               ),
      //               ),
      //           ),
      //         )
      //       ],
      //     )
      //   ],
      // ),
      actions: <Widget>[

        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            color: MyTheme.materialColor,
            padding: const EdgeInsets.all(14),
            child: Center(child: Text("OKAY",style: TextStyle(color: Colors.white,fontSize: 16))),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            color: MyTheme.materialColor,
            padding: const EdgeInsets.all(14),
            child: Center(child: Text("CANCEL",style: TextStyle(color: Colors.white,fontSize: 16),)),
          ),
        ),
      ],
    ),
    );
  }

}
