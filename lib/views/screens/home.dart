import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/states/authentication_states.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/screens/login.dart';
import 'package:clawtech_logistica_app/views/screens/registro.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_login_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthenticationViewModel viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = BlocProvider.of<AuthenticationViewModel>(context);
    viewModel.initialAithentication();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationViewModel, AuthenticationState>(
      bloc: viewModel,
      builder: ((context, state) {
        if (state is LoadingState) {
          return LoadingPage();
        } else if (state is AuthenticationSuccessState) {
          return DashboardPage();
        } else {
          return ScaffoldLoginBackground(
              child: BlocListener(
                  bloc: viewModel,
                  listener: (context, AuthenticationState state) {
                    if (state.message != null) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(state.message!),
                        backgroundColor: Theme.of(context).accentColor,
                      ));
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: state.loading ? 0.7 : 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: PageView(
                            controller: state.controller,
                            children: [
                              Login(
                                errorMessage: state.message,
                              ),
                              RegistrationPage(
                                errorMessage: state.message,
                              )
                            ],
                          ),
                        ),
                      ),
                      state.loading
                          ? Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ))
                          : Container()
                    ],
                  )));
        }
      }),
    );
  }
}



