function aveCost = Evaluation(prediction,TestLabel,cost)

NumIns = size(TestLabel,2);
sumCost = 0;
for i = 1:NumIns
   sumCost = sumCost + cost(TestLabel(i),prediction(i)); 
end
aveCost = sumCost;
