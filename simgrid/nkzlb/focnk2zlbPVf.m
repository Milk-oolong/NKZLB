function f = focnk2zlbPVf(x0,rnpast,gnow,znow,rnow,ystar,coeffcn,coeffpn,coeffcb,coeffpb,coefrnn,ZLBflag,polyd,xmat,wmat,...
    pibar,gamma,beta,invnu,gbar,tau,phi,psi1,psi2,rhor,rhog,rhoz,rnss)

nghe = size(xmat,1);

c0  = x0(1,:);
pi0 = x0(2,:);

y0 = c0/(1/gbar/exp(gnow) - phi/2*(pi0-pibar)^2);
rn0 = rnpast^rhor*( rnss*(pi0/pibar)^psi1*(y0/ystar)^psi2 )^(1-rhor)*exp(rnow);

fc0 = 0.0;
fp0 = 0.0;
for ighe=1:nghe

    gp = rhog*gnow + xmat(ighe,1);
    zp = rhoz*znow + xmat(ighe,2);
    rp = xmat(ighe,3);
    
    rnp = makebas4([rn0 gp zp rp],polyd)*coefrnn;
    if (rnp>=1.0)    
        fcx = makebas4([rn0 gp zp rp],polyd)*coeffcn;
        fpx = makebas4([rn0 gp zp rp],polyd)*coeffpn;
    else
        fcx = makebas4([rn0 gp zp rp],polyd)*coeffcb;
        fpx = makebas4([rn0 gp zp rp],polyd)*coeffpb;
    end
    
    weight = wmat(ighe,1)*wmat(ighe,2)*wmat(ighe,3);
    fc0 = fc0 + weight*fcx;
    fp0 = fp0 + weight*fpx;

end

if (ZLBflag==1)
    f(1,:) = -c0^(-tau) + fc0;
else
    f(1,:) = -c0^(-tau) + rn0*fc0;
end
f(2,:) = ( (1-invnu)+invnu*c0^tau - phi*(pi0-pibar)*(pi0-.5*invnu*(pi0-pibar)) )*c0^(-tau)*y0 ...
    + fp0;