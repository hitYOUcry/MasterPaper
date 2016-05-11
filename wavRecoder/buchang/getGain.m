%% gain cal
 function gain = getGain(thr_f,amp)
if amp <= 45
    % low 
    gain = low_g(thr_f);
else if amp <= 85
        % mid
        gain = mid_g(thr_f);
    else
    % loud
     gain = loud_g(thr_f);
    end
end
end

%% FIG6 low
function gain = low_g(hl)
if hl < 20
    gain = 0;
else if 20 <= hl && hl <= 60
        gain = hl - 20;
    else
        gain = hl - 20 - 0.5*(hl - 60);
    end
end
end

%% FIG6 mid
function gain = mid_g(hl)
if hl < 20
    gain = 0;
else if 20 <= hl && hl <= 60
        gain = 0.6 * (hl - 20);
    else
        gain = 0.8 * (hl - 23);
    end
end
end

%% FIG6 loud
function gain = loud_g(hl)
if hl < 40
    gain = 0;
else
    gain = 0.1 * (hl - 40)^1.4;
end
end