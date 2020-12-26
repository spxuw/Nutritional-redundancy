clear
clc

%% prepare the reference 
FNN_UFDA=load('USDA_FNN_level3.csv');
FNN_UFDA = double(logical(FNN_UFDA))';
FNN_UFDA(:,5) = []; % remove water
Food_distance = squareform(pdist(FNN_UFDA,'jaccard'));

%% NR of DMAS
NR_real=[];NR_Null1=[];NR_Null2=[];NR_Null3=[];
Food_DMAS=load('Food_DMAS.mat');
Food_DMAS=Food_DMAS.DMASfood;
days=reshape(Food_DMAS(:,1),7618,length(Food_DMAS)/7618);
Food_DMAS=reshape(Food_DMAS(:,2),7618,length(Food_DMAS)/7618);
Food_DMAS = Food_DMAS./repmat(sum(Food_DMAS,1),7618,1);

s1=sum(logical(Food_DMAS),1);
s1=find(s1<2);
Food_DMAS(:,s1)=[];
days(:,s1)=[];

% NR real
[FD_DMAS, ND_DMAS, NR_DMAS] = NDNR_Rao_q (Food_DMAS, Food_distance, 1);
NR_real=[NR_real NR_DMAS./(FD_DMAS)];

%% Null-composition-1
Num_food=size(Food_DMAS,1);
FNN_table_relabel=FNN_UFDA(randperm(7618,Num_food),:);
FNN_table_relabel=FNN_table_relabel(:,sum(FNN_table_relabel,1)>0);
Food_distance1 = squareform(pdist(FNN_table_relabel,'jaccard'));

[FD_DMAS_null1, ND_DMAS_null1, NR_DMAS_null1]=NDNR_Rao_q (Food_DMAS, Food_distance1, 1);
NR_Null1=[NR_Null1 NR_DMAS_null1./(FD_DMAS_null1)];

% NULL-composition-2
Food_DMAS_Null2=Nullmodel_composition(Food_DMAS, 4);
[FD_DMAS_null2, ND_DMAS_null2, NR_DMAS_null2]=NDNR_Rao_q (Food_DMAS_Null2, Food_distance, 1);
NR_Null2=[NR_Null2 NR_DMAS_null2./(FD_DMAS_null2)];

% NULL-composition-3
Food_DMAS_Null3=Nullmodel_composition(Food_DMAS, 5);
[FD_DMAS_null3, ND_DMAS_null3, NR_DMAS_null3]=NDNR_Rao_q (Food_DMAS_Null3, Food_distance, 1);
NR_Null3=[NR_Null3 NR_DMAS_null3./(FD_DMAS_null3)];

%% Figure of first day
m1 = find(days(1,:) == 1);
NR_real = NR_real(m1);
NR_Null1 = NR_Null1(m1);
NR_Null2 = NR_Null2(m1);
NR_Null3 = NR_Null3(m1);

real_posi=1;
NULL_1_posi=2;
NULL_2_posi=3;
NULL_3_posi=4;

g_NR_real=[ones(1,length(NR_real))*real_posi(1)];
g_NR_NULL_1=[ones(1,length(NR_Null1))*NULL_1_posi(1)];
g_NR_NULL_2=[ones(1,length(NR_Null2))*NULL_2_posi(1)];
g_NR_NULL_3=[ones(1,length(NR_Null3))*NULL_3_posi(1)];

real_color=[59/255,59/255,59/255];
NULL_1_color=[0,0.45,0.74];
NULL_2_color=[0.85,0.33,0.1];
NULL_3_color=[0.47,0.67,0.19];

figure('position',[537 713 977/5*3/4 420*2/3]);
hold on;
boxplot(NR_real,g_NR_real,'color',real_color,'positions',real_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null1,g_NR_NULL_1,'color',NULL_1_color,'positions',NULL_1_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null2,g_NR_NULL_2,'color',NULL_2_color,'positions',NULL_2_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);
boxplot(NR_Null3,g_NR_NULL_3,'color',NULL_3_color,'positions',NULL_3_posi,'width',0.5,'Symbol','.','OutlierSize',0.5);

set(gca,'fontsize',10)
set(gca,'XTickLabel',{' '});
set(gca,'ylim',[0,0.8]);
set(gca,'xlim',[-2,8]);
set(gca,'xtick',[]);
