import 'package:injectable/injectable.dart';
import '../entities/scan_result_entity.dart';
import '../repositories/scan_repository.dart';

@injectable
class GetUserScansUseCase {
  final ScanRepository _repository;

  GetUserScansUseCase(this._repository);

  Future<List<ScanResultEntity>> execute(String userId) {
    return _repository.getUserScans(userId);
  }
}
