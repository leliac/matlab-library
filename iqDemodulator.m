function [xI,xQ]=iqDemodulator(fc,x,f0)
    Tc=1/fc;
    t=(0:Tc:(length(x)-1)*Tc)';
    xI=cos(2*pi*f0*t).*x;
    xQ=sin(2*pi*f0*t).*x;
end