import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/popup_menu_context.dart';

class PopupWindow extends StatefulWidget{
  final Widget child;
  final Function getUpdates;
  
  PopupWindow({super.key, required this.child, required this.getUpdates}) : assert(child.key != null);

  @override
  State<StatefulWidget> createState() {
    return PopupWindowState();
  }
}

class PopupWindowState extends State<PopupWindow>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showPopUpMenu,
      child: widget.child,
    );
  }

  void showPopUpMenu(){
    showCupertinoDialog(
        context: context,
        builder: (context){
          RenderBox renderBox =
          (widget.child.key as GlobalKey).currentContext?.findRenderObject()
                as RenderBox;
          Offset position = renderBox.localToGlobal(Offset.zero);
          return PopupMenuContent(
              getUpdates: widget.getUpdates,
              position: position,
              size: renderBox.size,
              onAction: (x){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text('Action => $x'),
                ));
        }
    );
  });}


  
}

