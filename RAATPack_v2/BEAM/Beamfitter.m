function [fit_values_AASHTO] = Beamfitter(A,b,cycles,number_of_files);

i=0;
while(1)
    i = i+1;
fit_values_AASHTO_data=(A.*exp(b.*cycles));

if i==number_of_files
    break
end
end
end
