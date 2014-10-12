function res=tallyTFPN(res)

for j = 1 : length(res.gtVals)
    if res.gtVals(j) == 1
        if res.gtVals(j) == res.predVals(j)
            res.tpT = res.tpT+1;
        elseif res.predVals(j) == 2
            res.fnT = res.fnT+1;
            res.fpP = res.fpP+1;             
        elseif res.predVals(j) == 3
            res.fnT = res.fnT+1;
            res.fpD = res.fpD+1;           
        end
    end
    if res.gtVals(j) == 2
        if res.gtVals(j) == res.predVals(j)
            res.tpP = res.tpP+1;
        elseif res.predVals(j)== 1
            res.fnP = res.fnP+1;
            res.fpT = res.fpT+1;
        elseif res.predVals(j)== 3
            res.fnP = res.fnP+1;
            res.fpD = res.fpD+1;            
        end
    end        
    if res.gtVals(j) == 3
        if res.gtVals(j) == res.predVals(j)
            res.tpD = res.tpD+1;
        elseif res.predVals(j) == 1
            res.fnD = res.fnD+1;
            res.fpT = res.fpT+1;
        elseif res.predVals(j) == 2
            res.fnD = res.fnD+1;
            res.fpP = res.fpP+1;            
        end
    end    
end