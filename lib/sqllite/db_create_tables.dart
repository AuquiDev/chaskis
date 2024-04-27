// database_helper.dart

import 'package:sqflite/sqflite.dart';

class DatabaseTablesDB {
  static Future<void> createTables(Database db) async {
    List<String> queries = [
      '''
      CREATE TABLE  tasistencias (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        id_empleados TEXT,
        id_trabajo TEXT,
        hora_entrada TEXT,
        hora_salida TEXT,
        nombre_personal TEXT,
        actividad_rol TEXT,
        detalles TEXT
      );
      ''',
      '''
      CREATE TABLE tdetalletrabajo (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        codigo_grupo TEXT,
        id_restriccionAlimentos TEXT,
        id_cantidad_paxguia TEXT,
        id_itinerariodiasnoches TEXT,
        id_tipogasto TEXT,
        fecha_inicio TEXT,
        fecha_fin TEXT,
        descripcion TEXT,
        costo_asociados REAL
      );
      ''',
      '''
      CREATE TABLE templeados (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        estado INTEGER,
        id_rolesSueldo_Empleados TEXT,
        nombre TEXT,
        apellido_paterno TEXT,
        apellido_materno TEXT,
        sexo TEXT,
        direccion_residencia TEXT,
        lugar_nacimiento TEXT,
        fecha_nacimiento TEXT,
        correo_electronico TEXT,
        nivel_escolaridad TEXT,
        estado_civil TEXT,
        modalidad_laboral TEXT,
        cedula INTEGER,
        cuenta_bancaria TEXT,
        imagen TEXT,
        cv_document TEXT,
        telefono TEXT,
        contrasena TEXT,
        rol TEXT
      );
      ''',
      '''
      CREATE TABLE treportepasajeros (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        idTrabajo TEXT,
        nombre_pasajero TEXT,
        gmail TEXT,
        idioma INTEGER,
        pregunta1 TEXT,
        pregunta2 TEXT,
        pregunta3 TEXT,
        pregunta4 TEXT,
        pregunta5 TEXT,
        pregunta6 TEXT,
        pregunta7 TEXT,
        pregunta8 TEXT,
        pregunta9 TEXT,
        pregunta10 TEXT,
        pregunta11 TEXT,
        pregunta12 TEXT,
        pregunta13 TEXT,
        idEmpleados TEXT
      );
      ''',
      '''
      CREATE TABLE treporteincidencias (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        idTrabajo TEXT,
        idEmpleados TEXT,
        pregunta1 TEXT,
        pregunta2 TEXT,
        pregunta3 TEXT,
        pregunta4 TEXT,
        pregunta5 TEXT,
        pregunta6 TEXT,
        pregunta7 TEXT
    );
      ''',
      '''
      CREATE TABLE tpersonal (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        nombre TEXT,
        rol TEXT,
        image TEXT
      );
    '''
    ];

    for (String query in queries) {
      await db.execute(query);
    }
  }
}
