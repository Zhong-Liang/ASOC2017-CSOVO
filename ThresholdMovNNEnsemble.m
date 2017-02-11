function ens = ThresholdMovNNEnsemble( Trainpatterns,Traintargets )
%

Train=Trainpatterns';
TrainLabel=Traintargets';
ClassType = unique(TrainLabel);

NumClass=size(ClassType,2);

TrainTarget=LabelFormatConvertion(TrainLabel,ClassType);% change to 0-1 label vector format

%-------------step 1: train a cost-blind  neural network -------------------

net = newff(Train,TrainTarget,10,{'logsig','logsig'},'trainrp');
net.trainParam.epochs = 200;
net.trainParam.showWindow = false;
net=train(net,Train,TrainTarget);

ens=net;