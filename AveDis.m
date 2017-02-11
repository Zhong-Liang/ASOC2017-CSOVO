function DIS = AveDis(Testpatterns,TrainInstance,ClassNum,k,AttributeType)

label = unique(TrainInstance(:,size(TrainInstance,2))');
D = zeros(1,ClassNum);
AttNum = size(AttributeType,2);
for i = 1:ClassNum

Train1 = TrainInstance(TrainInstance(:,size(TrainInstance,2))==i,:);
Train2 = TrainInstance(TrainInstance(:,size(TrainInstance,2))~=i,:);

InsNum = size(Train1,1);
distance = zeros(InsNum,1);
for j = 1:InsNum    
    Testpatterns1 = Testpatterns;
    Testpatterns2 = Train1(j,(1:AttNum));
    
    Train_tmp = Train1;
    Train_tmp(j,:) = [];

    training = cat(1,Train_tmp,Train2);

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

%distance

if InsNum < k
    D(i) = sum(distance,1)/InsNum;
else
    distance_sort = sort(distance);
    distance_NN = distance_sort(1:k,:);
    %distance_NN
    D(i) = sum(distance_NN,1)/k;
end
%D    
end

DIS = D;