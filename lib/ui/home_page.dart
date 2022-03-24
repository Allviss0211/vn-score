import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vn_score/models/pen_stroke_model.dart';
import 'package:vn_score/providers/bg_color_provider.dart';
import 'package:vn_score/providers/eraser_provider.dart';
import 'package:vn_score/providers/sheetnumber_provider.dart';
import 'package:vn_score/providers/sheets_provider.dart';
import 'package:vn_score/ui/components/left_appbar.dart';
import 'package:vn_score/ui/components/right_bar.dart';
import 'package:vn_score/ui/components/top_bar.dart';
import 'package:vn_score/ui/constants/constants.dart';
import 'package:vn_score/ui/painters/draw.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final ScreenshotController controller = ScreenshotController();
  @override
  void initState() {
    assetsAudioPlayer.open(
        Audio.network(
            "https://data.chiasenhac.com/down2/2180/4/2179558-3ff1e0d6/128/Gu%20Cukak%20Remix_%20-%20Freaky_%20Seachains.mp3"),
        autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) => SafeArea(
          child: Stack(
            children: [
              Screenshot(
                controller: controller,
                child: Consumer<SheetsViewProvider>(
                  builder: (context, sheetView, child) {
                    return sheetView.isGrid
                        ? GridPaper(
                            interval: 20,
                            divisions: 1,
                            subdivisions: 1,
                            child: Consumer<SheetNumberProvider>(
                              builder: (context, sheetNProv, child) {
                                return Consumer<EraserProvider>(
                                  builder: (context, eraseProv, child) {
                                    print('ERASER CHANGED');
                                    return Consumer<BgColorProvider>(
                                      builder:
                                          (BuildContext context, bg, child) =>
                                              Container(
                                        color: bg.bgColor,
                                        child: MouseRegion(
                                          cursor: eraseProv.isEraser
                                              ? SystemMouseCursors.copy
                                              : SystemMouseCursors.basic,
                                          child: GestureDetector(
                                            onPanUpdate:
                                                (DragUpdateDetails details) {
                                              setState(
                                                () {
                                                  RenderBox object = context
                                                      .findRenderObject();
                                                  Offset _localPosition = object
                                                      .globalToLocal(details
                                                          .globalPosition);
                                                  PenStroke _localPoint =
                                                      PenStroke();
                                                  _localPoint.color =
                                                      eraseProv.isEraser
                                                          ? bg.bgColor
                                                          : brushColor;
                                                  _localPoint.offset =
                                                      _localPosition;
                                                  _localPoint.brushWidth =
                                                      eraseProv.isEraser
                                                          ? eraserWidth
                                                          : brushWidth;
                                                  _localPoint.strokeCap =
                                                      strokeCap;
                                                  points = List.from(points)
                                                    ..add(_localPoint);
                                                },
                                              );
                                            },
                                            onPanEnd:
                                                (DragEndDetails details) => {
                                              deletedPoints.clear(),
                                              points.add(null),
                                              print('POINTS: ${points.length}'),
                                            },
                                            child: CustomPaint(
                                              painter: DrawPen(points: points),
                                              size: Size.infinite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : Consumer<SheetNumberProvider>(
                            builder: (context, sheetNProv, child) {
                              print(
                                  'NUMBER OF SHEETS 2: ${sheetNProv.sheetNumber}');

                              return Consumer<EraserProvider>(
                                builder: (context, eraseProv, child) =>
                                    Consumer<BgColorProvider>(
                                  builder: (context, bg, child) => Container(
                                    color: bg.bgColor,
                                    child: MouseRegion(
                                      cursor: eraseProv.isEraser
                                          ? SystemMouseCursors.disappearing
                                          : SystemMouseCursors.basic,
                                      child: GestureDetector(
                                        onPanUpdate:
                                            (DragUpdateDetails details) {
                                          setState(
                                            () {
                                              RenderBox object =
                                                  context.findRenderObject();
                                              Offset _localPosition =
                                                  object.globalToLocal(
                                                      details.globalPosition);
                                              PenStroke _localPoint =
                                                  PenStroke();
                                              _localPoint.color =
                                                  eraseProv.isEraser
                                                      ? bg.bgColor
                                                      : brushColor;
                                              _localPoint.offset =
                                                  _localPosition;
                                              _localPoint.brushWidth =
                                                  eraseProv.isEraser
                                                      ? eraserWidth
                                                      : brushWidth;
                                              _localPoint.strokeCap = strokeCap;
                                              points = List.from(points)
                                                ..add(_localPoint);
                                            },
                                          );
                                        },
                                        onPanEnd: (DragEndDetails details) => {
                                          deletedPoints.clear(),
                                          points.add(null),
                                        },
                                        child: CustomPaint(
                                          painter: DrawPen(points: points),
                                          size: Size.infinite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              TopAppBar(),
              Align(
                alignment: Alignment.topCenter,
                child: TopBar(
                  player: assetsAudioPlayer,
                ),
              ),
              Positioned(
                right: 0.0,
                child: RightBar(
                  screenshotController: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
