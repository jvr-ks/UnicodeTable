# UnicodeTable  
  
### Status: Betatest
(Usable, but still under construction!)  
  
UnicodeTable shows a table of Unicode characters (compare: "charmap.exe" a standard Windows app).  
  
Doubleclick on any character to get more information (UTF-16 and UTF8 values, name of first character etc.).  
The character is copied to the clipboard.  
Mark multible characters to get a sequence of values.  
If "Catch characters outside the app" is enabled (menu ➔ settings),  
any character(s) copied to the clipboard are processed.  
  
<a href="https://github.com/jvr-ks/UnicodeTable/blob/main/assets/images/unicodeTable.png"><img src="https://github.com/jvr-ks/UnicodeTable/blob/main/assets/images/unicodeTable.png" align="left"></a>
<br clear="all" />
  
* Use \[Ctrl] + \[Mouse-wheel] to zoom in/out,  
* Use \[Alt] + \[Mouse-wheel] to select next/previous table-section (or use the ▼/▲-buttons),  
* Mark a character (double-click) an press \[Ctrl] + [c] to show parameters (Parameter-Box),  
  (Only in the table, besides the switch Menu -&gt; Settings -&gt; "Catch characters outside the app" is checked)  
  Tabs and Blanks are always removed from the captured string!     
* Enter values (hexadecimal, i.e. U+xy, xy < 0x01FFFF) (separated by blanks) in the "Num. to UTF-32 Char." field.  
  Characters are display in the Character(s)-field of the Param-Box.  
* Press \[F1] again to close the QuickHelp-window.  
* "Noto Color Emoji" is an open source font (not included).

#### Blocks  
Menu ↣ Blocks contains buttons to access Unicode-blocks (sorted by block-names).  
  
#### Favorites  
The file "UnicodeTableFavorites.txt" contains all known Unicode blocks,  
ordered by value and beneath ordered by name.  
If a row starts with a semicolon, it is commented out.  
  
To use a row as a favorite, edit the file "UnicodeTableFavorites.txt":  
(Menu ↣ [Favorites] ↣ [Edit Favorites File])  
Copy the row to the top and remove the leading semicolon.  
  
Favorites are accessible via Menu-buttons (Menu: Blocks ↣ Favorites).  

#### Character Names  
Character names are looked up in the file "unicodeNames.txt".  
If the value is missing, it is fetched from the internet.
Control characters: Only a few Control characters (in the area 0 to 9F) can be parsed,  
some of them are even not displayable because it is a plain text display.  
Example: Displaying a "Carriage Return" would just move the cursor to the first position ...

#### Fonts  
Use the menu entry "Table Font" to change the font used in the table (the "Table" is just plain test).  
Unicode has 149186 characters (Unicode 15.0), no font covers all the possible characters.  
The [noto font family](https://en.wikipedia.org/wiki/Noto_fonts) covers about a half of the possible characters
I personally prefer the "Source Code Pro" font (-> Internet).  
The character table uses tabs to generate a table like layout, but alignment depends on the font selected,  
and most fonts will not be shown aligned correctly to the index header.  
There are some very big characters also, taking far more space (like U+1242B).  
The ParamBox Character(s) field does not support all characters supported by the character table (but most).  
**The index may be misaligned, if within the selected font the space of a "tab" character is to small.** 
  
#### Known issues / bugs  
  
Issue / Bug | Type | fixed in version  
------------ | ------------- | -------------  
 
  
#### Latest changes:  
  
Version (&gt;=)| Change  
------------ | -------------  
0.016 | Fontsize menu added, Font name/size selection moved to the Settings menu
0.015 | ParamBox menu button to show the name of the first character (Range: < U+FFF0)
0.011 | Bugfixes
0.010 | Table font is selectable  
0.009 | Settings -&gt; Switch "Catch characters outside the app"
0.006 | Favorites (Menu ↣ Favorites)
0.005 | Blocks
0.003 | Parameter-Box
  
#### Download Zip-file  
Github: [UnicodeTable.zip](https://github.com/jvr-ks/UnicodeTable/raw/main/UnicodeTable.zip)  
The zip-files don't contain any source-code!  
  
#### License: GNU GENERAL PUBLIC LICENSE  
Please take a look at [license.txt](https://github.com/jvr-ks/UnicodeTable/raw/main/license.txt)  
(Hold down the \[CTRL]-key to open the file in a new window/tab!)  
  
Copyright (c) 2024 J. v. Roos   
  
  
<a name="virusscan">  

##### Virusscan at Virustotal 
[UnicodeTable.exe 64bit-exe](https://www.virustotal.com/gui/url/991fc18082b9d0fa55a80ff69d77bcbb3cc59738a3120a7698d1bed6246efb6e/detection/u-991fc18082b9d0fa55a80ff69d77bcbb3cc59738a3120a7698d1bed6246efb6e-1720787969)
