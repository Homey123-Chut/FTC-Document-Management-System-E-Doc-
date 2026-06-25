import 'dart:async';

enum DownloadStatus { idle, downloading, completed, error }

class DownloadProgress {
  final String fileName;
  final double progress; 
  final DownloadStatus status;
  final String? localPath;
  final String? errorMessage;

  const DownloadProgress({
    required this.fileName,
    this.progress = 0.0,
    this.status = DownloadStatus.idle,
    this.localPath,
    this.errorMessage,
  });

  DownloadProgress copyWith({
    String? fileName,
    double? progress,
    DownloadStatus? status,
    String? localPath,
    String? errorMessage,
  }) {
    return DownloadProgress(
      fileName: fileName ?? this.fileName,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      localPath: localPath ?? this.localPath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DownloadService {
  final StreamController<DownloadProgress> _controller =
      StreamController<DownloadProgress>.broadcast();

  Stream<DownloadProgress> get progressStream => _controller.stream;

  Future<DownloadProgress> downloadFile(String fileName, {String? url}) async {
    _controller.add(DownloadProgress(
      fileName: fileName,
      status: DownloadStatus.downloading,
      progress: 0.0,
    ));

    try {
      final localPath = await _simulateDownload(fileName);
      final completed = DownloadProgress(
        fileName: fileName,
        status: DownloadStatus.completed,
        progress: 1.0,
        localPath: localPath,
      );
      _controller.add(completed);
      return completed;
    } catch (e) {
      final error = DownloadProgress(
        fileName: fileName,
        status: DownloadStatus.error,
        errorMessage: e.toString(),
      );
      _controller.add(error);
      return error;
    }
  }

  Future<String> _simulateDownload(String fileName) async {
    const int totalSteps = 10;
    const Duration stepDelay = Duration(milliseconds: 300);

    for (int i = 1; i <= totalSteps; i++) {
      await Future.delayed(stepDelay);
      _controller.add(DownloadProgress(
        fileName: fileName,
        status: DownloadStatus.downloading,
        progress: i / totalSteps,
      ));
    }

    return '/storage/emulated/0/Download/$fileName';
  }

  void dispose() {
    _controller.close();
  }
}
