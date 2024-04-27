import 'package:flutter/material.dart';
import 'package:chaskis/pages/t_asistencia_page.dart';

class Card3D {
  const Card3D(
      {required this.description,
      required this.title,
      required this.page,
      required this.pathImage,});
  final Widget page;
  final String title;
  final String description;
  final String pathImage;
} 

 List<Card3D> cardList = [
  const Card3D(
    title: 'Control de Asistencia',
    page: FormularioAsistenciapage(),
    description:
        'Cocinero,Arrieros,\nLimpieza,Guardían\nTejedoras',
   pathImage: 'assets/img/hoja2.png'
  ),
];
