function setChildrenToPixel(fig)
children = get(fig,'Children');
for i=1:length(children)
    set(children(i),'Units','pixels')
end