import 'package:flutter/material.dart';
import 'package:manga_app/bloc/register_bloc.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/mybutton.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  String? birthDateInString;
  DateTime? birthDate;
  late RegisterBloc registerBloc;

  @override
  void initState() {
    registerBloc = RegisterBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context,
          title: 'Register Page',
          color: Colors.brown.shade700),
      body: imageBackgroundColor(),
    );
  }

  Widget imageBackgroundColor() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ('assets/images/main_image.png'),
              ),
              fit: BoxFit.cover,
            ),
            // shape: BoxShape.rectangle,
          ),
        ),
        buildBody(),
      ],
    );
  }

  Widget buildBody() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
        colors: [
          Colors.brown.shade300.withOpacity(0.7),
          Colors.grey.withOpacity(0.7),
        ],
      )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<bool>(
            stream: registerBloc.registerStream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: 'Manga',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Z',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.w600,
                            fontFamily: AutofillHints.streetAddressLine1,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'A good story every day',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  MyTextField(
                    labelText: 'Name',
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    onChanged: (String name) {
                      registerBloc.checkName(name);
                    },
                    inputCheck: registerBloc.errorName,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  MyTextField(
                    labelText: 'PhoneNumber',
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    onChanged: (String phone) {
                      registerBloc.checkPhoneNumber(phone);
                    },
                    inputCheck: registerBloc.errorPhone,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  MyTextField(
                    labelText: 'Password',
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    onChanged: (String password) {
                      registerBloc.checkPassword(password);
                      registerBloc.checkConfirmPassword(password, _passwordConfirmController.text);
                    },
                    inputCheck: registerBloc.errorPassword,
                    obscureText: registerBloc.showPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        registerBloc.showTextFieldPassword();
                      },
                      icon: (snapshot.data ?? false)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye),
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  MyTextField(
                    labelText: 'Confirm Password',
                    controller: _passwordConfirmController,
                    keyboardType: TextInputType.text,
                    obscureText: registerBloc.showConfirmPasswordIcon,
                    onChanged: (String confirmPassword) {
                      registerBloc.checkConfirmPassword(
                          _passwordController.text, confirmPassword);
                    },
                    inputCheck: registerBloc.errorConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        registerBloc.showTextFieldConfirmPassword();
                      },
                      icon: (snapshot.data ?? false)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye),
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: MyTextField(
                              controller: _dateOfBirthController,
                              labelText: 'Date of Birth',
                              enable: false,
                              inputCheck: registerBloc.errorDataOfBirth,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.calendar_month_outlined,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final datePick = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (datePick != null && datePick != birthDate) {
                          birthDate = datePick;
                          birthDateInString =
                              "${birthDate?.day}/${birthDate?.month}/${birthDate?.year}";
                          _dateOfBirthController.text = birthDateInString ?? '';
                          registerBloc
                              .checkDateOfBirth(_dateOfBirthController.text);
                        }
                      }),
                  const SizedBox(
                    height: 28,
                  ),
                  MyTextField(
                    labelText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String email) {
                      registerBloc.checkEmail(email);
                    },
                    inputCheck: registerBloc.errorEmail,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  MyButton(
                      textButton: 'Register',
                      textColor: Colors.black,
                      backgroundColor: Colors.green,
                      onTap: () {
                        // registerBloc.checkDateOfBirth(_dateOfBirthController.text ?? '');
                      }),
                  const SizedBox(
                    height: 28,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
