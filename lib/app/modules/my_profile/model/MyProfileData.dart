import 'package:vteach_teacher/app/modules/my_profile/model/Document.dart';
import 'package:vteach_teacher/app/modules/my_profile/model/Interest.dart';
import 'package:vteach_teacher/app/modules/my_profile/model/KnownLanguages.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';

import '../../signup_1/model/SubjectData.dart';
import 'GradeSubject.dart';

class MyProfileData {
  int? userId;
  String? profileImage;
  String? fullName;
  String? countryCode;
  String? mobileNumber;
  String? email;
  String? experience;
  String? education;
  String? description;
  String? avgRating;
  String? totalRating;
  String? country_id;
  String? state_id;
  String? city_id;
  String? rate;
  String? commission_rate;
  String? country_name;
  String? state_name;
  String? city_name;
  List<GradesData>? grade;
  List<GradeSubject>? gradeSubject;
  List<SubjectData>? subject;
  String? chargeHour;
  List<Document>? document;
  List<Interest>? interests;
  List<KnownLanguages>? knownLanguages;

  MyProfileData(
      {this.userId,
      this.profileImage,
      this.fullName,
      this.countryCode,
      this.mobileNumber,
      this.email,
      this.experience,
      this.education,
      this.description,
      this.knownLanguages,
      this.interests,
      this.avgRating,
      this.totalRating,
      this.country_id,
      this.state_id,
      this.city_id,
      this.rate,
      this.commission_rate,
      this.country_name,
      this.state_name,
      this.city_name,
      this.grade,
      this.gradeSubject,
        this.subject,
      this.chargeHour,
      this.document});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    profileImage = json['profile_image'];
    fullName = json['full_name'];
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    experience = json['experience'];
    education = json['education'];
    description = json['description'];
    avgRating = json['avg_rating'];
    totalRating = json['total_rating_count'];
    country_id = json['country_id'];
    state_id = json['state_id'];
    city_id = json['city_id'];
    rate = json['rate'];
    commission_rate = json['commission_rate'];
    country_name = json['country_name'];
    state_name = json['state_name'];
    city_name = json['city_name'];
    if (json['grade'] != null) {
      grade = <GradesData>[];
      json['grade'].forEach((v) {
        grade!.add(new GradesData.fromJson(v));
      });
    }
    if (json['grade_subject'] != null) {
      gradeSubject = <GradeSubject>[];
      json['grade_subject'].forEach((v) {
        gradeSubject!.add(new GradeSubject.fromJson(v));
      });
    }
    if (json['subject'] != null) {
      subject = <SubjectData>[];
      json['subject'].forEach((v) {
        subject!.add(new SubjectData.fromJson(v));
      });
    }
    chargeHour = json['charge_hour'];
    if (json['document'] != null) {
      document = <Document>[];
      json['document'].forEach((v) {
        document!.add(new Document.fromJson(v));
      });
    }

    if (json['interests'] != null) {
      interests = <Interest>[];
      json['interests'].forEach((v) {
        interests!.add(new Interest.fromJson(v));
      });
    }

    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguages>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(new KnownLanguages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['profile_image'] = this.profileImage;
    data['full_name'] = this.fullName;
    data['country_code'] = this.countryCode;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['experience'] = this.experience;
    data['education'] = this.education;
    data['description'] = this.description;
    data['avg_rating'] = this.avgRating;
    data['total_rating'] = this.totalRating;
    data['country_id'] = this.country_id;
    data['state_id'] = this.state_id;
    data['city_id'] = this.city_id;
    data['rate'] = this.rate;
    data['commission_rate'] = this.commission_rate;
    data['country_name'] = this.country_name;
    data['state_name'] = this.state_name;
    data['city_name'] = this.city_name;
    if (this.grade != null) {
      data['grade'] = this.grade!.map((v) => v.toJson()).toList();
    }
    if (this.gradeSubject != null) {
      data['grade_subject'] = this.gradeSubject!.map((v) => v.toJson()).toList();
    }
    if (this.subject != null) {
      data['subject'] = this.subject!.map((v) => v.toJson()).toList();
    }
    data['charge_hour'] = this.chargeHour;
    if (this.document != null) {
      data['document'] = this.document!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}