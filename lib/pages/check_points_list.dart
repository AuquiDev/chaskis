

// import 'package:chaskis/models/model_runners_ar.dart';
import 'package:chaskis/models/model_list_check_points_ar.dart';
import 'package:chaskis/provider/provider_sql_check_p0.dart';
import 'package:chaskis/provider/provider_sql_empelado.dart';
import 'package:chaskis/provider/provider_sql_list_check_points_ar.dart';
import 'package:chaskis/provider/provider_sql_runners_ar.dart';
import 'package:chaskis/provider/provider_t_list_check_ar.dart';
import 'package:chaskis/utils/format_fecha.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class CheckPotinsList extends StatefulWidget {
  const CheckPotinsList({super.key});

  @override
  State<CheckPotinsList> createState() => _CheckPotinsListState();
}

class _CheckPotinsListState extends State<CheckPotinsList> {
  String idtrabajo = '';
  late ExpandedTileController _controller;

  @override
  void initState() {
    Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();

    Provider.of<DBCheckP00AppProvider>(context, listen: false).initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      mostrarDialogoSeleccion();
    });
    super.initState();

    _controller = ExpandedTileController(isExpanded: false);
  }

  void mostrarDialogoSeleccion() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Puntos de Control',
      text:
          'Selecciona un punto de control.',
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
        Provider.of<TListCheckPoitns_ARProvider>(context).listAsistencia;
    final personSQlList = Provider.of<DBTListCheckPoitns_ARProvider>(context).listsql;
    List<TListCheckPoitns_ARModels> personalList =
        isffline ? personSQlList : personalServerList;
    //LISTA GRUPOS ALMACÉ
    personalList.sort((a,b)=>a.orden.compareTo(b.orden));
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: dataCache.usuarioEncontrado!.rol == 'admin'
          ? Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 370),
                child: personalList.isEmpty
                    ? H2Text(
                        text: 'No hay datos disponibles',
                        color: Colors.white,
                        fontSize: 14,
                      )
                    : ExpandedTileList.builder(
                        itemCount: personalList.length,
                        itemBuilder: (context, index, controller) {
                          final e = personalList[index];
                          //Color intercalado
                          Color color = index % 2 == 0
                              ? Color(0xFF3F3F3F)
                              : Color(0xFF222222);
                          return ExpandedTile(
                            expansionAnimationCurve: Curves.easeInOut,
                            theme: ExpandedTileThemeData(
                              headerColor: color,
                              headerRadius: 14.0,
                              headerPadding: EdgeInsets.all(14.0),
                              headerSplashColor: Colors.white,
                              contentBackgroundColor: Colors.white,
                              contentPadding: EdgeInsets.all(24.0),
                              contentRadius: 12.0,
                            ),
                            controller: _controller,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                H2Text(
                                  text: e.nombre ,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Table(
                                  border: TableBorder.all(
                                      color: Colors.white38, width: 0.4),
                                  children: [
                                    TableRow(
                                      children: [
                                        H2Text(
                                          text: 'DORSAL',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: 'GÉNERO',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: 'PAÍS',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: 'TALLA',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        H2Text(
                                          text: e.ubicacion,
                                          fontSize: 13,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: e.elevacion,
                                          fontSize: 11,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: formatFechaPDfhora(e.horaApertura),
                                          fontSize: 11,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: formatFechaPDfhora(e.horaCierre),
                                          fontSize: 11,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            content: DelayedDisplay(
                                delay: Duration(milliseconds: 300),
                                child: FlutterLogo()),
                          );
                        },
                      ),
              ),
            )
          : const Center(
              child: H2Text(
                text:
                    'Acceso restringido: Solo los administradores tienen permisos para este panel.',
                fontSize: 13,
              ),
            ),
    );
  }
}
