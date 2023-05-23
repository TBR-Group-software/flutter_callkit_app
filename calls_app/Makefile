# This will generate environment variables
define app_generate_env
flutter pub add environment_config
flutter pub run environment_config:generate
flutter pub remove environment_config
endef

generate_env:
	$(app_generate_env)
