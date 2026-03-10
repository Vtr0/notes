from pathlib import Path
import shutil,requests,time
V=print;m=len;J=int;X=True;K=enumerate;b=open;M=input;j=shutil.rmtree;v=requests.RequestException;d=requests.get;C=time.perf_counter;gm=1024*1024
from bs4 import BeautifulSoup
from urllib.parse import urljoin,urlparse
from PIL import Image
F={"User-Agent":"Mozilla/5.0","Referer":"https://taphuan.olm.vn/"}
Q="https://cdn3.olm.vn/"
def z(k):
 V("\nFetching page...")
 try:
  Y=d(k,headers=F)
  Y.raise_for_status()
 except v as e:
  V(f"\n\033[31mError fetching page: {e}.\033[0m")
  return[]
 N=BeautifulSoup(Y.text,"html.parser")
 L=[]
 for u in N.select("#reader img"):
  R=u.get("data-src")or u.get("src")
  if R:
   L.append(urljoin(Q,R))
 V("Total images found:\033[33m",m(L),"\033[0m")
 return L
def H(i,t,a=""):
 G=i/t
 W=40
 x=J(W*G)
 B=f" {G*100:5.1f}% "
 f=W//2
 if(G<0.5): o="█"*x+"░"*(f-x)+B+"░"*f
 else: o="█"*f+B+"█"*(x-f)+"░"*(W-x)
 V(f"\033[32m\r|{o}| \033[36m{i:>3}/{t} \033[0m{a}",end="")
def l(L,P):
 V("\nDownloading images...")
 P.mkdir(parents=X,exist_ok=X)
 c=[]
 E=0
 q=C()
 T=m(L)
 for i,u in K(L):
  try:
   r=d(u,headers=F)
   r.raise_for_status()
  except v as e:
   V(f"\nError downloading image {i+1}: \033[31m{e}.\033[0m")
   return[]
  n=P/f"{i:03}.jpg"
  with b(n,"wb")as f:
   f.write(r.content)
  c.append(n)
  e=C()-q
  E+=m(r.content)
  S=E/e if e>0 else 0
  w=S/gm
  A=f" (\033[33m{E/gm:.2f} MB\033[0m – \033[35m{w:.2f} MB/s\033[0m)"
  H(i+1,T,A)
 return c
def a(c,h):
 V("\n\nCreating PDF...\nAdding images to PDF...")
 t=[]
 i=1
 E=0
 for f in c:
  u=Image.open(f).convert("RGB")
  t.append(u)
  E+=f.stat().st_size
  H(i,m(c),f" (\033[33m{E/gm:.2f} MB\033[0m)")
  i+=1
 if t:
  t[0].save(h,save_all=X,append_images=t[1:])
 V("\nPDF created:\033[33m",h,"\033[0m",f" (\033[36m{h.stat().st_size/gm:.2f} MB\033[0m)")
def g(P):
 p="y"
 if p=="y":
  j(P)
  V("\n\033[31mTemplate Image folder deleted.\033[0m")
 else:
  V("\n\033[32mTemplate Images kept.\033[0m")
def O():
 U=Path(__file__).resolve().parent
 I="https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"
 i=M("Enter book URL (press Enter for default): ").strip()
 k=i if i else I
 V("Using URL:\033[33m",k,"\033[0m")
 r=urlparse(k).path;s=Path(r).name;y=s.split(".")[0]
 P=U/y;h=U/f"{y}.pdf"
 D=z(k)
 if not D:
  V("\n\033[31mNo images found. The page may require JavaScript.\033[0m")
  return
 c=l(D,P)
 if not c:
  V("\n\033[31mNo PDF created.\033[0m")
  g(P)
  return
 a(c,h)
 g(P)
if __name__=="__main__":
 O()