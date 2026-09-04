function [x_config,y_config] = data_transformer(x_config_original,y_config_original,checkboxes)

if(checkboxes(1)==0 && checkboxes(2)==0 && checkboxes(3)==0)

    x_config=x_config_original;
    
elseif(checkboxes(1)==1 && checkboxes(2)==0 && checkboxes(3)==0)
    x_config=x_config_original-x_config_original(1);

elseif(checkboxes(1)==1 && checkboxes(2)==1 && checkboxes(3)==0)
    x_config=-(x_config_original-x_config_original(1));

elseif(checkboxes(1)==1 && checkboxes(2)==1 && checkboxes(3)==1)
    x_config=x_config_original;
 
elseif(checkboxes(1)==1 && checkboxes(2)==0 && checkboxes(3)==1)
    x_config=x_config_original;    
       
elseif(checkboxes(1)==0 && checkboxes(2)==1 && checkboxes(3)==1)
    x_config=-(x_config_original-x_config_original(end)); 

elseif(checkboxes(1)==0 && checkboxes(2)==1 && checkboxes(3)==0)
    x_config=-x_config_original
    
elseif(checkboxes(1)==0 && checkboxes(2)==0 && checkboxes(3)==1)
    x_config=x_config_original-x_config_original(end)
end

if(checkboxes(4)==0 && checkboxes(5)==0 && checkboxes(6)==0)

    y_config=y_config_original;
    
elseif(checkboxes(4)==1 && checkboxes(5)==0 && checkboxes(6)==0)
    y_config=y_config_original-y_config_original(1);

elseif(checkboxes(4)==1 && checkboxes(5)==1 && checkboxes(6)==0)
    y_config=-(y_config_original-y_config_original(1));

elseif(checkboxes(4)==1 && checkboxes(5)==1 && checkboxes(6)==1)
    y_config=-(y_config_original-y_config_original(1));
 
elseif(checkboxes(4)==1 && checkboxes(5)==0 && checkboxes(6)==1)
    y_config=y_config_original;    
       
elseif(checkboxes(4)==0 && checkboxes(5)==1 && checkboxes(6)==1)
    y_config=-(y_config_original-y_config_original(end)); 

elseif(checkboxes(4)==0 && checkboxes(5)==1 && checkboxes(6)==0)
    y_config=-y_config_original
    
elseif(checkboxes(4)==0 && checkboxes(5)==0 && checkboxes(6)==1)
    y_config=y_config_original-y_config_original(end)
end
end