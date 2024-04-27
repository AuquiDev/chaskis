
import 'package:chaskis/models/model_t_empleado.dart';
import 'package:chaskis/sqllite/db_create_local_storage.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBEmpleado {
  final DBLocalStorage _databaseTablesDB =  DBLocalStorage.instance;

   //METODOS EMPLEADO
  Future<void> insertarEmpleado(TEmpleadoModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'templeados',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'estado': e.estado ? 1 : 0, // Convertir booleano a entero
        // 'id_rolesSueldo_Empleados': e.idRolesSueldoEmpleados,
        'nombre': e.nombre,
        'apellido_paterno': e.apellidoPaterno,
        'apellido_materno': e.apellidoMaterno,
        'sexo': e.sexo,
        // 'direccion_residencia': e.direccionResidencia,
        // 'lugar_nacimiento': e.lugarNacimiento,
        // 'fecha_nacimiento': e.fechaNacimiento?.toIso8601String(),
        // 'correo_electronico': e.correoElectronico,
        // 'nivel_escolaridad': e.nivelEscolaridad,
        // 'estado_civil': e.estadoCivil,
        // 'modalidad_laboral': e.modalidadLaboral,
        'cedula': e.cedula.toInt(),
        // 'cuenta_bancaria': e.cuentaBancaria,
        'imagen': e.imagen,
        // 'cv_document': e.cvDocument,
        'telefono': e.telefono,
        'contrasena': e.contrasena,
        'rol': e.rol,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TEmpleadoModel>> getEmpleados() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> response = await db.query('templeados');

    List<TEmpleadoModel> listData = List<TEmpleadoModel>.from(
      response.map((e) => convertirEmpleado(e)).toList(),
    );
    return listData;
  }

  Future<void> updateEmpleado(TEmpleadoModel empleado, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'templeados',
      {
        'id': empleado.id,
        'collectionId': empleado.collectionId,
        'collectionName': empleado.collectionName,
        'created': empleado.created?.toIso8601String(),
        'updated': empleado.updated?.toIso8601String(),
        'estado': empleado.estado ? 1 : 0, // Convertir booleano a entero
        // 'id_rolesSueldo_Empleados': empleado.idRolesSueldoEmpleados,
        'nombre': empleado.nombre,
        'apellido_paterno': empleado.apellidoPaterno,
        'apellido_materno': empleado.apellidoMaterno,
        'sexo': empleado.sexo,
        // 'direccion_residencia': empleado.direccionResidencia,
        // 'lugar_nacimiento': empleado.lugarNacimiento,
        // 'fecha_nacimiento': empleado.fechaNacimiento?.toIso8601String(),
        // 'correo_electronico': empleado.correoElectronico,
        // 'nivel_escolaridad': empleado.nivelEscolaridad,
        // 'estado_civil': empleado.estadoCivil,
        // 'modalidad_laboral': empleado.modalidadLaboral,
        'cedula': empleado.cedula.toInt(),
        // 'cuenta_bancaria': empleado.cuentaBancaria,
        'imagen': empleado.imagen,
        // 'cv_document': empleado.cvDocument,
        'telefono': empleado.telefono,
        'contrasena': empleado.contrasena,
        'rol': empleado.rol,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

// Eliminar un empleado por su idsql
  Future<void> deleteEmpleado(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('templeados', where: 'idsql = ?', whereArgs: [idsql]);
  }

// Borrar todos los empleados
  Future<void> clearEmpleados() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('templeados');
    await _databaseTablesDB.initDataBase();
  }
}




//EMPLEADO
TEmpleadoModel convertirEmpleado(Map<String, dynamic> json) {
  return TEmpleadoModel(
    idsql: json['idsql'],
    id: json['id'],
    collectionId: json['collectionId'],
    collectionName: json['collectionName'],
    created: DateTime.parse(json['created']),
    updated: DateTime.parse(json['updated']),
    estado: json['estado'] ==1,
    // idRolesSueldoEmpleados: json['id_rolesSueldo_Empleados'],
    nombre: json['nombre'],
    apellidoPaterno: json['apellido_paterno'],
    apellidoMaterno: json['apellido_materno'],
    sexo: json['sexo'],
    // direccionResidencia: json['direccion_residencia'],
    // lugarNacimiento: json['lugar_nacimiento'],
    // fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
    // correoElectronico: json['correo_electronico'],
    // nivelEscolaridad: json['nivel_escolaridad'],
    // estadoCivil: json['estado_civil'],
    // modalidadLaboral: json['modalidad_laboral'],
    cedula: json['cedula'].toInt(),
    // cuentaBancaria: json['cuenta_bancaria'],
    imagen: json['imagen'],
    // cvDocument: json['cv_document'],
    telefono: json['telefono'],
    contrasena: json['contrasena'],
    rol: json['rol'],
  );
}
