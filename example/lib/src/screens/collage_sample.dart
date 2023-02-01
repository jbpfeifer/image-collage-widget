library image_collage_widget;

import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_collage_widget/image_collage_widget.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// A CollageWidget.
class CollageSample extends StatefulWidget {
  final CollageType collageType;

  const CollageSample(this.collageType, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CollageSample();
  }
}

class _CollageSample extends State<CollageSample> {
  final GlobalKey _screenshotKey = GlobalKey();
  bool _startLoading = false;

  getRatio() {
    var ratio = 3 / 2;
    // print(widget.collageType);
    // if (widget.collageType == CollageType.VSplit ||
    //     widget.collageType == CollageType.VFour ||
    //     widget.collageType == CollageType.ThreeVertical ||
    //     widget.collageType == CollageType.LeftBig ||
    //     widget.collageType == CollageType.RightBig ||
    //     widget.collageType == CollageType.SixSquare) {
    //   ratio = 3 / 2;
    if (widget.collageType == CollageType.HSplit ||
        widget.collageType == CollageType.HFour ||
        widget.collageType == CollageType.ThreeHorizontal) {
      ratio = 2 / 3;
    }
    return ratio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Collage maker",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () => _capturePng(),
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(
                  child: Text("Share",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ),
            )
          ]),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey,
        child: Center(
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: getRatio(),
                child: RepaintBoundary(
                  key: _screenshotKey,

                  /// @param withImage:- If withImage = true, It will load image from given {filePath (default = "Camera")}
                  /// @param collageType:- CollageType.CenterBig

                  child: ImageCollageWidget(
                    collageType: widget.collageType,
                    withImage: true,
                  ),
                ),
              ),
              if (_startLoading)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  /// call this method to share file
  _shareScreenShot(String imgpath) async {
    setState(() {
      _startLoading = false;
    });
    try {
      Share.shareFiles([imgpath]);
    } on PlatformException catch (e) {
      log('Platform Exception: $e');
    } catch (e) {
      log('Exception: $e');
    }
  }

  ///Used for capture screenshot
  Future<Uint8List> _capturePng() async {
    try {
      setState(() {
        _startLoading = true;
      });
      Directory dir;
      RenderRepaintBoundary? boundary = _screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      await Future.delayed(const Duration(milliseconds: 2000));
      if (Platform.isIOS) {
        ///For iOS
        dir = await getApplicationDocumentsDirectory();
      } else {
        ///For Android
        dir = (await getExternalStorageDirectory())!;
      }
      var image = await boundary?.toImage(pixelRatio: 3.0);
      var byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      File screenshotImageFile =
          File('${dir.path}/${DateTime.now().microsecondsSinceEpoch}.png');
      await screenshotImageFile.writeAsBytes(byteData!.buffer.asUint8List());
      _shareScreenShot(screenshotImageFile.path);
      return byteData.buffer.asUint8List();
    } catch (e) {
      setState(() {
        _startLoading = false;
      });
      print("Capture Image Exception Main : " + e.toString());
      throw Exception();
    }
  }
}
