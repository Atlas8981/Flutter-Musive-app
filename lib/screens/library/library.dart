import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_icons/line_icons.dart';
import 'package:spotify_clone/controllers/main_controller.dart';
import 'package:spotify_clone/methods/get_time_ago.dart';
import 'package:spotify_clone/methods/snackbar.dart';
import 'package:spotify_clone/screens/AddMusicPage.dart';
import 'package:spotify_clone/screens/liked_songs/liked_songs.dart';
import 'package:spotify_clone/screens/playlist/playlist_songs.dart';
import 'package:spotify_clone/screens/recently_played/recently_played_songs.dart';
import 'package:spotify_clone/utils/loading.dart';

class Library extends StatelessWidget {
  final MainController con;

  const Library({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LibraryAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            LibraryRow(
              onTap: () async {
                Get.to(LikedSongs(con: con));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LikedSongs(
                //       con: con,
                //     ),
                //   ),
                // );
              },
              iconData: CupertinoIcons.heart_fill,
              title: 'Liked Songs',
              subTitleWidget: ValueListenableBuilder(
                valueListenable: Hive.box('liked').listenable(),
                builder: (context, Box box, c) {
                  return Text(
                    box.length.toString() + " Songs",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            LibraryRow(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentlyPlayedSongs(
                      con: con,
                    ),
                  ),
                );
              },
              iconData: CupertinoIcons.arrow_counterclockwise,
              title: 'Recently played',
              subTitleWidget: ValueListenableBuilder(
                valueListenable: Hive.box('RecentlyPlayed').listenable(),
                builder: (context, Box box, c) {
                  return Text(
                    box.length.toString() + " Songs",
                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            LibraryRow(
              onTap: () {
                Get.to(() => AddMusicPage());
              },
              iconData: Icons.add,
              title: "Add Music",
              subtitle: "",
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box('playlists').listenable(),
                builder: (context, Box<dynamic> box, child) {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (box.length != 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24.0, horizontal: 16),
                            child: Text(
                              "Your playlists",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: Hive.box('playlists').length,
                            itemBuilder: (context, i) {
                              final playlists = Hive.box('playlists').getAt(i);
                              return Dismissible(
                                key: Key(playlists['name'].toString()),
                                onDismissed: (direction) {
                                  box.deleteAt(i);
                                  context.showSnackBar(
                                      message: "Deleted playlist.");
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PlaylistSongs(
                                                  con: con,
                                                  name: playlists['name'],
                                                  coverImage:
                                                      playlists['coverImage'],
                                                )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 6),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                              imageUrl: playlists['coverImage'],
                                              width: 60,
                                              height: 60,
                                              placeholder: (context, u) =>
                                                  const LoadingImage(
                                                    icon: Icon(LineIcons.user),
                                                  ),
                                              fit: BoxFit.cover),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                playlists['name'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "Created By you " +
                                                    "".displayTimeAgoFromTimestamp(
                                                        playlists['created']),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class LibraryRow extends StatelessWidget {
  const LibraryRow(
      {Key? key,
      required this.onTap,
      required this.iconData,
      required this.title,
      this.subtitle,
      this.subTitleWidget})
      : super(key: key);

  final Function() onTap;
  final IconData iconData;
  final String title;
  final String? subtitle;
  final Widget? subTitleWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 4,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.green,
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  subTitleWidget ??
                      Text(
                        subtitle ?? "",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                  // ValueListenableBuilder(
                  //     valueListenable: Hive.box('RecentlyPlayed').listenable(),
                  //     builder: (context, Box box, c) {
                  //       return Text(
                  //         box.length.toString() + " Songs",
                  //         style: const TextStyle(
                  //             color: Colors.grey, fontSize: 14.0),
                  //       );
                  //     })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LibraryAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Your Library",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
