import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:websafe_svg/websafe_svg.dart';


class ToolsWidget extends StatefulWidget {
  @override
  _ToolsWidgetState createState() => _ToolsWidgetState();
}

class _ToolsWidgetState extends State<ToolsWidget> {
  int _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SubTitle("Tools"),
          FlatButton.icon(
            icon: Icon(_selectedItem == 1 ? Icons.close : Icons.location_on),
            label: Text("Map location"),
            color: _selectedItem == 1 ? Colors.grey : Colors.transparent,
            onPressed: () => setState(() {
              _selectedItem = _selectedItem == 1 ? null : 1;
            }),
          ),
          currentTool()
      ],
    );
  }

  Widget currentTool() {
    switch (_selectedItem) {
      case 1:
        return MapToolWidget();
        break;
      default:
        return Container();
    }
  }
}


class MapToolWidget extends StatefulWidget {
  @override
  _MapToolWidgetState createState() => _MapToolWidgetState();
}

class _MapToolWidgetState extends State<MapToolWidget> {
  GlobalKey _mapKey = GlobalKey();
  List<MapPointModel> positions = List();
  Size get mapSize => (_mapKey.currentContext.findAncestorRenderObjectOfType() as RenderBox).size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              PositionedTapDetector(
                key: _mapKey,
                onTap: (position) {
                  var color = RandomColorGenerator.generate();
                  var dx = num.parse((position.relative.dx / mapSize.width).toStringAsFixed(3));
                  var dy = num.parse((position.relative.dy / mapSize.height).toStringAsFixed(3));
                  var offset = Offset(dx, dy);
                  var point = MapPointModel(offset: offset, color: color);
                  setState(() => positions.add(point));
                },
                child: WebsafeSvg.asset("assets/images/worldmap.svg", color: Colors.grey)
              ),
              ...positions.map((p) => Positioned(
                left: (p.offset.dx * mapSize.width) - 12,
                top: (p.offset.dy * mapSize.height) - 24,
                child: InkResponse(
                  child: Icon(
                    Icons.location_on, color: p.color,
                    size: 24,
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: p.toString()));
                  },
                ),
              ))
            ]
          ),
          SizedBox(width: 40,),
          Expanded(
            child: ListView(
              key: GlobalKey(),
              shrinkWrap: true,
              children: [
                FlatButton(
                  child: Text("Clear"),
                  onPressed: () {
                    setState(() {
                      positions = List();
                    });
                  },
                ),
                ...positions.map((p) => InputChip(
                  avatar: CircleAvatar(backgroundColor: p.color,),
                  label: Text(p.toString()),
                  onDeleted: () {
                    setState(() => positions.remove(p));
                  },
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: p.toString()));
                  },
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MapPointModel {
  Offset offset;
  Color color;
  MapPointModel({@required this.offset, @required this.color});

  @override
  String toString() => "${offset.dx};${offset.dy}";
}