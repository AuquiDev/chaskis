import 'package:chaskis/models/model_t_personal.dart';
import 'package:chaskis/sqllite/db_create_local_storage.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBPersonal {
  final DBLocalStorage _databaseTablesDB = DBLocalStorage.instance;

  //PERSONAL: METODOS
  Future<void> insertarDetalleTrabajo(TPersonalModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'tpersonal',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'nombre': e.nombre,
        'rol': e.rol,
        'image': e.image,
    
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TPersonalModel>> getDetalleTrabajo() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> response = await db.query('tpersonal');

    List<TPersonalModel> listData = List<TPersonalModel>.from(
      response.map((e) => convertirPersonal(e)).toList(),
    );
    return listData;
  }

  Future<void> updateDetalleTrabajo(
      TPersonalModel detalle, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'tpersonal',
      {
        'id': detalle.id,
        'collectionId': detalle.collectionId,
        'collectionName': detalle.collectionName,
        'created': detalle.created?.toIso8601String(),
        'updated': detalle.updated?.toIso8601String(),
        'nombre': detalle.nombre,
        'rol': detalle.rol,
        'image': detalle.image,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

  Future<void> deleteTdetalletrabajo(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tpersonal', where: 'idsql = ?', whereArgs: [idsql]);
  }

  //Borrar  todos los datos
  Future<void> clearDetalleTrabajo() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tpersonal');
    await _databaseTablesDB.initDataBase();
  }
}

// Añadir una función para convertir datos de la tabla 'tdetalletrabajo'
TPersonalModel convertirPersonal(Map<String, dynamic> json) {
  return TPersonalModel(
    idsql: json['idsql'],
    id: json["id"],
    collectionId: json["collectionId"],
    collectionName: json["collectionName"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    nombre: json["nombre"],
    rol: json["rol"],
    image: json["image"],
  );
}
