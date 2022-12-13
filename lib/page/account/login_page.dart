import 'package:flutter/material.dart';
import 'package:manga_app/bloc/login_bloc.dart';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/mybutton.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';
import 'package:manga_app/common/widgets/progress_dialog.dart';
import 'package:manga_app/common/widgets/toast_overlay.dart';
import 'package:manga_app/page/account/register_page.dart';
import 'package:manga_app/page/manga/bottom_navigation_bar_page.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  late LoginBloc loginBloc;

  SharedPreferences? pref;
  late ProgressDialog progress;

  @override
  void initState() {
    progress = ProgressDialog(context);
    loginBloc = LoginBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image.asset('assets/images/main_image.png'),
          ),
          RichText(
            text: const TextSpan(
              text: 'Manga',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Z',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w600,
                      fontFamily: AutofillHints.streetAddressLine1,
                      fontSize: 30),
                ),
                TextSpan(
                  text: ' : A good story every day',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: buildBodyLogin(),
          ),
          RichText(
            text: const TextSpan(
              text: 'Hotline: ',
              style: TextStyle(fontWeight: FontWeight.w600),
              children: <TextSpan>[
                TextSpan(
                  text: '0981571687',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBodyLogin() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: StreamBuilder<bool>(
        stream: loginBloc.loginStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              MyTextField(
                // autoFocus: true,
                controller: _phoneNumberController,
                maxLines: 12,
                labelText: 'Số điện thoại',
                hintText: '0981 5xx xxx',
                textAlign: TextAlign.start,
                keyboardType: TextInputType.phone,
                onChanged: (String phone) {
                  loginBloc.checkPhoneNumber(phone);
                },
                inputCheck: loginBloc.errorPhone,
              ),
              const SizedBox(
                height: 16,
              ),
              MyTextField(
                labelText: 'Mật khẩu',
                controller: _passwordController,
                hintText: '********',
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                obscureText: loginBloc.showPassword,
                onChanged: (String password) {
                  loginBloc.checkPassword(password);
                },
                inputCheck: loginBloc.errorPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    loginBloc.showTextFieldPassword();
                  },
                  icon: (snapshot.data ?? false)
                      ? const Icon(Icons.remove_red_eye)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      textButton: 'Đăng ký',
                      textColor: Colors.black,
                      backgroundColor: Colors.grey.shade500,
                      onTap: () {
                        navigatorPush(context, const RegisterPage());
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: MyButton(
                      textButton: 'Đăng nhập',
                      textColor: Colors.black,
                      backgroundColor: Colors.green,
                      onTap: () {
                        login(
                          phoneNumber: _phoneNumberController.text,
                          password: _passwordController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void login({
    required String phoneNumber,
    required String password,
  }) {
    if(loginBloc.errorPhone == '' && loginBloc.errorPassword == '') {
      {
        apiService
            .login(
          phoneNumber: _phoneNumberController.text,
          password: _passwordController.text,
        )
            .then((user) {
          hive.setValue(userKey, user);

          ToastOverlay(context).showToastOverlay(
              message: 'Đăng nhập thành công, Xin chào: ${user.name}', type: ToastType.success);

          navigatorPushAndRemoveUntil(context, const BottomNavigationBarPage());
        }).catchError(
              (e) {
            ToastOverlay(context).showToastOverlay(
                message: 'Login Error: ${e.toString()}', type: ToastType.error);
          },
        );
      }
    } else {
      ToastOverlay(context).showToastOverlay(
          message: 'Đăng nhập thất bại', type: ToastType.error);
    }
  }
}
