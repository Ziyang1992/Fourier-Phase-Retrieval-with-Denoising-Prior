function t = convert(c,t)
t = uint8((c-min(min(c)))/(max(max(c))-min(min(c)))*255);
end