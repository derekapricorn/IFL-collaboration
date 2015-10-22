%independent variables
ind_mat = [diffNC,diffNFV,diffXSA,pct_NC,pct_XSA,pct_NFV,BMI,C_AHI,Age];
%test for normality
for ii = 1:9
    adtest(ind_mat(:,ii))%Checked with normality. all are normally distributed
end

%stepwise regression
[b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(ind_mat,flatten1,'penter',0.05,'premove',0.1) 
 