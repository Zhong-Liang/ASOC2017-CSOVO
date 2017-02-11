function vector = Cost2Vector(cost, kind)
%
%
if size(cost,1)>2
NumClass = size(cost,1);
vector = zeros(1,NumClass);
switch(kind)
    case 'a'
    [m,ind] = max(sum(cost));    
    for i = 1:NumClass
        if cost(i,ind)~=0
        vector(i) = cost(i,ind);
        else
        vector(i) = 1.0;
        end
    end
    
    case 'b'
    for i = 1:NumClass
        for j = 1:NumClass
            if i~=j
               vector(i) = cost(i,j);
               break;
            end
            
        end
    end   
      case 'c'  
      vector = sum(cost,2)';   
          
      case 'd'
      vector = sum(cost,2)'; 
      
end

else
    vector = sum(cost,2)'; 
end