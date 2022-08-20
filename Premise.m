function premise = Premise(d, delD)

a = mem_dR(d);
b = mem_del_dR(delD);

premise = zeros(5,5);

for i = 1:5
    for j = 1:5
        premise(i,j) = min(a(i),b(j));
    end
end

end