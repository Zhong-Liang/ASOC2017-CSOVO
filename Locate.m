function loc=Locate(V,value)
%
if(length(unique(V))~=length(V))
    error('values in the set is not unique')
end
    
v=unique(value);
Nv=length(v);

for i=1:Nv
    id=find(value==v(i));
    l=find(V==v(i));
    if(isempty(l))
        loc(id)=-1;
    else
        loc(id)=l;
    end
end
%end
    
    


