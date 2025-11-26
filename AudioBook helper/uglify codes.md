# MINIFIER & OBFUSCATOR (using tool noted with * )

**I am using**
- JS:* **https://uglifyjs.net** (check 'Mangle names', 'Mangle function names')
- CSS: * **https://cssnano.github.io/cssnano/playground/** (Use Preset Default)  
	http://css.github.io/csso/csso.html

- HTML + SVG minifier * **https://codebeautify.org/minify-html**  

**Others**
- HTML+CSS+JS: https://htmlcompressor.com  
	https://refresh-sf.com
- Html (node JS): https://github.com/kangax/html-minifier?tab=readme-ov-file
- CSS+JS (jar app): https://developers.google.com/closure
	UI online: http://closure-compiler.appspot.com

**Best minifier review:**  
- https://dev.to/behainguyen/javascript-and-css-minification-345e  
- https://www.scalenut.com/blogs/best-css-minify-minifier  
- https://kinsta.com/blog/minify-javascript/  

# Notepad++	

Using **`notepad++`** to clean **`data_*.js`** files and minify `html` code before minifying and obfuscation.
## Using `Replace` diaglog 

### Remove extra `script`, `style`, `comment` tag before objuscating
To remove HTML comment, style, script marker: in Notepad++ replace diaglog, choose "Regular expression mode", then replace following with empty ""
```
	\"use strict\"\;|<!--(.+)-->|</?script>|</?style>
```

### Remove extra `"` out of properties name for most mini `data_*` database

Replace following (in Regular expression mode) with `$1`:
```text
"(bookId|meta|name|eName|bookGrp|gId|books|title|eTitle|author|type|mc|cover|ssrc|grp|wc|url|urlLine|nd|startNum|wcSrc|tap|skipStart|label|f|t|autoTap|year|intro|parts|stt|tit|eTit|dur|img|oUrl|cId|infor)":
```


OR more extensively (but may cause flaws), replace following (in Regular expression mode) with `$1`:
```
"([^\"]+)":
```
## Edit file `shortcuts.xml`
Macros of `Notepad++` saved at file `shortcuts.xml` in folder `%AppData%\Notepad++`.  
You can add following code the the `shortcuts.xml` file, to have `REMOVE style script TAG` and `Trim name of Database` available in `Notepad++`'s `Macros` menu
```xml
    <Macros>
        <Macro name="REMOVE style script TAG" Ctrl="no" Alt="no" Shift="no" Key="0">
            <Action type="3" message="1700" wParam="0" lParam="0" sParam="" />
            <Action type="3" message="1601" wParam="0" lParam="0" sParam='\&quot;use strict\&quot;\;|&lt;!--(.+)--&gt;|&lt;/?script&gt;|&lt;/?style&gt;' />
            <Action type="3" message="1625" wParam="0" lParam="2" sParam="" />
            <Action type="3" message="1602" wParam="0" lParam="0" sParam="" />
            <Action type="3" message="1702" wParam="0" lParam="770" sParam="" />
            <Action type="3" message="1701" wParam="0" lParam="1609" sParam="" />
        </Macro>
        <Macro name="Trim name of Database" Ctrl="no" Alt="no" Shift="no" Key="0">
            <Action type="0" message="2422" wParam="0" lParam="0" sParam="" />
            <Action type="0" message="2325" wParam="0" lParam="0" sParam="" />
            <Action type="0" message="2178" wParam="0" lParam="0" sParam="" />
            <Action type="0" message="2422" wParam="0" lParam="0" sParam="" />
            <Action type="0" message="2325" wParam="0" lParam="0" sParam="" />
            <Action type="3" message="1700" wParam="0" lParam="0" sParam="" />
            <Action type="3" message="1601" wParam="0" lParam="0" sParam='\&quot;(bookId|meta|name|eName|bookGrp|gId|books|title|eTitle|author|type|mc|cover|ssrc|grp|wc|url|urlLine|nd|startNum|wcSrc|tap|skipStart|label|f|t|autoTap|year|intro|parts|stt|tit|sTit|eTit|dur|img|oUrl|cId|infor)\&quot;:' />
            <Action type="3" message="1625" wParam="0" lParam="2" sParam="" />
            <Action type="3" message="1602" wParam="0" lParam="0" sParam="$1:" />
            <Action type="3" message="1702" wParam="0" lParam="770" sParam="" />
            <Action type="3" message="1701" wParam="0" lParam="1609" sParam="" />
        </Macro>  
    </Macros>
```

# Test tools
## Performance test tools
- https://webflow.com/blog/website-performance-test-tools
- https://pagespeed.web.dev/
- https://www.webpagetest.org

## Github
- https://github.com/trimstray/the-book-of-secret-knowledge//master
- https://github.com/hocchudong/git-github-for-sysadmin?tab=readme-ov-file
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh

<!-- 
Some fixes

data-tooltip="Tổng thời gian cả cuốn sách"
add &nbsp; to avoid svg and label too close

Các background svg image có animation trong code svg có thể bị mất animation
ol#elmPlaylist li.beingPlay:after {
	bottom: 4px;
	content: url(...);
	...
}
change 'content' to (to make the bar jumping):
url('data:image/svg+xml,<svg fill="red" viewBox="0 0 10.5 7" xmlns="http://www.w3.org/2000/svg"><rect transform="translate(.5 6) rotate(180) translate(-.5 -6)" x="-.5" y="5" width="1.5" height="2"><animate attributeName="height" dur="1.2s" keyTimes="0;0.5;1" repeatCount="indefinite" values="2;7;2"/> </rect> <rect transform="translate(3.5 4.5) rotate(180) translate(-3.5 -4.5)" x="2.5" y="2" width="1.5" height="5"> <animate attributeName="height" dur="2.8s" keyTimes="0;0.4;0.8;1" repeatCount="indefinite" values="5;1;7;5"/> </rect> <rect transform="translate(6.5 3.5) rotate(180) translate(-6.5 -3.5)" x="5.5" width="1.5" height="7"> <animate attributeName="height" dur="1s" keyTimes="0;0.5;1" repeatCount="indefinite" values="7;0;7"/> </rect> <rect transform="translate(9.5 5) rotate(180) translate(-9.5 -5)" x="8.5" y="3" width="1.5" height="4"> <animate attributeName="height" dur="4.7s" keyTimes="0;0.5;1" repeatCount="indefinite" values="2;7;2"/> </rect> </svg>')

OR (longer, by maybe safer):
url('data:image/svg+xml;charset=utf-8,%3Csvg fill="red" viewBox="0 0 10.5 7" xmlns="http://www.w3.org/2000/svg"%3E%3Crect transform="translate(.5 6) rotate(180) translate(-.5 -6)" x="-.5" y="5" width="1.5" height="2"%3E%3Canimate attributeName="height" dur="1.2s" keyTimes="0;0.5;1" repeatCount="indefinite" values="2;7;2"/%3E %3C/rect%3E %3Crect transform="translate(3.5 4.5) rotate(180) translate(-3.5 -4.5)" x="2.5" y="2" width="1.5" height="5"%3E %3Canimate attributeName="height" dur="2.8s" keyTimes="0;0.4;0.8;1" repeatCount="indefinite" values="5;1;7;5"/%3E %3C/rect%3E %3Crect transform="translate(6.5 3.5) rotate(180) translate(-6.5 -3.5)" x="5.5" width="1.5" height="7"%3E %3Canimate attributeName="height" dur="1s" keyTimes="0;0.5;1" repeatCount="indefinite" values="7;0;7"/%3E %3C/rect%3E %3Crect transform="translate(9.5 5) rotate(180) translate(-9.5 -5)" x="8.5" y="3" width="1.5" height="4"%3E %3Canimate attributeName="height" dur="4.7s" keyTimes="0;0.5;1" repeatCount="indefinite" values="2;7;2"/%3E %3C/rect%3E %3C/svg%3E')
 -->