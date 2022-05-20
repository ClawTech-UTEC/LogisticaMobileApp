import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/login_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/screens/login.dart';
import 'package:clawtech_logistica_app/views/screens/registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationViewModel(userService: userService),
      child: BlocBuilder<AuthenticationViewModel, AuthenticationState>(
          builder: ((context, state) {
        if (state is InitialState) {
          BlocProvider.of<AuthenticationViewModel>(context)
              .initialAithentication();
          return Center(child: CircularProgressIndicator());
        }
        if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AuthenticationSuccessState) {
          return DashboardPage();
        } else if (state is ErrorState) {
          return Login(errorMessage: state.message);
        } else if (state is SigningUpState) {
          return RegistrationPage();
        } else if (state is RegistrationErrorState) {
          return RegistrationPage(errorMessage: state.message);
        } else
          return Login();
      })),
    );
  }
}
