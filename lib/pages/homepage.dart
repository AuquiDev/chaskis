// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:chaskis/pages/t_asistencia_page.dart';
import 'package:chaskis/provider_cache/current_page.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/provider/provider_sql_detalle_grupo.dart';
import 'package:chaskis/provider/provider_sql_empelado.dart';
import 'package:chaskis/provider/provider_sql_tasitencia.dart';
import 'package:chaskis/models/model_t_empleado.dart';
import 'package:chaskis/pages/t_empleado_login.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:chaskis/shared%20preferences/shared_global.dart';
import 'package:chaskis/widgets/char_local_storage.dart';
import 'package:chaskis/widgets/demo_conectivity_plus.dart';
import 'package:chaskis/widgets/state_signal_icons.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool active = false;
  // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

  @override
  void initState() {
    _initializeDatabase();
    active = true; // Cambiado aquí
    _activateAfterDelay();
    super.initState();
  }

  // Método para inicializar las bases de datos
  void _initializeDatabase() {
    Provider.of<DBAsistenciaAppProvider>(context, listen: false).initDatabase();
    Provider.of<DBDetalleGrupoProvider>(context, listen: false).initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    // Provider.of<DBPersonalProvider>(context, listen: false).initDatabase();
    sharedPrefs.setLoggedIn(); // Supongo que este método debe ser llamado aquí
  }

  // Método para activar active después de un retraso
  void _activateAfterDelay() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        // Asegúrate de que el widget todavía esté montado antes de cambiar el estado
        setState(() {
          active = false;
        });
      }
    });
  }

  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UsuarioProvider>(context);
    TEmpleadoModel? user = dataProvider.usuarioEncontrado;
    return Scaffold(
        body: DraggableHome(
      headerWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserCard(
              user: user,
              size: 150,
            ),
            const OfflineSIgnalButon(),
          ],
        ),
      ),
      headerBottomBar: active ?  SizedBox() :  Container( color:Colors.black, child: ConectivityDemo()), //CONECTIVITY
      appBarColor: Colors.white,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserImage(
          user: user,
          size: 30,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H2Text(
            text: user == null ? 'Visitante' : user.nombre,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          user == null
              ? const SizedBox()
              : H2Text(
                  text: user.rol,
                  fontSize: 12,
                ),
        ],
      ),
      bottomSheet: ListTile(
        title: H2Text(text: 'Hola'),
      ),
      body:  [
        //CARRUSEL CON INDICADOR: GESTION
        ElevatedButton(
          onPressed: () {
            final layoutmodel =
                Provider.of<LayoutModel>(context, listen: false);
            layoutmodel.currentPage = FormularioAsistenciapage();
          },
          child:  H2Text(text: 'Asistencias'),),
        //DIAGRAMA INDICADOR DE SINCRONIZACION DE DATOS.
        DiagrmaIndicatorSinc(),
      ],
    ));
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetCircularAnimator(
            size: 65,
            innerColor: Colors.black12,
            outerColor: Colors.black12,
            outerAnimation: Curves.elasticInOut,
            child: DelayedDisplay(
                delay: const Duration(seconds: 1),
                child: UserImage(user: user, size: size))),
        H2Text(
          text: user == null ? 'Visitante' : user!.nombre,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        user == null
            ? const SizedBox()
            : H2Text(
                text: user!.rol,
                fontSize: 12,
              ),
      ],
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: user == null
          ? imagenLogo()
          : ImageLoginUser(
              user: user,
              size: size,
            ),
    );
  }
}

Container imagenLogo() {
  return Container(
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/img/logo_smallar.png',
          ),
        ),
        color: Colors.black12),
  );
}
