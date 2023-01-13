import 'package:flutter/material.dart';

import '../my_theme.dart';

class WorkOrderScreen2 extends StatefulWidget {
  const WorkOrderScreen2({Key? key}) : super(key: key);

  @override
  State<WorkOrderScreen2> createState() => _WorkOrderScreen2State();
}

class _WorkOrderScreen2State extends State<WorkOrderScreen2> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              fontSize: 16
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
                      child: Text('Mark as Picked',
                        
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Mark as Packed',
                      child: Text('Mark as Packed',
                        ),
                    ),
                    DropdownMenuItem(
                      value: 'Mark as Dispatched',
                      child: Text('Mark as Dispatched',
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
}
