import '../model/db.dart';

class ActivityStore {
  final Map<String, Map<String, int>> _activities = {};
  List<Manifest> _activitiesManifest = [];
  Map<String, int> _activitiesCache = {};
  String _selectedDate = dateKey(DateTime.now());

  static String padDate(int d) => d.toString().padLeft(2, '0');

  static String dateKey(DateTime date) => '${date.year}-${padDate(date.month)}-${padDate(date.day)}';

  Map<String, int> get activities => _activities[_selectedDate]!;

  List<Manifest> get manifest => _activitiesManifest;

  Map<String, int> get cache => _activitiesCache;

  void addManifest(List<Manifest> manifest) => _activitiesManifest = manifest;

  void addActivity(String dateString, String activityName, int minutes) {
    if (!_activities.containsKey(dateString)) {
      _activities[dateString] = {};
    }
    _activities[dateString]![activityName] = minutes;
  }

  Map<String, int>? getActivitiesForDate(String dateString) {
    _selectedDate = dateString;
    if (_activities.containsKey(dateString)) {
      return _activities[dateString]!;
    }
    return null;
  }

  int updateActivityMinutes(String dateString, String activityName, int minutes) {
    if (
      _activities.containsKey(dateString) && 
      _activities[dateString]!.containsKey(activityName)
    ) {
      _activities[dateString]![activityName] = minutes;
      return minutes;
    }
    return 0;
  }

  void resetCache() => _activitiesCache = Map.from(activities);

  void updateCache(String activityName, int activityMinutes) {
    _activitiesCache[activityName] = activityMinutes;
  }

  void saveCache() {
    _activities[_selectedDate] = Map.from(_activitiesCache);
  }
}
