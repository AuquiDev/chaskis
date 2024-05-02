
// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chaskis/models/model_t_personal.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class PageQrGenerate extends StatefulWidget {
  const PageQrGenerate({
    super.key,
    required this.e,
  });
  final TPersonalModel e;

  @override
  State<PageQrGenerate> createState() => _PageQrGenerateState();
}

class _PageQrGenerateState extends State<PageQrGenerate> {
  Future<Widget> buildQrCode(TPersonalModel e) async {
    final qrDataString = '${widget.e.id}|${widget.e.nombre}|${widget.e.rol}';
    final qrData = QrCode.fromData(
        data: qrDataString, errorCorrectLevel: QrErrorCorrectLevel.L);

    // Carga la imagen de forma asíncrona
    const AssetImage assetImage = AssetImage('assets/img/qr_logo.png');
    final ByteData byteData =
        await (assetImage.bundle ?? DefaultAssetBundle.of(context))
            .load(assetImage.keyName);

    final List<int> bytes = byteData.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(Uint8List.fromList(bytes));

    final qrPainter = QrPainter(
        data: qrDataString,
        color: const Color(0xFF644033),
        version: QrVersions.auto,
        embeddedImage: image,
        embeddedImageStyle: const QrEmbeddedImageStyle(
            // color: Colors.red,
            size: Size(60, 50)));

    final qrWidget = RepaintBoundary(
      child: CustomPaint(
        painter: qrPainter,
        size: const Size(220, 220),
      ),
    );
    return qrWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.brown,
                  spreadRadius: 1,
                  blurRadius: 1,
                )
              ],
            ),
            child: Stack(
              children: [
                CustomPaint(
                  painter: CustomBackgroundPainter(), // Fondo personalizado
                  size: MediaQuery.of(context).size,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    Center(
                        child: WidgetCircularAnimator(
                      innerColor: Colors.teal,
                      outerColor: Colors.cyan,
                      outerAnimation: Curves.elasticInOut,
                      child: widget.e.image!.isEmpty
                          ? _imagenLogo()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: widget.e.image != null &&
                                        widget.e.image is String &&
                                        widget.e.image!.isNotEmpty
                                    ? 'https://planet-broken.pockethost.io/api/files/${widget.e.collectionId}/${widget.e.id}/${widget.e.image}'
                                    : 'https://via.placeholder.com/300',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    _imagenLogo(), // Widget a mostrar si hay un error al cargar la imagen
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    H2Text(
                      text: widget.e.nombre.toUpperCase(),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF644033),
                    ),
                    H2Text(
                      text: widget.e.rol,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF644033),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder<Widget>(
                      future: buildQrCode(widget.e),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ??
                              Container(); // Puedes personalizar el contenedor de carga aquí
                        } else {
                          return const CircularProgressIndicator(); // Otra opción es mostrar un indicador de carga
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _imagenLogo() {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(
              'assets/img/qr_logo.png',
            ),
          ),
          color: Colors.black12),
    );
  }
}

class CustomBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dibuja el fondo personalizado aquí
    const gradient = LinearGradient(
      colors: [Color(0xFF644033), Color(0xFFCECCCC)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
          Rect.fromPoints(const Offset(0, 0), Offset(0, size.height)))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.2) // Mover al punto inicial
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 0.35, // Punto de control y punto final de la curva
        size.width,
        size.height * 0.2, // Punto final de la curva
      )
      ..lineTo(size.width, 0) // Línea hasta la parte superior derecha
      ..lineTo(0, 0) // Línea hasta la parte superior izquierda
      ..close(); // Cierra el path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
