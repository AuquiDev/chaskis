
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chaskis/models/model_t_asistencia.dart';
import 'package:chaskis/models/model_t_personal.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/provider/provider_sql_tasitencia.dart';
import 'package:chaskis/provider/provider_t_asistencia.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vibration/vibration.dart';

class QrScannerPersonal extends StatefulWidget {
  const QrScannerPersonal({
    super.key,
    required this.personalList, required this.idTrabajo,
  });
  final List<TPersonalModel> personalList;
  final String idTrabajo;
  @override
  State<QrScannerPersonal> createState() => _QrScannerPersonalState();
}

class _QrScannerPersonalState extends State<QrScannerPersonal> {
   FlutterTts flutterTts = FlutterTts(); 
  TPersonalModel isPerson = TPersonalModel(id: '', nombre: '-', rol: '-');

  bool isParticle = false;
  void particleinsta() {
    setState(() {
      isParticle = true;
    });
    // Después de 2 segundos, establece isParticle en false
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isParticle = false;
      });
    });
  }

  //PERSONAL Asistencia Encontrado
  TAsistenciaModel personScaner = TAsistenciaModel(
    id: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    idEmpleados: '',
    idTrabajo: '',
    horaEntrada: DateTime.now(),
    horaSalida: DateTime.now(),
    nombrePersonal: '',
    actividadRol: '',
    detalles: '',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _scanQRCode(); //SCANNER QR
        particleinsta();
      },
      child: FadeOutParticle(
        disappear: isParticle,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 200,
              color: Color(0xFF0590A2),
            ),
            H2Text(
              text: 'Registro de Asistencia',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0590A2),
            ),
            H2Text(
              text: 'Presione aquí',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3C4343),
            ),
          ],
        ),
      ),
    );
  }
 Future<bool> hasVibrator() async {
  return (await Vibration.hasVibrator()) ?? false;
}

Future<void> vibrate() async {
  if (await hasVibrator()) {
    Vibration.vibrate(duration: 500);
  }
}

void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('song/tono.mp3')); // Ruta a tu archivo de sonido
  }
  //SCANEAR QR
  Future<void> _scanQRCode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", 'Cancelar', true, ScanMode.DEFAULT);

      List<String> personalData =
          barcodeScanRes.split('|'); //Conveirte el String en una lista
      String idpersonal = personalData[0]; //El primer Elemento de la lista

      TPersonalModel person = widget.personalList.firstWhere(
        (p) => p.id == idpersonal,
        orElse: () => TPersonalModel(nombre: 'nombre', rol: 'rol'),
      );

      setState(() {
        isPerson = person;
      });

      if (person.id != null) {
        playSound();
        
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Asistencia marcada',
          text:
              '¡Bienvenido, ${isPerson.nombre}! Tu asistencia ha sido registrada.\n${isPerson.rol}',
          confirmBtnColor: const Color(0xFF18861C),
          confirmBtnText: 'Aceptar',
          cancelBtnText: '',
        );
        speackQr('¡Bienvenido, ${isPerson.nombre}! Tu asistencia ha sido registrada. Como ${isPerson.rol}');
        //SIQREXISTE guardamos en la Base de datos
        final listSql = Provider.of<DBAsistenciaAppProvider>(context, listen: false).listsql;
        final listServer =  Provider.of<TAsistenciaProvider>(context, listen: false).listAsistencia;
        final isOffline = Provider.of<UsuarioProvider>(context, listen: false).isOffline;
        // Verificamos si el usuario ya tiene una asistencia registrada para hoy
        TAsistenciaModel? asistenciaPersonal;
        try {
          asistenciaPersonal = isOffline
              ? listSql.firstWhere(
                  (e) {
                    print('List SQl : ${e.nombrePersonal}');
                    return e.nombrePersonal == isPerson.nombre &&
                        e.horaEntrada.day == DateTime.now().day;
                  },
                )
              : listServer.firstWhere(
                  (e) {
                    print('List SERVER : ${e.nombrePersonal}');
                    return e.nombrePersonal == isPerson.nombre &&
                        e.horaEntrada.day == DateTime.now().day;
                  },
                );
          vibrate();
          setState(() {
            personScaner = asistenciaPersonal!;
          });
        } catch (e) {
          print('Error al buscar la asistencia para hoy: $e');
        }

        // Comprobamos si la asistencia para hoy existe y tiene un ID no nulo
        if (asistenciaPersonal?.id != null) {
          isOffline ? editarffline() : editarEntrada();
          print('Asistencia editada');
        } else {
          isOffline ? enviaroffline() : guardarEntrada();
          print('Asistencia guardada');
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Usuario no encontrado',
          text: 'No se encontró un usuario',
          confirmBtnColor: Colors.red,
          confirmBtnText: 'Cerrar',
          cancelBtnText: '',
        );
      }
    } catch (e) {
      print('Error $e');
    }
  }
  speackQr(text) async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.defaultMode);
    await flutterTts.speak(text);
  }
  //SQLLITE
  Future<void> enviaroffline() async {
    final user =
        Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
    final TAsistenciaModel offlineData = TAsistenciaModel(
      id: '',
      created: DateTime.now(),
      updated: DateTime.now(),
      idEmpleados: user!.id!,
      idTrabajo: widget.idTrabajo,
      horaEntrada: DateTime.now(),
      horaSalida: DateTime.now(),
      nombrePersonal: isPerson.nombre,
      actividadRol: isPerson.rol,
      detalles: '',
    );
    await context.read<DBAsistenciaAppProvider>().insertData(offlineData, true);
  }

  Future<void> editarffline() async {
    final TAsistenciaModel offlineData = TAsistenciaModel(
      id: personScaner.id,
      created: personScaner.created,
      updated: DateTime.now(),
      idEmpleados: personScaner.idEmpleados,
      idTrabajo: personScaner.idTrabajo,
      horaEntrada: personScaner.horaEntrada,
      horaSalida: DateTime.now(),
      nombrePersonal: personScaner.nombrePersonal,
      actividadRol: personScaner.actividadRol,
      detalles: personScaner.detalles,
    );
    print('EDIT DATA : offlinee ${personScaner.id}');
    await context
        .read<DBAsistenciaAppProvider>()
        .updateData(offlineData, personScaner.idsql!, true);
  }

//SERVER
  Future<void> editarEntrada() async {
    await context.read<TAsistenciaProvider>().updateTAsistenciaProvider(
          id: personScaner.id,
          idEmpleados: personScaner.idEmpleados,
          idTrabajo: personScaner.idTrabajo,
          horaEntrada: personScaner.horaEntrada,
          horaSalida: DateTime.now(),
          nombrePersonal: personScaner.nombrePersonal,
          actividadRol: personScaner.actividadRol,
          detalles: personScaner.detalles,
        );
  }

  Future<void> guardarEntrada() async {
    final user =
        Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
    await context.read<TAsistenciaProvider>().postTAsistenciaProvider(
          id: '',
          idEmpleados: user!.id,
          idTrabajo: widget.idTrabajo,
          horaEntrada: DateTime.now(),
          horaSalida: DateTime.now(),
          nombrePersonal: isPerson.nombre,
          actividadRol: isPerson.rol,
          detalles: '',
        );
  }
}
