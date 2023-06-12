# This will generate environment variables
define app_generate_env
flutter pub add environment_config
flutter pub run environment_config:generate
flutter pub remove environment_config
endef

# This will run project code generation
define app_codegen
flutter pub run build_runner build --delete-conflicting-outputs
endef

generate_env:
	$(app_generate_env)

codegen:
	$(app_codegen)