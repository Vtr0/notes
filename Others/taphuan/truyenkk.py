import re
import time
import requests

from bs4 import BeautifulSoup
from ebooklib import epub
from tqdm import tqdm


BASE_URL = "https://truyenmoikk.com"
NOVEL_URL = "https://truyenmoikk.com/kiem-tien-o-day"

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 "
        "(Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 "
        "Chrome/124.0 Safari/537.36"
    )
}


def get_soup(url):
    r = requests.get(url, headers=HEADERS, timeout=30)
    r.raise_for_status()
    return BeautifulSoup(r.text, "lxml")


def find_all_chapter_links():
    """
    Duyệt các trang:
    /trang-1
    /trang-2
    ...
    """

    chapter_links = []
    page = 40

    while page < 41:  #True:

        if page == 1:
            url = NOVEL_URL
        else:
            url = f"{NOVEL_URL}/trang-{page}"

        print("Đang quét:", url)

        try:
            soup = get_soup(url)
        except Exception:
            break

        found = []


        for a in soup.find(id="list-chapter").find_all("a", href=True):
            href = a["href"]

            if "/chuong-" in href:
                if href.startswith("/"):
                    href = BASE_URL + href

                found.append(href)

        found = list(dict.fromkeys(found))

        if not found:
            break

        chapter_links.extend(found)

        page += 1
        time.sleep(0.5)

    chapter_links = list(dict.fromkeys(chapter_links))

    print("Tổng chương:", len(chapter_links))

    return chapter_links

def extract_chapter(url):
    r = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
    r.raise_for_status()
    html = r.text

    # title vẫn dùng soup
    soup = BeautifulSoup(html, "html.parser")
    h1 = soup.find("a", class_="chapter-title")
    title = h1.get_text(strip=True) if h1 else "No title"

    # lấy RAW block chapter-content (KHÔNG parse lại)
    m = re.search(
        r'(<article[^>]+class="chapter-content"[^>]*>.*?</article>)',
        html,
        re.DOTALL | re.IGNORECASE
    )

    if not m:
        raise Exception("No chapter-content found")

    content = m.group(1)

    # chỉ remove 2 tag
    content = re.sub(r"<ins.*?>.*?</ins>", "", content, flags=re.DOTALL)
    content = re.sub(r"<iframe.*?>.*?</iframe>", "", content, flags=re.DOTALL)

    ten_file = url.rstrip("/").split("/")[-1].replace("-", "_")

    return ten_file, title, content

def extract_chapter1(url):

    soup = get_soup(url)

    title = ""

    h1 = soup.find("a", class_="chapter-title") #soup.find("h1")
    if h1:
        title = h1.get_text(strip=True)

    content = None

    possible_selectors = [
        ".chapter-content",
        ".entry-content",
        ".reading-content",
        "#chapter-content",
        ".text-left"
    ]

    content_tag = None
    for selector in possible_selectors:
        content_tag = soup.select_one(selector)
        if content_tag:
            break

    if not content_tag:
        raise Exception(f"Không tìm thấy nội dung: {url}")

    # Xóa <ins> và <iframe> nhưng giữ nguyên tất cả các thẻ khác
    for tag_name in ["ins", "iframe"]:
        for t in content_tag.find_all(tag_name):
            t.decompose()  # xóa hoàn toàn thẻ

    # Lấy nguyên HTML bên trong content_tag
    html_content = content_tag.decode_contents(formatter="html")

    ten_file = url.rstrip("/").split("/")[-1].replace("-", "_")

    return ten_file, title, html_content


def build_epub(chapters):

    book = epub.EpubBook()

    book.set_identifier("kiem-tien-o-day")
    book.set_title("Kiếm Tiên Ở Đây")
    book.set_language("vi")

    epub_chapters = []

    for idx, url in enumerate(tqdm(chapters)):

        try:
            ten_file, title, content = extract_chapter(url)

            chapter = epub.EpubHtml(
                title=title,
                file_name=f"{ten_file}.xhtml",
                lang="vi"
            )

            chapter.content = f"""
            <h1>{title}</h1>
            {content}
            """

            book.add_item(chapter)
            epub_chapters.append(chapter)

            time.sleep(0.3)

        except Exception as e:
            print("\nLỗi:", e)

    book.toc = tuple(epub_chapters)

    book.spine = ["nav"] + epub_chapters

    book.add_item(epub.EpubNcx())
    book.add_item(epub.EpubNav())

    epub.write_epub(
        "KiemTienODay.epub",
        book
    )

    print("Đã tạo EPUB")


def main():

    chapters = find_all_chapter_links()

    chapters.sort(
        key=lambda x: int(
            re.findall(r"chuong-(\d+)", x)[0]
        )
        if re.findall(r"chuong-(\d+)", x)
        else 0
    )

    build_epub(chapters)


if __name__ == "__main__":
    main()