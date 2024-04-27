
import 'package:chaskis/api/path_key_api.dart';
import 'package:chaskis/models/model_t_personal.dart';
import 'package:pocketbase/pocketbase.dart';

class TPersonal {
  static getAsitenciaPk() async {
    final records = await pb1.collection('personal_op').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TPersonalModel data) async {
    final record =
        await pb1.collection('personal_op').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TPersonalModel? data}) async {
    final record =
        await pb1.collection('personal_op').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb1.collection('personal_op').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb1.realtime;
  }
}