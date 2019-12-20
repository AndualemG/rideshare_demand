function [F_d,F_mod]=CompareFlows(OD,OD_d)
[m,n]=size(OD_d);
F_mod=[];
F_d=[];
t=0;
for i=1:m
    if (OD_d(i,3)>0&&OD_d(i,4)>1.0) %%% treshold by distance
       t=t+1; 
       F_d(t)=OD_d(i,3);
       index=find(OD(:,1)==OD_d(i,1)&OD(:,2)==OD_d(i,2));
       F_mod(t)=OD(index,3);
    end
end
loglog(F_d,F_mod,'ro')
hold 'on'
loglog(F_d,F_d,'b-')
set(gca,'FontName','Times New Roman','FontSize',20)
xlabel('T_{ij} (Data)','FontName','Times New Roman','FontSize',20)
ylabel('T_{ij} (Radiation Model)','FontName','Times New Roman','FontSize',20)

xlim([min(F_d) max(F_d)])
ylim([min(F_d) max(F_d)])
