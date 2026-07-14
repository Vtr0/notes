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
    
    if seconds >= 3600:
        # Format as H:MM:SS
        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        seconds = seconds % 60
        return f"{hours}:{minutes:02d}:{seconds:02d}"
    else:
        # Format as MM:SS
        return f"{seconds // 60:02d}:{seconds % 60:02d}"


def transform_items(items, download_url):
    result = []

    for item in items:
        transformed = {
            "tit": item.get("title").replace(' - ', " – "),
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

def sort_by_title(items):
    import re
    m_sorted = sorted(
        items,
        key=lambda x: int(re.search(r'\d+', x["tit"]).group())
    )
    return m_sorted

# Example usage
if __name__ == "__main__":
    url = "https://archive.org/details/ma-thien-ky-full_202511"
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

    choice = input("\nSort chapters by title? (y/n): ").strip().lower()
    if choice == "y": formatted_items = sort_by_title(formatted_items)

    artist = "Linkin Park"
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