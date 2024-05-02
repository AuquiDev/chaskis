
import 'package:chaskis/offline/page_test_check_point_00.dart';
import 'package:chaskis/offline/page_test_list_check_points.dart';
import 'package:chaskis/offline/page_test_runners.dart';
import 'package:chaskis/pages/check_points_list.dart';
import 'package:chaskis/pages/home_page_race.dart';
import 'package:chaskis/page_qr/qr_page_listdata_runner.dart';
import 'package:chaskis/page_qr/qr_page_runners.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/offline/page_test_asistencia.dart';
import 'package:chaskis/offline/page_test_detalletrabajo.dart';
import 'package:chaskis/offline/page_text_empelado.dart';



class PageRoutes {
  Icon icon;
  String title;
  Widget path;
  PageRoutes({required this.icon, required this.title, required this.path});
}

List<PageRoutes> routes = [
  
  PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
      title: "List Check points list - SQL",
      path:   DBListCheckPointsArPage(), ),
  PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
      title: "Check points list",
      path:   CheckPotinsList(), ),
  PageRoutes(
       icon: const Icon(Icons.emoji_people_sharp , color: Color(0xFF207D23),),
      title: "Runners List",
      path:   const DBRunnerspage(), ),
   PageRoutes(
       icon: const Icon(Icons.emoji_people_sharp , color: Color(0xFF207D23),),
      title: "Check Points 00",
      path:   const DBCheckPoints00Page(), ),
   PageRoutes(
       icon: const Icon(Icons.emoji_people_sharp , color: Color(0xFF207D23),),
      title: "Runners QR GENERATE",
      path:   const   QrListaRunners(), ),
  
   PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
      title: "Lector CheckP 00",
      path:   const QrPageRunners(), ),

    // PageRoutes(
    //    icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
    //   title: "Control Asistencia",
    //   path:   const QrPageAsistencia(), ),
     //Almacenar y SIncronizar data 
   PageRoutes(
      icon: const Icon(Icons.sync, color: Colors.red,),
      title: "Local Asistencias",
      path:   const DBAsistenciaPage(), ),
   PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "Usuarios",
      path:   const DBEmpleadoPage(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.cloud_download, color: Colors.red,),
  //     title: "Personal",
  //     path:   const DBPersonalPage(), ),
    
  PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "Grupos",
      path:   const DBDetalletrabajoPage(), ),
  //  PageRoutes(
  //      icon: const Icon(Icons.qr_code, color: Colors.red,),
  //     title: "Qr Generate",
  //     path:   const QrListaPersonal(), ),

   PageRoutes(
       icon: const Icon(Icons.qr_code, color: Colors.red,),
      title: "Home Paeg ANde Race",
      path:   HomePageRace(), ),
  
   
 
];
