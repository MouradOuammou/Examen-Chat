import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ConversationRepository(),
      child: MaterialApp(
        title: 'Messagerie',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => ConversationBloc(
            conversationRepository: RepositoryProvider.of<ConversationRepository>(context),
          )..add(LoadConversations()),
          child: const ConversationListScreen(),
        ),
      ),
    );
  }
}