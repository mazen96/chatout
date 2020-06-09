import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/core/view_models/views/home_view_model.dart';
import 'package:chatout/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: HomeViewModel(
          auth: Provider.of(context), firestore: Provider.of(context)),
      onModelReady: (model) => model.getMyConversations(),
      builder: (context, model, child) => Scaffold(
        appBar: buildAppBar(context, model),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(RoutePaths.AddConversation);
            model.getMyConversations();
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: Container(
            child: model.myConversations == null
                ? Center(child: CircularProgressIndicator())
                : model.myConversations.length > 0
                    ? buildConversationsList(model)
                    : Center(child: Text('You have 0 chats')),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, dynamic model) {
    return AppBar(
      title: Text(
        'Chat Rooms',
        style: TextStyle(fontFamily: 'Pacifico', fontSize: 28.0),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await model.signOut();
            Navigator.of(context).pushReplacementNamed(RoutePaths.SignIn);
          },
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////////
  Widget buildConversationsList(dynamic model) {
    return ListView.builder(
        itemCount: model.myConversations.length,
        itemBuilder: (BuildContext context, int index) {
          print('%%%%%%%%%%%%%%%%% :: current indexxxx :: $index');
          return ListTile(
            title: Text(model.myConversations[index].username),
            subtitle: Text(model.myConversations[index].email),
            onTap: () {
              Map<String, String> args = {
                "conversationId": model.myConversations[index].id,
                "currentUserId": model.currentUser.id,
                "friendUserName": model.myConversations[index].username
              };

              Navigator.of(context)
                  .pushNamed(RoutePaths.ConversationView, arguments: args);
            },
          );
        });
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
}
