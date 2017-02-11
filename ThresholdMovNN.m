function   [TMprediction, TMout]=ThresholdMovNN(out,Cost,ClassType,kind)
% Impelementation of threshlod-moving algorithm that is a post process 
% of Neural Network to make NN cost sensitive by threshold moving,
% therefore it becomes harder for higher-cost instances to be misclassified.


if(nargin<3)
    help ThresholdMovNN;
end
if(size(out,1)~=size(Cost,1))
    error('out and Cost are not consistent on class number.');
end

C = Cost2Vector(Cost,kind);


NumClass=size(Cost,1);
NumIns=size(out,2);
TMout=zeros(size(out));
for i=1:NumClass   
    TMout(i,:)=out(i,:)*C(i);    
end


TMout=normalize(TMout);

%convert  real-value outputs to predictions
[maxv,id]=max(TMout);
maxv=repmat(maxv,NumClass,1);
maxclass=(abs(maxv-TMout)<1e-6).*out;
[tmp,id]=max(maxclass);
TMprediction=ClassType(id);   

%end
        
