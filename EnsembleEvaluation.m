function results = EnsembleEvaluation( ensemble,TrainInstance,Testpatterns,cost,kind,AttributeType,CostType)
%explain:
%
TestNum = size(Testpatterns,1);
results = zeros(1,TestNum);
ClassNum = size(ensemble,2);
switch (kind)
%voting strategy (Vote)
    case 'a'
for z = 1:size(Testpatterns,1);
    r=zeros(ClassNum,ClassNum);
    S=zeros(ClassNum,ClassNum);
    for i = 1:size(ensemble,1);
        for j = 1:size(ensemble,2)
            if i<j        
               COST = [0,cost(i,j);cost(j,i),0];
               r(i,j) =  EvaluateValue( Testpatterns(z,:), ensemble(i,j).ens,COST,CostType);
               if r(i,j)>0.5
                  S(i,j)=1;
               else
                  S(i,j)=0;
               end
            elseif i>j
               S(i,j) = 1-S(j,i);
               
            else
                S(i,j) = 0;
            end            
        end
    end
    S_sum = sum(S,2);
    [score,label] = max(S_sum);
    results(z) = label;
end

% weighted voting stratery (WV)
case 'b'
for z = 1:size(Testpatterns,1);
    r=zeros(ClassNum,ClassNum);
    for i = 1:size(ensemble,1);
        for j = 1:size(ensemble,2)
            if i<j
               COST = [0,cost(i,j);cost(j,i),0];
               r(i,j) =  EvaluateValue( Testpatterns(z,:), ensemble(i,j).ens,COST,CostType);
            elseif i>j
               r(i,j) = 1-r(j,i);               
            else
                r(i,j) = 0;
            end            
        end
    end
    %r
    r_sum = sum(r,2);
    [score,label] = max(r_sum);
    results(z) = label;
end

% Learning valued preference for classification (LVPC)
case 'c'
for z = 1:size(Testpatterns,1);
    r=zeros(ClassNum,ClassNum);
    for i = 1:size(ensemble,1);
        for j = 1:size(ensemble,2)
            if i~=j
               COST = [0,cost(i,j);cost(j,i),0];
               r(i,j) =  EvaluateValue( Testpatterns(z,:), ensemble(i,j).ens,COST,CostType);    
            else
               r(i,j) = 0;
            end           
        end
    end
    %normalization
    Nr = zeros(ClassNum,ClassNum);
    for i=1:ClassNum
       for j=1:ClassNum
           if i~=j
              Nr(i,j)=r(i,j)/(r(i,j)+r(j,i));
           else
              Nr(i,j)=0;
           end
       end
    end
    r=Nr;
%    
    P=zeros(ClassNum,ClassNum);
    C=zeros(ClassNum,ClassNum);
    I=zeros(ClassNum,ClassNum);
    for i=1:ClassNum
        for j = 1:ClassNum
            P(i,j)=r(i,j)-min(r(i,j),r(j,i));
            C(i,j)=min(r(i,j),r(j,i));
            I(i,j)=1-max(r(i,j),r(j,i));
        end
    end
    score = zeros(1,ClassNum);
    for i = 1:ClassNum
        PosNum = size(TrainInstance(TrainInstance(:,size(TrainInstance,2))==i,:),1);
        for j = 1:ClassNum
        NegNum = size(TrainInstance(TrainInstance(:,size(TrainInstance,2))==j,:),1);    
            if i~=j
               score(i) = score(i)+P(i,j)+0.5*C(i,j)+(PosNum/(PosNum+NegNum))*I(i,j);
            end
        end
    end
    [m,label] = max(score);
    results(z) = label;
end
          
% Preference relations solved by Non-Dominance Criterion  (ND)
case 'd'
for z = 1:size(Testpatterns,1);
    r=zeros(ClassNum,ClassNum);
    for i = 1:size(ensemble,1);
        for j = 1:size(ensemble,2)
            if i~=j
               COST = [0,cost(i,j);cost(j,i),0];
               r(i,j) =  EvaluateValue( Testpatterns(z,:), ensemble(i,j).ens,COST,CostType);    
            else
               r(i,j) = 0;
            end           
        end
    end
   % r
    %normalization
    Nr = zeros(ClassNum,ClassNum);
    for i=1:ClassNum
       for j=1:ClassNum
           if i~=j
              Nr(i,j)=r(i,j)/(r(i,j)+r(j,i));
           else
              Nr(i,j)=0;
           end
       end
    end
    r=Nr;
%
R = zeros(ClassNum,ClassNum);
for i = 1:ClassNum   
    for j = 1:ClassNum
        if r(i,j)>r(j,i)
           R(i,j) = r(i,j)-r(j,i);
        else
            R(i,j) = 0;
        end
    end
end
%R
%
ND = zeros(1,ClassNum);
for i = 1:ClassNum    
    ND(i) = 1-max(R(:,i));    
end
%ND
%
    [m,label] = max(ND);
    results(z) = label;
end       
% Distance-based relative competence weighting (DRCW)    
case 'e'

for z = 1:size(Testpatterns,1);
    r=zeros(ClassNum,ClassNum);
    for i = 1:size(ensemble,1);
        for j = 1:size(ensemble,2)
            if i<j
               COST = [0,cost(i,j);cost(j,i),0];
               r(i,j) =  EvaluateValue( Testpatterns(z,:), ensemble(i,j).ens,COST,CostType);
            elseif i>j
               r(i,j) = 1-r(j,i);               
            else
                r(i,j) = 0;
            end            
        end
    end
%    r
% 
k=5;%according to the literature
    DIS = AveDis(Testpatterns(z,:),TrainInstance,ClassNum,k,AttributeType);
   
    WR = zeros(ClassNum,ClassNum);
    for i = 1:ClassNum
        for j = 1:ClassNum
            weight=DIS(j)*DIS(j)/((DIS(i)*DIS(i)+DIS(j)*DIS(j))+0.0000000001);%in case of denominator is equal to 0
            WR(i,j)= r(i,j)*weight;
        end
    end
   % WR
%    
    WR_sum = sum(WR,2);
    [m,label] = max(WR_sum);
    results(z) = label;    
end  

% Dynamic classifier selection for One-vs-One strategy: Avoiding non-competent classifiers (DCS)
    case 'f'
for z = 1:size(Testpatterns,1);
    r=zeros(ClassNum,ClassNum);
    for i = 1:size(ensemble,1);
        for j = 1:size(ensemble,2)
            if i<j
               COST = [0,cost(i,j);cost(j,i),0];
               r(i,j) =  EvaluateValue( Testpatterns(z,:), ensemble(i,j).ens,COST,CostType);
            elseif i>j
               r(i,j) = 1-r(j,i);               
            else
                r(i,j) = 0;
            end            
        end
    end
k=3*ClassNum;
[DelClassLabel,ClassLabel, flag] = NearestLabel( Testpatterns(z,:),TrainInstance,ClassNum,k,AttributeType );
%NewR = zeros(size(ClassLabel,2),size(ClassLabel,2));
if size(unique(ClassLabel),2) == 1
 results(z) = unique(ClassLabel);   
else
if flag==1
   for i = 1: size(DelClassLabel,2)
       r(DelClassLabel(i),:)=0;  
       r(:,DelClassLabel(i))=0;
   end
   %r
   r_sum = sum(r,2);
   [score,label] = max(r_sum);
   results(z) = label;
else
   r_sum = sum(r,2);
   [score,label] = max(r_sum);
   results(z) = label; 
end

end
%r
end  
        
                
end
