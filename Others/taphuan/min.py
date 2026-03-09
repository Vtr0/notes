from pathlib import Path
U=print
t=len
J=int
g=enumerate
p=open
O=True
C=input
import shutil
f=shutil.rmtree
import requests
S=requests.RequestException
x=requests.get
from bs4 import BeautifulSoup
from urllib.parse import urljoin,urlparse
from PIL import Image
l={"User-Agent":"Mozilla/5.0","Referer":"https://taphuan.olm.vn/"}
G="https://cdn3.olm.vn/"
def z(X):
 U("\nFetching page...")
 try:
  w=x(X,headers=l)
  w.raise_for_status()
 except S as e:
  U(f"\n\033[31mError fetching page: {e}.\033[0m")
  return[]
 d=BeautifulSoup(w.text,"html.parser")
 R=[]
 for F in d.select("#reader img"):
  H=F.get("data-src")or F.get("src")
  if H:
   R.append(urljoin(G,H))
 U("Total images found:\033[33m",t(R),"\033[0m")
 return R
def k(i,total):
 W=i/total
 P=40
 N=J(P*W)
 L=f" {W*100:5.1f}% "
 T=P//2
 if(W<0.5):
  h="#"*N+"-"*(T-N)+L+"-"*T
 else:
  h="#"*T+L+"#"*(N-T)+"-"*(P-N)
 U(f"\033[32m\r[{h}] {i}/{total} \033[0m",end="")
def D(R,A):
 U("\nDownloading images...")
 b=[]
 n=t(R)
 for i,url in g(R):
  k(i+1,n)
  try:
   r=x(url,headers=l)
   r.raise_for_status()
  except S as e:
   U(f"\nError downloading image {i+1}: \033[31m{e}.\033[0m")
   return[]
  V=A/f"{i:03}.jpg"
  with p(V,"wb")as f:
   f.write(r.content)
  b.append(V)
 return b
def ix(b,K):
 U("\n\nCreating PDF...\nAdding images to PDF...")
 E=[]
 i=1
 for f in b:
  F=Image.open(f).convert("RGB")
  E.append(F)
  k(i,t(b))
  i+=1
 if E:
  E[0].save(K,save_all=O,append_images=E[1:])
 U("\nPDF created:\033[33m",K,"\033[0m")
def r(A):
 s="y"
 if s=="y":
  f(A)
  U("\n\033[31mTemplate Image folder deleted.\033[0m")
 else:
  U("\n\033[32mTemplate Images kept.\033[0m")
def B():
 m=Path(__file__).resolve().parent
 a="https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"
 e=C("Enter book URL (press Enter for default): ").strip()
 X=e if e else a
 U("Using URL:",X)
 Q=urlparse(X).path
 c=Path(Q).name
 M=c.split(".")[0]
 A=m/M
 K=m/f"{M}.pdf"
 A.mkdir(parents=O,exist_ok=O)
 y=z(X)
 if not y:
  U("No images found. The page may require JavaScript.")
  return
 b=D(y,A)
 ix(b,K)
 r(A)
if __name__=="__main__":
 B()