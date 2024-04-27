
import 'package:chaskis/pages/home_page_race.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/offline/page_test_asistencia.dart';
import 'package:chaskis/offline/page_test_detalletrabajo.dart';
import 'package:chaskis/offline/page_test_personal.dart';
import 'package:chaskis/offline/page_text_empelado.dart';
import 'package:chaskis/qr_generate_personal.dart';
import 'package:chaskis/qr_page.dart';


class PageRoutes {
  Icon icon;
  String title;
  Widget path;
  PageRoutes({required this.icon, required this.title, required this.path});
}

List<PageRoutes> routes = [
    PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
      title: "Control Asistencia",
      path:   const QrPageAsistencia(), ),
     //Almacenar y SIncronizar data 
   PageRoutes(
      icon: const Icon(Icons.sync, color: Colors.red,),
      title: "Local Asistencias",
      path:   const DBAsistenciaPage(), ),
   PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "Usuarios",
      path:   const DBEmpleadoPage(), ),
  PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "Personal",
      path:   const DBPersonalPage(), ),
    
  PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "Grupos",
      path:   const DBDetalletrabajoPage(), ),
   PageRoutes(
       icon: const Icon(Icons.qr_code, color: Colors.red,),
      title: "Qr Generate",
      path:   const QrListaPersonal(), ),

   PageRoutes(
       icon: const Icon(Icons.qr_code, color: Colors.red,),
      title: "Home Paeg ANde Race",
      path:   HomePageRace(), ),
  
   
 
];
