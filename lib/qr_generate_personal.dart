// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/models/model_t_detalle_trabajo.dart';
import 'package:chaskis/models/model_t_personal.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/provider/provider_sql_personal.dart';
import 'package:chaskis/provider/provider_t_personal.dart';
import 'package:chaskis/qr_generate_page.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:chaskis/utils/divider_custom.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class QrListaPersonal extends StatefulWidget {
  const QrListaPersonal({super.key});

  @override
  State<QrListaPersonal> createState() => _QrListaPersonalState();
}

class _QrListaPersonalState extends State<QrListaPersonal> {
  String idtrabajo = '';
  @override
  void initState() {
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      mostrarDialogoSeleccion();
    });
    super.initState();
  }

  void mostrarDialogoSeleccion() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Generar Códigos QR',
      text:
          'Selecciona un usuario de la lista y genera su código QR para exportar.',
      confirmBtnColor: const Color(0xFF18861C),
      confirmBtnText: 'Aceptar',
      cancelBtnText: 'Continuar',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataCache = Provider.of<UsuarioProvider>(context);
    bool isffline = dataCache.isOffline;

    final personalServerList =
        Provider.of<TPersonalProvider>(context).listaPersonal;
    final personSQlList = Provider.of<DBPersonalProvider>(context).listsql;
    List<TPersonalModel> personalList =
        isffline ? personSQlList : personalServerList;
    //LISTA GRUPOS ALMACÉ

    return Scaffold(
      body: Stack(
        children: [
          dataCache.usuarioEncontrado!.rol == 'admin'
              ? ListView.builder(
                  itemCount: personalList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final e = personalList[index];
                    //Color intercalado
                    Color color = index % 2 == 0
                        ? const Color(0x3CE2E1E1)
                        : const Color(0xFFFFFFFF);
                    return Container(
                      color: color,
                      child: DelayedDisplay(
                        delay: const Duration(seconds: 1),
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          title: H2Text(
                            text: e.nombre,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: H2Text(
                            text: e.rol,
                            fontSize: 15,
                          ),
                          leading: const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.qr_code,
                                color: Colors.pink,
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageQrGenerate(e: e),
                                ));
                          },
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child:  H2Text(
                    text:
                        'Acceso restringido: Solo los administradores tienen permisos para este panel.',
                    fontSize: 13,

                  ),
                ),
          Positioned(
            right: 0,
            top: 6,
            child: DelayedDisplay(
              delay: const Duration(seconds: 1),
              child: Image.asset(
                'assets/img/hoja3.png',
                height: 200,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 6,
            child: DelayedDisplay(
              delay: const Duration(seconds: 1),
              child: Image.asset(
                'assets/img/rama.png',
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void shetPage(List<TDetalleTrabajoModel> listadetalletrabajo,
      String obtenerDetalleTrabajo) {
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
                                : Colors.white30,
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
}
