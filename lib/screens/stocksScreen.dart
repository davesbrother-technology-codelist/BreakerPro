import 'package:flutter/material.dart';

import '../my_theme.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  TextStyle customTextStyle=TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: MyTheme.materialColor);
  TextStyle customTextStyle2=TextStyle(fontWeight: FontWeight.bold,fontSize: 15,);


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
        title: Text(
          "Stocks",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/laser.png',scale: 3.5,),
                    SizedBox(width: 70,),
                    Text('BLACK BOX',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: MyTheme.materialColor),),
                  ],

              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Part Id',style: customTextStyle,),
                  SizedBox(width: 95,),
                  Expanded(child: Text('a',style: customTextStyle2,)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Make',style: customTextStyle),
                  SizedBox(width: 102,),
                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Model',style: customTextStyle),
                  SizedBox(width: 96,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Year',style: customTextStyle),
                  SizedBox(width: 108,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Location',style: customTextStyle),
                  SizedBox(width: 80,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Registration No',style: customTextStyle),
                  SizedBox(width: 32,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Price',style: customTextStyle),
                  SizedBox(width: 102,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Stock Reference',style: customTextStyle),
                  SizedBox(width: 28,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manufacture Year',style: customTextStyle),
                  SizedBox(width: 18,),

                  Expanded(child: Text('a',style: customTextStyle2)),
                ],

              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,color: MyTheme.materialColor,)


            ],
          ),

        );
      }),
    );
  }
}
