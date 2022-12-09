import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga_app/bloc/account_bloc.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';
import 'package:manga_app/common/widgets/toast_overlay.dart';
import 'package:manga_app/model/user.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/upload_photo_service.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({Key? key}) : super(key: key);

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  late AccountBloc accountBloc;
  String url = '';

  String? birthDateInString;
  DateTime? birthDate;

  final picker = ImagePicker();

  @override
  void initState() {
    accountBloc = AccountBloc();
    accountBloc.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: 'Thông tin cá nhân',
        actions: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              apiAccountBloc.updateProfile(
                name: _nameController.text,
                dateOfBirth: _dateOfBirthController.text,
                email: _emailController.text,
                avatar: url,
              );
              ToastOverlay(context).showToastOverlay(
                  message: 'Thay đổi thông tin thành công',
                  type: ToastType.success);
            },
            icon: const Icon(Icons.save_as),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<User>(
        stream: accountBloc.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data;
          _nameController.text = user?.name ?? '';
          _dateOfBirthController.text = user?.dateOfBirth ?? '';
          _phoneNumberController.text = user?.phoneNumber ?? '';
          _emailController.text = user?.email ?? '';
          url = user?.avatar ?? '';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey.shade200,
                        child: CachedNetworkImage(
                          imageUrl: url,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: IconButton(
                        onPressed: () {
                          selectImage(source: ImageSource.gallery);
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                MyTextField(
                  controller: _nameController,
                  autoFocus: true,
                  labelText: 'Name',
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(
                  height: 8,
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
                      }
                    }),
                const SizedBox(
                  height: 8,
                ),
                MyTextField(
                  controller: _phoneNumberController,
                  labelText: 'Phone Number',
                  enable: false,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(
                  height: 8,
                ),
                MyTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          );
        });
  }

  Future selectImage({required ImageSource source}) async {
    try {
      final image = await picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 10,
      );
      if (image != null) {
        uploadAvatar(image);
      }
    } catch (e) {
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    }
  }

  void uploadAvatar(XFile f) {
    apiUploadPhotoService.uploadAvatar(file: f).then((value) {
      setState(() {
        apiService.user?.avatar = '${value.media}';
        print('_ChangeProfileState.uploadAvatar: $url');
      });
    }).catchError((e) {
      ToastOverlay(context).showToastOverlay(
          message: 'Có lỗi xảy ra: ${e.toString()}', type: ToastType.error);
    });
  }
}
