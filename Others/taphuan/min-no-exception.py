from pathlib import Path
I=print
o=len
Y=int
e=enumerate
d=open
O=True
a=input
import shutil
i=shutil.rmtree
import requests
X=requests.get
from bs4 import BeautifulSoup
from urllib.parse import urljoin,urlparse
from PIL import Image
t={"User-Agent":"Mozilla/5.0","Referer":"https://taphuan.olm.vn/"}
l="https://cdn3.olm.vn/"
def m(C):
 I("\nFetching page...")
 g=X(C,headers=t)
 g.raise_for_status()
 r=BeautifulSoup(g.text,"html.parser")
 k=[]
 for D in r.select("#reader img"):
  F=D.get("data-src")or D.get("src")
  if F:
   k.append(urljoin(l,F))
 I("Total images found:\033[33m",o(k),"\033[0m")
 return k
def b(i,total):
 p=i/total
 W=40
 c=Y(W*p)
 w=f" {p*100:5.1f}% "
 E=W//2
 if(p<0.5):
  s="#"*c+"-"*(E-c)+w+"-"*E
 else:
  s="#"*E+w+"#"*(c-E)+"-"*(W-c)
 I(f"\033[32m\r[{s}] {i}/{total} \033[0m",end="")
def H(k,G):
 I("\nDownloading images...")
 n=[]
 q=o(k)
 for i,url in e(k):
  b(i+1,q)
  r=X(url,headers=t)
  M=G/f"{i:03}.jpg"
  with d(M,"wb")as f:
   f.write(r.content)
  n.append(M)
 return n
def V(n,S):
 I("\n\nCreating PDF...\nAdding images to PDF...")
 y=[]
 i=1
 for f in n:
  D=Image.open(f).convert("RGB")
  y.append(D)
  b(i,o(n))
  i+=1
 if y:
  y[0].save(S,save_all=O,append_images=y[1:])
 I("\nPDF created:\033[33m",S,"\033[0m")
def U(G):
 A="y"
 if A=="y":
  i(G)
  I("\n\033[31mTemplate Image folder deleted.\033[0m")
 else:
  I("\n\033[32mTemplate Images kept.\033[0m")
def T():
 j=Path(__file__).resolve().parent
 R="https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"
 B=a("Enter book URL (press Enter for default): ").strip()
 C=B if B else R
 I("Using URL:",C)
 L=urlparse(C).path
 u=Path(L).name
 K=u.split(".")[0]
 G=j/K
 S=j/f"{K}.pdf"
 G.mkdir(parents=O,exist_ok=O)
 P=m(C)
 if not P:
  I("No images found. The page may require JavaScript.")
  return
 n=H(P,G)
 V(n,S)
 U(G)
if __name__=="__main__":
 T()