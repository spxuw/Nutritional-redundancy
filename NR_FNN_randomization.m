clear
clc

%% prepare the reference 
FNN_USDA=load('USDA_FNN_level3.csv');
FNN_USDA = double(logical(FNN_USDA))';
FNN_USDA(:,5) = []; % remove water
Food_distance = squareform(pdist(FNN_USDA,'jaccard'));

%% FNN of null models
FNN_table_NULL_1=Nullmodel_FNN(FNN_USDA,1);
FNN_table_NULL_2=Nullmodel_FNN(FNN_USDA,2);
FNN_table_NULL_3=Nullmodel_FNN(FNN_USDA,3);
FNN_table_NULL_4=Nullmodel_FNN(FNN_USDA,4);

Food_distance1 = squareform(pdist(FNN_table_NULL_1,'jaccard'));
Food_distance2 = squareform(pdist(FNN_table_NULL_2,'jaccard'));
Food_distance3 = squareform(pdist(FNN_table_NULL_3,'jaccard'));
Food_distance4 = squareform(pdist(FNN_table_NULL_4,'jaccard'));

%% NR of DMAS
NR_real=[]; NR_Null1=[]; NR_Null2=[]; NR_Null3=[]; NR_Null4=[];
Food_DMAS=load('Food_DMAS.mat');
Food_DMAS=Food_DMAS.DMASfood;
days=reshape(Food_DMAS(:,1),7618,length(Food_DMAS)/7618);
Food_DMAS=reshape(Food_DMAS(:,2),7618,length(Food_DMAS)/7618);
Food_DMAS = Food_DMAS./repmat(sum(Food_DMAS,1),7618,1);

s1=sum(logical(Food_DMAS),1);
s1=find(s1<2);
Food_DMAS(:,s1)=[];
days(:,s1)=[];

[FD_DMAS, ND_DMAS, NR_DMAS] = NDNR_Rao_q (Food_DMAS, Food_distance, 1);
NR_real=[NR_real NR_DMAS./FD_DMAS];
[FD_DMAS_null1, ND_DMAS_null1, NR_DMAS_null1] = NDNR_Rao_q (Food_DMAS, Food_distance1, 1);
NR_Null1=[NR_Null1 NR_DMAS_null1./FD_DMAS_null1];
[FD_DMAS_null2, ND_DMAS_null2, NR_DMAS_null2] = NDNR_Rao_q (Food_DMAS, Food_distance2, 1);
NR_Null2=[NR_Null2 NR_DMAS_null2./FD_DMAS_null2];
[FD_DMAS_null3, ND_DMAS_null3, NR_DMAS_null3] = NDNR_Rao_q (Food_DMAS, Food_distance3, 1);
NR_Null3=[NR_Null3 NR_DMAS_null3./FD_DMAS_null3];
[FD_DMAS_null4, ND_DMAS_null4, NR_DMAS_null4] = NDNR_Rao_q (Food_DMAS, Food_distance4, 1);
NR_Null4=[NR_Null4 NR_DMAS_null4./FD_DMAS_null4];

%% Figure of first day
m1 = find(days(1,:) == 1);
NR_real = NR_real(m1);
NR_Null1 = NR_Null1(m1);
NR_Null2 = NR_Null2(m1);
NR_Null3 = NR_Null3(m1);
NR_Null4 = NR_Null4(m1);

real_posi=1;
NULL_1_posi=2;
NULL_2_posi=3;
NULL_3_posi=4;
NULL_4_posi=5;

g_NR_real=[ones(1,length(NR_real))*real_posi(1)];
g_NR_NULL_1=[ones(1,length(NR_Null1))*NULL_1_posi(1)];
g_NR_NULL_2=[ones(1,length(NR_Null2))*NULL_2_posi(1)];
g_NR_NULL_3=[ones(1,length(NR_Null3))*NULL_3_posi(1)];
g_NR_NULL_4=[ones(1,length(NR_Null4))*NULL_4_posi(1)];

real_color=[59/255,59/255,59/255];
NULL_1_color=[0,0.45,0.74];
NULL_2_color=[0.85,0.33,0.1];
NULL_3_color=[0.47,0.67,0.19];
NULL_4_color=[0.93,0.69,0.13];

figure('position',[537 713 977/5*3/4 420*2/3]);
hold on;
boxplot(NR_real,g_NR_real,'color',real_color,'positions',real_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null1,g_NR_NULL_1,'color',NULL_1_color,'positions',NULL_1_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null2,g_NR_NULL_2,'color',NULL_2_color,'positions',NULL_2_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null3,g_NR_NULL_3,'color',NULL_3_color,'positions',NULL_3_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null4,g_NR_NULL_4,'color',NULL_4_color,'positions',NULL_4_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);

set(gca,'fontsize',10)
set(gca,'XTickLabel',{' '});
set(gca,'ylim',[0,0.8]);
set(gca,'xlim',[-2,8]);
set(gca,'xtick',[]);
