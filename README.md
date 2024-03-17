# UnicodeTable  
  
### Status: Betatest
  
UnicodeTable shows a table of Unicode characters (compare: "charmap.exe" a standard Windows app).  
  
Usable, but still under construction!  
  
<a href="https://github.com/jvr-ks/UnicodeTable/blob/main/assets/images/unicodeTable.png"><img src="https://github.com/jvr-ks/UnicodeTable/blob/main/assets/images/unicodeTable.png" align="left"></a>
<br clear="all" />

  
* Use \[Ctrl] + \[Mouse-wheel] to zoom in/out,  
* Use \[Alt] + \[Mouse-wheel] to select next/previous table-section (or use the ▼/▲-buttons),  
* Mark a character (double-click) an press \[Ctrl] + [c] to show parameters (Parameter-Box),  
  (Only in the table, besides the switch Menu -&gt; Settings -&gt; "Catch characters outside the app" is checked)   
* Enter values (hexadecimal, i.e. U+xy, xy < 0x01FFFF) (separated by blanks) in the "Num. to UTF-32 Char." field.  
  Characters are display in the Character(s)-field of the Param-Box.  
* Press \[F1] again to close the QuickHelp-window.  

#### Blocks  
Menu ↣ Blocks contains a few buttons to access Unicode-blocks (sorted by block-names).  
  
#### Favorites  
The file "UnicodeTableFavorites.txt" contains all known Unicode blocks,  
ordered by value and beneath ordered by name.  
If a row starts with a semicolon, it is commented out.  
  
To use a row as a favorite, edit the file "UnicodeTableFavorites.txt":  
(Menu ↣ [Favorites] ↣ [Edit Favorites File])  
Copy the row to the top and remove the leading semicolon.  
  
Favorites are accessible via Menu-buttons (Menu: Blocks ↣ Favorites).  

#### Font  
The font is currently fixed to "Consolas".  
No single font includes all the characters defined in the Unicode standard.  
(The Unicode standard itself is still evolving.)

  
#### Known issues / bugs  
  
Issue / Bug | Type | fixed in version  
------------ | ------------- | -------------  
 |  |   
  
#### Latest changes:  
  
Version (&gt;=)| Change  
------------ | -------------  
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
[UnicodeTable.exe 64bit-exe](https://www.virustotal.com/gui/url/991fc18082b9d0fa55a80ff69d77bcbb3cc59738a3120a7698d1bed6246efb6e/detection/u-991fc18082b9d0fa55a80ff69d77bcbb3cc59738a3120a7698d1bed6246efb6e-1710718194)
