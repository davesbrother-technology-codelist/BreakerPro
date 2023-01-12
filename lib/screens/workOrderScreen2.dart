import 'package:flutter/material.dart';

class WorkOrderScreen2 extends StatefulWidget {
  const WorkOrderScreen2({Key? key}) : super(key: key);

  @override
  State<WorkOrderScreen2> createState() => _WorkOrderScreen2State();
}

class _WorkOrderScreen2State extends State<WorkOrderScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Order'),
        actions: [
          Text('data')
        ],
      ),
      body: Text("") ,
    );
  }
}
