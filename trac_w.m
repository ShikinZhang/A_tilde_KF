

function w = trac_w(t)
    if t < 20
        w = 0;
    else
        if t < 30
            w = -pi / 10;
        else
            if t < 40
                w = pi / 10;
            else
                if t < 50
                    w = -pi / 10;
                else
                    if t < 60
                        w = pi / 10;
                    else
                        if t < 70
                            w = -pi / 10;
                        else
                            w = 0;
                        end
                    end
                end
            end
        end
    end
end