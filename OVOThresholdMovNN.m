function aveCost = OVOThresholdMovNN( TrainInstance,TestInstance,cost,ClassNum,OVOType,AttributeType,CostType )
%
%
Testpatterns = TestInstance(:,1:size(TestInstance,2)-1);
Testtargets = TestInstance(:,size(TestInstance,2))';


ensemble = EnsClassifier(TrainInstance,ClassNum);

results = EnsembleEvaluation( ensemble,TrainInstance,Testpatterns,cost,OVOType,AttributeType,CostType);


aveCost = Evaluation(results,Testtargets,cost); 