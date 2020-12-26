function Food_table_NULL = Nullmodel_composition(Food_table,index)
rng(0)
[Num_spe, Num_samp]=size(Food_table);
Food_table_NULL=zeros(size(Food_table));
switch index
    case 4
        for i=1:Num_samp
            Inonzeros=find(Food_table(:,i)>0);
            Food_table_NULL(Inonzeros,i)=Food_table(Inonzeros(randperm(length(Inonzeros))),i);
        end
    
    case 5
        for i=1:Num_spe
            Inonzeros=find(Food_table(i,:)>0);
            Food_table_NULL(i,Inonzeros)=Food_table(i,Inonzeros(randperm(length(Inonzeros))));
        end
end
    