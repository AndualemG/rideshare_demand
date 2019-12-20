
%extended radiation model
%%% Trip production
norm_num=sum(N_num_mat(:,1));
disp(norm_num)
p=sum(pop(:,1));
disp(p)%enter the desired total trip number here
alpha=0.6%1.1305%1.797385; % the alpha value for the extended radiation model
%load the distance matrix, population and POI distribution
[m,n]=size(dist_cell);
O=pop; %population representing generation
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
sum(pop)
%%
sum(POI);
sum(O);
sum(D);
norm_num

                    