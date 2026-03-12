import time,shutil,requests,itertools,threading,time;from pathlib import Path;from bs4 import BeautifulSoup;from urllib.parse import urljoin,urlparse;from PIL import Image;from contextlib import contextmanager
W=print;n=True;vL=len;vP=int;vc=enumerate;vR=open;vl=input;E=time.perf_counter;A=time.sleep;N=shutil.rmtree;g=requests.RequestException;q=requests.get;gm=1024*1024
v={"User-Agent":"Mozilla/5.0","Referer":"https://taphuan.olm.vn/"};L="https://cdn3.olm.vn/"
@contextmanager
def s(message="Working"):
 E=time.perf_counter
 A=time.sleep
 P=threading.Event()
 def z():
  for c in itertools.cycle("⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"):
   if P.is_set():
    break
   W(f"\r{message} {c} ",end="",flush=n)
   A(0.1)
 c=threading.Thread(target=z)
 c.start()
 try:
  yield
 finally:
  P.set()
  c.join()
  W(f"\r{message} Done\n",end="",flush=n)
def X(u):
 W("\nExtracting image URLs from page...")
 with s("Fetching page"):
  try:
   R=q(u,headers=v)
   R.raise_for_status()
  except g as e:
   W(f"\n\033[31mError fetching page: {e}.\033[0m")
   return[]
  l=BeautifulSoup(R.text,"html.parser")
 S=[]
 for V in l.select("#reader img"):
  t=V.get("data-src")or V.get("src")
  if t:
   S.append(urljoin(L,t))
 W("Total images found:\033[33m",vL(S),"\033[0m")
 return S
def f(i,total,additionStr=""):
 Q=i/total;Y=40;H=vP(Y*Q);y=f" {Q:^6.1%} ";w=Y//2
 C="█"*H+"░"*(w-H)+y+"░"*w if(Q<0.5) else "█"*w+y+"█"*(H-w)+"░"*(Y-H)
 W(f"\033[32m\r|{C}| \033[36m{i:>3}/{total} \033[0m{additionStr} ",end="")
def G(S,D):
 W("\nDownloading images...")
 D.mkdir(parents=n,exist_ok=n)
 j=[];m=0;I=E();a=vL(S)
 for i,url in vc(S):
  try:
   r=q(url,headers=v)
   r.raise_for_status()
  except g as e:
   W(f"\nError downloading image {i+1}: \033[31m{e}.\033[0m")
   return[]
  o=D/f"{i:03}.jpg"
  with vR(o,"wb")as fv:
   fv.write(r.content)
  j.append(o)
  x=E()-I;m+=vL(r.content);T=m/x if x>0 else 0;F=T/gm
  b=f" (\033[33m{m/gm:.2f} MB\033[0m – 🌐 \033[38;5;46m{F:.2f} MB/s\033[0m)"
  f(i+1,a,b)
 return j
def K(j,U):
 W("\n\nCreating PDF...\nAdding images to PDF...")
 k=[];i=1;m=0
 for fv in j:
  V=Image.open(fv).convert("RGB")
  k.append(V)
  m+=fv.stat().st_size
  f(i,vL(j),f" (\033[33m{m/gm:.2f} MB\033[0m)")
  i+=1
 W("\n")
 with s("Packaging PDF"):
  if k:k[0].save(U,save_all=n,append_images=k[1:])
 W("\n📁 PDF created:\033[33m",U,"\033[0m",f" (\033[36m{U.stat().st_size/gm:.2f} MB\033[0m)")
def M(D):
 d="y"
 if d=="y":N(D);W("\n\033[31mTemplate Image folder deleted.\033[0m")
 else:W("\n\033[32mTemplate Images kept.\033[0m")
def O():
 i=Path(__file__).resolve().parent
 h="https://taphuan.olm.vn/tap-huan/doc-sach/shs-cong-nghe-3.4538694745#page=0"
 J=vl("Enter book URL (press Enter for default): ").strip()
 u=J if J else h
 W("Using URL:\033[33m",u,"\033[0m")
 e=urlparse(u).path;r=Path(e).name;p=r.split(".")[0];D=i/p;U=i/f"{p}.pdf"
 B=X(u)
 if not B:W("\n\033[31mNo images found. The page may require JavaScript.\033[0m");return
 j=G(B,D)
 if not j:W("\n\033[31mNo PDF created.\033[0m");M(D);return
 K(j,U)
 M(D)
if __name__=="__main__":
 O()