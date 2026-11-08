/// Coordinates App-owned users of FlutterBluePlus' process-wide scanner:
/// passive Auto Connect rediscovery, one-shot Auto Connect/OTA discovery, and the
/// manually opened Connection sheet.
///
/// This deliberately does not own BLE connection/session state or protocol behavior.
class ConnectionScanCoordinator {
  int _generation = 0;
  int? _activePassiveAttempt;
  int? _activeOneShotAttempt;
  bool _manualSheetOpen = false;
  bool _manualDeviceSelected = false;
  bool _connectionHandoffActive = false;
  Future<void> _operationQueue = Future<void>.value();

  bool get isManualSheetOpen => _manualSheetOpen;
  bool get manualDeviceSelected => _manualSheetOpen && _manualDeviceSelected;
  bool get isConnectionHandoffActive => _connectionHandoffActive;
  bool get hasActivePassiveAttempt => _activePassiveAttempt == _generation;
  bool get hasActiveOneShotAttempt => _activeOneShotAttempt == _generation;

  void beginConnectionHandoff() {
    _connectionHandoffActive = true;
    invalidatePassiveAttempts();
  }

  void completeConnectionHandoff() {
    _connectionHandoffActive = false;
    invalidatePassiveAttempts();
  }

  int? beginPassiveAttempt() {
    if (_manualSheetOpen ||
        _connectionHandoffActive ||
        _activePassiveAttempt == _generation ||
        _activeOneShotAttempt == _generation) {
      return null;
    }
    final token = _generation;
    _activePassiveAttempt = token;
    return token;
  }

  bool isPassiveAttemptCurrent(int token) =>
      !_manualSheetOpen &&
      !_connectionHandoffActive &&
      token == _generation &&
      _activePassiveAttempt == token;

  void finishPassiveAttempt(int token) {
    if (_activePassiveAttempt == token) {
      _activePassiveAttempt = null;
    }
  }

  int? beginOneShotAttempt() {
    if (_manualSheetOpen ||
        _connectionHandoffActive ||
        _activePassiveAttempt == _generation ||
        _activeOneShotAttempt == _generation) {
      return null;
    }
    final token = _generation;
    _activeOneShotAttempt = token;
    return token;
  }

  bool isOneShotAttemptCurrent(int token) =>
      !_manualSheetOpen &&
      !_connectionHandoffActive &&
      token == _generation &&
      _activeOneShotAttempt == token;

  void finishOneShotAttempt(int token) {
    if (_activeOneShotAttempt == token) {
      _activeOneShotAttempt = null;
    }
  }

  void invalidatePassiveAttempts() {
    _generation++;
  }

  bool openManualSheet() {
    if (_manualSheetOpen || _connectionHandoffActive) return false;
    _manualSheetOpen = true;
    _manualDeviceSelected = false;
    invalidatePassiveAttempts();
    return true;
  }

  void markManualDeviceSelected() {
    if (_manualSheetOpen) {
      _manualDeviceSelected = true;
      beginConnectionHandoff();
    }
  }

  bool closeManualSheet() {
    if (!_manualSheetOpen) return false;
    final shouldResumePassive = !_manualDeviceSelected;
    _manualSheetOpen = false;
    _manualDeviceSelected = false;
    invalidatePassiveAttempts();
    return shouldResumePassive;
  }

  Future<void> runSerialized(Future<void> Function() operation) {
    final result = _operationQueue.then((_) => operation());
    _operationQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
    return result;
  }
}
