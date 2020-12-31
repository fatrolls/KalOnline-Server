KOTE - Kal Online Tree Editor
=========================================

Setup
-----
1. Extract the contents of the KOTE.zip to you Kal Server directory.
2. Download and copy swordcrypt.exe to the bin directory.
3. Download and copy PKZIP25.exe to the bin directory.
4. Edit the contents of KalDir.bat to match the location of your Kal Client directory.
5. Run Prepare.bat.
6. Run KOTE.bat.
7. Run UpdateClient.bat if you have made changes to the client side.
8. Run Clean.bat if you wish to recover some disk space.

Keys
----
Left/Right   - Enter/exit item branch
Up/Down      - Select item
PgUp/PgDn    - Fast select item
Enter        - Change property/specialty
Del          - Delete property/specialty
Tab          - Follow link
Backspace    - Return to top stack position
[            - Push location on stack
]            - Pop location on stack
F5           - Store changes to current item  (* next to index = unstored)
F7           - Cancel changes to item
F9           - Create child object
F10          - Fix missing link to name
Shift-F9     - Clone monster
Esc          - Quit/Select first unsaved item

Notes
-----
To quit you must either save/cancel all changes.  Pressing Esc will automaticall
select the first unsaved item.

Programmed by Erkle with help from Swarm