import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/bloc/account_bloc.dart';
import 'package:manga_app/bloc/manga_detail_bloc.dart';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/confirm_dialog.dart';
import 'package:manga_app/common/widgets/toast_overlay.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/user.dart';
import 'package:manga_app/page/account/change_profile.dart';
import 'package:manga_app/page/account/login_page.dart';
import 'package:manga_app/page/manga/manga_detail_page.dart';
import 'package:manga_app/service/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Manga>? listMangaFavorite = apiService.user?.mangafavorite;
  int? countManga;

  String? name;
  String? avatar;

  @override
  void initState() {
    apiAccountBloc.getProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        children: [
          buildProfile(),
          const SizedBox(
            height: 20,
          ),
          buildListFavoriteManga(),
          const SizedBox(
            height: 20,
          ),
          buildListSettingApp(),
          const SizedBox(
            height: 20,
          ),
          buildListSettingProfile(),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return StreamBuilder<User>(
        stream: apiAccountBloc.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey.shade200,
                        child: CachedNetworkImage(
                          imageUrl: user?.avatar ?? '',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    Text(
                      user?.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                const Divider(
                  color: Colors.black26,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.currency_bitcoin),
                              Text('Tiền của tôi'),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${user?.coin ?? 0} ',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.point_of_sale),
                              Text('Điểm của tôi')
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${user?.point ?? 0}',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget buildListFavoriteManga() {
      return Container(
        // alignment: Alignment.topLeft,
        height: 256,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách truyện yêu thích',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder<List<Manga>>(
              stream: apiMangaDetailBloc.mangaDetailFavoriteStream,
              builder: (context, snapshot) {
                List<Manga>? mangaFs = apiService.user?.mangafavorite;

                return Flexible(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final manga = mangaFs?[index];
                      return GestureDetector(
                        onTap: () {
                          navigatorPush(context,
                              MangaDetailPage(manga: manga ?? Manga()));
                        },
                        child: buildFavoriteManga(
                          manga ?? Manga(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                    itemCount: mangaFs?.length ?? 0,
                  ),
                );
              },
            ),
          ],
        ),
      );

  }

  Widget buildFavoriteManga(Manga manga) {
    return Container(
      width: 164,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: manga.avatar ?? '',
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            flex: 1,
            child: Text(
              manga.name ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListSettingApp() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.stars_sharp),
              SizedBox(
                width: 16,
              ),
              Text('Nạp Tiền'),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: const [
              Icon(Icons.add_chart),
              SizedBox(
                width: 16,
              ),
              Text('Đăng ký hội viên'),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: const [
              Icon(Icons.message),
              SizedBox(
                width: 16,
              ),
              Text('Tin nhắn'),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: const [
              Icon(Icons.notifications),
              SizedBox(
                width: 16,
              ),
              Text('Thông báo'),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: const [
              Icon(Icons.phone),
              SizedBox(
                width: 16,
              ),
              Text('Liên hệ '),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildListSettingProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              ToastOverlay(context).showToastOverlay(
                  message: 'Thông tin cá nhân', type: ToastType.success);
            },
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                    onTap: () {
                      navigatorPush(context, const ChangeProfile());
                    },
                    child: const Text('Thông tin cá nhân')),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: const [
              Icon(Icons.password),
              SizedBox(
                width: 16,
              ),
              Text('Đổi mật khẩu'),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              showConfirmDialog(
                context: context,
                message: 'Bạn có muốn đăng xuất không?',
                onConfirm: () {
                  logout();
                },
              );
            },
            child: Row(
              children: const [
                Icon(Icons.arrow_right_alt_rounded),
                SizedBox(
                  width: 16,
                ),
                Text('Đăng xuất'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void getProfile() {
  //   apiService
  //       .getProfile(id: int.parse(apiService.user?.id ?? '0'))
  //       .then((profileUser) {
  //     name = profileUser.name ?? '';
  //
  //     // url = profileUser.avatar ?? '';
  //     setState(() {});
  //   }).catchError((e) {
  //     ToastOverlay(context).showToastOverlay(
  //         message: 'Có lỗi xảy ra: ${e.toString()}', type: ToastType.error);
  //   });
  // }

  void logout() {
    hive.remove(userKey);
    navigatorPushAndRemoveUntil(context, const LoginPage());
  }
}
