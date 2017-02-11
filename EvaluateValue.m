function re = EvaluateValue( Test, net, cost, CostType )
%
% 
Test = Test';

out=sim(net,Test);
out=normalize(out);

%-------------step 3: using FUNCTION ThresholdMovNN to get cost-sensitive prediction
%                              or its real-value output o*
ClassType = [1,2];
[cs_prediction,cs_out]=ThresholdMovNN(out,cost,ClassType,CostType);
re = cs_out(1,1);
   
