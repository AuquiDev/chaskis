// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:chaskis/models/model_runners_ar.dart';
import 'package:chaskis/provider/provider_sql_check_p0.dart';
import 'package:chaskis/provider/provider_sql_empelado.dart';
import 'package:chaskis/provider/provider_sql_runners_ar.dart';
import 'package:chaskis/provider/provider_t_runners_ar.dart';
import 'package:chaskis/page_qr/qr_lector_runners.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:provider/provider.dart';
// import 'package:quickalert/quickalert.dart';

class QrPageRunners extends StatefulWidget {
  const QrPageRunners({super.key});

  @override
  State<QrPageRunners> createState() => _QrPageRunnersState();
}

class _QrPageRunnersState extends State<QrPageRunners> {
  FlutterTts flutterTts = FlutterTts();
  String idtrabajo = '';
  @override
  void initState() {
     Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();
              Provider.of<DBCheckP00AppProvider>(context, listen:  false).initDatabase();
              Provider.of<DBEMpleadoProvider>(context, listen:  false).initDatabase();
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      // mostrarDialogoSeleccion();
      speackQr('Presione sobre la imagen QR para comenzar.');
    });
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detener la reproducción de TTS
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isffline = Provider.of<UsuarioProvider>(context).isOffline;

    final personalServerList =
        Provider.of<TRunnersProvider>(context).listAsistencia;
    final personSQlList = Provider.of<DBRunnersAppProvider>(context).listsql;
    List<TRunnersModel> personalList =
        isffline ? personSQlList : personalServerList;

    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.white24,
                border: Border.all(
                    style: BorderStyle.solid, color: Color(0xffAB0D0D)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 1200),
                    child: QrScannerRunners(
                      personalList: personalList,
                      idTrabajo: idtrabajo,
                    ),
                  ),
                  H2Text(
                      text: 'QR SCANNER'.toUpperCase(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54),
                  H2Text(
                      text:
                          'Presione aquí para escanear el código QR del corredor.',
                      fontSize: 12,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      color: Colors.white54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  speackQr(text) async {
    await flutterTts.stop(); // Detener la reproducción de TTS
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
}
