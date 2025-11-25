c="", $0.querySelectorAll("a").forEach(m=> {c+="\"" + decodeURI(m.href) + "\",\n"});copy(c)

## Handy functions
### make 10 unique book Id
```javascript
copy([...Array(10).keys()].map(BookData.prototype.makeUniqueId))
```

### title case string
```javascript
function titleCase(str) {
  str = str.toLowerCase().split(' ');
  for (var i = 0; i < str.length; i++) {
    str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1); 
  }
  return str.join(' ');
}
```

### to H:mm:ss
```javascript
var toHhMmSs = (sec) => {
	function pad(n, width, z) {
		z = z || '0';
		n = n + '';
		return String(n).padStart(width, z); // '0009'
	}
	
	if (isNaN(sec)) return "00:00";
	sec = sec << 0; //make sec to be integer
	let h = (sec / 3600) << 0; sec = sec % 3600;
	let m = (sec / 60) << 0;
	s = sec % 60;
	return (h ? h + ":" : "") + pad(m, 2) + ":" + pad(s, 2);
}
```

## Make AudioBook database 
### from Youtube

#### From **Youtube playlist** (can replace `$0` with `document.querySelector("#contents")` )

```javascript
//, oUrl: m.querySelector("a").href.match(/v\=([^\&]+)\&/)[1]
c=[];i=1;document.querySelectorAll("#contents > ytd-playlist-video-renderer").forEach(m => {c.push({stt:i++,tit:m.querySelector("h3").innerText.replaceAll("-", "–"), url:[""], dur:m.querySelector(".yt-badge-shape__text").innerText, img: m.querySelector("img").src.split("/").slice(-2,-1)[0]})}); copy(c)
```

#### From **Youtube Live**
```javascript
//stt:i++, url:[""], 
c=[];i=1;document.querySelectorAll("#contents > ytd-rich-item-renderer").forEach(m => {c.push({tit:m.querySelector("h3").innerText.replaceAll("-", "–"), dur:m.querySelector(".yt-badge-shape__text").innerText, img: m.querySelector("img").src.split("/").slice(-2,-1)[0]})}); c.reverse();copy(c)
```
-----
#### From **Youtube Live for XTTT**
```javascript
c=[];i=1;document.querySelectorAll("#contents > ytd-rich-item-renderer").forEach(m => {t={tit:m.querySelector("h3").innerText.replaceAll("-", "–"), dur:m.querySelector(".yt-badge-shape__text").innerText, img: m.querySelector("img").src.split("/").slice(-2,-1)[0]};
a = t.tit.split("–")[0]; if(!a.includes(":")) delete t.tit; else {b=a.split(":"); t.tit = `Tập ${b[0].match(/\d+/)[0]} – ${titleCase(b[1])}`; t.tit = t.tit.replace(/\s+/g," ").trim()}
c.push(t)}); c.reverse();copy(c)
```
#### From Youtube Live for XTTT (m is array of new items need to be added)
```javascript
m.forEach(t => {a = t.tit.split("–")[0]; if(!a.includes(":")) delete t.tit; else {b=a.split(":"); t.tit = `Tập ${b[0].match(/\d+/)[0]} – ${titleCase(b[1])}`; t.tit = t.tit.replace(/\s+/g," ").trim()} }); copy(m)
```
-----
### From other page
#### From phatphapungdung
```javascript
c=[]; document.querySelectorAll(".fp-playlist-external > a").forEach( (m, stt) => {m=JSON.parse(m.getAttribute("data-item")); c.push( {tit: m.fv_title.replaceAll("-", "–"), dur:"", url: [decodeURI(m.sources[0].src).replaceAll("\n","")] } ) }); copy(c)
```

#### From chuagiango
```javascript
c=[]; i=1; document.querySelectorAll(".views-table > tbody > tr").forEach(_tr => {c.push({stt:i++, tit: _tr.firstElementChild.innerText, dur:"", url: [decodeURI( _tr.lastElementChild.firstElementChild.getAttribute("href"))] })}); copy(c)
c.forEach(m => m.dur = t[m.stt]); copy(c)
```

#### DIEUPHAPAM
http://media.dieuphapam.net/data/2697/data/
```javascript
c=[...$0.querySelectorAll("a")].map(t => decodeURI(t.href)); copy(c)

//covert to real link
c=[...$0.querySelectorAll("a")].map(t => {let x  = t.href.match(/f\=(\d+)\.(.+)$/); return decodeURI(`http://media.dieuphapam.net/data/${x[1]}/data/${x[2]}`)}); copy(c)
```

#### From ph.tinhtong.vn
```javascript
m=[];i=1; $$(".mdtc-clnplra-playlist > ul > li").forEach(_li => m.push({tit: _li.lastChild.lastChild.nodeValue.replaceAll("-","–"), dur: _li.children[1].innerText, url: ['https://ph.tinhtong.vn' + _li.firstChild.firstChild.getAttribute('href')]}) ); copy(m)
```
OR
```javascript
c= m.map(t => Object.assign({stt:"",tit:"",dur:"",url:[] }, t));c.forEach(t => t.tit = t.tit.replaceAll("-","–")); copy(c)
```


#### Link to convert from youtube video to mp3 that can used in Audio HTML Element
```html
https://ph.tinhtong.vn/Home/GetAudioYoutube/{YT_id}
```

#### From phapthihoi.org
```javascript
c=document.getElementById("player").contentWindow.jwplayer("container").config.playlist.map(a => decodeURIComponent(a.file) ); copy(c)

i=1;c=document.getElementById("player").contentWindow.jwplayer("container").config.playlist.map(a => ( {stt:i++, tit: a.title.trim().replace(" -", "."), url: [decodeURIComponent(a.file)], dur:""}) ); copy(c)
```

#### from fileList of phapthihoi
```javascript
copy(Array.prototype.map.call(document.querySelectorAll("a[href]"), a => decodeURIComponent(a.href)).filter(a => a.indexOf(".mp3")>-1) )

k=0; for(i=0; i< xData[k].parts.length;i++){xData[k].parts[i].url=m[i]};copy(xData[k].parts)
```

### From archive.org
```javascript
//archieve.org get all information (title, duration, links and even audio histogram
c=[];i=1; JSON.parse(document.querySelector(".js-play8-playlist").getAttribute("value")).forEach(m => c.push({stt:i++,tit:m.title, url:[""], dur:toHhMmSs(m.duration)}) );copy(c)

c=[]; JSON.parse(document.querySelector(".js-play8-playlist").getAttribute("value")).forEach(m => {c.push(m.duration)});copy(c)
//copy mp3 links
c= [...$0.querySelectorAll("a")].map(m => decodeURIComponent(m.href));copy(c)

//copy duration
c="";$0.querySelectorAll("button").forEach(m => c+="\""+m.lastElementChild.innerText+"\",\n");copy(c)
```

#### archieve.org Sort to correct order
```javascript
c= JSON.parse(document.querySelector(".js-play8-playlist").getAttribute("value"));
toNum = x => {a = x.orig.match(/_(\d+)\.mp3/); return a? Number(a[1]) : 1}; //regex must be changed in each case
c.sort((x,y) => toNum(x) - toNum(y) );
m = c.map(t => {return {tit: t.title.trim().replace("-", "–"), dur:toHhMmSs(t.duration)} });
copy(m);
```
-------------------------------
### FREE DOWNLOAD MANAGER links generator
```javascript
/*
link: the links with asterik * at the number, such as https://archive.org/download/gia-thien/*.mp3
f: from number; t: to number
pad: number of "0" to pad at start of the number
*/
fdmLink = (link,f,t, pad = 0) => {
	let links=[];
	for(let i=f; i<=t; i++) links.push(link.replace("*", (i+"").padStart(pad,"0") ));
	let ret = links.join("\n");
	copy(ret);
	return ret;
}
```
-------------------------------
#### remove STT:
x = data_2.ach_Data; x.books.forEach(b => b.parts.forEach(p => {if(p.hasOwnProperty("stt")) delete p.stt})); copy(x)
	
add STT back:
.parts[i] = Object.assign({stt: i+1}, .parts[i])
--------
### Nhat-truyen
get nhat truyen (https://nhattruyen.one/) media playlist
- Chọn một li trong playlist, chuột phải --> 'break on' --> 'attribute modifications'.
- Bấm vào mục tương ứng với li đó trong playlist, Developer Tool sẽ break.
- Trong 'Call Stack', tìm đến caller 'play', trong file js sẽ có lệnh 'this.playlist', lệnh này sẽ cho full playlist

Hoặc trong file jplayer.playlist.min.js tìm 'play:', đặt break, play 1 chương bất kỳ để dừng code