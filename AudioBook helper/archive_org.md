# Extract data for Audio Book from `archive.org`

## Requirement
The program requires `BeautifulSoup` for reading html markup and `pyperclip` to copy text to clipboard. You can install both libraries by run following command in Window `command prompt`:
```batch
pip install BeautifulSoup
pip install pyperclip
```
## The program
Using following `python` program

```python
import requests
from urllib.parse import unquote
from bs4 import BeautifulSoup
import json
import pyperclip
import re

def extract_image_url(html):
    # Parse HTML
    soup = BeautifulSoup(html, "html.parser")
    
    # Find the <input> tag
    input_tag = soup.find("input", class_="js-iaux-loose-images")
    if input_tag is None:
        raise ValueError("No <input> tag with class 'js-iaux-loose-images' found")
    
    # Extract the value of the 'value' attribute (which contains JSON)
    value = input_tag.get("value")
    if value is None:
        raise ValueError("No 'value' attribute found in <input> tag")
    
    # Parse the JSON in the 'value' attribute
    try:
        data = json.loads(value)
        image_url = data.get("image_url")
        return image_url
    except json.JSONDecodeError:
        raise ValueError("Failed to decode JSON from input 'value' attribute")


def extract_playlist_json(html):
    # 2. Parse HTML
    soup = BeautifulSoup(html, "html.parser")

    # 3. Find the <play-av> tag
    play_av = soup.find("play-av")
    if play_av is None:
        raise ValueError("No <play-av> tag found")

    # 4. Extract the playlist attribute
    playlist_str = play_av.get("playlist")
    if playlist_str is None:
        raise ValueError("No 'playlist' attribute found")

    # 5. Convert JSON string to Python object
    playlist_json = json.loads(playlist_str)

    return playlist_json

def seconds_to_mmss(seconds):
    seconds = int(float(seconds))  # handle "508.24" safely
    return f"{seconds // 60:02d}:{seconds % 60:02d}"


def transform_items(items, download_url):
    result = []

    for item in items:
        transformed = {
            "tit": item.get("title"),
            "dur": seconds_to_mmss(item.get("duration", 0)),
            "url": [("https://archive.org" + unquote(src.get("file"))).replace(download_url,"").replace(".mp3", "") for src in item.get("sources", [])]
        }
        result.append(transformed)

    return result

def extract_title(html):
    # Parse the HTML
    soup = BeautifulSoup(html, "html.parser")
    
    # Find the <span> inside <h1> with class "item-title"
    title_tag = soup.find("h1", class_="item-title").find("span", itemprop="name")
    if title_tag:
        return title_tag.text.strip()
    else:
        raise ValueError("Title not found")

# Example usage
if __name__ == "__main__":
    url = "https://archive.org/details/05-livin-on-the-edge_202508" # The archive collection link
    download_url = url.replace("/details/", "/download/") + "/"
    # 1. Fetch HTML content
    response = requests.get(url, timeout=10)
    response.raise_for_status()
    html = response.text

    playlist = extract_playlist_json(html)

    formatted_items = transform_items(playlist, download_url)

    # Pretty-print result
    # print(json.dumps(formatted_items, indent=2))

    image_url = extract_image_url(html).replace("?cnt=0", "")
    print("Image URL:", image_url)

    artist = "Aerosmith" #name of the artist
    full_data = {
        "bookId": "",
        "title": extract_title(html),
        "author": artist,
	   "type": "Hard Rock",
	   "mc": artist,
	   "cover": image_url,
        "ssrc": [url],
        "grp": [f"{re.sub(r'[^a-zA-Z]', '', artist).upper()}1$5Z", "HARDROCK.MMC", "HARDROCK.MMC"],
          "wc": {
               "url": [
                    {
                    "urlLine": 0,
                    "nd": 1,
                    "wcSrc": f"{url.replace("/details/", "/download/")}/<*~~*>.mp3"
                    }
               ]
          },
          "year": "",
          "intro": "",
        "parts": formatted_items
    }

    # Copy the JSON to clipboard
    pyperclip.copy(json.dumps(full_data, indent=2))
```
## Explain
* `extract_playlist_json()`: extract the detail of playlist. The idea is that the `archive.org` html code contains an `<play-av>`, inside it has an `args` attributes which in turn contain `playlist='[]'`, extract content of this variable and jsonize it.
* `transform_items()`: convert the playlist extracted by `extract_playlist_json()` above into into the AudioBook format including: `tit`, `dur`, `url`
* `extract_title()`: extract the title of the collection. The idea is looking for `<h1 class="item-title">` tag.
* `extract_image_url()`: extract the cover images. Idea is looking for an html markup `<input class="js-iaux-loose-images" ..>` and extract the image url.
## How to run
* Replace the collection's `archive.org` link to `url`, name of the artist to `artist`
* You might want to modify the `grp` value inside `full_data` variable to match your audio book's group id.
## Output
The Audio Book's full book data is copied to clipboard. All you need is just paste it into some online json editor such as [Json Editor](https://jsoneditoronline.org/) to re-format if needed.