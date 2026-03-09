from pathlib import Path
W=print
m=len
u=int
S=enumerate
I=open
E=True
O=input
import shutil
X=shutil.rmtree
import requests
d=requests.get
from bs4 import BeautifulSoup
from urllib.parse import urljoin,urlparse
from PIL import Image
HEADERS={"User-Agent":"Mozilla/5.0","Referer":"https://taphuan.olm.vn/"}
IMG_BASE_URL="https://cdn3.olm.vn/"
def b(URL):
 W("\nFetching page...")
 res=d(URL,headers=HEADERS)
 res.raise_for_status()
 soup=BeautifulSoup(res.text,"html.parser")
 image_urls=[]
 for img in soup.select("#reader img"):
  src=img.get("data-src")or img.get("src")
  if src:
   image_urls.append(urljoin(IMG_BASE_URL,src))
 W("Total images found:\033[33m",m(image_urls),"\033[0m")
 return image_urls
def P(i,total):
 percent=i/total
 bar_length=40
 filled=u(bar_length*percent)
 fPercentage=f" {percent*100:5.1f}% "
 half_bar=bar_length//2
 if(percent<0.5):
  bar="#"*filled+"-"*(half_bar-filled)+fPercentage+"-"*half_bar
 else:
  bar="#"*half_bar+fPercentage+"#"*(filled-half_bar)+"-"*(bar_length-filled)
 GREEN="\033[32m"
 RESET="\033[0m"
 W(f"{GREEN}\r[{bar}] {i}/{total} {RESET}",end="")
def h(image_urls,IMAGE_DIR):
 W("\nDownloading images...")
 files=[]
 img_len=m(image_urls)
 for i,url in S(image_urls):
  P(i+1,img_len)
  r=d(url,headers=HEADERS)
  filename=IMAGE_DIR/f"{i:03}.jpg"
  with I(filename,"wb")as f:
   f.write(r.content)
  files.append(filename)
 return files
def J(files,PDF_FILE):
 W("\n\nCreating PDF...\nAdding images to PDF...")
 images=[]
 i=1
 for f in files:
  img=Image.open(f).convert("RGB")
  images.append(img)
  P(i,m(files))
  i+=1
 if images:
  images[0].save(PDF_FILE,save_all=E,append_images=images[1:])
 W("\nPDF created:\033[33m",PDF_FILE,"\033[0m")
def x(IMAGE_DIR):
 choice="y"
 if choice=="y":
  X(IMAGE_DIR)
  W("\n\033[31mTemplate Image folder deleted.\033[0m")
 else:
  W("\n\033[32mTemplate Images kept.\033[0m")
def R():
 BASE_DIR=Path(__file__).resolve().parent
 DEFAULT_URL="https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"
 user_input=O("Enter book URL (press Enter for default): ").strip()
 URL=user_input if user_input else DEFAULT_URL
 W("Using URL:",URL)
 path=urlparse(URL).path
 slug=Path(path).name
 name=slug.split(".")[0]
 IMAGE_DIR=BASE_DIR/name
 PDF_FILE=BASE_DIR/f"{name}.pdf"
 IMAGE_DIR.mkdir(parents=E,exist_ok=E)
 urls=b(URL)
 if not urls:
  W("No images found. The page may require JavaScript.")
  return
 files=h(urls,IMAGE_DIR)
 J(files,PDF_FILE)
 x(IMAGE_DIR)
if __name__=="__main__":
 R()
