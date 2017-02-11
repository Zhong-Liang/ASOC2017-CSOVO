function ensemble = EnsClassifier( TrainInstance,ClassNum )
%

ensemble = struct('ens',{});

for i = 1:ClassNum
    for j = 1:ClassNum
      if i~=j
        pos_ins = TrainInstance(TrainInstance(:,size(TrainInstance,2))==i,:);
        neg_ins = TrainInstance(TrainInstance(:,size(TrainInstance,2))==j,:);
      
        pos_ins(:,size(pos_ins,2))=1;
        neg_ins(:,size(neg_ins,2))=2;

        sample = cat(1,pos_ins,neg_ins);
        NewTrainpatterns = sample(:,1:size(sample,2)-1);
        NewTraintargets = sample(:,size(sample,2));
        
        ens = ThresholdMovNNEnsemble(NewTrainpatterns,NewTraintargets);
      
        ensemble(i,j).ens = ens;
       
       else
        ensemble(i,j).ens = {};
       end
    end
end