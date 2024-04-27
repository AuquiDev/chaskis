// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chaskis/models/model_t_empleado.dart';
import 'package:chaskis/pages/orientation_phone_page.dart';
import 'package:chaskis/pages/orientation_web_page.dart';
import 'package:chaskis/provider_cache/provider_cache.dart';
import 'package:chaskis/provider/provider_t_empleado.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:chaskis/utils/decoration_form.dart';
import 'package:chaskis/shared%20preferences/shared_global.dart';
import 'package:chaskis/widgets/demo_conectivity_plus.dart';
import 'package:chaskis/widgets/offline_buton.dart';
import 'package:chaskis/widgets/state_signal_icons.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String text = '';
  //SHAREDPREFENCES
  bool _isLoggedIn = false;

  @override
  void initState() {
    cargarUsuario();
    // Al inicializar el widget, obtenemos el estado de inicio de sesión previo
    SharedPrefencesGlobal().getLoggedIn().then((value) {
      setState(() {
        _isLoggedIn = value; // Actualizamos el estado de inicio de sesión
      });
    });

    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
    super.initState();
  }

  void cargarUsuario() async {
    await Provider.of<UsuarioProvider>(context, listen: false).cargarUsuario();
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<TEmpleadoProvider>(context);
    TEmpleadoModel? user =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;

    // Paso 1: Verificar si ya estás autenticado
    if (_isLoggedIn) {
      // Paso 2: Redireccionar automáticamente a la página posterior al inicio de sesión
      // return const WebPage();
      final screensize = MediaQuery.of(context).size;
      if (screensize.width > 900) {
        // print('Web Page: ${screensize.width}');
        return const WebPage();
      } else {
        // print('Web Page: ${screensize.width}');
        return const PhonePage();
      }
      // Redirige a la página posterior al inicio de sesión
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/fondo.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
             
              DelayedDisplay(
                delay: const Duration(milliseconds: 5000),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 220, bottom: 120),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 350),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          color: Colors.black12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               LoginBar(user: user),
                              // TextFormField(
                              //   controller: _cedulaController,
                              //   keyboardType: TextInputType.number,
                              //   maxLength: 8,
                              //   inputFormatters: [
                              //     //Expresion Regular
                              //     FilteringTextInputFormatter.allow(
                              //         RegExp('[0-9]'))
                              //   ],
                              //   decoration: decorationTextField(
                              //       hintText: 'campo obligatorio',
                              //       labelText: 'DNI ',
                              //       prefixIcon: const Icon(Icons.person,
                              //           color: Colors.black45)),
                              //   validator: (value) {
                              //     if (value != null && value.isEmpty) {
                              //       return 'Campo obligatorio';
                              //     }
                              //     if (value!.length < 8) {
                              //       return 'Ingrese 8 digitos';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // TextFormField(
                              //   controller: _passwordController,
                              //   obscureText: isVisible,
                              //   keyboardType: TextInputType.visiblePassword,
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.deny(
                              //         RegExp(r'\s')), // Denegar espacios
                              //   ],
                              //   decoration: decorationTextField(
                              //       hintText: 'campo obligatorio',
                              //       labelText: 'contraseña',
                              //       prefixIcon: IconButton(
                              //           onPressed: () {
                              //             isVisible = !isVisible;
                              //             setState(() {});
                              //           },
                              //           icon: Icon(
                              //             isVisible != true
                              //                 ? Icons.visibility
                              //                 : Icons.visibility_off,
                              //             size: 18,
                              //           ))),
                              //   validator: (value) {
                              //     if (value != null && value.isEmpty) {
                              //       return 'Campo obligatorio';
                              //     }
                              //     if (value!.length < 6) {
                              //       return 'Ingrese más de 6 caracteres';
                              //     }
                              //     if (value.contains(' ')) {
                              //       return 'La contraseña no puede contener espacios';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              GestureDetector(
                                  onTap: () {
                                    if (Theme.of(context).platform ==
                                        TargetPlatform.android) {
                                      // Mostrar AlertDialog en Android
                                      showAndroidDialog(context);
                                    } else if (Theme.of(context).platform ==
                                        TargetPlatform.iOS) {
                                      // Mostrar CupertinoDialog en iOS
                                      showiOSDialog(context);
                                    }
                                  },
                                  child: const OfflineSIgnalButon()),
                              // Container(
                              //   margin:
                              //       const EdgeInsets.symmetric(vertical: 30),
                              //   child: ElevatedButton(
                              //     style: ButtonStyle(
                              //         backgroundColor: MaterialStatePropertyAll(
                              //             Colors.black),
                              //         shape: const MaterialStatePropertyAll(
                              //             RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(10)),
                              //         ))),
                              //     onPressed: loginProvider.islogin
                              //         ? null
                              //         : () async {
                              //             initStarLogin();
                              //             await Provider.of<UsuarioProvider>(
                              //                     context,
                              //                     listen: false)
                              //                 .cargarUsuario();
                              //           },
                              //     child: SizedBox(
                              //         height: 60,
                              //         child: Center(
                              //             child: loginProvider.islogin
                              //                 ? const CircularProgressIndicator(
                              //                     color: Colors.white,
                              //                   )
                              //                 : const H2Text(
                              //                     text: 'Iniciar Sesión',
                              //                     fontWeight: FontWeight.w600,
                              //                     color: Colors.white,
                              //                   ))),
                              //   ),
                              // ),
                              user?.imagen == null
                                  ? ConectivityDemo()
                                  : SizedBox(),
                              H2Text(text: generateMaskedText(text), fontSize: 30,color: Colors.white60,),
                              NumericKeyboard(
                                onKeyboardTap: (value) {
                                  setState(() {
                                    if (text.length + value.length <= 8) {
                                      text = text + value;
                                      _passwordController.text = text;
                                      _cedulaController.text = text;
                                      print('TEXTO: $text');
                                      print(text.length);
                                      print(value.length);
                                    }
                                  });
                                },
                                rightButtonFn: () {
                                  setState(() {
                                    if (text.isNotEmpty) {
                                      text = text.substring(0, text.length - 1);
                                      _passwordController.text = text;
                                      _cedulaController.text = text;
                                    }
                                  });
                                },
                                leftButtonFn: loginProvider.islogin
                                    ? null
                                    : () async {
                                        initStarLogin();
                                        await Provider.of<UsuarioProvider>(
                                                context,
                                                listen: false)
                                            .cargarUsuario();
                                      },
                                textColor: Colors.red,
                                 rightIcon: Icon(
                                  Icons.backspace,
                                  color: Colors.red,
                                ),
                                leftIcon: Icon(
                                  Icons.check,
                                  color: Colors.red,
                                ),
                              ),
                            ],
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
    );
  }
  String generateMaskedText(String text) {
  final int maxLength = 8;
  String maskedText = '';

  for (int i = 0; i < maxLength; i++) {
    if (i < text.length) {
      maskedText += text[i];
    } else {
      maskedText += '•';
    }
  }

  return maskedText;
}
// Función para mostrar un AlertDialog en Android
  void showAndroidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Trabajar sin conexión a internet.'),
          content: ModoOfflineClick(),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar un CupertinoDialog en iOS
  void showiOSDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // title: Text('Trabajar sin conexión a internet.'),
          content: ModoOfflineClick(),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initStarLogin() async {
    final loginProvider =
        Provider.of<TEmpleadoProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      await loginProvider.login(
          context: context,
          cedulaDNI: int.parse(_cedulaController.text),
          password: _passwordController.text);
      _formKey.currentState!.save();

      //SIMULAR UNA CARGA
      if (loginProvider.islogin) {
        // Crear una instancia de SharedPrefencesGlobal
        SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

        // Luego, llama al método setLoggedIn en esa instancia
        await sharedPrefs.setLoggedIn();

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          final screensize = MediaQuery.of(context).size;
          if (screensize.width > 900) {
            // print('Web Page: ${screensize.width}');
            return const WebPage();
          } else {
            // print('Web Page: ${screensize.width}');
            return const PhonePage();
          }
        }), (route) => false);
      } else {
        speackQr('usuario no encontrado');
        ElegantNotification.error(
          width: 360,
          stackedOptions: StackedOptions(
            key: 'topRight',
            type: StackedType.above,
            itemOffset: Offset(0, 5),
          ),
          position: Alignment.topCenter,
          animation: AnimationType.fromTop,
          title: Text('Error'),
          description: Text('Usuario no encontrado'),
          onDismiss: () {},
        ).show(context);
      }
    }
  }

  speackQr(text) async {
    await flutterTts.stop(); // Detener la reproducción anterior, si la hay
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

class LoginBar extends StatelessWidget {
  const LoginBar({
    super.key,
    required this.user,
  });

  final TEmpleadoModel? user;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 6000),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            user?.imagen == null
                ? Image.asset(
                    'assets/img/logo_smallar.png',
                    height: 100,
                  )
                : RippleAnimation(
                    duration: const Duration(seconds: 1),
                    color: Colors.white10,
                    child: ImageLoginUser(
                      user: user,
                      size: 100,
                    ),
                  ),
            H2Text(
              text: user?.imagen == null
                  ? 'Bienvenido'.toUpperCase()
                  : 'Hola ${user!.nombre}!'.toUpperCase(),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class ImageLoginUser extends StatelessWidget {
  const ImageLoginUser({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          // ignore: unnecessary_null_comparison, unnecessary_type_check
          imageUrl: user?.imagen != null &&
                  user?.imagen is String &&
                  user!.imagen!.isNotEmpty
              ? 'https://andes-race-challenge.pockethost.io/api/files/${user!.collectionId}/${user!.id}/${user!.imagen}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              imagenLogo(), // Widget a mostrar si hay un error al cargar la imagen
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
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
