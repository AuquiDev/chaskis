// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:chaskis/api/path_key_api.dart';
import 'package:chaskis/models/model_t_personal.dart';
import 'package:chaskis/poketbase/t_personal.dart';
import 'package:pocketbase/pocketbase.dart';

class TPersonalProvider with ChangeNotifier {
  List<TPersonalModel> listaPersonal = [];

  TPersonalProvider() {
    print('Asistencia Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TPersonalModel> get e => listaPersonal;

  void addAsistencia(TPersonalModel e) {
    listaPersonal.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TPersonalModel e) {
    listaPersonal[listaPersonal.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TPersonalModel e) {
    listaPersonal.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TPersonal.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TPersonalModel ubicaciones =  TPersonalModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? nombre,String? rol}) async {
    isSyncing = true;
    notifyListeners();
    TPersonalModel data = TPersonalModel(
        id: '',
        nombre: nombre!,
        rol: rol!,
        );

    await TPersonal.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider(  {String? id, String? nombre,String? rol}) async {
    isSyncing = true;
    notifyListeners();
    TPersonalModel data = TPersonalModel(
        id: '',
        nombre: nombre!,
        rol: rol!,
        );

    await TPersonal.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TPersonal.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TPersonalModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
         nombre: e.nombre,
        rol: e.rol,
      );
      print('POST ASISTENCIA API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
         nombre: e.nombre,
        rol: e.rol,
      );
      print('PUT ASISTENCIA API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb1.collection('personal_op').subscribe('*', (e) {
      print('REALTIME Personal ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TPersonalModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TPersonalModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TPersonalModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
