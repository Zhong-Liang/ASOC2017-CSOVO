function    Cost=CostMatrix(NumClass,InsNum,maxvalue,kind)
%Generate 3 types of cost matrix 


if(nargin<1)
    help CostMatrix;
elseif(nargin<2)
    if(NumClass<2)
        error('NumClass error.')
    end
    maxvalue=10;
    kind='c';
elseif(nargin<3)
    kind='c';
end

switch(kind)
    
    % type (a) cost matrix
    case 'a'         
        %confirm union condition
        for i=1:NumClass   
            for j=1:NumClass
                if (i ~= j)
                    Cost(i,j) = 1;
                end
            end
        end
        I=round(rand(1,1)*(NumClass-1))+1;%dominative row index I        
        for j=1:NumClass
            if(j~=I)
                Cost(j,I) = round(rand(1,1) * (maxvalue-2) + 2);
            end
        end
        
    % type (b) cost matrix
    case 'b'   
        %generate random vlaues between 1 and maxvalue for cost matrix
        for j=1:NumClass
            rn = round(rand(1,1) * (maxvalue-1) + 1);
            for i=1:NumClass
                if (i ~= j) 
                    Cost(j,i) = rn;
                end
            end
        end        
        %confirm union condition
        if(min(Cost(find(Cost(:)>0)))>1)
            rn=round(rand(1,1)*(NumClass-1))+1;
            for i=1:NumClass
                if(i~=rn)
                    Cost(rn,i)=1;
                end
            end                  
        end

    % type (c) cost matrix 
    case 'c'        
        %generate random vlaues between 1 and maxvalue for cost matrix
        Cost=zeros(NumClass);
        for i=1:NumClass
            for j=1:NumClass               
                if (i ~= j)
                    rn1 = round(rand(1,1) * (maxvalue-1) + 1);
                    Cost(i,j) = rn1;
                end
            end
        end        
        %confirm union condition
        if(min(Cost(find(Cost(:)>0)))>1)
            rn1=round(rand(1,1)*(NumClass-1))+1;
            rn2=round(rand(1,1)*(NumClass-1))+1;
            while(rn1==rn2)
                rn1=round(rand(1,1)*(NumClass-1))+1;
            end
            Cost(rn1,rn2)=1;
        end
   
    case 'd'
      Cost=zeros(NumClass);
      for i = 1:NumClass
          for j = 1:NumClass
              if i~=j
                 Cost(i,j) = randsample((0:2000*(InsNum(j)/InsNum(i))),1);
              end
          end
      end
   %   Cost
    Cost = Cost/max(max(Cost));
    otherwise
        error('type error.')
end
        