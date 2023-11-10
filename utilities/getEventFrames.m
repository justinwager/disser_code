function [strikeFrame,toeoffFrame] = getEventFrames(vertGRF,forceThreshold)

strikeCheck = find(vertGRF >= forceThreshold,15);
toeoffCheck = find(vertGRF >= forceThreshold,15,'last');
for i = 1:10
    checkStart = strikeCheck(i);
    checkEnd = strikeCheck(i)+5;
    if vertGRF(checkStart:checkEnd) >= forceThreshold
        strikeFrame = strikeCheck(i);
        break
    end
end

for i = 15:-1:6
    checkStart = toeoffCheck(i)-5;
    checkEnd = toeoffCheck(i);
    if vertGRF(checkStart:checkEnd) >= forceThreshold
        toeoffFrame = toeoffCheck(i);
        break
    end
end