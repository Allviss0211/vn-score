import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vn_score/providers/bg_color_provider.dart';
import 'package:vn_score/providers/sheets_provider.dart';
import 'package:vn_score/ui/components/background_color_button.dart';
import 'package:vn_score/ui/components/bottom_left_bar.dart';
import 'package:vn_score/ui/components/eraser_button.dart';
import 'package:vn_score/ui/components/pen_properties_button.dart';
import 'package:vn_score/ui/components/text_insert_button.dart';
import 'package:vn_score/ui/constants/constants.dart';
import 'package:vn_score/ui/styles/icon_styles.dart';
import 'package:vn_score/ui/styles/popup_styles.dart';

class TopAppBar extends StatefulWidget {
  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  void createNewFunction(bool isgrid) {
    Navigator.of(context).pop();
    var _sheetView = Provider.of<SheetsViewProvider>(context, listen: false);
    _sheetView.isGrid = isgrid;
    Scaffold.of(context).setState(() {
      points.clear();
      deletedPoints.clear();
      revPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _bgColorProvider = Provider.of<BgColorProvider>(context);
    return Builder(
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Column(
                    children: [
                      PenProperties(),
                      BackGroundColorButton(bgColorProvider: _bgColorProvider),
                      // ShapeInsertButton(),
                      EraserButton(),
                      TextInsertButton(),
                      PopupMenuButton<String>(
                        color: popupMenuColor,
                        tooltip: 'Sheet View',
                        icon: Icon(
                          Icons.add,
                          color: iconColor,
                          size: iconSize + 7,
                        ),
                        onSelected: (String value) {},
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'normalpaper',
                            child: ListTile(
                              title: Text(
                                'Normal',
                                style: popupTextStyle,
                              ),
                              onTap: () {
                                createNewFunction(false);
                              },
                            ),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'gridpaper',
                            child: ListTile(
                              title: Text(
                                'Grid Paper',
                                style: popupTextStyle,
                              ),
                              onTap: () {
                                createNewFunction(true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BottomLeftBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
