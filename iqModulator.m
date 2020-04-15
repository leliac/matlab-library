function x=iqModulator(fc,xI,xQ,f0)
    Tc=1/fc;
    t=(0:Tc:(length(xI)-1)*Tc)';
    x=xI.*cos(2*pi*f0*t)-xQ.*sin(2*pi*f0*t);
end