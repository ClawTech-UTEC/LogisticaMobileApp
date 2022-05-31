import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/screens/login.dart';
import 'package:clawtech_logistica_app/views/screens/registro.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_login_background.dart';
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
            return LoadingPage();
          }
          if (state is LoadingState) {
            return LoadingPage();
          } else if (state is AuthenticationSuccessState) {
            return DashboardPage();
          } else {
            return ScaffoldLoginBackground(
                child: state is SignInErrorState
                    ? Login(errorMessage: state.message)
                    : state is SignUpState
                        ? RegistrationPage()
                        : state is SignUpErrorState
                            ? RegistrationPage(errorMessage: state.message)
                            : Login());
          }
        }),
      ),
    );
  }
}
