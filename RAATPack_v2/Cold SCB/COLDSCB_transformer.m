function [time_config,stroke_config,COD_config,load_config] = COLDSCB_transformer(COD_config_original,load_config_original,stroke_config_original,time_config_original,checkboxes)

if(checkboxes(1)==0 && checkboxes(2)==0 && checkboxes(3)==0)

    COD_config=COD_config_original;
    
elseif(checkboxes(1)==1 && checkboxes(2)==0 && checkboxes(3)==0)
    COD_config=COD_config_original-COD_config_original(1);

elseif(checkboxes(1)==1 && checkboxes(2)==1 && checkboxes(3)==0)
    COD_config=-(COD_config_original-COD_config_original(1));

elseif(checkboxes(1)==1 && checkboxes(2)==1 && checkboxes(3)==1)
    COD_config=COD_config_original;
 
elseif(checkboxes(1)==1 && checkboxes(2)==0 && checkboxes(3)==1)
    COD_config=COD_config_original;    
       
elseif(checkboxes(1)==0 && checkboxes(2)==1 && checkboxes(3)==1)
    COD_config=-(COD_config_original-COD_config_original(end)); 

elseif(checkboxes(1)==0 && checkboxes(2)==1 && checkboxes(3)==0)
    COD_config=-COD_config_original;
    
elseif(checkboxes(1)==0 && checkboxes(2)==0 && checkboxes(3)==1)
    COD_config=COD_config_original-COD_config_original(end);
end

if(checkboxes(4)==0 && checkboxes(5)==0 && checkboxes(6)==0)

    load_config=load_config_original;
    
elseif(checkboxes(4)==1 && checkboxes(5)==0 && checkboxes(6)==0)
    load_config=load_config_original-load_config_original(1);

elseif(checkboxes(4)==1 && checkboxes(5)==1 && checkboxes(6)==0)
    load_config=-(load_config_original-load_config_original(1));

elseif(checkboxes(4)==1 && checkboxes(5)==1 && checkboxes(6)==1)
    load_config=-(load_config_original-load_config_original(1));
 
elseif(checkboxes(4)==1 && checkboxes(5)==0 && checkboxes(6)==1)
    load_config=load_config_original;    
       
elseif(checkboxes(4)==0 && checkboxes(5)==1 && checkboxes(6)==1)
    load_config=-(load_config_original-load_config_original(end)); 

elseif(checkboxes(4)==0 && checkboxes(5)==1 && checkboxes(6)==0)
    load_config=-load_config_original;
    
elseif(checkboxes(4)==0 && checkboxes(5)==0 && checkboxes(6)==1)
    load_config=load_config_original-load_config_original(end);
end

if(checkboxes(7)==0 && checkboxes(8)==0 && checkboxes(9)==0)

    time_config=time_config_original;
    
elseif(checkboxes(7)==1 && checkboxes(8)==0 && checkboxes(9)==0)
    time_config=time_config_original-time_config_original(1);

elseif(checkboxes(7)==1 && checkboxes(8)==1 && checkboxes(9)==0)
    time_config=-(time_config_original-time_config_original(1));

elseif(checkboxes(7)==1 && checkboxes(8)==1 && checkboxes(9)==1)
    time_config=time_config_original;
 
elseif(checkboxes(7)==1 && checkboxes(8)==0 && checkboxes(9)==1)
    time_config=time_config_original;    
       
elseif(checkboxes(7)==0 && checkboxes(8)==1 && checkboxes(9)==1)
    time_config=-(time_config_original-time_config_original(end)); 

elseif(checkboxes(7)==0 && checkboxes(8)==1 && checkboxes(9)==0)
    time_config=-time_config_original;
    
elseif(checkboxes(7)==0 && checkboxes(8)==0 && checkboxes(9)==1)
    time_config=time_config_original-time_config_original(end);
end

if(checkboxes(10)==0 && checkboxes(11)==0 && checkboxes(12)==0)

    stroke_config=stroke_config_original;
    
elseif(checkboxes(10)==1 && checkboxes(11)==0 && checkboxes(12)==0)
    stroke_config=stroke_config_original-stroke_config_original(1);

elseif(checkboxes(10)==1 && checkboxes(11)==1 && checkboxes(12)==0)
    stroke_config=-(stroke_config_original-stroke_config_original(1));

elseif(checkboxes(10)==1 && checkboxes(11)==1 && checkboxes(12)==1)
    stroke_config=-(stroke_config_original-stroke_config_original(1));
 
elseif(checkboxes(10)==1 && checkboxes(11)==0 && checkboxes(12)==1)
    stroke_config=stroke_config_original;    
       
elseif(checkboxes(10)==0 && checkboxes(11)==1 && checkboxes(12)==1)
    stroke_config=-(stroke_config_original-stroke_config_original(end)); 

elseif(checkboxes(10)==0 && checkboxes(11)==1 && checkboxes(12)==0)
    stroke_config=-stroke_config_original;
    
elseif(checkboxes(10)==0 && checkboxes(11)==0 && checkboxes(12)==1)
    stroke_config=stroke_config_original-stroke_config_original(end);
end



end