function [fit,s] = Search(UE,fit,s,Ec,Et,M)
index1 = randperm(UE.N);
for i = 1:UE.N
    index = index1(i);
    if sum(M(index,:))>1
        for j = 1:UE.N+1
            if M(index,j) == 1
                Task = find(s == j-1);
                if isempty(Task)
                    if s(index)~=0&&j~=1&&(Ec(index,s(index))+Et(index,s(index))>Ec(index,j-1)+Et(index,j-1))
                        fit = fit - (Ec(index,s(index))+Et(index,s(index)))+(Ec(index,j-1)+Et(index,j-1));
                        s(index) = j-1;
                    end
                end
            end
        end
    end
end
end














% for i = 1:100
%     index = index1(i);
%     if s0(index) == -1 && bests(index) ~= 0              %对于执行方式不唯一且不在云上执行的任务做局部搜索
%         allowMode = find(M(index,2:end)==0);     % 当前的执行方式的能耗与可供选择的执行方式能耗计较
%         tempIndex = allowMode((Ec(index,allowMode+1)+Etmin(index,allowMode+1))<(Ec(index,bests(index)+1)+Etmin(index,bests(index)+1))); %%按序号排序
%         if ~isempty(tempIndex)
%             [~,sortIndex] = sort(Ec(index,tempIndex+1)+Et(index,tempIndex+1));
%             tempIndex = tempIndex(sortIndex);
%             for j = 1:size(tempIndex,2)
%                 swapIndex = find(bests==tempIndex(j));
%                 if ~isempty(swapIndex)                        %如果该执行方式已经被选择，则比较交换前后的能耗差。如果交换后能耗较低，则进行交换操作，否则保持不变。
%                     if M(swapIndex,bests(index)+1)==0&&((Ec(index,bests(index)+1)+Et(index,bests(index)+1)+Ec(swapIndex,tempIndex(j)+1)+Et(swapIndex,tempIndex(j)+1))>...
%                             (Ec(index,tempIndex(j)+1)+Et(index,tempIndex(j)+1)+Ec(swapIndex,bests(index)+1)+Et(swapIndex,bests(index)+1)))
%                         bestfit = bestfit+(Ec(index,tempIndex(j)+1)+Et(index,tempIndex(j)+1)+Ec(swapIndex,bests(index)+1)+Et(swapIndex,bests(index)+1))-...
%                             (Ec(index,bests(index)+1)+Et(index,bests(index)+1)+Ec(swapIndex,tempIndex(j)+1)+Et(swapIndex,tempIndex(j)+1));
%                         bests(swapIndex) = bests(index);
%                         bests(index) = tempIndex(j);
%                         break;
%                     end
%                 else                                                      %如果该执行方式未被选择，则直接进行插入操作。
%                     bestfit = bestfit+(Ec(index,tempIndex(j)+1)+Et(index,tempIndex(j)+1))-(Ec(index,bests(index)+1)+Et(index,bests(index)+1));
%                     bests(index) = tempIndex(j);
%                     break;
%                 end
%             end
%         end
%     end
% end