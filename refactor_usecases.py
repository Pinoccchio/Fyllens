import os
import re

# Use case files
use_case_files = [
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\authentication\domain\usecases\get_current_user_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\authentication\domain\usecases\reset_password_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\authentication\domain\usecases\sign_in_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\authentication\domain\usecases\sign_out_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\authentication\domain\usecases\sign_up_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\profile\domain\usecases\create_profile_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\profile\domain\usecases\get_user_profile_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\profile\domain\usecases\update_profile_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\profile\domain\usecases\upload_profile_picture_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\scan\domain\usecases\delete_scan_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\scan\domain\usecases\get_user_scans_usecase.dart",
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\scan\domain\usecases\perform_scan_usecase.dart",
]

# Map of repository type to its implementation path
repo_mapping = {
    "AuthRepository": "../../data/repositories/auth_repository_impl.dart",
    "ProfileRepository": "../../data/repositories/profile_repository_impl.dart",
    "ScanRepository": "../../data/repositories/scan_repository_impl.dart",
}

for file_path in use_case_files:
    if not os.path.exists(file_path):
        print(f"WARNING: File not found: {file_path}")
        continue

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove injectable import
    content = re.sub(r"import 'package:injectable/injectable.dart';\n", "", content)

    # Determine which repository is used
    repo_type = None
    repo_impl = None
    for repo, impl_path in repo_mapping.items():
        if f"../repositories/{repo.lower().replace('repository', '_repository')}.dart" in content:
            repo_type = repo
            repo_impl = impl_path
            break

    # Add import for repository implementation if needed
    if repo_type and repo_impl:
        if "import '../../data/repositories/" not in content:
            # Find repository import line
            repo_import_pattern = f"import '../repositories/{repo_type.lower().replace('repository', '_repository')}.dart';"
            if repo_import_pattern in content:
                content = content.replace(
                    repo_import_pattern,
                    f"{repo_import_pattern}\nimport '{repo_impl}' show {repo_type.replace('Repository', 'RepositoryImpl')};"
                )

    # Remove @injectable annotation
    content = re.sub(r"@injectable\n", "", content)

    # Find class name
    class_match = re.search(r"class (\w+UseCase)", content)
    if not class_match:
        print(f"WARNING: Could not find class in {file_path}")
        continue

    class_name = class_match.group(1)

    # Find repository field and constructor
    field_match = re.search(r"final (\w+Repository) _repository;", content)
    if not field_match:
        print(f"WARNING: Could not find repository field in {file_path}")
        continue

    repo_name = field_match.group(1)

    # Find constructor
    constructor_pattern = f"{class_name}\\(this._repository\\);"

    # Create singleton pattern
    if f"static {class_name}? _instance;" not in content:
        # Replace constructor with singleton pattern
        impl_name = repo_name.replace("Repository", "RepositoryImpl")
        singleton_code = f"""static {class_name}? _instance;
  final {repo_name} _repository;

  {class_name}._() : _repository = {impl_name}.instance;

  /// Get singleton instance
  static {class_name} get instance {{
    _instance ??= {class_name}._();
    return _instance!;
  }}"""

        # Replace the old constructor
        content = re.sub(
            f"final {repo_name} _repository;\n\n  {constructor_pattern}",
            singleton_code,
            content
        )

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"DONE: Updated {os.path.basename(file_path)}")

print("\nDONE: All use case files updated!")
