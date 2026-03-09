# pip install requests pillow beautifulsoup4
""" Minified version of getTaphuanPDF.py, for fun and to make it harder to read. 
    install pyminifier: `pip install pyminifier3`
    run code: `pyminifier --replacement-length=1 --remove-literal-statements --obfuscate-builtins --obfuscate-functions --outfile=min.py getTaphuanPDF.py`
"""
#import os
from pathlib import Path
import shutil
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from PIL import Image

# Set headers to mimic a browser, some servers may block requests with default Python user-agent
HEADERS = {"User-Agent": "Mozilla/5.0",
            "Referer": "https://taphuan.olm.vn/" # some images may require Referer header to be set to the main page URL, otherwise we may get 403 Forbidden error when trying to download them
            }

IMG_BASE_URL = "https://cdn3.olm.vn/" # base URL for images, in case the src is a relative URL, we need to join it with this base URL

def extract_image_urls(URL):
    print("\nFetching page...")

    res = requests.get(URL, headers=HEADERS)
    res.raise_for_status()

    soup = BeautifulSoup(res.text, "html.parser")

    image_urls = []    

    for img in soup.select("#reader img"):
        src = img.get("data-src") or img.get("src") #https://cdn3.olm.vn/upload/taphuan/cf17fffe-784f-7265-9ed3-bab136ffc707-202507161352262308-1772302383981.jpg
        if src:
            image_urls.append(urljoin(IMG_BASE_URL, src)) #in case src is a relative URL, we join it with the base URL

    """ for i, url in enumerate(image_urls):
        print(i+1, url) """

    print("Total images found:\033[33m", len(image_urls), "\033[0m")
    return image_urls

""" Simple progress bar. """
def progress1(i, total):
    percent = i / total
    bar_length = 40

    filled = int(bar_length * percent)
    bar = "#" * filled + "-" * (bar_length - filled)

    print(f"\r[{bar}] {i}/{total} - {percent*100:5.1f}% ", end="")
    

""" Improved progress bar with percentage in the middle. """
def progress(i, total):
    percent = i / total
    bar_length = 40

    filled = int(bar_length * percent)
    fPercentage = f" {percent*100:5.1f}% "
    half_bar = bar_length // 2

    # bar = "#" * filled + "-" * (bar_length - filled)
    if(percent < 0.5):
        bar = "#" * filled + "-" * (half_bar - filled) + fPercentage + "-" * half_bar
    else:
        bar = "#" * half_bar + fPercentage + "#" * (filled - half_bar) + "-" * (bar_length - filled)

    GREEN = "\033[32m"
    RESET = "\033[0m"

    print(f"{GREEN}\r[{bar}] {i}/{total} {RESET}", end="")
    #print(f"\r[{bar}] {i}/{total} ", end="")

def download_images(image_urls, IMAGE_DIR):
    print("\nDownloading images...")

    files = []

    img_len = len(image_urls)
    for i, url in enumerate(image_urls):
        #print(f"Downloading {i+1}/{len(image_urls)}")
        progress(i+1, img_len)

        r = requests.get(url, headers=HEADERS)

        filename = IMAGE_DIR / f"{i:03}.jpg" # os.path.join(IMAGE_DIR, f"{i:03}.jpg")

        with open(filename, "wb") as f:
            f.write(r.content)

        files.append(filename)

    return files


def create_pdf(files, PDF_FILE):
    print("\n\nCreating PDF...\nAdding images to PDF...")

    images = []

    i = 1
    for f in files:
        img = Image.open(f).convert("RGB")
        images.append(img)
        progress(i, len(files))
        i += 1

    if images:
        images[0].save(
            PDF_FILE,
            save_all=True,
            append_images=images[1:]
        )

    print("\nPDF created:\033[33m", PDF_FILE, "\033[0m")


def delete_images(IMAGE_DIR):
    # choice = input("\nDelete downloaded image folder? (y/n): ").strip().lower()
    choice = "y"
    if choice == "y":
        shutil.rmtree(IMAGE_DIR)
        print("\n\033[31mTemplate Image folder deleted.\033[0m")
    else:
        print("\n\033[32mTemplate Images kept.\033[0m")

def main():
    """ 
    # -------- Get script directory --------
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))

    # -------- Default URL --------
    DEFAULT_URL = "https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"

    # -------- Ask user for URL --------
    user_input = input("Enter book URL (press Enter for default): ").strip()
    URL = user_input if user_input else DEFAULT_URL

    print("Using URL:", URL)

    # -------- Extract book name from URL --------
    path = urlparse(URL).path
    slug = os.path.basename(path)
    name = slug.split(".")[0]

    IMAGE_DIR = os.path.join(BASE_DIR, name)
    PDF_FILE = os.path.join(BASE_DIR, f"{name}.pdf")

    os.makedirs(IMAGE_DIR, exist_ok=True)
 """
    # -------- Get script directory --------
    BASE_DIR = Path(__file__).resolve().parent

    # -------- Default URL --------
    DEFAULT_URL = "https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"

    # -------- Ask user for URL --------
    user_input = input("Enter book URL (press Enter for default): ").strip()
    URL = user_input if user_input else DEFAULT_URL

    print("Using URL:", URL)

    # -------- Extract book name from URL --------
    path = urlparse(URL).path
    slug = Path(path).name
    name = slug.split(".")[0]

    IMAGE_DIR = BASE_DIR / name
    PDF_FILE = BASE_DIR / f"{name}.pdf"

    IMAGE_DIR.mkdir(parents=True, exist_ok=True)

    # -------- Extract image URLs --------
    urls = extract_image_urls(URL)

    if not urls:
        print("No images found. The page may require JavaScript.")
        return

    # -------- Download images, create PDF, and delete images --------
    files = download_images(urls, IMAGE_DIR)
    create_pdf(files, PDF_FILE)
    delete_images(IMAGE_DIR)

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


''' Download all pages of the book manually using JS:
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
'''