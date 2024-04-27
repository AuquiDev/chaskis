// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chaskis/models/model_t_detalle_trabajo.dart';
import 'package:chaskis/models/model_t_personal.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/provider/provider_sql_detalle_grupo.dart';
import 'package:chaskis/provider/provider_sql_personal.dart';
import 'package:chaskis/provider/provider_t_detalle_trabajo.dart';
import 'package:chaskis/provider/provider_t_personal.dart';

import 'package:chaskis/qr_lector.dart';  

import 'package:chaskis/utils/custom_text.dart';
import 'package:chaskis/utils/divider_custom.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class QrPageAsistencia extends StatefulWidget {
  const QrPageAsistencia({super.key});

  @override
  State<QrPageAsistencia> createState() => _QrPageAsistenciaState();
}

class _QrPageAsistenciaState extends State<QrPageAsistencia> {
  FlutterTts flutterTts = FlutterTts();
  String idtrabajo = '';
  @override
  void initState() {
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      mostrarDialogoSeleccion();
      speackQr('Selecciona un código de grupo presionando el círculo rosado antes de continuar.');
    });
    super.initState();
  }

  void mostrarDialogoSeleccion() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Seleccionar Código de Grupo',
      text: 'Por favor, selecciona un código de grupo antes de continuar.',
      confirmBtnColor: const Color(0xFF18861C),
      confirmBtnText: 'Aceptar',
      cancelBtnText: 'Continuar',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
  @override
  void dispose() {
      flutterTts.stop();  // Detener la reproducción de TTS
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isffline = Provider.of<UsuarioProvider>(context).isOffline;

    final personalServerList =
        Provider.of<TPersonalProvider>(context).listaPersonal;
    final personSQlList = Provider.of<DBPersonalProvider>(context).listsql;
    List<TPersonalModel> personalList =
        isffline ? personSQlList : personalServerList;
    //LISTA GRUPOS ALMACÉ
    final listatrabajoApi =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
    final listatrabajoSql =
        Provider.of<DBDetalleGrupoProvider>(context).listsql;
    final listadetalletrabajo = isffline ? listatrabajoSql : listatrabajoApi;
    listadetalletrabajo.sort((a, b) => a.created!.compareTo(b.created!));

    String obtenerDetalleTrabajo(String idTrabajo) {
      for (var data in listadetalletrabajo) {
        if (data.id == idTrabajo) {
          return data.codigoGrupo;
        }
      }
      return '';
    }
    
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 6,
            child: DelayedDisplay(
              delay: const Duration(seconds: 1),
              child: Image.asset(
                'assets/img/rama.png',
                height: 200,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: RippleAnimation(
              color: const Color(0x2A87C1C4),
              delay: const Duration(milliseconds: 900),
              repeat: true,
              ripplesCount: 6,
              minRadius: 50,
              child: DelayedDisplay(
                delay: const Duration(seconds: 2),
                child: QrScannerPersonal(
                  personalList: personalList,
                  idTrabajo: idtrabajo,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  idtrabajo.isEmpty
                      ? const H2Text(
                          text: 'Seleccione el Codígo de Grupo.',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.pink,
                        )
                      : const H2Text(
                          text: 'Codígo de Grupo.',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.pink,
                        ),
                  GestureDetector(
                    onTap: () {
                      shetPage(listadetalletrabajo, obtenerDetalleTrabajo(idtrabajo));
                    },
                    child: WidgetCircularAnimator(
                      size: 100,
                      innerColor: Colors.pinkAccent,
                      outerColor: Colors.pink,
                      outerAnimation: Curves.elasticInOut,
                      child: DelayedDisplay(
                        delay: const Duration(seconds: 1),
                        child: CircleAvatar(
                          backgroundColor: Colors.pink,
                          child: RippleAnimation(
                            color: const Color(0xFFE7E4D7),
                            delay: const Duration(milliseconds: 500),
                            repeat: idtrabajo.isEmpty ? true : false,
                            ripplesCount: 1,
                            minRadius: 50,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: H2Text(
                                  text: obtenerDetalleTrabajo(idtrabajo),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  void shetPage(List<TDetalleTrabajoModel> listadetalletrabajo, String obtenerDetalleTrabajo) {
    showModalBottomSheet(
        constraints: BoxConstraints.loose(
            Size.fromHeight(MediaQuery.of(context).size.height * .50)),
        scrollControlDisabledMaxHeightRatio: BorderSide.strokeAlignOutside,
        useSafeArea: true,
        context: context,
        backgroundColor: Colors.black,
        builder: (BuildContext context) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 350),
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DividerCustom(),
                const Center(
                  child: H2Text(
                    text: 'Seleccione el Codígo de Grupo.',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calcular el número de columnas en función del ancho disponible
                    int crossAxisCount = (constraints.maxWidth / 80).floor();
                    // Puedes ajustar el valor 100 según tus necesidades
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: 2),
                      itemCount: listadetalletrabajo.length,
                      itemBuilder: (BuildContext context, int index) {
                        final t = listadetalletrabajo.reversed.toList()[index];
                        return GestureDetector(
                          onTap: () {
                            idtrabajo = t.id!;
                            obtenerDetalleTrabajo;
                            // obtenerDetalleTrabajo(idtrabajo);
                            print(t.codigoGrupo);
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            color: idtrabajo == t.id
                                ? const Color(0xFFFDFD05)
                                :  Colors.white30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                H2Text(
                                  text: t.codigoGrupo,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ], 
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        });
  }
  speackQr(text) async {
    await  flutterTts.stop();  // Detener la reproducción de TTS
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
