Yahh KOSP has now too a very smal script engine on lua base :P

Function list:

  * Message("Example message")                    ;Show messages in main server window.
  * WriteMemoryByte("0x1000", 2)                  ;Write one byte in the offset location.
  * WriteMemoryDword("0x1000", 2589)              ;Write one dword in the offset location.
  * ReadMemoryByte("0x1000")                      ;Read one byte out of the offset location.
  * ReadMemoryDword("0x1000")                     ;Read one dword out of the offset location.
  * Notice("Example notice")                      ;Notice message in game
  * parseInt("1234")                              ;Parse string number to integer
  * parseBolean("true")                           ;Parse string bolean to 0 or 1
  * GetProperties("properties", "default")        ;Read the properties string value out of the config.properties
 