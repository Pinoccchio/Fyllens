import os
import re

provider_files = {
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\authentication\presentation\providers\auth_provider.dart": [
        ("SignInUseCase", "_signInUseCase"),
        ("SignUpUseCase", "_signUpUseCase"),
        ("SignOutUseCase", "_signOutUseCase"),
        ("ResetPasswordUseCase", "_resetPasswordUseCase"),
        ("GetCurrentUserUseCase", "_getCurrentUserUseCase"),
    ],
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\profile\presentation\providers\profile_provider.dart": [
        ("GetUserProfileUseCase", "_getUserProfileUseCase"),
        ("CreateProfileUseCase", "_createProfileUseCase"),
        ("UpdateProfileUseCase", "_updateProfileUseCase"),
        ("UploadProfilePictureUseCase", "_uploadProfilePictureUseCase"),
    ],
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\scan\presentation\providers\scan_provider.dart": [
        ("PerformScanUseCase", "_performScanUseCase"),
    ],
    r"C:\Users\User\Documents\first_year_files\THIRD_YEAR\APPDEV_FINAL_PROJ\FYLLENS_GIT\Fyllens\lib\features\scan\presentation\providers\history_provider.dart": [
        ("GetUserScansUseCase", "_getUserScansUseCase"),
        ("DeleteScanUseCase", "_deleteScanUseCase"),
    ],
}

for file_path, use_cases in provider_files.items():
    if not os.path.exists(file_path):
        print(f"WARNING: File not found: {file_path}")
        continue

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove injectable import
    content = re.sub(r"import 'package:injectable/injectable.dart';\n", "", content)

    # Remove @injectable annotation
    content = re.sub(r"@injectable\n", "", content)

    # Find the class name
    class_match = re.search(r"class (\w+Provider)", content)
    if not class_match:
        print(f"WARNING: Could not find provider class in {file_path}")
        continue

    class_name = class_match.group(1)

    # Build the initialization code for constructor
    init_lines = []
    for use_case_class, field_name in use_cases:
        init_lines.append(f"        {field_name} = {use_case_class}.instance")

    init_code = ",\n".join(init_lines)

    # Find and replace the constructor
    # First, find the old constructor pattern
    old_constructor_pattern = rf"{class_name}\(\s*\n"

    # Find all the parameter lines
    param_pattern = r"this\._\w+,?\s*\n"

    # Create new constructor
    new_constructor = f"""{class_name}()
      : {init_code};"""

    # Find the old constructor block (starts with ClassName( and ends with );)
    old_constructor_regex = rf"{class_name}\([^)]*\);"

    # Replace old constructor
    content = re.sub(old_constructor_regex, new_constructor, content, flags=re.DOTALL)

    # Also need to handle the special case for auth_repository if it exists
    # Remove AuthRepository from constructor params if present
    if "AuthRepository _authRepository" in content:
        # This line needs to stay as a field but init differently
        content = content.replace(
            "final AuthRepository _authRepository;",
            "late final AuthRepository _authRepository;"
        )
        # Add initialization in the initialize method or at the top
        if "_authRepository = " not in content:
            # Add after constructor
            content = content.replace(
                f"{class_name}()\n      : {init_code};",
                f"{class_name}()\n      : {init_code} {{\n    _authRepository = AuthRepositoryImpl.instance;\n  }}"
            )

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"DONE: Updated {os.path.basename(file_path)}")

print("\nDONE: All provider files updated!")
