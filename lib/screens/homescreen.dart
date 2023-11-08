 import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../boxes/boxes.dart';
import '../models/note_model.dart';
class HomePage extends StatefulWidget {
  const  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller =TextEditingController();
  final discriptioncontroller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive DataBase'),
      ),
     body: ValueListenableBuilder<Box<NotesModel>>(
       builder: (context,box,_){
         var data =box.values.toList().cast<NotesModel>();
         return ListView.builder(
             itemCount: box.length,
             itemBuilder: (context, index)
             {
           return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(data[index].title.toString(),style: TextStyle(fontSize: 20,),),
                      Spacer(),
                      InkWell(
                          onTap: (){
                            _editMyDialog(data[index],data[index].title.toString(),data[index].description.toString());


                          },
                          child: Icon(Icons.edit)),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                          onTap: (){
                            delet(data[index]);
                          },
                          child: Icon(Icons.delete,color: Colors.red,)),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Text(data[index].description.toString()),
                ],
              ),
            ),
           );

         });

       }, valueListenable: Boxes.getData().listenable(),
     ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showMyDialog();


        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _editMyDialog(NotesModel notesModel,String title,String description) async{
    return showDialog(context: context, builder: (context){
      controller.text=title;
      discriptioncontroller.text=description;
      return AlertDialog(


        content: SingleChildScrollView(
          child:Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: discriptioncontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
              ),

            ],
          ) ,
        ),

        title:Text('Edit Notes') ,
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          } , child: const Text('Cancel')),
          TextButton(onPressed: ()async{
            notesModel.title=controller.text.toString();

          await notesModel.save();
            Navigator.pop(context);
          } , child: const Text('Edit')),
        ],
      );

    });
  }
  Future<void> _showMyDialog() async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(

        content: SingleChildScrollView(
          child:Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: discriptioncontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
              ),

            ],
          ) ,
        ),

        title:Text('Add Notes') ,
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          } , child: const Text('Cancel')),
          TextButton(onPressed: (){
            final data =NotesModel(title: controller.text, description: discriptioncontroller.text);
            final box =Boxes.getData();
            box.add(data);
            print(box);
            controller.clear();
            discriptioncontroller.clear();
            data.save();
            box.add(data);
            Navigator.pop(context);
          } , child: const Text('Add')),
        ],
      );

    });
  }

  void delet(NotesModel notesModel) async {
    await notesModel.delete();
  }

}
