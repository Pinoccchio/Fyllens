import 'dart:io';
import 'package:injectable/injectable.dart';
import '../entities/scan_result_entity.dart';
import '../repositories/scan_repository.dart';

@injectable
class PerformScanUseCase {
  final ScanRepository _repository;

  PerformScanUseCase(this._repository);

  Future<ScanResultEntity> execute({
    required File imageFile,
    required String plantId,
    required String plantName,
    required String userId,
  }) {
    return _repository.performScan(
      imageFile: imageFile,
      plantId: plantId,
      plantName: plantName,
      userId: userId,
    );
  }
}
