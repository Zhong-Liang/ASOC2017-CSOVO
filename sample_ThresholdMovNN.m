function aveCost = sample_ThresholdMovNN(InsTrain,InsTest,cost,ClassType,CostType)
% 

training=InsTrain;
testing=InsTest;

Train=training(:,1:(size(training,2)-1))';
TrainLabel=training(:,size(training,2))';
Test=testing(:,1:(size(testing,2)-1))';
TestLabel=testing(:,size(testing,2))';

NumAtt=size(Train,1);
NumClass=size(ClassType,2);
NumTest=size(Train,2);
NumTrain=size(Test,2);
attribute=zeros(1,NumAtt);

TrainTarget=LabelFormatConvertion(TrainLabel,ClassType);% change to 0-1 label vector format

%-------------step 1: train a cost-blind  neural network -------------------

net = newff(Train,TrainTarget,10,{'logsig','logsig'},'trainrp');
net.trainParam.epochs = 200;
net.trainParam.showWindow = false;
net=train(net,Train,TrainTarget);

%-------------step 2: test exampling using N to get real-value outputs----

out=sim(net,Test);

out=normalize(out);

%-------------step 3: using FUNCTION ThresholdMovNN to get cost-sensitive prediction
%                              or its real-value output o*

[cs_prediction,cs_out]=ThresholdMovNN(out,cost,ClassType,CostType);

aveCost = Evaluation(cs_prediction,TestLabel,cost);    
