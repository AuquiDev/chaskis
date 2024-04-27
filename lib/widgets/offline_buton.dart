
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/provider/provider_sql_detalle_grupo.dart';
import 'package:chaskis/provider/provider_sql_empelado.dart';
import 'package:chaskis/provider/provider_sql_personal.dart';
import 'package:chaskis/provider/provider_sql_tasitencia.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:provider/provider.dart';

class ModoOfflineClick extends StatelessWidget {
   
  const ModoOfflineClick({super.key});
  @override
  Widget build(BuildContext context) {
     final dataProvider = Provider.of<UsuarioProvider>(context);
    bool isoffline = dataProvider.isOffline;
    return Card(
      surfaceTintColor: Colors.black,
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:10),
        child: SwitchListTile.adaptive(
          visualDensity: VisualDensity.compact,
          dense: true,
          contentPadding: const EdgeInsets.all(0),
          activeColor: Colors.red,
          inactiveTrackColor: Colors.green,
            title: const H2Text(
              text: 'Modo Offline',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            subtitle: H2Text(
              text: isoffline ? 'Activado' : ' Desactivado',
              fontSize: 12, 
              color: Colors.white,
            ),
            value: isoffline,
            onChanged: (value) {
              //INICALIZAR LAS BD O TABLAS>
              Provider.of<DBAsistenciaAppProvider>(context, listen: false).initDatabase();
              Provider.of<DBDetalleGrupoProvider>(context, listen:  false).initDatabase();
              Provider.of<DBEMpleadoProvider>(context, listen:  false).initDatabase();
              Provider.of<UsuarioProvider>(context, listen: false).setIsOffline(value);
              Provider.of<DBPersonalProvider>(context, listen: false).initDatabase();
              playSound();
            }),
      ),
    );
  }
  void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('song/tono.mp3')); // Ruta a tu archivo de sonido
  }
}
