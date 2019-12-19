% CYPLAN 257 FINAL PROJECT
%Radiation Model
LLN = table2array(readtable('LL.csv'));
POPN = table2array(readtable('POPf.csv'));
POIN = table2array(readtable('POPIf.csv'));
Mon = table2array(readtable('Mon.csv'));
Tue = table2array(readtable('Tue.csv'));
Wed = table2array(readtable('Wed.csv'));
Thu = table2array(readtable('Thu.csv'));
%%
POP(:,1)=POPN(:,2);
POP(:,2)=floor(POPN(:,3));
POI(:,1)=POIN(:,2);
POI(:,2)=POIN(:,3);
%%
norm_num=sum(Mon(:,4))
dist_cell=zeros(size(LL,1),size(LL,1));
for j=1:size(LL,1);
    for k=1:size(LL,1);
        dist_cell(j,k)=pos2dist(LL(j,4),LL(j,3),LL(k,4),LL(k,3),1);
    end
end

%%
% od_census calculation
od_2=Mon(:,2:4);
od_census=zeros(size(od_2,1),4);
F=zeros(size(POP,1),2);
for i=1:size(POP,1);
    F(i,2)=i;
    %F(i,1)=THE_NODES(i,1);
end
F(:,1)=POP(:,1);
%%

for i=1:size(od_2,1);
    for j=1:size(POP,1)
        if od_2(i,1)==F(j,1);
            od_census(i,1)=F(j,2);
        end
        if od_2(i,2)==F(j,1);
            od_census(i,2)=F(j,2);
        end
    end
end
od_census(:,3)=od_2(:,3);
for i=1:size(POP,1);
    od_census(i,4)=dist_cell(od_census(i,1),od_census(i,2));
end


%%
%EXTENDED RADIATION MODEL
%%% Trip production


disp(norm_num)
p=sum(POP(:,2));
disp(p)%enter the desired total trip number here
alpha=0.1%1.1305%1.797385; % the alpha value for the extended radiation model
%load the distance matrix, population and POI distribution
[m,n]=size(dist_cell);
O=POP; %population representing generation
D=POI; %POI representing attraction
%sumO=sumD
sumD=sum(D);
sumO=sum(O);
D=D.*norm_num./sumD; %fraction of POIS escaled to the total trip production
O=O.*norm_num./sumO; %fraction of Trips escaled to the total trip production
%Initialize the output OD matrix
OD=zeros(m*(m-1),4);
OD_num=0;
for i=1:m
    prop=zeros(m,1);
    dist=zeros(m,1);
    for j=1:m
        if i~=j
            %calculate Sij
            dist(j)=dist_cell(i,j);
            index=find(dist_cell(i,:)<dist(j)&dist_cell(i,:)>0);
            s=sum(D(index));
            prop(j)=(D(i)^alpha+1)*((D(i)+s+D(j))^alpha-(D(i)+s)^alpha)/(((D(i)+s)^alpha+1)*((D(i)+s+D(j))^alpha+1));
        end
    end
    for j=1:m
        if i~=j
            OD_num=OD_num+1;
            OD(OD_num,1)=i;  %id o
            OD(OD_num,2)=j;  %id dest
            OD(OD_num,3)=O(i)*prop(j)/sum(prop); %trips from i to j
            OD(OD_num,4)=dist(j); %distance DD
            OD(OD_num,5)=O(i);  % Trips from O
            OD(OD_num,6)=D(j);  % Trips from I
        end
    end
end
%%
save OD.mat OD 
                    
%%
figure
CompareFlows(OD,od_census);
title('Flow comparison')
%%

figure
[x1,y1]=CalcFlows(od_census,'o-','k');
hold on;
[x2,y2]=CalcFlows(OD,'^-','b');
legend('Data','Radiation Model','Location','southwest')
set(gca,'FontName','Times New Roman','FontSize',20)
title('Number of Trips vs distance')
%%
disp(sum(POP(:,2)));
disp(sum(POI(:,2)));
disp(norm_num);
%%
figure
plot(LL(:,4),LL(:,3),'k.');
%%
save Monday.csv  Monday 
