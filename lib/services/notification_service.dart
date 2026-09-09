import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  // 1. Đối tượng cầu nối giao tiếp với hệ điều hành
  // FlutterLocalNotificationsPlugin là class trung gian giao tiếp giữa app vs HDH
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // 2. Hàm khởi tạo hệ thống

  Future<void> init() async {
    // a. Cài đặt múi giờ của máy
    //  Đọc cơ sở dữ liệu múi giờ toàn cầu IANA (chứa dữ liệu hàng trăm thành phố trên thế giới) nạp vào bộ nhớ RAM.
    tz.initializeTimeZones();
    // Gửi lệnh xuống Android hỏi: "Thiết bị này đang ở múi giờ nào?"
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    // Gán múi giờ đó làm mặc định cho ứng dụng. Đảm bảo thời gian bạn lên lịch trùng khớp 100% với đồng hồ thực tế của người dùng.
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // b. Cài đặt icon mặc định cho thông báo
    // Quy chuẩn bắt buộc của Android: Mọi thông báo hiển thị trên Android bắt buộc phải có 1 biểu tượng đơn sắc (Monochrome Icon) để vẽ lên thanh trạng thái (Status Bar) phía trên cùng màn hình
    const androidSettings = AndroidInitializationSettings(
      // Đường dẫn trỏ tới file icon ứng dụng đã có sẵn trong thư mục Android Native (android/app/src/main/res/mipmap-...).
      '@mipmap/ic_launcher',
    );
    const initSetting = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSetting);

    // c. Xin quyền thông báo (Dành cho Android 13 trở lên)
    // Dòng code trên yêu cầu Android hiển thị một bảng thông báo hệ thống: "Cho phép MiniTask gửi thông báo?" ngay khi mở ứng dụng.
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // 3. Hàm lên lịch hẹn giờ phát thông báo
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Đổi thời gian sang định dạng múi giờ của thiết bị
    // Đóng gói đối tượng DateTime thông thường thành đối tượng thời gian có múi giờ cụ thể.
    final tzDate = tz.TZDateTime.from(scheduledTime, tz.local);

    // Kiểm tra: Nếu thời gian đã trôi qua thì không hẹn
    if (tzDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }
    // Cấu hình Kênh thông báo trên Android
    const androidDetails = AndroidNotificationDetails(
      'task_channel_id', // Mã định danh kênh
      'Task Reminders', // Tên kênh hiển thị trong Cài đặt
      channelDescription: 'The channel remind your task',
      // Mức quan trọng cao nhất của Android. Cho phép thông báo phát âm thanh to, rung mạnh và xuất hiện dưới dạng biểu ngữ (Heads-up Banner) trượt từ trên đỉnh màn hình xuống.
      importance: Importance.max,
      // Độ ưu tiên hiển thị cao trong danh sách thông báo.
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Gửi lệnh lên lịch cho Android AlarmManager
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // Rung chuông ngay cả khi điện thoại tắt màn hình
    );

    // 4. Hàm hủy thông báo
    Future<void> cancelNotification(int id) async {
      await _plugin.cancel(id);
    }
  }
}
