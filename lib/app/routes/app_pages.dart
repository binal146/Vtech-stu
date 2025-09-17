import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/add_document/add_document_binding.dart';
import 'package:vteach_teacher/app/modules/add_document/add_document_view.dart';
import 'package:vteach_teacher/app/modules/agora_demo/agora_demo_binding.dart';
import 'package:vteach_teacher/app/modules/agora_demo/agora_demo_view.dart';
import 'package:vteach_teacher/app/modules/agora_new/agora_demo_new_view.dart';
import 'package:vteach_teacher/app/modules/appoint_success/appoint_success_view.dart';
import 'package:vteach_teacher/app/modules/appointment/appointment_binding.dart';
import 'package:vteach_teacher/app/modules/appointment/appointment_view.dart';
import 'package:vteach_teacher/app/modules/appointment_detail/appointment_detail_binding.dart';
import 'package:vteach_teacher/app/modules/appointment_detail/appointment_detail_view.dart';
import 'package:vteach_teacher/app/modules/bottom__navigation_bar/BottomNavView.dart';
import 'package:vteach_teacher/app/modules/bottom__navigation_bar/bottom_nav_binding.dart';
import 'package:vteach_teacher/app/modules/call_details/call_detail_binding.dart';
import 'package:vteach_teacher/app/modules/call_details/call_detail_view.dart';
import 'package:vteach_teacher/app/modules/call_screen/call_binding.dart';
import 'package:vteach_teacher/app/modules/call_screen/call_view.dart';
import 'package:vteach_teacher/app/modules/change_password/change_password_binding.dart';
import 'package:vteach_teacher/app/modules/change_password/change_password_view.dart';
import 'package:vteach_teacher/app/modules/chat/chat_binding.dart';
import 'package:vteach_teacher/app/modules/chat/chat_view.dart';
import 'package:vteach_teacher/app/modules/confirm_appointment/confirm_appointment_binding.dart';
import 'package:vteach_teacher/app/modules/confirm_appointment/confirm_appointment_view.dart';
import 'package:vteach_teacher/app/modules/contact_us/contact_us_binding.dart';
import 'package:vteach_teacher/app/modules/edit_profile/edit_profile_binding.dart';
import 'package:vteach_teacher/app/modules/edit_profile/edit_profile_view.dart';
import 'package:vteach_teacher/app/modules/forgot_password/forgotpassword_binding.dart';
import 'package:vteach_teacher/app/modules/history/history_binding.dart';
import 'package:vteach_teacher/app/modules/history/history_view.dart';
import 'package:vteach_teacher/app/modules/home/home_binding.dart';
import 'package:vteach_teacher/app/modules/home/home_view.dart';
import 'package:vteach_teacher/app/modules/login/login_binding.dart';
import 'package:vteach_teacher/app/modules/login/login_view.dart';
import 'package:vteach_teacher/app/modules/more/more_binding.dart';
import 'package:vteach_teacher/app/modules/more/more_view.dart';
import 'package:vteach_teacher/app/modules/my_profile/my_profile_binding.dart';
import 'package:vteach_teacher/app/modules/my_profile/my_profile_view.dart';
import 'package:vteach_teacher/app/modules/notification/notification_binding.dart';
import 'package:vteach_teacher/app/modules/notification/notification_view.dart';
import 'package:vteach_teacher/app/modules/past_appointment/past_appointment_binding.dart';
import 'package:vteach_teacher/app/modules/past_appointment/past_appoitment_view.dart';
import 'package:vteach_teacher/app/modules/rate_review/rate_review_binding.dart';
import 'package:vteach_teacher/app/modules/rate_review/rate_review_view.dart';
import 'package:vteach_teacher/app/modules/request_appointment_detail/request_appointment_detail_binding.dart';
import 'package:vteach_teacher/app/modules/request_appointment_detail/request_appointment_detail_view.dart';
import 'package:vteach_teacher/app/modules/review_list/review_binding.dart';
import 'package:vteach_teacher/app/modules/review_list/review_view.dart';
import 'package:vteach_teacher/app/modules/signup_1/signup1_binding.dart';
import 'package:vteach_teacher/app/modules/signup_1/signup1_view.dart';
import 'package:vteach_teacher/app/modules/teacher_detail/teacher_detail_binding.dart';
import 'package:vteach_teacher/app/modules/teacher_detail/teacher_detail_view.dart';
import 'package:vteach_teacher/app/modules/teacher_list/teacher_binding.dart';
import 'package:vteach_teacher/app/modules/teacher_list/teacher_view.dart';
import 'package:vteach_teacher/app/modules/upcoming_appointment/upcoming_appointment_binding.dart';
import 'package:vteach_teacher/app/modules/upcoming_appointment/upcoming_appoitment_view.dart';
import 'package:vteach_teacher/app/modules/view_image/viewimage_binding.dart';
import 'package:vteach_teacher/app/modules/view_image/viewimage_view.dart';
import 'package:vteach_teacher/app/modules/view_pdf/viewpdf_binding.dart';
import 'package:vteach_teacher/app/modules/view_pdf/viewpdf_view.dart';
import '../modules/agora_new/agora_demo__new_binding.dart';
import '../modules/appoint_success/appoint_success_binding.dart';
import '../modules/availability/availability_binding.dart';
import '../modules/availability/availability_view.dart';
import '../modules/contact_us/contact_us_view.dart';
import '../modules/forgot_password/forgotpassword_view.dart';
import '../modules/signup_2/signup2_binding.dart';
import '../modules/signup_2/signup2_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/webview/webview_binding.dart';
import '../modules/webview/webview_view.dart';

part 'app_routes.dart';

class AppPages {

  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [

    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),

    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: _Paths.SIGN_UP_1,
      page: () => Signup1View(),
      binding: SignUp1Binding(),
    ),

    GetPage(
      name: _Paths.SIGN_UP_2,
      page: () => Signup2View(),
      binding: SignUp2Binding(),
    ),

    GetPage(
      name: _Paths.BOTTOM_NAV_BAR,
      page: () => BottomNavView(),
      binding: BottomNavBinding(),
    ),

    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: _Paths.APPOINMENT,
      page: () => AppointMentView(),
      binding: AppointmentBinding(),
    ),

    GetPage(
      name: _Paths.SIGNIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: _Paths.TEACHER_LIST,
      page: () => TeacherView(),
      binding: TeacherBinding(),
    ),

    GetPage(
      name: _Paths.TEACHER_DETAIL,
      page: () => TeacherDetailView(),
      binding: TeacherDetailBinding(),
    ),

    GetPage(
      name: _Paths.AVAILABILITY,
      page: () => AvailabilityView(),
      binding: AvailabilityBinding(),
    ),

    GetPage(
      name: _Paths.CONFIRM_APPOINTMENT,
      page: () => ConfirmAppointmentView(),
      binding: ConfirmAppointmentBinding(),
    ),

    GetPage(
      name: _Paths.APPOINT_SUCCESS,
      page: () => AppointSuccessView(),
      binding: AppointSuccessBinding(),
    ),

    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),

    GetPage(
      name: _Paths.UPCOMING_APPOINTMENT,
      page: () => UpcomingAppointmentView(),
      binding: UpcomingAppointmentBinding(),
    ),

    GetPage(
      name: _Paths.MORE,
      page: () => MoreView(),
      binding: MoreBinding(),
    ),

    GetPage(
      name: _Paths.CONTACT_US,
      page: () => ContactUsView(),
      binding: ContactUsBinding(),
    ),

    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),

    GetPage(
      name: _Paths.PAST_APPOINTMENT,
      page: () => PastAppointmentView(),
      binding: PastAppointmentBinding(),
    ),

    GetPage(
      name: _Paths.APPOINTMENT_DETAIL,
      page: () => AppointmentDetailView(),
      binding: AppointmentDetailBinding(),
    ),

    GetPage(
      name: _Paths.RATE_REVIEW,
      page: () => RateReviewView(),
      binding: RateReviewBinding(),
    ),

    GetPage(
      name: _Paths.APPOINTMENT,
      page: () => AppointMentView(),
      binding: AppointmentBinding(),

    ),

    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),

    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => MyProfileView(),
      binding: MyProfileBinding(),
    ),

    GetPage(
      name: _Paths.ADD_DOCUMENT,
      page: () => AddDocumentView(),
      binding: AddDocumentBinding(),
    ),

    GetPage(
      name: _Paths.AGORA_DEMO,
      page: () => AgoraDemoView(),
      binding: AgoraDemoBinding(),
    ),

    GetPage(
      name: _Paths.WEB_VIEW,
      page: () => WebView(),
      binding: WebViewBinding(),
    ),

    GetPage(
      name: _Paths.VIEW_PDF,
      page: () => ViewPdfView(),
      binding: ViewPdfBinding(),
    ),

    GetPage(
      name: _Paths.REQUEST_APPOINTMENT_DETAIL,
      page: () => RequestAppointmentDetailView(),
      binding: RequestAppointmentDetailBinding(),
    ),

    GetPage(
      name: _Paths.CALL_DETAIL,
      page: () => CallDetailView(),
      binding: CallDetailBinding(),
    ),

    GetPage(
      name: _Paths.CALL,
      page: () => CallView(),
      binding: CallBinding(),
    ),

    GetPage(
      name: _Paths.AGORA_DEMO_NEW,
      page: () => AgoraDemoNewView(),
      binding: AgoraDemoNewBinding(),
    ),

    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),

    GetPage(
      name: _Paths.REVIEW,
      page: () => ReviewView(),
      binding: ReviewBinding(),
    ),

    GetPage(
      name: _Paths.VIEW_IMAGE,
      page: () => ViewImageView(),
      binding: ViewImageBinding(),
    ),

  ];
}
