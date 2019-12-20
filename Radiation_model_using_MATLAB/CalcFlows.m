function [x P]=CalcFlows(OD,marker,color)
[m,n]=size(OD);
x=[];
y=[];
Fl=[];
Ds=[];
t=0;
for i=1:m
    if (OD(i,4)>1.0&&OD(i,3)>0)
       t=t+1; 
       Fl(t)=OD(i,3);
       Ds(t)=OD(i,4);
    end
end
[x,P]=lnbin(Ds,Fl,50);
loglog(x,P/sum(P),[color,marker],'MarkerEdgeColor',color,'MarkerSize',6,'MarkerFaceColor',color,'linewidth',0.75);
set(gca,'FontName','Times New Roman','FontSize',20)
xlabel('Distance (km), r','FontName','Times New Roman','FontSize',20)
ylabel('P(r)','FontName','Times New Roman','FontSize',20)