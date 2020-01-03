#include "io.h"
#define ll long long
#define rint register int

  const int mod=998244353, gen=3;
  
  ll K(ll x,int y){
    ll t=1;
    for (;y;y>>=1,x=x*x%mod) if (y&1) t=t*x%mod;
    return t;
  }
  int up(int x){
    return x>=mod? x-mod: x;
  }
  int dn(int x){
    return x<0? x+mod: x;
  }
 
  int dp[2101];
  void fft(int *a,int n){
    dp[0]=0;
    int i, j, b;
    for (i=1;i<(1<<n);++i){
      dp[i]= j= i&1? dp[i-1]+(1<<n>>1): dp[i>>1]>>1;
      if (i<j){
      	int t=a[i];	a[i]=a[j]; a[j]=t;
      }
    }
    for (b=0;b<n;++b){
      int len1=1<<b, len2=1<<(b+1), w0=K(gen,(mod-1)/len2);
      for (i=0;i<(1<<n);i+=len2){
        int *l=a+i, *r=a+i+len1; int w=1, tmp;
        for (j=0;j<len1;++j){
          tmp=(ll)w*r[j]%mod;
          r[j]=dn(l[j]-tmp);
          l[j]=up(l[j]+tmp);
          w=(ll)w*w0%mod;
        }
      }
    }
  }
 
  void realmain(int *a,int *b,int la,int lb){
    ++la, ++lb; int len=la+lb;
    int n=0, i, j; for (;len>(1<<n);) ++n;
    for (i=la;i<(1<<n);++i) a[i]=0;
    for (i=lb;i<(1<<n);++i) b[i]=0;
    fft(a,n); fft(b,n);
    for (i=0;i<(1<<n);++i) a[i]=(ll)a[i]*b[i]%mod;
    //reverse(a+1,a+(1<<n));
    for (i=1;;++i){
    	j=(1<<n)-i;
		if (i<j) {
	      	int t=a[i];	a[i]=a[j]; a[j]=t;
	    }else break;	
    }
    
    fft(a,n); ll inv=K(1<<n,mod-2);
    for (i=0;i<(1<<n);++i) a[i]=(ll)a[i]*inv%mod;
  }

int A[2101], B[2101];

void poly_multiply(unsigned *a, int n, unsigned *b, int m, unsigned *c)
{
	int i;
	for (i=0;i<=n;++i) A[i]=a[i];
	for (i=0;i<=m;++i) B[i]=b[i];
	realmain(A,B,n,m);
	for (i=0;i<=n+m;++i) c[i]=A[i];
}

unsigned a[2101], b[2101], c[2101];
int main(){
	int n=1, m=2;
	/*
	a[0]=1; a[1]=2;
	b[0]=1; b[1]=2; b[2]=1;
	poly_multiply(a,n,b,m,c);
	int i; for (i=0;i<=3;++i) printf("%d ",c[i]);
	*/
	n=inl();
        m=inl();
	int i;
	for (i=0;i<=n;++i) a[i]=inl();
	for (i=0;i<=m;++i) b[i]=inl();
	poly_multiply(a,n,b,m,c);
	for (i=0;i<=n + m;++i) outl(c[i]), outb(' '), sleep(1);
}
