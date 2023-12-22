function E2 = fitE2min(beta,t,temp)
    E2=sum(abs(beta(1)*t.^2 + beta(2)*t + beta(3) - temp).^2);
    % This calculation is the sum of squares of the residuals.
    %(This is simply a measure of the discrepancy, or the difference between the model prediction and the actual reading.)
    % To find the best 'fit' this equation should be minimized, and we know
    % that to find the minimum of any equation is to find its derivative.
end