# pip install requests pillow BeautifulSoup
import os
import shutil
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from PIL import Image

HEADERS = {"User-Agent": "Mozilla/5.0"}

# -------- Get script directory --------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# -------- Default URL --------
DEFAULT_URL = "https://taphuan.olm.vn/tap-huan/doc-sach/shs-tieng-viet-1-tap-hai.4534568231"

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


def extract_image_urls():
    print("\nFetching page...")

    res = requests.get(URL, headers=HEADERS)
    res.raise_for_status()

    soup = BeautifulSoup(res.text, "html.parser")

    image_urls = []

    IMG_BASE_URL = "https://cdn3.olm.vn/"

    for img in soup.select("#reader img"):
        src = img.get("data-src") or img.get("src") #https://cdn3.olm.vn/upload/taphuan/cf17fffe-784f-7265-9ed3-bab136ffc707-202507161352262308-1772302383981.jpg
        if src:
            image_urls.append(urljoin(IMG_BASE_URL, src)) #in case src is a relative URL, we join it with the base URL

    """ for i, url in enumerate(image_urls):
        print(i+1, url) """

    print("Total images found:", len(image_urls))
    return image_urls


def download_images(image_urls):
    print("\nDownloading images...")

    files = []

    for i, url in enumerate(image_urls):
        print(f"Downloading {i+1}/{len(image_urls)}")

        r = requests.get(url, headers=HEADERS)

        filename = os.path.join(IMAGE_DIR, f"{i:03}.jpg")

        with open(filename, "wb") as f:
            f.write(r.content)

        files.append(filename)

    return files


def create_pdf(files):
    print("\nCreating PDF...")

    images = []

    for f in files:
        img = Image.open(f).convert("RGB")
        images.append(img)

    if images:
        images[0].save(
            PDF_FILE,
            save_all=True,
            append_images=images[1:]
        )

    print("\nPDF created:", PDF_FILE)


def delete_images():
    choice = input("\nDelete downloaded image folder? (y/n): ").strip().lower()

    if choice == "y":
        shutil.rmtree(IMAGE_DIR)
        print("Template Image folder deleted.")
    else:
        print("Template Images kept.")


def main():
    urls = extract_image_urls()

    if not urls:
        print("No images found. The page may require JavaScript.")
        return

    files = download_images(urls)
    create_pdf(files)
    delete_images()


if __name__ == "__main__":
    main()



'''
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