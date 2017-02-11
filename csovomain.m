function csovomain
%
%
clc;clear all; close all
%--------------------read data-------------------------------
sample = xlsread('gla.xls');
times = 5;
CV = 5;
AttributeType = [0,0,0,0,0,0,0,0,0];
%----------------generate the cost matrix----------------------------------
ClassType = unique(sample(:,size(sample,2)))';
ClassType
CostType = 'a';
costMax = 10;
ClassNum = size(ClassType,2);  
InsNum = zeros(1,ClassNum);
for i = 1:ClassNum
    InsNum(1,i) = size(sample(sample(:,size(sample,2))==i,:),1);
end
cost=CostMatrix(ClassNum,InsNum,costMax,CostType);


MethodNum = 8;
Finalresult = zeros(MethodNum,2);
%--------------------save the detail result---------------------------
            BPresult = zeros(CV*times,1);
            CSresult = zeros(CV*times,1);
            Voteresult = zeros(CV*times,1);
            WVresult = zeros(CV*times,1);
            LVPCresult = zeros(CV*times,1);
            NDresult = zeros(CV*times,1);
            DRCWresult = zeros(CV*times,1);
            DCSresult = zeros(CV*times,1);
  
            flag = 1;
%--------------------save the detail result---------------------------

%----------------store the mean result of each time------------------------
        BPreturn = zeros(times,1);    
        CSreturn = zeros(times,1); 
        Votereturn = zeros(times,1); 
        WVreturn = zeros(times,1); 
        LVPCreturn = zeros(times,1); 
        NDreturn = zeros(times,1); 
        DRCWreturn = zeros(times,1); 
        DCSreturn = zeros(times,1); 

%----------------store the mean result of each time------------------------




for iii = 1:times
    iii

%--------------store the result of each time for computing the mean result-------
        BPre = zeros(1,CV);
        CSre = zeros(1,CV);
        Votere = zeros(1,CV);
        WVre = zeros(1,CV);   
        LVPCre = zeros(1,CV);
        NDre = zeros(1,CV);
        DRCWre = zeros(1,CV);
        DCSre = zeros(1,CV);
        
%--------------store the result of each time for computing the mean result--------

    for i = 1:ClassNum
        InsClass{i} = sample(sample(:,size(sample,2))==ClassType(i),:); 
        % InsClass{i}
        [M,N]=size(InsClass{i});
        indices{i}=crossvalind('Kfold',InsClass{i}(1:M,N),CV);%进行随机分包
        %indices{i}
    end

    for k = 1:CV
        InsTrain = [];
        InsTest = [];
        for i = 1:ClassNum
            test_index = (indices{i} == k);
            train_index = ~test_index;
            InsTrain = cat(1,InsTrain,InsClass {i}(train_index,:));
            InsTest = cat(1,InsTest,InsClass {i}(test_index,:));
        end
      
        % use the BP as the classifier without cost-sensitive
        BPaveAcc = BPNN(InsTrain,InsTest,cost,ClassType);
        BPre(1,k) = BPaveAcc;
        % use the Threshold-moving cost-sensitive method as classifier 
        CSaveAcc = sample_ThresholdMovNN(InsTrain,InsTest,cost,ClassType,CostType);
        CSre(1,k) = CSaveAcc;
        % a denotes voting strategy (Vote)
        VoteaveAcc = OVOThresholdMovNN(InsTrain,InsTest,cost,ClassNum,'a',AttributeType,CostType);
        Votere(1,k) = VoteaveAcc;

        % b denotes weighted voting stratery (WV)
        WVaveAcc = OVOThresholdMovNN(InsTrain,InsTest,cost,ClassNum,'b',AttributeType,CostType);
        WVre(1,k) = WVaveAcc;

        % c denotes Learning valued preference for classification (LVPC)
        LVPCaveAcc = OVOThresholdMovNN(InsTrain,InsTest,cost,ClassNum,'c',AttributeType,CostType);
        LVPCre(1,k) = LVPCaveAcc;

        % d denotes Preference relations solved by Non-Dominance Criterion  (ND)
        NDaveAcc = OVOThresholdMovNN(InsTrain,InsTest,cost,ClassNum,'d',AttributeType,CostType);
        NDre(1,k) = NDaveAcc;

        % e denotes Distance-based relative competence weighting (DRCW)
        DRCWaveAcc = OVOThresholdMovNN(InsTrain,InsTest,cost,ClassNum,'e',AttributeType,CostType);
        DRCWre(1,k) = DRCWaveAcc;
 
        % f denotes Dynamic classifier selection for One-vs-One strategy: Avoiding non-competent classifiers (DCS)
        DCSaveAcc = OVOThresholdMovNN(InsTrain,InsTest,cost,ClassNum,'f',AttributeType,CostType);
        DCSre(1,k) = DCSaveAcc;


%----------------------------the detailed results-------------------------        
        BPresult(flag,1) = BPaveAcc;      
        CSresult(flag,1) = CSaveAcc;        
        Voteresult(flag,1) = VoteaveAcc;
        WVresult(flag,1) = WVaveAcc;
        LVPCresult(flag,1) = LVPCaveAcc;
        NDresult(flag,1) = NDaveAcc;
        DRCWresult(flag,1) = DRCWaveAcc;
        DCSresult(flag,1) = DCSaveAcc;
        flag = flag+1;
%-------------------------------the detailed results----------------------        

    end


        BPreturn(iii,1)=mean(BPre);    
        CSreturn(iii,1)=mean(CSre);
        Votereturn(iii,1)=mean(Votere);
        WVreturn(iii,1)=mean(WVresult);
        LVPCreturn(iii,1)=mean(LVPCre);
        NDreturn(iii,1)=mean(NDre);
        DRCWreturn(iii,1)=mean(DRCWre);
        DCSreturn(iii,1)=mean(DCSre);


end

       Finalresult(1,1) = mean(BPresult);   
       Finalresult(1,2) = std(BPresult);
       Finalresult(2,1) = mean(CSresult);
       Finalresult(2,2) = std(CSresult);
       Finalresult(3,1) = mean(Voteresult);
       Finalresult(3,2) = std(Voteresult);
       Finalresult(4,1) = mean(WVresult);
       Finalresult(4,2) = std(WVresult);
       Finalresult(5,1) = mean(LVPCresult);
       Finalresult(5,2) = std(LVPCresult);
       Finalresult(6,1) = mean(NDresult);
       Finalresult(6,2) = std(NDresult);
       Finalresult(7,1) = mean(DRCWresult);
       Finalresult(7,2) = std(DRCWresult);
       Finalresult(8,1) = mean(DCSresult);
       Finalresult(8,2) = std(DCSresult);

 %--------------------------save the result with setup a file--------------
  save('BPmean.mat','BPreturn');
 save('CSmean.mat','CSreturn');
 save('Votemean.mat','Votereturn');
 save('WVmean.mat','WVreturn');
 save('LVPCmean.mat','LVPCreturn');
 save('NDmean.mat','NDreturn');
 save('DRCWmean.mat','DRCWreturn');
 save('DCSmean.mat','DCSreturn');

 
 save('BPresult.mat','BPresult');
 save('CSresult.mat','CSresult');
 save('Voteresult.mat','Voteresult');
 save('WVresult.mat','WVresult');
 save('LVPCresult.mat','LVPCresult');
 save('NDresult.mat','NDresult');
 save('DRCWresult.mat','DRCWresult');
 save('DCSresult.mat','DCSresult');

 
 save('glaresult.mat','Finalresult');
%--------------------------save the result with setup a file-------------- 