// ignore_for_file: avoid_print


// import 'package:chaskis/models/model_runners_ar.dart';
import 'package:chaskis/models/model_list_check_points_ar.dart';
import 'package:chaskis/poketbase/t_list_check_points_ar.dart';
// import 'package:chaskis/poketbase/t_runners_ar.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/api/path_key_api.dart';
// import 'package:chaskis/poketbase/t_asistencia.dart';
import 'package:pocketbase/pocketbase.dart';

class TListCheckPoitns_ARProvider with ChangeNotifier {
  List<TListCheckPoitns_ARModels> listAsistencia = [];

  TListCheckPoitns_ARProvider() {
    print('RUNNERS SERVICES Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TListCheckPoitns_ARModels> get e => listAsistencia;

  void addAsistencia(TListCheckPoitns_ARModels e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TListCheckPoitns_ARModels e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TListCheckPoitns_ARModels e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TListCheckPoitns_AR.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TListCheckPoitns_ARModels ubicaciones =  TListCheckPoitns_ARModels.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? ubicacion,
    String? nombre,
    String? descripcion,
    String? elevacion,
    int? orden,
    DateTime? horaApertura,
    DateTime? horaCierre,
    bool? estatus,
   String? itemsList }) async {
    isSyncing = true;
    notifyListeners();
    TListCheckPoitns_ARModels data = TListCheckPoitns_ARModels(
        id: '',
      idEvento: idEvento!,
      ubicacion: ubicacion!,
      nombre: nombre!,
      descripcion: descripcion!,
      elevacion: elevacion!,
      orden: orden!,
      horaApertura: horaApertura!,
      horaCierre: horaCierre!,
      estatus: estatus!,
      itemsList: itemsList!
      
        );

    await TListCheckPoitns_AR.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? ubicacion,
    String? nombre,
    String? descripcion,
    String? elevacion,
    int? orden,
    DateTime? horaApertura,
    DateTime? horaCierre,
    bool? estatus,
   String? itemsList }) async {
    isSyncing = true;
    notifyListeners();
    TListCheckPoitns_ARModels data = TListCheckPoitns_ARModels(
        id: id!,
      idEvento: idEvento!,
      ubicacion: ubicacion!,
      nombre: nombre!,
      descripcion: descripcion!,
      elevacion: elevacion!,
      orden: orden!,
      horaApertura: horaApertura!,
      horaCierre: horaCierre!,
      estatus: estatus!,
      itemsList: itemsList!);

    await TListCheckPoitns_AR.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TListCheckPoitns_AR.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TListCheckPoitns_ARModels e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEvento: e.idEvento,
      ubicacion: e.ubicacion,
      nombre: e.nombre,
      descripcion: e.descripcion,
      elevacion: e.elevacion,
      orden: e.orden,
      horaApertura: e.horaApertura,
      horaCierre: e.horaCierre,
      estatus: e.estatus,
      itemsList: e.itemsList
      );
      print('POST RUNNERS API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
         idEvento: e.idEvento,
      ubicacion: e.ubicacion,
      nombre: e.nombre,
      descripcion: e.descripcion,
      elevacion: e.elevacion,
      orden: e.orden,
      horaApertura: e.horaApertura,
      horaCierre: e.horaCierre,
      estatus: e.estatus,
      itemsList: e.itemsList
      );
      print('PUT RUNNERS API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_check_points').subscribe('*', (e) {
      print('REALTIME Runners ${e.action}');
      print('REALTIME VALUE ${e.record}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TListCheckPoitns_ARModels.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TListCheckPoitns_ARModels.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TListCheckPoitns_ARModels.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
