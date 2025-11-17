import 'dart:io';
import 'package:injectable/injectable.dart';
import '../repositories/profile_repository.dart';

/// Upload profile picture use case
/// Single responsibility: Upload user profile picture
@injectable
class UploadProfilePictureUseCase {
  final ProfileRepository _repository;

  UploadProfilePictureUseCase(this._repository);

  /// Execute upload profile picture
  /// Returns URL of uploaded image
  Future<String> execute({
    required String userId,
    required File imageFile,
  }) {
    return _repository.uploadProfilePicture(
      userId: userId,
      imageFile: imageFile,
    );
  }
}
