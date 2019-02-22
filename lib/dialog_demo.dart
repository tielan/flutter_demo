import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'huddialog.dart';

class DialogDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DialogDemo();
}

class _DialogDemo extends State<DialogDemo> {
  GlobalKey anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialog Demo'),
      ),
      body: Container(
        color: Colors.tealAccent,
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('show simple dialog'),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('show alert dialog'),
              onPressed: () {
                HUDDialog.show(
                    context: context,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          CupertinoTextField(
                            placeholder: '请输入姓名',
                          ),
                           CupertinoTextField(
                            placeholder: '请输入姓名',
                          ),
                           CupertinoTextField(
                            placeholder: '请输入姓名',
                          ),
                           CupertinoTextField(
                            placeholder: '请输入姓名',
                          ),
                           CupertinoTextField(
                            placeholder: '请输入姓名',
                          )
                        ],
                      ),
                    ));
              },
            ),
            RaisedButton(
                child: Text(
                  'show general dialog',
                ),
                key: anchorKey,
                onPressed: () {
                  HUDDialog.showAttachToKey(
                      anchorKey: anchorKey,
                      context: context,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              child: Column(
                                children: <Widget>[
                                  CupertinoTextField(
                                    placeholder: '请输入姓名',
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 44.0,
                                      alignment: Alignment.center,
                                      color: Color(0xff000000),
                                      child: Text(
                                        '取消',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      HUDDialog.dismiss(context);
                                    },
                                    child: Container(
                                      height: 44.0,
                                      alignment: Alignment.center,
                                      color: Color(0xffff0000),
                                      child: Text('确定',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ));
                }),
          ],
        ),
      ),
    );
  }
}
