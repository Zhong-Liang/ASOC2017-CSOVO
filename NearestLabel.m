function [DelClassLabel,ClassLabel, flag] = NearestLabel( Testpatterns,TrainInstance,ClassNum,k,AttributeType )
%
DelClassLabel=[];
flag=0;
class = TrainInstance(:,size(TrainInstance,2)); 
label = unique(TrainInstance(:,size(TrainInstance,2))');
AttNum = size(AttributeType,2);

Train = TrainInstance;
InsNum = size(Train,1);

distance = zeros(InsNum,1);
for j = 1:InsNum    
    Testpatterns1 = Testpatterns;
    Testpatterns2 = Train(j,(1:AttNum));
    training = TrainInstance;
    training(j,:) = [];
    
    for z = 1:AttNum   
        if isnan(Testpatterns1(1,z)) || isnan(Testpatterns2(1,z))
           dis=1;
        elseif AttributeType(1,z)==1 %1 denotes the attribute as nominal
            vdm = 0;
            for r = 1:ClassNum
                NAX = training(training(:,z)==Testpatterns1(1,z),:);
                NAXI = NAX(NAX(:,size(NAX,2))==label(r),:);
                num1 = size(NAXI,1);
                num2 = size(NAX,1);
                if  num2 == 0
                    num2 = num2+0.00000001;
                end
                NAY = training(training(:,z)==Testpatterns2(1,z),:);
                NAYI = NAY(NAY(:,size(NAY,2))==label(r),:);
                num3 = size(NAYI,1);
                num4 = size(NAY,1);
                if  num4 == 0
                    num4 = num4+0.00000001;
                end   
                vdm = vdm + (num1/(num2)-num3/(num4))^2;
            end
           dis=sqrt(vdm);
        else % 0 denotes the attribute as linear
           SD = std(training(:,z));  
           if SD == 0
              SD = SD +0.000000001;
           end
           diff = abs(Testpatterns1(1,z)-Testpatterns2(1,z))/((4*SD));
           dis=diff;
        end  
    distance(j,1) = distance(j,1) + dis^2;             
    end
    distance(j,1) = sqrt(distance(j,1));  
end

n = size(distance,1);
D = zeros(n,2);
for i = 1:n
    D(i,1) = i;
    D(i,2) = distance(i,1);
end

for i = 1:2*k
    [dis,ind] = min(D(:,2));
    ClassLabel(i) = class(D(ind,1),1);
    D(ind,:) = [];
    if i == k && size(unique(ClassLabel),2) > 1
       break;
    end
end

%ClassLabel
%unique(ClassLabel)
if size(unique(ClassLabel),2) ~= ClassNum
   flag=1;
end
ClassLabel = unique(ClassLabel);

index=1;
for i = 1:size(label,2)
    flag1 = 0;
    for j = 1:size(ClassLabel,2)
        if label(i)==ClassLabel(j)
           flag1 = 1; 
        end
    end
    if flag1 == 0;
       DelClassLabel(index)=label(i);
       index = index+1;
    end
end    