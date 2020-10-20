function moveChildren(from,to,x)
children = get(from,'Children');
for i=1:length(children)
    pos = get(children(i),'Position');
    pos(1) = x;
    set(children(i),'Parent',to,'Position', pos);
end