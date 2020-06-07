import 'package:chatout/core/models/message.dart';
import 'package:chatout/core/view_models/views/conversation_view_model.dart';
import 'package:chatout/ui/widgets/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationView extends StatelessWidget {
  final String conversationId;
  final String currentUserID;
  final String friendUserName;
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  ConversationView(
      {Key key,
      @required this.conversationId,
      @required this.currentUserID,
      @required this.friendUserName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: ConversationViewModel(
          conversationID: conversationId,
          firestoreService: Provider.of(context)),
      onModelReady: (model) => model.listenToMessages(),
      builder: (context, model, child) => Scaffold(
        appBar: buildAppBar(context),
        body: SafeArea(
          child: Container(
              child: Column(
            children: <Widget>[
              //buildMessageBubble(context, model.messages[0])
              buildMessagesList(context, model),
              buildMessageComposer(context, model),
            ],
          )),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(friendUserName),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.exit_to_app),
//          onPressed: () async {
//            await model.signOut();
//            Navigator.of(context).pushReplacementNamed(RoutePaths.SignIn);
//          },
//        ),
//      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////

  Widget buildMessagesList(BuildContext context, dynamic model) {
    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.grey[200],
          child: ListView.builder(
              //shrinkWrap: true,
              reverse: true,
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              itemCount: model.messages.length,
              itemBuilder: (BuildContext context, int index) {
                Message currentMsg = model.messages[index];
                return buildMessageBubble(context, currentMsg);
              }),
        ),
      ),
    );
  }

  Widget buildMessageBubble(BuildContext context, Message currentMsg) {
    bool isMe = currentMsg.senderId == currentUserID ? true : false;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          //alignment: isMe ? Alignment.bottomRight : Alignment.topLeft,
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColorLight
                //.withAlpha(150)
                : Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(15.0),
                bottomLeft: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 20.0,
                  offset: Offset(10, 10),
                  color: Colors.black54),
            ],
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Text(
            currentMsg.text,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMessageComposer(BuildContext context, dynamic model) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _msgController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Send a message ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 5.0),
              child: RawMaterialButton(
                constraints: BoxConstraints(minWidth: 50.0),
                onPressed: () {
                  String msgTxt = _msgController.text;
                  if (msgTxt != null && msgTxt.length > 0) {
                    model.sendMessage(currentUserID, msgTxt);
                    _msgController.clear();
                    _scrollController.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                  }
                },
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryTextTheme.headline.color,
                ),
                padding: EdgeInsets.fromLTRB(15.0, 15.0, 11.0, 15.0),
                shape: CircleBorder(),
              )

//            IconButton(
//              onPressed: () {},
//              icon: Icon(
//                Icons.send,
//                color: Theme.of(context).primaryColor,
//              ),
//            ),
              ),
        ],
      ),
    );
  }
}
