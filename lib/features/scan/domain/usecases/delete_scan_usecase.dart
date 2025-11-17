import 'package:injectable/injectable.dart';
import '../repositories/scan_repository.dart';

@injectable
class DeleteScanUseCase {
  final ScanRepository _repository;

  DeleteScanUseCase(this._repository);

  Future<void> execute(String scanId) {
    return _repository.deleteScan(scanId);
  }
}
