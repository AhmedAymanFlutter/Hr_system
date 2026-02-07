import '../models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
  Future<AnnouncementModel> createAnnouncement(AnnouncementModel announcement);
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  // Mock Data
  final List<AnnouncementModel> _announcements = [
    AnnouncementModel(
      id: '1',
      title: 'Company Picnic',
      content: 'Join us for the annual company picnic this Saturday!',
      date: DateTime.now().subtract(const Duration(days: 2)),
      author: 'HR Department',
    ),
    AnnouncementModel(
      id: '2',
      title: 'New Health Insurance Policy',
      content:
          'We have updated our health insurance provider. Please review the new policy documents.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      author: 'Admin',
    ),
  ];

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _announcements;
  }

  @override
  Future<AnnouncementModel> createAnnouncement(
    AnnouncementModel announcement,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newAnnouncement = AnnouncementModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: announcement.title,
      content: announcement.content,
      date: announcement.date,
      author: announcement.author,
    );
    _announcements.insert(0, newAnnouncement);
    return newAnnouncement;
  }
}
