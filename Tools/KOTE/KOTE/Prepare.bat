@call KalDir.bat

copy %KAL_DIR%\data\HyperText\e\e.pk e.pk\In\
cd e.pk
call In.bat
cd ..

copy %KAL_DIR%\data\Config\Config.pk Config.pk\In\
cd Config.pk
call In.bat
cd ..
