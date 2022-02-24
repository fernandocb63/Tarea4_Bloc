import 'dart:io';

import 'package:fake_baccount/users_page/bloc/cuentas_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _screenshotcontroller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotcontroller,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
                    featureId: 'fid_share',
                    backgroundColor: Colors.grey,
                    contentLocation: ContentLocation.below,
                    title: const Text("Boton para compartir"),
                    tapTarget: const Icon(Icons.share), targetColor: Colors.grey.shade700,
                    overflowMode: OverflowMode.extendBackground,
                    child:IconButton(
              tooltip: "Compartir pantalla",
              onPressed: screenshot,
              icon: Icon(Icons.share),
            )),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  listener: (context, state) {
                    if (state is PictureErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${state.errorMsg}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PictureSelectedState) {
                      return CircleAvatar(
                        backgroundImage: FileImage(state.picture!),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 122, 113, 113),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Bienvenido",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text("Usuario${UniqueKey()}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DescribedFeatureOverlay(
                    featureId: 'fid_tarjeta',
                    backgroundColor: Colors.grey,
                    contentLocation: ContentLocation.below,
                    title: const Text("Boton para ver tarjetas"),
                    tapTarget: const Icon(Icons.credit_card), targetColor: Colors.indigo,
                    overflowMode: OverflowMode.extendBackground,
                    child:CircularButton(
                      textAction: "Ver tarjeta",
                      iconData: Icons.credit_card,
                      bgColor: Color(0xff123b5e),
                      action: null,
                    )),
                    DescribedFeatureOverlay(
                    featureId: 'fid_foto',
                    backgroundColor: Colors.grey,
                    contentLocation: ContentLocation.below,
                    title: const Text("Boton para cambiar y ver tu foto"),
                    tapTarget: const Icon(Icons.camera_alt), targetColor: Colors.orange,
                    overflowMode: OverflowMode.extendBackground,
                    child:CircularButton(
                      textAction: "Cambiar foto",
                      iconData: Icons.camera_alt,
                      bgColor: Colors.orange,
                      action: () {
                        BlocProvider.of<PictureBloc>(context).add(
                          ChangeImageEvent(),
                        );
                      },
                    )),
                    DescribedFeatureOverlay(
                    featureId: 'fid_tuto',
                    backgroundColor: Colors.grey,
                    contentLocation: ContentLocation.below,
                    title: const Text("Boton para ver tutorial"),
                    tapTarget: const Icon(Icons.play_arrow), targetColor: Colors.green,
                    overflowMode: OverflowMode.extendBackground,
                    child:CircularButton(
                      textAction: "Ver tutorial",
                      iconData: Icons.play_arrow,
                      bgColor: Colors.green,
                      action: (){
                        FeatureDiscovery.discoverFeatures(
                          context,
                          const <String> {
                            'fid_tuto',
                            'fid_tarjeta',
                            'fid_foto',
                            'fid_share',
                          }
                        );
                      },
                    )),
                  ],
                ),
                SizedBox(height: 48),
                BlocConsumer<CuentasBloc, CuentasState>(
                listener: (context, state) {
                },
                builder: (context, state) {
                  if (state is CuentaSelected){
                    return Expanded(
                      child: ListView.builder(
                      itemCount: (state.cuentamap["cuentas"] as List).length,
                      itemBuilder: (BuildContext context, int index) {
                        return CuentaItem(
                          tipoCuenta: state.cuentamap["cuentas"][index]["cuenta"].toString(),
                          terminacion: (state.cuentamap["cuentas"][index]["tarjeta"]).toString().substring(5),
                          saldoDisponible: (state.cuentamap["cuentas"][index]["dinero"]).toString(),
                          );
                      },),
                    );
                  } else if (state is CuentasErrorState) {
                    return Text("No hay cuentas por mostrar");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              ],
            ),
          
        ),
      ),
    );
  }

  void screenshot() async {
    final uint8List = await _screenshotcontroller.capture();
	  String tempPath = (await getTemporaryDirectory()).path;
	  File file = File('$tempPath/image.png');
	  await file.writeAsBytes(uint8List!);
	  await Share.shareFiles([file.path]);
  }
}
