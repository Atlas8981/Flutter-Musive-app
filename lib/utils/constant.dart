import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/models/user.dart';

const String imageDir = "assets/images/";
const String userCollection = "users";
const String musicCollection = "music";
const String additionalCollection = "additionInfo";
const String saveItemCollection = "saveItems";
const String recentViewItemCollection = "recentView";

const redColor = Color.fromARGB(255, 236, 0, 0);
const defaultColor = Color(0xFF34568B);
const englishFontFamily = 'Roboto';
const khmerFontFamily = 'KhmerOSBattambang';

const String dummyNetworkImage =
    "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/flutter%2F2021-10-31%2021%3A58%3A15.282499?alt=media&token=f492b829-e106-467e-b3f1-6c05122a0969";
const String networkBackgroundImage =
    "https://firebasestorage.googleapis.com/v0/b/project-shotgun.appspot.com/o/IMG_2086-EFFECTS.jpg?alt=media&token=fcd87303-09e6-4ec7-9620-211f240fc85f";
const String dummyAlbumImage =
    "https://firebasestorage.googleapis.com/v0/b/sdabjomreang-961c4.appspot.com/o/artwork%2F2022-04-13%2016%3A13%3A12.982127%20-%20Dawn%20FM?alt=media&token=f66d545a-7358-417b-9dff-ef04cd6560b9";
const String dummySongNetwork =
    "https://firebasestorage.googleapis.com/v0/b/sdabjomreang-961c4.appspot.com/o/music%2F2022-04-13%2016%3A13%3A06.375591%20-%20Out%20of%20Time?alt=media&token=9c1f43aa-c769-47f1-9cba-e21e10f8c1bc";

final dummyUser = User(
  profileImage: dummyNetworkImage,
  name: "Jake",
  username: "sullyJake",
);

final dummySong = SongModel(
  name: "Out of time",
  coverImageUrl: dummyAlbumImage,
  songname: "Out of time Song",
  trackid: dummySongNetwork,
);
final dummySongList = [
  dummySong,
  dummySong,
  dummySong,
  dummySong,
  dummySong,
  dummySong,
  dummySong,
  dummySong,
  dummySong,
];

final List<User> dummyUserList = [
  dummyUser,
  dummyUser,
  dummyUser,
  dummyUser,
  dummyUser,
  dummyUser,
];

Widget commonHeightSpacing({double? height}) {
  return SizedBox(height: height ?? 8);
}

Widget commonWidthSpacing({double? width}) {
  return SizedBox(width: width ?? 8);
}

String? validatePhoneNumber(String? value) {
  String pattern = r'^(?:[+0][1-9])?[0-9]{9,10}$';
  RegExp regExp = RegExp(pattern);

  if (value == null || value.isEmpty) {
    return 'emptyField';
  } else if (!regExp.hasMatch("0" + value)) {
    return 'invalidPhoneNumber';
  }
  return null;
}

String getFont() {
  // if (Get.locale == const Locale('en', 'US')) {
  //   return englishFontFamily;
  // } else {
  //   return khmerFontFamily;
  // }
  return "";
}

String calDate(DateTime itemDate) {
//Convert to second
  double date = (DateTime.now().second - itemDate.second).toDouble();
  String timeEnd = "second";
  if (date > 0) {
    if (date >= 60) {
      date = date / 60;
      timeEnd = "minutes";
      if (date >= 60) {
        date = date / 60;
        timeEnd = "hours";
        if (date >= 24) {
          date = date / 24;
          timeEnd = "day";
          if (date > 7) {
            date = date / 7;
            timeEnd = "week";
            if (date > 4) {
              date = date / 4;
              timeEnd = "month";
// if(date>12){
//   date = date/12.roundToDouble();
//   timeEnd = " year(s)";
// }
            }
          }
        }
      }
    }
  }
  return "${date.toInt()} $timeEnd";
}

final priceNumberFormat = NumberFormat("###,###.0#");

String formatPrice(double price) {
  return priceNumberFormat.format(price.toInt());
}

String formatLocaleNumber(String number) {
  // if (Get.locale == const Locale('en', 'US')) {
  //   return number;
  // }
  // return KhmerDate.khmerNumber(number);
  return "";
}

final time = DateFormat('mm:ss');
String formatDateTimeFromInt(int? millisecond) {
  if (millisecond == null) {
    return "";
  }

  final asDateTime = DateTime.fromMillisecondsSinceEpoch(millisecond);
  final timeAsString = time.format(asDateTime);
  return timeAsString;
}

String formatDate(int millisecond) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(millisecond);
  final chatDateFormat = DateFormat('E MM, hh:mm', getLanguageCode());
  return chatDateFormat.format(dateTime);
}

String getLanguageCode() {
  if (Get.locale == const Locale('en', 'US')) {
    return "en";
  } else {
    return 'km';
  }
}

ThemeMode determineThemeMode(String? selectedMode) {
  if (selectedMode == "Light") {
    return ThemeMode.light;
  } else if (selectedMode == "Dark") {
    return ThemeMode.dark;
  } else {
    return ThemeMode.system;
  }
}

void requestFocus(BuildContext context) {
  return FocusScope.of(context).requestFocus(FocusNode());
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 18,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}

void showSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
  );
}
