import '../model/db.dart';

class ActivityStore {
  final Map<String, Map<String, int>> _activities = {};
  List<Manifest> _activitiesManifest = [];
  Map<String, int> _activitiesCache = {};
  String _selectedDate = dateKey(DateTime.now());
  final Map<String, DateTime> _activitiesRecordingCache = {};

  static String padDate(int d) => d.toString().padLeft(2, '0');

  static String dateKey(DateTime date) => '${date.year}-${padDate(date.month)}-${padDate(date.day)}';

  Map<String, int> get activities => _activities[_selectedDate] ?? {};

  List<Manifest> get manifest => _activitiesManifest;

  Map<String, int> get cache => _activitiesCache;

  void addManifest(List<Manifest> manifest) => _activitiesManifest = manifest;

  void addActivityToManifest(Manifest activity) {
    _activitiesManifest.add(activity);
    _activitiesCache[activity.activityName] = 0;
    if (_activities.keys.isEmpty) {
      _activities[dateKey(DateTime.now())] = {};
    }
    for (String key in _activities.keys) {
      _activities[key]![activity.activityName] = 0;
    }
  }

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

  void startRecording(String activityName) {
    _activitiesRecordingCache[activityName] = DateTime.now();
  }

  int stopRecording(String activityName) {
    DateTime startTime = _activitiesRecordingCache[activityName]!;
    _activitiesRecordingCache.remove(activityName);
    return DateTime.now().difference(startTime).inMinutes;
  }

  bool nameIsDuplicate(String activityName) => activities.containsKey(activityName);
}
