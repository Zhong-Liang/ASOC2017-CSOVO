function    out=LabelFormatConvertion(label,ClassType,kind)
% conversion between scalar class label format and  0-1 class label vector format.   
% the latter is required when training a real-valued (between [0,1]) neural network. 
% 


if (nargin<3)
    kind=1;
end

switch(kind)
    % convert scalar class label format to 0-1 class label vector format
    case 1
        if(size(label,1)>1)
            error('input label format error.')
        end
        NumClass=length(ClassType);
        n=length(label);
        out=zeros(NumClass,n);
        
        class=Locate(ClassType,label);
        for i=1:n            
            out(class(i),i)=1;              
        end        
       
    % convert  0-1 class label vector to scalar class label 
    case 2
        if(size(label,1)~=length(ClassType))
            error('input label format is not consistent with class type.')
        end
        [tmp,id]=max(label);
        out=ClassType(id);
        
    otherwise
        error('wrong kind.');
end
        
            
