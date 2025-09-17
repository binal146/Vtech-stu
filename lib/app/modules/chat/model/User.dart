import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/base/BaseModel.dart';


class User extends BaseModel {
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? gender = "male";
  String? address = "";
  String? avg_rating = "0.0";
  String? dob;
  String? description;
  dynamic countryCode;
  String? mobileNumber;
  dynamic otp;
  RxBool is_select_for_community = RxBool(false);
  int? otp_verified;
  int? email_verified;
  String? state_id;
  String? discount;
  String? is_discount;
  String? state_name;
  String? country_name;
  int? pet_added;
  String? open_time;
  String? close_time;
  int? is_following = 0;
  int? is_block;
  int? follower_count;
  int? following_count;
  int? post_count;
  int? profile_updated;
  int? block_user_count;
  int? like_count;
  String? otpDate;
  String? createdAt;
  String? createdRequestDate;
  dynamic userId;
  String? fullProfileImagePath;
  String? profile_image_original_url;
  int? is_professional;
  int? user_account;
  int? is_notification;

  int is_verified = 0;
  RxInt is_mute_user = RxInt(0);
  int? user_request;
  int? is_subscribed;
  int? is_booking;
  int? booking_id;

  User? user;
  User? follower;
  String? token;
  User? data;
  List<User>? dataList;
  String? social_id;

  User(
      {this.username,
      this.firstName,
      this.lastName,
      this.countryCode,
      this.mobileNumber,
      this.otp,
      this.otpDate,
      this.createdAt,
      this.createdRequestDate,
      this.userId,
      this.fullProfileImagePath,
      this.is_professional,
      this.user_account,
      this.is_notification,
      this.user_request,
      this.user,
      this.token,
      this.data,
      this.otp_verified,
      this.email_verified,
      this.pet_added,
      this.is_following,
      this.is_block,
      this.follower_count,
      this.following_count,
      this.post_count,
      this.profile_updated,
      this.dob,
      this.description,
      this.email,
      this.gender,
      this.is_subscribed,
      this.is_booking,
      this.booking_id,
      this.social_id});

  int checkNotificationMuted(
      String? muteDateTime, String? currentTime, int isMuteUser) {
    DateTime convertStringToMuteDateTime =
        stringToDateTime(muteDateTime.toString(), 'yyyy-MM-dd HH:mm:ss');
    late DateTime? currentDate;
    if (currentTime != null) {
      currentDate =
          stringToDateTime(currentTime.toString(), 'yyyy-MM-dd HH:mm:ss');
    } else {
      currentDate = DateTime.now();
    }

    int differenceInDays =
        currentDate.difference(convertStringToMuteDateTime).inDays;
    print('get difference In Days is : $differenceInDays');
    print('is_mute_user.value : $isMuteUser');

    if (isMuteUser == 0) {
      return 1;
    } else if (isMuteUser == 1 && differenceInDays < 7) {
      return 0;
    } else if (isMuteUser == 2 && differenceInDays < 30) {
      return 0;
    }
    return 1;
  }

  DateTime stringToDateTime(String dateString, String format) {
    try {
      final dateTime = DateFormat(format).parseUtc(dateString);
      return dateTime.toUtc();
    } catch (e) {
      return DateTime.now().toUtc();
    }
  }

  User.fromJson(Map<String, dynamic> json) {
    response_msg = json['response_msg'];
    success = json['success'];
    username = json['username'];

    if (json['first_name'] != null && json['first_name'] != 'null') {
      firstName = json['first_name'];
    } else {
      firstName = '';
    }

    if (json['last_name'] != null && json['last_name'] != 'null') {
      lastName = json['last_name'];
    } else {
      lastName = '';
    }

    email = json['email'];
    dob = json['dob'];
    description = json['description'];
    gender = json['gender'];
    countryCode = json['country_code'].toString();
    mobileNumber = json['mobile_number'];
    otp = json['otp'].toString();
    otp_verified = json['otp_verified'];

    email_verified = json['email_verified'];
    state_id = json['state_id'].toString();
    state_name = json['state_name'].toString();
    discount = json['discount'].toString();
    country_name = json['country_name'].toString();
    pet_added = json['pet_added'];
    open_time = json['open_time'];
    close_time = json['close_time'];

    is_following = json['is_following'];
    is_block = json['is_block'];
    follower_count = json['follower_count'];
    following_count = json['following_count'];
    post_count = json['post_count'];
    profile_updated = json['profile_updated'];
    block_user_count = json['block_user_count'];
    like_count = json['like_count'];
    otpDate = json['otp_date'];
    createdAt = json['created_at'];
    createdRequestDate = json['created_date'];

    is_subscribed = json['is_subscribed'];
    is_booking = json['is_booking'];
    booking_id = json['booking_id'];

    userId = json['user_id'].toString();
    fullProfileImagePath = json['full_profile_image_path'];
    if (json.containsKey('profile_image_original_url')) {
      profile_image_original_url = json['profile_image_original_url'];
    }

    address = json['address'];
    if (json.containsKey('user')) {
      user = json['user'] != null ? User.fromJson(json['user']) : null;
    }

    is_professional = json['is_professional'];

    if (json.containsKey('avg_rating') &&
        json['avg_rating'] != null &&
        json['avg_rating'] != 'null') {
      avg_rating = json['avg_rating'];
    }

    user_account = json['user_account'];
    is_notification = json['is_notification'];
    if (json.containsKey('is_verified')) {
      is_verified = json['is_verified'];
    }

    if (json.containsKey('is_discount')) {
      is_discount = json['is_discount'].toString();
    }
    if (json.containsKey("is_mute_user")) {
      is_mute_user.value = json['is_mute_user'];
    }
    user_request = json['user_request'];
    if (json.containsKey('following')) {
      follower =
          json['following'] != null ? User.fromJson(json['following']) : null;
    }
    if (json.containsKey('follower')) {
      follower =
          json['follower'] != null ? User.fromJson(json['follower']) : null;
    }

    token = json['token'];
    if (json.containsKey('data') && json['data'] is List<dynamic>) {
      if (json['data'] != null) {
        dataList = <User>[];
        json['data'].forEach((v) {
          dataList!.add(User.fromJson(v));
        });
      }
    } else {
      data = json['data'] != null ? User.fromJson(json['data']) : null;
    }


    if (json.containsKey('pet_memorial') &&
        json['pet_memorial'] is List<dynamic>) {
    }



    Map<String, dynamic> temp = <String, dynamic>{};
    temp['certification_image_path'] = "";
    temp['pid_image_path'] = "";

    if (json['social_id'] != "" && json['social_id'] != null) {
      social_id = json['social_id'];
    } else {
      social_id = '';
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['dob'] = dob;
    data['description'] = description;
    data['gender'] = gender;
    data['country_code'] = countryCode.toString();
    data['mobile_number'] = mobileNumber;
    data['otp'] = otp;
    data['otp_date'] = otpDate;
    data['created_at'] = createdAt;
    data['pet_added'] = pet_added;
    data['close_time'] = close_time;
    data['open_time'] = open_time;
    data['is_following'] = is_following;
    data['is_block'] = is_block;
    data['follower_count'] = follower_count;
    data['post_count'] = post_count;
    data['state_id'] = state_id;
    data['discount'] = discount;
    data['is_discount'] = is_discount;

    data['state_name'] = state_name;
    data['country_name'] = country_name;
    data['following_count'] = following_count;
    data['otp_verified'] = otp_verified;
    data['email_verified'] = email_verified;
    data['profile_updated'] = profile_updated;
    data['block_user_count'] = block_user_count;
    data['user_account'] = user_account;
    data['is_notification'] = is_notification;
    data['is_verified'] = is_verified;
    data['avg_rating'] = avg_rating;
    data['user_request'] = user_request;
    data['is_subscribed'] = is_subscribed;
    data['is_booking'] = is_booking;
    data['booking_id'] = booking_id;
    data['user_id'] = userId;
    data['social_id'] = social_id;

    data['full_profile_image_path'] = fullProfileImagePath;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['is_professional'] = is_professional;
    if (follower != null) {
      data['follower'] = follower!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (dataList != null) {
      data['data'] = dataList!.map((v) => v.toJson()).toList();
    }
    data['token'] = token;
    data['response_msg'] = response_msg;
    data['success'] = success;
    return data;
  }

  String getFullName() {
    if ((firstName == null || (firstName ?? "").isEmpty) &&
        (lastName == null || (lastName ?? "").isEmpty)) {
      return username ?? '';
    }

    String fullName = '';
    if (firstName != null) {
      fullName += firstName!;
    }
    if (lastName != null) {
      if (fullName.isNotEmpty) {
        fullName += ' ';
      }
      fullName += lastName!;
    }
    return fullName;
  }

  String getFullMobile() {
    if (countryCode != null && mobileNumber != null) {
      return countryCode + " " + mobileNumber;
    }
    return "";
  }

  String getDobFormetted() {
    try {
      DateTime format = DateFormat('yyyy-MM-dd').parse(dob.toString());
      return DateFormat('dd MMM yyyy').format(format);
    } catch (e) {
      return "";
    }
  }

  String getStateName() {
    dynamic Fulladdress = "";
    if (is_professional == 1 && address != null) {
      Fulladdress = address ?? "";
    }
    if (state_name != null && state_name != 'null') {
      if (Fulladdress.toString().isNotEmpty) {
        Fulladdress = Fulladdress + ', ' + state_name ?? "";
      } else {
        Fulladdress = state_name ?? "";
      }
    }
    if (country_name != null && country_name != 'null') {
      if (Fulladdress.toString().isNotEmpty) {
        Fulladdress = Fulladdress + ', ' + country_name ?? "";
      } else {
        Fulladdress = country_name ?? "";
      }
    }

    return Fulladdress.toString();
  }

  String getOnlyStateName() {
    dynamic Fulladdress = "";

    if (state_name != null && state_name != 'null') {
      Fulladdress = state_name ?? "";
    }

    return Fulladdress.toString();
  }

  String getOpenCloseTime() {
    // if (open_time != null && close_time != null) {
    //   String openTime = DateFormat('hh:mm a')
    //       .format(DateFormat('HH:mm:ss').parse(open_time ?? ""));
    //   String closeTime = DateFormat('hh:mm a')
    //       .format(DateFormat('HH:mm:ss').parse(close_time ?? ""));

    //   return '$openTime-$closeTime';
    // }
    if (open_time != null && close_time != null) {
      var time = DateFormat('HH:mm:ss').parseUtc(open_time ?? "").toLocal();
      String formattedOpenTime = DateFormat('hh:mm a').format(time);

      var end = DateFormat('HH:mm:ss').parseUtc(close_time ?? "").toLocal();
      String formattedCloseTime = DateFormat('hh:mm a').format(end);

      // DateTime openUtcDateTime =
      //     DateFormat('HH:mm:ss').parse(open_time ?? "", true).toUtc();

      // DateTime openLocalDateTime = openUtcDateTime.toLocal();

      // String formattedOpenTime =
      //     DateFormat('hh:mm a').format(openLocalDateTime);

      // DateTime closeUtcDateTime =
      //     DateFormat('HH:mm:ss').parse(close_time ?? "", true).toUtc();

      // DateTime closeLocalDateTime = closeUtcDateTime.toLocal();

      // String formattedCloseTime =
      //     DateFormat('hh:mm a').format(closeLocalDateTime);

      return '$formattedOpenTime-$formattedCloseTime';
    }

    return "";
  }
}

class Notifications {
  final String group;
  final List<NotificationData> notificationData;

  Notifications({
    required this.group,
    required this.notificationData,
  });
}

class NotificationData {
  final String name;
  final String comment;
  final String date;

  NotificationData({
    required this.name,
    required this.comment,
    required this.date,
  });
}
