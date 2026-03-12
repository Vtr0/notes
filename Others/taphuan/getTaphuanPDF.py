# pip install requests pillow beautifulsoup4
""" Minified version of getTaphuanPDF.py, for fun and to make it harder to read. 
    - install pyminifier: `pip install pyminifier3`
    - run code: `pyminifier --replacement-length=1 -O --outfile=min.py getTaphuanPDF.py`
    - fix min.py: always error at `Image.N(f).convert("RGB")` replace `Image.N` (N can be something else, just looking for `convert("RGB")`) with `Image.open`
    - fix some other minor issues (if any), mostly because of poor choice of variable names. If there are too many duplicates in variables names, just run the minifier again.
"""
#import os
import time
import shutil
import requests
from pathlib import Path
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from PIL import Image

# Set headers to mimic a browser, some servers may block requests with default Python user-agent
HEADERS = {"User-Agent": "Mozilla/5.0",
            "Referer": "https://taphuan.olm.vn/" # some images may require Referer header to be set to the main page URL, otherwise we may get 403 Forbidden error when trying to download them
            }

IMG_BASE_URL = "https://cdn3.olm.vn/" # base URL for images, in case the src is a relative URL, we need to join it with this base URL

from contextlib import contextmanager
@contextmanager
def spinner(message="Working"):
    import itertools
    import threading
    import time

    stop = threading.Event()

    def spin():
        # for c in itertools.cycle("|/-\\"):
        for c in itertools.cycle("⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"):
            if stop.is_set():
                break
            print(f"\r{message} {c}", end="", flush=True) 
            time.sleep(0.1)
            
    thread = threading.Thread(target=spin)
    thread.start()

    try:
        yield
    finally:
        stop.set()
        thread.join()
        print(f"\r", end="", flush=True) #{message} Done\n

def extract_image_urls(URL):
    print("\nExtracting image URLs from page...")

    with spinner("Fetching page"):
        try:
            res = requests.get(URL, headers=HEADERS)
            res.raise_for_status()
        except requests.RequestException as e:
            print(f"\n\033[31mError fetching page: {e}.\033[0m")
            return []

        soup = BeautifulSoup(res.text, "html.parser")

    image_urls = []    

    for img in soup.select("#reader img"):
        src = img.get("data-src") or img.get("src") #https://cdn3.olm.vn/upload/taphuan/cf17fffe-784f-7265-9ed3-bab136ffc707-202507161352262308-1772302383981.jpg
        if src:
            image_urls.append(urljoin(IMG_BASE_URL, src)) #in case src is a relative URL, we join it with the base URL

    # for i, url in enumerate(image_urls): print(i+1, url)

    print("Total images found:\033[33m", len(image_urls), "\033[0m")
    return image_urls

""" Improved progress bar with percentage in the middle. """
def progress(i, total, additionStr=""):
    percent = i / total
    bar_length = 40

    filled = int(bar_length * percent)
    fPercentage = f" {percent:^6.1%} "
    half_bar = bar_length // 2

    if(percent < 0.5):
        bar = "█" * filled + "░" * (half_bar - filled) + fPercentage + "░" * half_bar
    else:
        bar = "█" * half_bar + fPercentage + "█" * (filled - half_bar) + "░" * (bar_length - filled)

    print(f"\033[32m\r|{bar}| \033[36m{i:>3}/{total} \033[0m{additionStr} ", end="")

def download_images(image_urls, IMAGE_DIR):
    print("\n📥 Downloading images...")

    IMAGE_DIR.mkdir(parents=True, exist_ok=True)

    files = []

    total_bytes = 0
    start_time = time.perf_counter()

    img_len = len(image_urls)
    for i, url in enumerate(image_urls):
        try:
            r = requests.get(url, headers=HEADERS)
            r.raise_for_status()
        except requests.RequestException as e:
            print(f"\nError downloading image {i+1}: \033[31m{e}.\033[0m")
            return []

        filename = IMAGE_DIR / f"{i:03}.jpg" # os.path.join(IMAGE_DIR, f"{i:03}.jpg")

        with open(filename, "wb") as f:
            f.write(r.content)

        files.append(filename)

        # speed calculation
        elapsed = time.perf_counter() - start_time
        total_bytes += len(r.content)
        speed = total_bytes / elapsed if elapsed > 0 else 0  # bytes/sec
        speed_mb = speed / (1024 * 1024)  # convert to MB/s
        speed_str = f" (\033[33m{total_bytes / (1024 * 1024):.2f} MB\033[0m – 🌐 \033[38;5;46m{speed_mb:.2f} MB/s\033[0m)"

        #print(f"Downloading {i+1}/{len(image_urls)}")
        progress(i+1, img_len, speed_str)
        
    return files


def create_pdf(files, PDF_FILE):
    print("\n\nCreating PDF...\n📦 Adding images to PDF...")

    images = []

    i = 1
    total_bytes = 0
    for f in files:
        img = Image.open(f).convert("RGB")
        images.append(img)
        total_bytes += f.stat().st_size
        progress(i, len(files), f" (\033[33m{total_bytes / (1024 * 1024):.2f} MB\033[0m)")
        i += 1

    print("\n")
    with spinner("Packaging PDF"):
        if images:
            images[0].save(
                PDF_FILE,
                save_all=True,
                append_images=images[1:]
            )

    print("📁 PDF created:\033[33m", PDF_FILE, "\033[0m", f" (\033[36m{PDF_FILE.stat().st_size / (1024 * 1024):.2f} MB\033[0m)")


def delete_images(IMAGE_DIR):
    # choice = input("\nDelete downloaded image folder? (y/n): ").strip().lower()
    choice = "y"
    if choice == "y":
        shutil.rmtree(IMAGE_DIR)
        print("\n\033[31mTemplate Image folder deleted.\033[0m")
    else:
        print("\n\033[32mTemplate Images kept.\033[0m")

def main():
    start_time = time.perf_counter()

    # -------- Get script directory --------
    BASE_DIR = Path(__file__).resolve().parent

    # -------- Default URL --------
    DEFAULT_URL = "https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"

    # -------- Ask user for URL --------
    user_input = input("Enter book URL (press Enter for default): ").strip()
    URL = user_input if user_input else DEFAULT_URL

    print("Using URL:\033[33m", URL, "\033[0m")

    # -------- Extract book name from URL --------
    path = urlparse(URL).path
    slug = Path(path).name
    name = slug.split(".")[0]

    IMAGE_DIR = BASE_DIR / name
    PDF_FILE = BASE_DIR / f"{name}.pdf"

    # -------- Extract image URLs --------
    urls = extract_image_urls(URL)

    if not urls:
        print("\n\033[31mNo images found. The page may require JavaScript.\033[0m")
        return

    # -------- Download images, create PDF, and delete images --------
    files = download_images(urls, IMAGE_DIR)

    if not files:
        print("\n\033[31mNo PDF created.\033[0m")
        delete_images(IMAGE_DIR)
        return
    
    create_pdf(files, PDF_FILE)
    delete_images(IMAGE_DIR)

    m, s = divmod(int(time.perf_counter() - start_time), 60)
    print(f"\n⌛ Total downloading time: \033[38;5;48m{m:02d}:{s:02d}\033[0m")

if __name__ == "__main__":
    main()
    
    """ 
    import time
    for p in range(101):
        progress(p + 1, 101)
        time.sleep(0.1)

    print("\n")

    for p in range(120):
        progress(p + 1, 120)
        time.sleep(0.1)
    """


""" 
Download all pages of the book manually using JS:
OLM using turn.js (https://github.com/ono77/Turn.js-5/blob/master/lib/turn.js) to render book pages, so we can't get all page images by just fetching the page source, we need to run JS to get all page images.
Download all pages of the book using JS:

Open Elements tab on Developer
search for element <<div id="reader" class="no-drag">
break on "subtree modification", refresh page
page will break and div#reader element will be full with all pages of the book

Run code, we will have all the pages:

c = Array.prototype.map.call(reader.children,
	(t,pageNo) =>{
		z = t.querySelector("img"); 
		return {page: pageNo+1, img: z.dataset.src ?? z.src};
}); copy(c)

--------------------
file turn.min.js
breakpoint on _addPage: function

this.data().pageObjs.map(t => t.context.querySelector("img").src)


File turn.min.js
search for 'e = this.children();' 
breakpoint on next line: 'a = g.extend('
run code

m = []
for (const pageNo in e) {

	t = e[pageNo];
	z = t.querySelector("img"); 
	m.push( {page: pageNo, img: z.dataset.src ?? z.src})
})

OR faster (node that e is an json object which has 'length' attribute and '0', '1','2',... attributes, so we can using map prototype of an array object

c = Array.prototype.map.call(e,
	(t,pageNo) =>{
		z = t.querySelector("img"); 
		return {page: pageNo+1, img: z.dataset.src ?? z.src};
})
"""