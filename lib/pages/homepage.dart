import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              addDataSection(),
              showOnetimeRead(),
              showRealtimeChange(),
            ],
          ),
        ),
      ),
    );
  }
  Widget showRealtimeChange() {
    return Column(
      children: [
        const Text("Real Time Change"),
        createRealTimeDate(),
        const Divider(),
      ],
    );
  }
  Widget createRealTimeDate(){
    return StreamBuilder(
      stream : FirebaseFirestore.instance.collection("Product").snapshots(),
      builder: (context, snapshot) {
        print("Realtime Change");
        print(snapshot.connectionState);
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }else{
          print(snapshot.data!.docs);
          return Column(
            children: createDataList(snapshot.data),
          );
        }
      },
      );
  }
  Widget showOnetimeRead() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Text("One Time Real")),
            IconButton(onPressed: () {
              setState(() {});
            },
             icon: const Icon(Icons.refresh))
          ],
        ),
        createOnetimeRealData(),
        const Divider(),
      ],
    );
  }
  Widget createOnetimeRealData(){
    return FutureBuilder(
      future : FirebaseFirestore.instance.collection("Product").get(), 
      builder: (context, snapshot) {
        print("Onetime");
        print(snapshot.connectionState);
        if(snapshot.connectionState == ConnectionState.done){
          return Column(
            children: createDataList(snapshot.data),
          );
        }else{
          return const Text("Waiting Data");
        }
      },
      );
  }
  List<Widget> createDataList(QuerySnapshot<Map<String, dynamic>>? data) {
    List<Widget> widgets = [];
    widgets = data!.docs.map((doc) {
      var data = doc.data();
      print(data['product_name']);
      return ListTile(
        onTap: () {
          print(doc.id);
          // ดึงข้อมูล มาแสดง เพื่อแก้ไข
        },
        title: Text(
            data['product_name'] + ", " + data['price'].toString() + " บาท"),
        subtitle: Text(data['type']),
        trailing: IconButton(
            onPressed: () {
              print("Delete");
              showConfirmDialog(doc.id);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
      );
    }).toList();

    return widgets;
  }

  void showConfirmDialog(String id) {
    var dialog = AlertDialog(
      title: const Text("ลบข้อมูล"),
      content: Text("ต้องการลบข้อมูลเอกสารรหัส $id"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Back")),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
                foregroundColor: const MaterialStatePropertyAll(Colors.white)),
            onPressed: () {
              FirebaseFirestore.instance.collection("Product").doc(id).delete();
            },
            child: Text("Delete")),
      ],
    );
    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  Widget addDataSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Add Data"),
          const Divider(),
          TextFormField(
            controller: _productController,
            decoration: const InputDecoration(labelText: "ชื่อสินค้า"),
          ),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: "ราคา"),
          ),
          TextFormField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: "ประเภท"),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection("Product").add({
                "product_name": _productController.text,
                "price": double.parse(_priceController.text),
                "type": _typeController.text,
              });
              _formKey.currentState!.reset();
            },
            child: const Text("Save"),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
