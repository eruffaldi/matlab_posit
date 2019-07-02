
%%
ra=100:1000:1e8;
[m,f]=floatpre('double',[],ra);
plot([m;f]')
hold on
[m2,f2]=floatpre('double',[],log2(ra));
plot([m;f2]')
hold on
legend({'naive max','naive ops','log2','logw2'})

%%
ra=0:1:int64(32767);
[m,f,Y,eraw]=floatpre('float16',[],ra); % export float
[~,~,raY]=floatpre('float16',[],Y); % export target type
goodexp=sum(eraw > 0 & eraw < eraw(end)); % safety check
sum(raY(goodexp) ==ra(goodexp)) == goodexp %  safety check
[mq,fq,Yq,erawq]=floatpre('float16',[],tanh(Y)); % export float
[ml,fl,Yl,erawl]=floatpre('float16',[],log2(Y)); % export float

figure(1)
hold on
plot([m;f]');
hold on
[ma,fa,Ya]=floatpre('float16alt',[],ra);
plot([ma;fa]');
plot([mq;fq]');
plot([ml;fl]');
hold off
legend({'float16 max','float16 min','float16alt max','float16alt min','tanh max','tanh min','log'});
xlabel('Exponent');
ylabel('Value');
figure(2)
subplot(1,2,1);
yyaxis left
plot(ra,Y)
yyaxis right
plot(ra,eraw)
legend({'float16'});
subplot(1,2,2);
plot(ra,Ya)
legend({'float16 alt'});
hold off

%%
ra=-100:1:100;
[m,f]=floatpre('float16',[],ra);
plot(ra,[m;f]');
hold on
[m,f]=floatpre('float16alt',[],ra);
plot(ra,[m;f]');
hold off
legend({'float16 max','float16 min','float16alt max','float16alt min'});

