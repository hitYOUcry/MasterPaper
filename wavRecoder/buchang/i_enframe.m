function y = i_enframe(s,inc)
n = size(s,1);
frame_len = size(s,2);
y(:,1) = s(1,:);
for i = 2 : n
    temp = s(i,:);
    y_len = size(y,1);
    y(y_len + 1 : y_len + inc) = temp(frame_len - inc + 1 : frame_len);
end