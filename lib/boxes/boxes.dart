



import 'package:hive/hive.dart';

import '../models/note_model.dart';

class Boxes{
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');

}