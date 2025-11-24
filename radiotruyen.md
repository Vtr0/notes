# Get media url from https://radiotruyen.me

## Page to help create bookmarklet
Open [https://caiorss.github.io/bookmarklet-maker/](https://caiorss.github.io/bookmarklet-maker/) for pasting the pure js code to make bookmarklet.  
If the code is too long, you can use [https://www.uglifyjs.net/](https://www.uglifyjs.net/) to minify the code before pasting to make bookmarklet.

Note that, after pasting the code (below), there is an `bookmarklet` link created by the page that you can drag it directly to _browser bookmark bar_ to create the bookmarklet

## Code to get whole or part of playlist start from current item (so should start from item 1)
```javascript
/* JAVASCRIPT */
const statBar = document.querySelector('h4');
statBar.style.color = "red";
const nBtn = $('.jp-next'); //next button

function wait(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
window.cList = [];
window.dur0=[];
const _WAIT = 1000;

async function getLinks() {
  let curMed = $('#jquery_jplayer_1').data('jPlayer'); //get current media object
  let playlistLen = document.querySelectorAll(".jp-playlist ul li").length;

  //ask number of item to get information starting from current playing item
  let itemNum = parseInt( prompt('Number of items you want to get links (from current item). Put 0 for all. Max value is ' + playlistLen), 10 );
  if(isNaN(itemNum)) itemNum = 1
  else if(itemNum === 0) itemNum = playlistLen;

  for (let i = 0; i < itemNum; i++) {
    const curStat = curMed.status;
	
	// wait for some more time if duration is still not yet updated
	if(!curStat.duration) {
		let waitMore = 0;
		while(!curStat.duration && waitMore < 3){
			await wait(_WAIT); waitMore++;
		}
	}

    // curStat.media in the form {title: name, mp3: link}
    window.cList.push( Object.assign(curStat.media, {dur: curStat.duration}) );
	
	// remember chapter miss duration (because moving to next chapter too fast)
	if(curStat.duration == 0) window.dur0.push(curStat.media.title);
	
    statBar.textContent = curStat.media.title; //display title on the page showing we just done on that chapter
    nBtn.click();
    await wait(_WAIT);
  }
}
async function run() {
  await getLinks();

  navigator.clipboard.writeText(JSON.stringify(window.cList));
  alert('All items copied into clipboard OR in window.cList variable');

	if(window.dur0.length > 0) alert("Missing duration (or copy window.dur0 variable):\n" + window.dur0.join("\n"));
}

run();
```

## bookmarklet code after generated

```javascript
javascript:(function()%7Bconst%20statBar%20%3D%20document.querySelector('h4')%3B%0AstatBar.style.color%20%3D%20%22red%22%3B%0Aconst%20nBtn%20%3D%20%24('.jp-next')%3B%20%2F%2Fnext%20button%0A%0Afunction%20wait(ms)%20%7B%0A%20%20return%20new%20Promise(resolve%20%3D%3E%20setTimeout(resolve%2C%20ms))%3B%0A%7D%0Awindow.cList%20%3D%20%5B%5D%3B%0Awindow.dur0%3D%5B%5D%3B%0Aconst%20_WAIT%20%3D%201000%3B%0A%0Aasync%20function%20getLinks()%20%7B%0A%20%20let%20curMed%20%3D%20%24('%23jquery_jplayer_1').data('jPlayer')%3B%20%2F%2Fget%20current%20media%20object%0A%20%20let%20playlistLen%20%3D%20document.querySelectorAll(%22.jp-playlist%20ul%20li%22).length%3B%0A%0A%20%20%2F%2Fask%20number%20of%20item%20to%20get%20information%20starting%20from%20current%20playing%20item%0A%20%20let%20itemNum%20%3D%20parseInt(%20prompt('Number%20of%20items%20you%20want%20to%20get%20links%20(from%20current%20item).%20Put%200%20for%20all.%20Max%20value%20is%20'%20%2B%20playlistLen)%2C%2010%20)%3B%0A%20%20if(isNaN(itemNum))%20itemNum%20%3D%201%0A%20%20else%20if(itemNum%20%3D%3D%3D%200)%20itemNum%20%3D%20playlistLen%3B%0A%0A%20%20for%20(let%20i%20%3D%200%3B%20i%20%3C%20itemNum%3B%20i%2B%2B)%20%7B%0A%20%20%20%20const%20curStat%20%3D%20curMed.status%3B%0A%09%0A%09%2F%2F%20wait%20for%20some%20more%20time%20if%20duration%20is%20still%20not%20yet%20updated%0A%09if(!curStat.duration)%20%7B%0A%09%09let%20waitMore%20%3D%200%3B%0A%09%09while(!curStat.duration%20%26%26%20waitMore%20%3C%203)%7B%0A%09%09%09await%20wait(_WAIT)%3B%20waitMore%2B%2B%3B%0A%09%09%7D%0A%09%7D%0A%0A%20%20%20%20%2F%2F%20curStat.media%20in%20the%20form%20%7Btitle%3A%20name%2C%20mp3%3A%20link%7D%0A%20%20%20%20window.cList.push(%20Object.assign(curStat.media%2C%20%7Bdur%3A%20curStat.duration%7D)%20)%3B%0A%09%0A%09%2F%2F%20remember%20chapter%20miss%20duration%20(because%20moving%20to%20next%20chapter%20too%20fast)%0A%09if(curStat.duration%20%3D%3D%200)%20window.dur0.push(curStat.media.title)%3B%0A%09%0A%20%20%20%20statBar.textContent%20%3D%20curStat.media.title%3B%20%2F%2Fdisplay%20title%20on%20the%20page%20showing%20we%20just%20done%20on%20that%20chapter%0A%20%20%20%20nBtn.click()%3B%0A%20%20%20%20await%20wait(_WAIT)%3B%0A%20%20%7D%0A%7D%0Aasync%20function%20run()%20%7B%0A%20%20await%20getLinks()%3B%0A%0A%20%20navigator.clipboard.writeText(JSON.stringify(window.cList))%3B%0A%20%20alert('All%20items%20copied%20into%20clipboard%20OR%20in%20window.cList%20variable')%3B%0A%0A%09if(window.dur0.length%20%3E%200)%20alert(%22Missing%20duration%20(or%20copy%20window.dur0%20variable)%3A%5Cn%22%20%2B%20window.dur0.join(%22%5Cn%22))%3B%0A%7D%0A%0Arun()%3B%7D)()%3B
```

##Using one of following js code to get one by one chapter
```javascript
/* JAVASCRIPT */
navigator.clipboard.writeText(JSON.stringify($("#jquery_jplayer_1").data("jPlayer").status.media)+",\n")

$(".jp-next").click();navigator.clipboard.writeText(JSON.stringify($("#jquery_jplayer_1").data("jPlayer").status.media)+",\n")
```