function ranks = rankorder(x)% ranks = rankorder(x)     assigns a rank to each element in x.  Return% vector, RANKS, is same dim as x.ranks = zeros(size(x));vals = sort(unique(x));for i = 1:length(vals)  ranks(x==vals(i)) = i;end