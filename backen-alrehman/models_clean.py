time="2026-01-24T23:01:44+05:00" level=warning msg="/Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
Traceback (most recent call last):
  File "/app/manage.py", line 26, in <module>
    main()
  File "/app/manage.py", line 22, in main
    execute_from_command_line(sys.argv)
  File "/usr/local/lib/python3.11/site-packages/django/core/management/__init__.py", line 442, in execute_from_command_line
    utility.execute()
  File "/usr/local/lib/python3.11/site-packages/django/core/management/__init__.py", line 416, in execute
    django.setup()
  File "/usr/local/lib/python3.11/site-packages/django/__init__.py", line 24, in setup
    apps.populate(settings.INSTALLED_APPS)
  File "/usr/local/lib/python3.11/site-packages/django/apps/registry.py", line 116, in populate
    app_config.import_models()
  File "/usr/local/lib/python3.11/site-packages/django/apps/config.py", line 269, in import_models
    self.models_module = import_module(models_module_name)
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "<frozen importlib._bootstrap>", line 1204, in _gcd_import
  File "<frozen importlib._bootstrap>", line 1176, in _find_and_load
  File "<frozen importlib._bootstrap>", line 1147, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 690, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 936, in exec_module
  File "<frozen importlib._bootstrap_external>", line 1074, in get_code
  File "<frozen importlib._bootstrap_external>", line 1004, in source_to_code
  File "<frozen importlib._bootstrap>", line 241, in _call_with_frames_removed
  File "/app/apps/core/models.py", line 23
    AND referenced_column_name IS NOT NULL
IndentationError: unexpected indent
