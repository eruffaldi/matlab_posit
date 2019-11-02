N=8;
e=0;
mv=2^(N-1);
tn='int8';
ut = @uint8;
invbit = typecast(ut(2^(N-2)),tn);
onep = invbit;
onepm = bitcmp(invbit)-1;
half = invbit/2;
two = bitor(half,invbit);
%pv = int16(-2^(N-1):2^(N-1)-1);
pv = typecast(ut(0:2^N-1),tn)';
prv = bitshift(pv,-1); % by r1
iprv = invbit+prv;
fs=bitshift(iprv,-1);
%plot([pv,prv,iprv,fs])
plot(pv,pv);
hold on
plot(pv,prv);
plot(pv,fs);
yticks(-mv:16:mv);
xticks(-mv:16:mv);
hold on
xl = xlim;
yl = ylim;
line([xl NaN double(onep) double(onep)],[double(onep),double(onep),NaN, yl],'LineStyle','--');
line([xl NaN,double(half),double(half)],[double(half),double(half),NaN,yl],'LineStyle','--','Color','green');
line([xl NaN,double(two),double(two)],[double(two),double(two),NaN,yl],'LineStyle','--','Color','red');
%legend({'x','x>>1','pinv+(x>>1)','fastsigmu','one'});
legend({'x','x>>1','pseudo','one','half','two'},'Location','northwest');
hold off

%%
scatter(pv,prv);
xlabel('x');
ylabel('x >> 1');
xl=xlim;
yl=ylim;
xticks(-mv:16:mv);
yticks(-mv:16:mv);
line([0 0],yl,'LineStyle','--','Color','red');
line(xl,[0 0],'LineStyle','--','Color','red');
line([onep onep],yl,'LineStyle','--');
line(xl,[onep onep],'LineStyle','--');
line([onepm onepm],yl,'LineStyle','--');
line(xl,[onepm onepm],'LineStyle','--');

 
%%                                                                               
%t = linspace(0,2*pi,2^N)-pi/2;                                                                                                                                                       
%ipv = @(x) t(typecast(x,'uint16'));
%r = 10;
%scatter(r*cos(ipv(pv)),r*sin(ipv(pv)),[],pv);