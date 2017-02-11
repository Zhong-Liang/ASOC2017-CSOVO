function Re = BPNN(InsTrain,InsTest,cost,ClassType)
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
out=sim(net,Test);
out=normalize(out);
%convert  real-value outputs to predictions
[maxv,id]=max(out);
maxv=repmat(maxv,NumClass,1);
maxclass=(abs(maxv-out)<1e-6).*out;
[tmp,id]=max(maxclass);
prediction=ClassType(id); 
Re = Evaluation(prediction,TestLabel,cost);
end

