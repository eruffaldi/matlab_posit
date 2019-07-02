addpath halfprecision/
n8 = arrayfun(@(x) {8,x,sprintf('positint8_t,8,%d,uint16_t,false.bin',x)},0:3,'UniformOutput',false);
p8 = cellvcat(cellfun(@(x) loadpositdump(['../build/' x{3}],x{1},x{2}),n8,'UniformOutput',false));

%%
n10 = arrayfun(@(x) {10,x,sprintf('positint16_t,10,%d,uint16_t,false.bin',x)},0:3,'UniformOutput',false);
 p10 = cellvcat(cellfun(@(x) loadpositdump(['../build/' x{3}],x{1},x{2}),n10,'UniformOutput',false));

%%
n12 = arrayfun(@(x) {12,x,sprintf('positint16_t,12,%d,uint16_t,false.bin',x)},0:4,'UniformOutput',false);
p12 = cellvcat(cellfun(@(x) loadpositdump(['../build/' x{3}],x{1},x{2}),n12,'UniformOutput',false));

%%
[u,h] = halfinrange(-10,10);      
tf16=dump2table([-length(u)/2:(length(u)/2-1);cast(u,'double');h]');
tf16.bits=16;
tf16.es=0;
tf16.what=categorical({'float'},{'posit','float','valid'})
f16=tf16;
%%
p12e=[f16;p12];
p10e=[f16;p10];

%%
qss={p8,p10,p12,f16};
%%
    colors =[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];[0,1,1]];

%%
for K=1:length(qss)
    qs=qss{K};
    figure;
    s=[];
    h=[];
    for I=1:length(qs)
        pd=qs(I,:);
        p=double(pd.data{1});
        usenan=false;
        h(I)=plot(p(:,1),p(:,3),'Color',colors(I,:));
        hold on
        plot(p(:,1),p(:,3),['*'],'Color',colors(I,:));
        if pd.what=='float'
         s{I} =sprintf('float16');
        else
         s{end+1} =sprintf('posit%d es=%d',pd.bits,pd.es);
        end
    ylim([-10,10]);
    end
    yl =ylim;
    title(sprintf('Posits %d bits with Y limit %f %f',bits,yl(1),yl(2)));

    hold off
    legend(h,s);
end

%%

% 
% size(u)
% plot(h)
% hold on
% plot(h,'*');
% yl =ylim;
% title(sprintf('float16 in range %f %f',yl(1),yl(2)));

%%
qss={p10e};
%%
for K=1:length(qss)
    qs=qss{K};
    figure;

    s={};
    h=[];
    for I=1:height(qs)
        bits =qs.bits(I);
        isfloatx = qs.what(I) == 'float';
        es=qs.es(I);
        usenan=false;
        h(I)=plot(p.float{I},p.res{I},'Color',colors(I,:));
        hold on
        plot(p(:,3),p(:,4),['.'],'Color',colors(I,:));
        if isfloatx
            s{I} =sprintf('float%d',bits);
        else
            s{I} = sprintf('posit%d es %d',bits,es);
        end
    end
    xlabel('Value');
    ylabel('Resolution');
    legend(h,s);
    hold off
    xlim([-10,10]);
end
