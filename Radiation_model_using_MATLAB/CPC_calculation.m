%Filter the data
OD_filtered = OD((OD(:,3)>=1), :);
od_census_filtered = od_census((od_census(:,3)>=1), :);
[vec,index] = ismember(od_census_filtered(:,1:2),OD_filtered(:,1:2),'rows');
OD_filtered = OD_filtered(index(vec),:);
od_census_filtered = od_census_filtered(vec,:);
%Do the scatter plot on the filtered data which should run a lot faster
%figure()
%CompareFlows(OD_filtered, od_census_filtered);
%%
T_census    = od_census_filtered(:,3);
T_simulated = OD_filtered(:,3);
cpc = 2 .* sum(min(T_census,T_simulated))./ (sum(T_census) + sum(T_simulated));
fprintf('\nCPC = %.5f\n', cpc);
%%
Final=zeros(size(OD_filtered,1),3);
Final(:,1:2)=OD_filtered(:,1:2);
Final(:,3)=CPC(:,1);
%%
%%%For each origin and destination pair, calculate CPC for the simulated flow and actual census flow 
[rows,col] = size(OD_filtered);
CPC = zeros(rows,1);
for i=1:rows

    flow_census    = od_census_filtered(i,3);
    flow_simulated = OD_filtered(i,3);
    
    %No need for "sum" since we are doing individual pairs
    CPC(i) = 2 * (min(flow_census,flow_simulated)) / ((flow_census) + (flow_simulated));
    
    %fprintf('CPC calculation: i = %i , from total %i\n', i, rows);
    
end
figure
[N,edges] = histcounts(CPC,'Normalization','probability');
plot(edges(1:size(edges,2)-1),N);
xlabel('CPC','FontName','Times New Roman','FontSize',20)
ylabel('P(CPC)','FontName','Times New Roman','FontSize',20)

%%
Final=zeros(size(OD_filtered,1),3);
Final(:,1:2)=OD_filtered(:,1:2);
Final(:,3)=CPC(:,1);
%%
Sorted=sortrows(Final,3);
%%
min=Sorted(1,:);
max=Sorted(end,:);
%%
mn=mean(Sorted(:,3));
x=zeros(size(Sorted,1),4);
x(:,1:3)=Sorted;
x(:,4)=abs(Sorted(:,3)-mn);
ave=sortrows(x,4);
Ave=ave(1,:);
%%
F=zeros(size(THE_NODES,1),2);
for i=1:size(THE_NODES,1);
    F(i,2)=i;
    %F(i,1)=THE_NODES(i,1);
end
F(:,1)=THE_NODES(:,1);
%%
min_ave_max=zeros(6,3);
for i=1:size(F,1);
    if F(i,2)==1;
        min_ave_max(1,1)=F(i,1)
    elseif F(i,2)==10;
        min_ave_max(2,1)=F(i,1);
    elseif F(i,2)==11;
        min_ave_max(3,1)=F(i,1);
    elseif F(i,2)==7;
        min_ave_max(4,1)=F(i,1);
        min_ave_max(5,1)=F(i,1);
    elseif F(i,2)==8;
        min_ave_max(6,1)=F(i,1);
    end
end
%%
for i=1:size(THE_NODES,1);
    for j=1:size(min_ave_max,1);
        if min_ave_max(j,1)==THE_NODES(i,1);
            min_ave_max(j,2)=THE_NODES(i,3)
            min_ave_max(j,3)=THE_NODES(i,4)
        end
    end
end
%%
load ('THE_NODES.txt');
%%
l=min_ave_max;
figure
plot(THE_NODES(:,4),THE_NODES(:,3),'k.');
hold on
%
%figure
%plot(CH_NODES(:,4),CH_NODES(:,3),'r.');
%

plot(CH_NODES(:,4),CH_NODES(:,3),'m.');
hold on
plot([l(1,3) l(2,3)],[l(1,2) l(2,2)],'ro');
hold on
plot([l(1,3) l(2,3)],[l(1,2) l(2,2)],'r');
hold on
plot([l(3,3) l(4,3)],[l(3,2) l(4,2)],'bo');
hold on
plot([l(3,3) l(4,3)],[l(3,2) l(4,2)],'b');
hold on
plot([l(5,3) l(6,3)],[l(5,2) l(6,2)],'go');
hold on
plot([l(5,3) l(6,3)],[l(5,2) l(6,2)],'g');
%plot((l(1,3),l(2,3)),(l(1,2),l(2,2)),'r+');