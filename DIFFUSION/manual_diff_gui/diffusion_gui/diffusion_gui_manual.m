function diffusion_gui_manual

clear; clc; close all

hObject= figure('Visible','off','Unit', 'normalized','position',[0.10, 0.07, .8, .8]);
handles = guihandles(hObject);
guidata(hObject,handles);

handles.axes = axes('Unit', 'normalized','position',[0.05, 0.05, .7, .9]);
rotate3d on


%% VARIABLES 

handles.dumbass = 1;
[handles.az, handles.el] = view;
 
handles.maxX = 10000;
handles.numX = 100;
handles.dx = 1/handles.numX;

handles.maxY = 10000;
handles.numY = 100;
handles.dy = 1/handles.numY;



handles.C = zeros(handles.numX, handles.numY);

handles.maxI = 10000;
handles.iter = 100;

handles.maxDiff = 100;
handles.diff = 1;

handles.maxStep = (handles.dx * handles.dy)/(4*handles.diff);
handles.step = (handles.dx *handles.dy)/(16*handles.diff);

handles.maxPause = 1;
handles.pause = .01;

handles.maxPeak = 100000;
handles.peak = 10000;

handles.X = handles.numX/2;
handles.Y = handles.numY/2;

handles.maxR = floor((handles.numX^2 + handles.numY^2)^(1/2));
handles.R = floor((handles.numX^2 + handles.numY^2)^(1/2))/4;

handles.bc = 1;
handles.shape = 1;

handles.inv = 0;


handles.lena = mean(imread('.\lena.jpg'),3);
handles.old = mean(imread('.\old.jpg'),3);
handles.T_text = uicontrol('Style', 'text', 'String', 'T = 1',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.85, .92, .1, .04]);



%% NUM X HANDLES
handles.numX_text = uicontrol('Style', 'text', 'String', 'X',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .85, .03, .04]);

handles.numX_edit = uicontrol('Style', 'edit','String', num2str(handles.numX),...
                    'Units', 'normalized',...
                    'Position', [.82, .85, .08, .04],...
                    'Callback', {@numX_edit});
handles.numX_slid = uicontrol('Style', 'slider','value', handles.numX/handles.maxX,...
                    'Units', 'normalized',...
                    'Position', [.91, .85, .08, .04],...
                    'Callback', {@numX_slid});                
                
%% NUM Y HANDLES   
handles.numY_text = uicontrol('Style', 'text', 'String', 'Y',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...                    
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .8, .03, .04]);                
                
handles.numY_edit = uicontrol('Style', 'edit','String', num2str(handles.numY),...
                    'Units', 'normalized',...
                    'Position', [.82, .8, .08, .04],...
                    'Callback', {@numY_edit});
handles.numY_slid = uicontrol('Style', 'slider','value', handles.numY/handles.maxY,...
                    'Units', 'normalized',...
                    'Position', [.91, .8, .08, .04],...
                    'Callback', {@numY_slid});                    

%% STEP HANDLES   
handles.step_text = uicontrol('Style', 'text', 'String', 't',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .75, .03, .04]);                
                
handles.step_edit = uicontrol('Style', 'edit','String', num2str(handles.step),...
                    'Units', 'normalized',...
                    'Position', [.82, .75, .08, .04],...
                    'Callback', {@step_edit});
handles.step_slid = uicontrol('Style', 'slider','value', handles.step/handles.maxStep,...
                    'Units', 'normalized',...
                    'Position', [.91, .75, .08, .04],...
                    'Callback', {@step_slid});                  

                
%% PAUSE HANDLES   
handles.pause_text = uicontrol('Style', 'text', 'String', 'P',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .7, .03, .04]);                
                
handles.pause_edit = uicontrol('Style', 'edit','String', num2str(handles.pause),...
                    'Units', 'normalized',...
                    'Position', [.82, .7, .08, .04],...
                    'Callback', {@pause_edit});
handles.pause_slid = uicontrol('Style', 'slider','value', handles.pause/handles.maxPause,...
                    'Units', 'normalized',...
                    'Position', [.91, .7, .08, .04],...
                    'Callback', {@pause_slid});         
                
%% DIFF HANDLES   
handles.diff_text = uicontrol('Style', 'text', 'String', 'K',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .65, .03, .04]);                
                
handles.diff_edit = uicontrol('Style', 'edit','String', num2str(handles.diff),...
                    'Units', 'normalized',...
                    'Position', [.82, .65, .08, .04],...
                    'Callback', {@diff_edit});
handles.diff_slid = uicontrol('Style', 'slider','value', handles.diff/handles.maxDiff,...
                    'Units', 'normalized',...
                    'Position', [.91, .65, .08, .04],...
                    'Callback', {@diff_slid});   
                
%% PEAK   
handles.peak_text = uicontrol('Style', 'text', 'String', 'T',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .55, .03, .04]);                
                
handles.peak_edit = uicontrol('Style', 'edit','String', num2str(handles.peak),...
                    'Units', 'normalized',...
                    'Position', [.82, .55, .08, .04],...
                    'Callback', {@peak_edit});
handles.peak_slid = uicontrol('Style', 'slider','value', handles.peak/handles.maxPeak,...
                    'Units', 'normalized',...
                    'Position', [.91, .55, .08, .04],...
                    'Callback', {@peak_slid});                

%% X COORDINATE   
handles.x_text = uicontrol('Style', 'text', 'String', 'x',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .5, .03, .04]);                
                
handles.x_edit = uicontrol('Style', 'edit','String', num2str(handles.X),...
                    'Units', 'normalized',...
                    'Position', [.82, .5, .08, .04],...
                    'Callback', {@x_edit});
handles.x_slid = uicontrol('Style', 'slider','value', handles.X/handles.numX,...
                    'Units', 'normalized',...
                    'Position', [.91, .5, .08, .04],...
                    'Callback', {@x_slid});    

%% Y COORDINATE   
handles.y_text = uicontrol('Style', 'text', 'String', 'y',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .45, .03, .04]);                
                
handles.y_edit = uicontrol('Style', 'edit','String', num2str(handles.Y),...
                    'Units', 'normalized',...
                    'Position', [.82, .45, .08, .04],...
                    'Callback', {@y_edit});
handles.y_slid = uicontrol('Style', 'slider','value', handles.Y/handles.numY,...
                    'Units', 'normalized',...
                    'Position', [.91, .45, .08, .04],...
                    'Callback', {@y_slid});                  
                
%% RADIUS  
handles.r_text = uicontrol('Style', 'text', 'String', 'R',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .4, .03, .04]);                
                
handles.r_edit = uicontrol('Style', 'edit','String', num2str(handles.R),...
                    'Units', 'normalized',...
                    'Position', [.82, .4, .08, .04],...
                    'Callback', {@r_edit});
handles.r_slid = uicontrol('Style', 'slider','value', handles.R/handles.maxR,...
                    'Units', 'normalized',...
                    'Position', [.91, .4, .08, .04],...
                    'Callback', {@r_slid});   
                
                
                
                
%% ITERATIONS  
handles.iter_text = uicontrol('Style', 'text', 'String', 'N',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .35, .03, .04]);                
                
handles.iter_edit = uicontrol('Style', 'edit','String', num2str(handles.iter),...
                    'Units', 'normalized',...
                    'Position', [.82, .35, .08, .04],...
                    'Callback', {@iter_edit});
handles.iter_slid = uicontrol('Style', 'slider','value', handles.iter/handles.maxI,...
                    'Units', 'normalized',...
                    'Position', [.91, .35, .08, .04],...
                    'Callback', {@iter_slid});                   
                
%% SHAPE  
handles.shape_text = uicontrol('Style', 'text', 'String', 'Shape',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.8, .3, .06, .04]);                
                
handles.shape_edit = uicontrol('Style', 'popup',...
                    'String', 'Cirle|Gaussian|Lena|Old',...
                    'Units', 'normalized',...
                    'Position', [.87, .3, .1, .04],...
                    'Callback', {@shape_popup});                
                
%% BOUNDARY CONDITIONS 
handles.bc_text = uicontrol('Style', 'text', 'String', 'B.C.',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.8, .25, .06, .04]);                
                
handles.bc_edit = uicontrol('Style', 'popup',...
                    'String', 'Dirichlet|Neumann|Cauchy',...
                    'Units', 'normalized',...
                    'Position', [.87, .25, .1, .04],...
                    'Callback', {@bc_popup});           
                
                
%% BOUNDARY CONDITIONS 
handles.method_text = uicontrol('Style', 'text', 'String', 'Method',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.8, .2, .06, .04]);                
                
handles.method_edit = uicontrol('Style', 'popup',...
                    'String', 'Explicit|Implicit|Crank-Nickelson',...
                    'Units', 'normalized',...
                    'Position', [.87, .2, .1, .04],...
                    'Callback', {@method_popup});                     
%% INVERSE
handles.inverse_text = uicontrol('Style', 'text', 'String', 'Inverse',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.8, .13, .08, .04]);                
                
handles.inverse_radio = uicontrol('Style', 'radio', 'Value', handles.inv,...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.9, .13, .02, .04],...
                    'Callback', {@inv_popup}); 
                
%% THE D
handles.theD = uicontrol('Style', 'pushbutton', 'String', 'The D',...
                    'Units', 'normalized',...
                    'HorizontalAlignment', 'center',...
                    'FontUnits', 'normalized',...
                    'FontSize', .6,...
                    'Position', [.78, .01, .2, .1],...
                    'Callback', {@theD});                   
                                                 
                

set(hObject, 'Visible', 'on');

guidata(hObject, handles);

initial(hObject, handles)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NUM X CALLBACKS
%%
function numX_edit(hObject, eventdata, ~)


    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = floor(val + .5);
        
        if (val > 0 && val <= handles.maxX)
            handles.numX = val;
            set(handles.numX_slid, 'Value', val/handles.maxX);
            
            %update dx
            handles.dx = 1/handles.numX;
            
            % adjust x-coordinates
            this = get(handles.x_slid, 'Value');
            set(handles.x_edit, 'String', num2str(this * handles.numX));
            
            
            % adjust radius
            handles.maxR = floor((handles.numX^2 + handles.numY^2)^(1/2));
            handles.R = floor((handles.numX^2 + handles.numY^2)^(1/2))/4;
            set(handles.r_edit, 'String', num2str(handles.R));
            set(handles.r_slid, 'value', handles.R/handles.maxR);
            
            
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxX)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.numX);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);

end


%%
function numX_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.numX = floor(val* (handles.maxX-10) + 10);
    set(handles.numX_edit, 'String', num2str(handles.numX));
    
    
    %update dx 
    handles.dx = 1/handles.numX;
    
    %adjust x coordinates
    this = get(handles.x_slid, 'Value');
    set(handles.x_edit, 'String', num2str(this * handles.numX));
    
    % adjust radius
    handles.maxR = floor((handles.numX^2 + handles.numY^2)^(1/2));
    handles.R = floor((handles.numX^2 + handles.numY^2)^(1/2))/3;
    set(handles.r_edit, 'String', num2str(handles.R));
    set(handles.r_slid, 'value', handles.R/handles.maxR)
    
  
    
    %adjust time step
    if 4*handles.diff*handles.step/(handles.dx * handles.dy) > .01
        disp('yea')
        
        handles.maxStep = (handles.dx * handles.dy)/(4*handles.diff);
        handles.step = (handles.dx *handles.dy)/(16*handles.diff);
        set(handles.step_edit, 'String', num2str(handles.step));
        set(handles.step_slid, 'String', handles.step/handles.maxStep);

    end
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NUM Y CALLBACKS
%%
function numY_edit(hObject, eventdata, ~)

    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = floor(val + .5);
        
        if (val > 0 && val <= handles.maxY)
            handles.numY = val;
            set(handles.numY_slid, 'Value', val/handles.maxY);
            
            this = get(handles.y_slid, 'Value');
            set(handles.y_edit, 'String', num2str(this * handles.numY));
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxY)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.numY);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end

%%
function numY_slid(hObject, eventdata, ~)
    
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.numY = floor(val* (handles.maxY-10) + 10);
    set(handles.numY_edit, 'String', num2str(handles.numY));
    
    this = get(handles.y_slid, 'Value');
    set(handles.y_edit, 'String', num2str(this * handles.numY));
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STEP CALLBACKS
%%
function step_edit(hObject, eventdata, ~)
    
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = (val);
        
        if (val <= handles.maxStep)
            handles.step = val;
            set(handles.step_slid, 'Value', val/handles.maxStep);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxStep)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.step);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%
function step_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.step = val* handles.maxStep;
    set(handles.step_edit, 'String', num2str(handles.step));
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAUSE CALLBACKS
%%
function pause_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = (val);
        
        if (val > 0 && val <= handles.maxPause)
            handles.pause = val;
            set(handles.pause_slid, 'Value', val/handles.maxPause);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxPause)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.pause);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%
function pause_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.pause = val* handles.maxPause;
    set(handles.pause_edit, 'String', num2str(handles.pause));
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DIFF CALLBACKS
%%
function diff_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = round(val);
        
        if (val > 0 && val < handles.maxDiff +1)
            handles. diff = val;
            set(handles.diff_slid, 'Value', val/handles.maxDiff);
            
            handles.maxStep = (handles.dx^2 + handles.dy^2)/(2*handles.diff);
            handles.step = (handles.dx^2 + handles.dy^2)/(10*handles.diff);
            if handles.diff^2*handles.step/(handles.dx^2 + handles.dy^2) > 1/2
%                 disp('hey')
                handles.maxStep = (handles.dx^2 + handles.dy^2)/(2*handles.diff^2);
                handles.step = (handles.dx^2 + handles.dy^2)/(8*handles.diff^2);
                
                guidata(hObject, handles);
                set(handles.step_edit, 'String', num2str(handles.step));
                set(handles.step_slid, 'String', handles.step/handles.maxStep);
            end
            
            
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxDiff)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.diff);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%
function diff_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.diff = val* handles.maxDiff;
    set(handles.diff_edit, 'String', num2str(handles.diff));
    
    if handles.diff^2*handles.step/(handles.dx^2 + handles.dy^2) > 1/2
%         disp('hey')
        handles.maxStep = (handles.dx^2 + handles.dy^2)/(2*handles.diff^2);
        handles.step = (handles.dx^2 + handles.dy^2)/(8*handles.diff^2);
        
        guidata(hObject, handles);
        set(handles.step_edit, 'String', num2str(handles.step));
        set(handles.step_slid, 'String', handles.step/handles.maxStep);
    end
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PEAK CALLBACKS
%%
function peak_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = round(val);
        
        if (val > 0 && val < handles.maxPeak +1)
            handles.peak = val;
            set(handles.peak_slid, 'Value', val/handles.maxPeak);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxPeak)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.peak);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%
function peak_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.peak = val* handles.maxPeak;
    set(handles.peak_edit, 'String', num2str(handles.peak));
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% X COORDINATE CALLBACKS
%%
function x_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = round(val);
        
        if (val > 0 && val < handles.numX +1)
            handles.X = val;
            set(handles.x_slid, 'Value', val/handles.numX);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.numX)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.X);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%
function x_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.X = val* handles.numX;
    set(handles.x_edit, 'String', num2str(handles.X));
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Y COORDINATE CALLBACKS
%%
function y_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = round(val);
        
        if (val > 0 && val < handles.numY +1)
            handles.Y = val;
            set(handles.y_slid, 'Value', val/handles.numY);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.numY)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.Y);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%
function y_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.Y = val* handles.numY;
    set(handles.y_edit, 'String', num2str(handles.Y));
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% R CALLBACKS
%%
function r_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = round(val);
        
        if (val > 0 && val < handles.maxR +1)
            handles.R = val;
            set(handles.r_slid, 'Value', val/handles.maxR);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxR)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        set(hObject, 'String', handles.iter);   
        fuck_off();
        
    end
       
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
    
end


%%
function r_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = get(hObject, 'value');
    handles.R = val* handles.maxR;
    set(handles.r_edit, 'String', num2str(handles.R));
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ITERATIONS CALLBACKS
%%
function iter_edit(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    val = str2double(get(hObject, 'String'));
    
    if ~isnan(val) && isreal(val)
        val = floor(val);
        
        if (val > 0 && val < handles.maxI +1)
            handles.iter = val;
            set(handles.iter_slid, 'Value', val/handles.maxI);
            
        else
            msg = ['Out Of Range: 0 - ' num2str(handles.maxI)];
            uiwait(msgbox(msg,'modal'));
        end
    else
        fuck_off();
        set(hObject, 'String', handles.iter);   
    end
    
    guidata(hObject, handles);
end


%%
function iter_slid(hObject, eventdata, ~)
    handles = guidata(hObject);
    val = get(hObject, 'value');
    handles.iter = val* handles.maxI;
    set(handles.iter_edit, 'String', num2str(handles.iter));
    
    guidata(hObject, handles);
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SHAPE CALLBACKS
%%
function shape_popup(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    
    handles.shape = get(hObject, 'value');
    
    
    guidata(hObject, handles);
    initial(hObject, eventdata, handles)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BC CALLBACKS
%%
function bc_popup(hObject, eventdata, ~)
    handles = guidata(hObject);
    handles.bc = get(hObject, 'value');
    guidata(hObject, handles);
    
    initial(hObject, eventdata, handles);
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INVERSE CALLBACKS
%%
function inv_popup(hObject, eventdata, ~)
    handles = guidata(hObject);
    handles.inv = get(hObject, 'value');
    handles.C = handles.peak - handles.C;
    
    guidata(hObject, handles);
    
    
    show(hObject, eventdata, handles);
       
    guidata(hObject, handles);
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% D CALLBACKS
%%
function theD(hObject, eventdata, ~)
%     handles = guidata(hObject);
%         
%     diffuse(hObject, eventdata, handles)
%     
%     guidata(hObject, handles);


    handles = guidata(hObject);
    [handles.az, handles.el] = view;
    
    
    initial(hObject, eventdata, handles);
    

    x = handles.diff*(handles.step/(handles.dx^2)).*...
        [1*ones(handles.numX,1) , - 2*ones(handles.numX,1), 1*ones(handles.numX,1)];
    
    diffX = spdiags(x, [-1, 0, 1], handles.numX, handles.numX);
    
    y = handles.diff*(handles.step/(handles.dy^2)).*...
        [1*ones(handles.numY,1) , - 2*ones(handles.numY,1), 1*ones(handles.numY,1)];
    
    diffY = spdiags(x, [-1, 0, 1], handles.numY, handles.numY);
    


    switch handles.bc
        case 1 
            for i = 1:handles.iter
                handles.C = handles.C + diffX*handles.C + handles.C*diffY;
                
                % enforce BC
                handles.C(1,1:end) = 0;
                handles.C(end,1:end) = 0;
                handles.C(1:end,1) = 0;
                handles.C(1:end,end) = 0;
                
                [handles.az, handles.el] = view;
                surf(handles.C, 'EdgeColor', 'none');
                view(handles.az, handles.el);
                
                axis([0 handles.numY 0 handles.numX 0 handles.peak*1.1]);
                mem = ['T = ' num2str(i)];
                set(handles.T_text,'String',num2str(mem));                
                pause(handles.pause);
            end

        case 2
            
            
            
            x = handles.diff*(handles.step/(handles.dx^2)).*...
                [1*ones(handles.numX+2,1) , - 2*ones(handles.numX+2,1), 1*ones(handles.numX+2,1)];
            
            diffX = spdiags(x, [-1, 0, 1], handles.numX, handles.numX);
            
            y = handles.diff*(handles.step/(handles.dy^2)).*...
                [1*ones(handles.numY+2,1) , - 2*ones(handles.numY+2,1), 1*ones(handles.numY+2,1)];
            
            diffY = spdiags(x, [-1, 0, 1], handles.numY, handles.numY);
            lineX = handles.diff*(handles.step/(handles.dx^2)).*[1 , - 2, 1];
            
            diffX = diag(repmat(lineX(1),handles.numX+1,1),-1)...
                + diag(repmat(lineX(2),handles.numX+2,1),0)...
                + diag(repmat(lineX(3),handles.numX+1,1),1);
            
            
            lineY = handles.diff*(handles.step/(handles.dy^2)).*[1 , - 2, 1];
            
            diffY = diag(repmat(lineY(1),handles.numY +1,1),-1)...
                + diag(repmat(lineY(2),handles.numY+2,1),0)...
                + diag(repmat(lineY(3),handles.numY+1,1),1);
            
            for i = 1:handles.iter
                % enforce BC
                handles.C(1,1:end) = handles.C(2,1:end);
                handles.C(end,1:end) = handles.C(end-1,1:end);
                handles.C(1:end,1) = handles.C(1:end,2);
                handles.C(1:end,end) = handles.C(1:end,end-1);                
                
                
                
                handles.C(1,1) = handles.C(2,2);
                handles.C(1,end) = handles.C(2,end-1);
                handles.C(end,1) = handles.C(end-1,2);
                handles.C(end,end) = handles.C(end-1,end-1);
                
                handles.C = handles.C + diffX*handles.C + handles.C*diffY;
                
                [handles.az, handles.el] = view;
                surf(handles.C(2:handles.numX,2:handles.numY), 'EdgeColor', 'none');
                view(handles.az, handles.el);
                
                axis([0 handles.numY 0 handles.numX 0 handles.peak*1.1]);
                
                mem = ['T = ' num2str(i)];
                set(handles.T_text,'String',num2str(mem));
                pause(handles.pause);
            end
        case 3
            lineX = handles.diff*(handles.step/(handles.dx^2)).*[1 , - 2, 1];
            
            diffX = diag(repmat(lineX(1),handles.numX,1),-1)...
                + diag(repmat(lineX(2),handles.numX+1,1),0)...
                + diag(repmat(lineX(3),handles.numX,1),1);
            
            lineY = handles.diff*(handles.step/(handles.dy^2)).*[1 , - 2, 1];
            
            diffY = diag(repmat(lineY(1),handles.numY,1),-1)...
                + diag(repmat(lineY(2),handles.numY+1,1),0)...
                + diag(repmat(lineY(3),handles.numY,1),1);
            
            for i = 1:handles.iter
                % enforce BC
                
                handles.C(end,2:end-1) = handles.C(end-1,2:end-1);
                handles.C(2:end-1,1) = handles.C(2:end-1,2);
                              
                
                
                handles.C = handles.C + diffX*handles.C + handles.C*diffY;
                
                
                handles.C(1,1:end) = 0;
                handles.C(1:end,end) = 0;  
                
                [handles.az, handles.el] = view;
                surf(handles.C(1:handles.numX,2:handles.numY+1), 'EdgeColor', 'none');
                view(handles.az, handles.el);
                
                axis([0 handles.numY 0 handles.numX 0 handles.peak*1.1]);
                
                mem = ['T = ' num2str(i)];
                set(handles.T_text,'String',num2str(mem));                
                pause(handles.pause);
            end
    end   
    
    
%     guidata(hObject, handles);
      
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZE   
function initial(hObject, eventdata, ~)
    
    handles = guidata(hObject);    
    
    switch handles.bc
        case 1 
            handles.C = zeros(handles.numX,handles.numY);
        case 2
            handles.C = zeros(handles.numX+2,handles.numY+2);
        case 3
            handles.C = zeros(handles.numX+1,handles.numY+1);
    end


    switch handles.shape
        case 1
            for i = 1:size(handles.C,1)
               for j = 1:size(handles.C,2)
                   handles.C(i,j) = handles.peak*( (((i-handles.X)/handles.R)^2 ... 
                    + ((j-handles.Y)/handles.R)^2) < 1);
               end
            end
            
        case 2
            for i = 1:size(handles.C,1)
               for j = 1:size(handles.C,2)
                   handles.C(i,j) = handles.peak*( exp(-(((i-handles.X)/handles.R)^2 ... 
                    + ((j-handles.Y)/handles.R)^2)));
               end
            end      
        case 3
            lena = handles.peak/max(max(handles.lena))*(handles.lena);
            handles.numX = size(handles.lena,1);
            handles.numY = size(handles.lena,2);
            
            set(handles.numX_edit, 'String', num2str(handles.numX));
            set(handles.numX_slid, 'value', handles.numX/handles.maxX);
            
            set(handles.numY_edit, 'String', num2str(handles.numY));
            set(handles.numY_slid, 'value', handles.numY/handles.maxY);
            
            switch handles.bc
                case 1
                    handles.C  = lena;
                case 2
                    handles.C(2:end-1, 2:end-1)  = lena;
                    
                case 3
                    handles.C(1:end-1, 1:end-1)  = lena;
            end
            
        case 4
            lena = handles.peak/max(max(handles.old))*(handles.old);
            handles.numX = size(handles.old,1);
            handles.numY = size(handles.old,2);
            
            set(handles.numX_edit, 'String', num2str(handles.numX));
            set(handles.numX_slid, 'value', handles.numX/handles.maxX);
            
            set(handles.numY_edit, 'String', num2str(handles.numY));
            set(handles.numY_slid, 'value', handles.numY/handles.maxY);
            
            switch handles.bc
                case 1
                    handles.C  = lena;
                case 2
                    handles.C(2:end-1, 2:end-1)  = lena;
                    
                case 3
                    handles.C(1:end-1, 1:end-1)  = lena;
            end            

    end
    
    if handles.inv == 1
        handles.C = handles.peak - handles.C;
    end
         
    guidata(hObject, handles);
    
    show(hObject, eventdata, handles);
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT     

function show(hObject, eventdata, ~)
    handles = guidata(hObject);
    
    
    [handles.az, handles.el] = view;
    surf(handles.C(1:handles.numX,1:handles.numY),'EdgeColor', 'none');
    view(handles.az, handles.el);
    axis([0 handles.numY 0 handles.numX 0 handles.peak*1.1]);
    
    guidata(hObject, handles);

    
%         lineX = handles.diff*(handles.step/(handles.dx^2)).*[1 , - 2, 1];
    
%     diffX = diag(repmat(lineX(1),handles.numX-1,1),-1)...
%         + diag(repmat(lineX(2),handles.numX,1),0)...
%         + diag(repmat(lineX(3),handles.numX-1,1),1);
%     
%     lineY = handles.diff*(handles.step/(handles.dy^2)).*[1 , - 2, 1]; 
%     
%     diffY = diag(repmat(lineY(1),handles.numY -1,1),-1)...
%         + diag(repmat(lineY(2),handles.numY,1),0)...
%         + diag(repmat(lineY(3),handles.numY-1,1),1);    
% 
%     
%     for i = 1:100
%     handles.C = handles.C + handles.C*diffX + diffY*handles.C;
%                 
%     
%     surf(handles.C(1:handles.numX,1:handles.numY),'EdgeColor', 'none');
%     axis([0 handles.numX 0 handles.numY 0 handles.peak*1.1]);
% 
%         pause(.1)
%     
%     end

    
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %% DIFFUSE 
% % function diffuse(hObject, eventdata, handles)
% %     handles = guidata(hObject);
% % 
% % 
% %     switch handles.bc
% %         case 1 
% %             lineX = handles.diff*(handles.step/(handles.dx^2)).*[1 , - 2, 1];
% %             
% %             diffX = diag(repmat(lineX(1),handles.numX-1,1),-1)...
% %                 + diag(repmat(lineX(2),handles.numX,1),0)...
% %                 + diag(repmat(lineX(3),handles.numX-1,1),1);
% %             
% %             lineY = handles.diff*(handles.step/(handles.dy^2)).*[1 , - 2, 1];
% %             
% %             diffY = diag(repmat(lineY(1),handles.numY -1,1),-1)...
% %                 + diag(repmat(lineY(2),handles.numY,1),0)...
% %                 + diag(repmat(lineY(3),handles.numY-1,1),1);
% %             
% %             for i = 1:handles.iter
% %                 handles.C = handles.C + diffX*handles.C + handles.*diffY;
% %                 
% %                 % enforce BC
% %                 handles.C(1,1:end) = 0;
% %                 handles.C(end,1:end) = 0;
% %                 handles.C(1:end,1) = 0;
% %                 handles.C(1:end,end) = 0;
% %                 
% %                 surf(handles.C, 'EdgeColor', 'none');
% %                 axis([0 handles.numX 0 handles.numY 0 handles.peak*1.1]);
% %                 mem = ['T = ' num2str(i)];
% %                 set(handles.T_text,'String',num2str(mem));                
% %                 pause(handles.pause);
% %             end
% % 
% %         case 2
% %             lineX = handles.diff*(handles.step/(handles.dx^2)).*[1 , - 2, 1];
% %             
% %             diffX = diag(repmat(lineX(1),handles.numX+1,1),-1)...
% %                 + diag(repmat(lineX(2),handles.numX+2,1),0)...
% %                 + diag(repmat(lineX(3),handles.numX+1,1),1);
% %             
% %             lineY = handles.diff*(handles.step/(handles.dy^2)).*[1 , - 2, 1];
% %             
% %             diffY = diag(repmat(lineY(1),handles.numY +1,1),-1)...
% %                 + diag(repmat(lineY(2),handles.numY+2,1),0)...
% %                 + diag(repmat(lineY(3),handles.numY+1,1),1);
% %             
% %             for i = 1:handles.iter
% %                 % enforce BC
% %                 handles.C(1,2:end-1) = handles.C(2,2:end-1);
% %                 handles.C(end,2:end-1) = handles.C(end-1,2:end-1);
% %                 handles.C(2:end-1,1) = handles.C(2:end-1,2);
% %                 handles.C(2:end-2,end) = handles.C(2:end-2,end-1);                
% %                 
% %                 
% %                 handles.C = handles.C + handles.C*diffX + diffY*handles.C;
% %                 
% %                 surf(handles.C(2:handles.numX+1,2:handles.numY+1), 'EdgeColor', 'none');
% %                 axis([0 handles.numX 0 handles.numY 0 handles.peak*1.1]);
% %                 
% %                 mem = ['T = ' num2str(i)];
% %                 set(handles.T_text,'String',num2str(mem));
% %                 pause(handles.pause);
% %             end
% %         case 3
% %             lineX = handles.diff*(handles.step/(handles.dx^2)).*[1 , - 2, 1];
% %             
% %             diffX = diag(repmat(lineX(1),handles.numX,1),-1)...
% %                 + diag(repmat(lineX(2),handles.numX+1,1),0)...
% %                 + diag(repmat(lineX(3),handles.numX,1),1);
% %             
% %             lineY = handles.diff*(handles.step/(handles.dy^2)).*[1 , - 2, 1];
% %             
% %             diffY = diag(repmat(lineY(1),handles.numY,1),-1)...
% %                 + diag(repmat(lineY(2),handles.numY+1,1),0)...
% %                 + diag(repmat(lineY(3),handles.numY,1),1);
% %             
% %             for i = 1:handles.iter
% %                 % enforce BC
% %                 
% %                 handles.C(end,2:end-1) = handles.C(end-1,2:end-1);
% %                 handles.C(2:end-1,1) = handles.C(2:end-1,2);
% %                               
% %                 
% %                 
% %                 handles.C = handles.C + handles.C*diffX + diffY*handles.C;
% %                 
% %                 
% %                 handles.C(1,1:end) = 0;
% %                 handles.C(1:end,end) = 0;  
% %                 
% %                 
% %                 surf(handles.C(1:handles.numX,2:handles.numY), 'EdgeColor', 'none');
% %                 axis([0 handles.numX 0 handles.numY 0 handles.peak*1.1]);
% %                 
% %                 mem = ['T = ' num2str(i)];
% %                 set(handles.T_text,'String',num2str(mem));                
% %                 pause(handles.pause);
% %             end
% %     end   
% %     
% %     
% %     guidata(hObject, handles);
% %     
% % end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fuck_off()

 
    handles = guidata(hObject);
    
    switch handles.dumbass
        case 1
            uiwait(msgbox('Invalid Input','modal'));
        case 2
            uiwait(msgbox('Still Wrong','modal'));
        case 3
            uiwait(msgbox('Wrong Again','modal'))
        case 4
            uiwait(msgbox('Thats enough','modal'));       
        case 5      
            uiwait(msgbox('Sigh','modal'));
        case 6
            uiwait(msgbox('Ah! Just stop','modal'));
        case 7
            uiwait(msgbox('Nope,stop','modal'));
        case 8
            uiwait(msgbox('Please! Just give up','modal'));
        case 9
            uiwait(msgbox('Step away from the keyboard','modal'));
        case 10
            uiwait(msgbox('Ah! Such a dick','modal'));
        case 11
            uiwait(msgbox('Is there any intelligence there?!','modal'));
        case 12
            uiwait(msgbox('Fuck you guy!','modal'));
        case 13
            uiwait(msgbox('OH YOU WANNA MESS WITH ME?','modal'));
        case 14
            uiwait(msgbox('WHY DONT YOU GO FUCK YOURSELF!','modal'));
            close();
    end
    
    handles.dumbass = handles.dumbass + 1;
    guidata(hObject, handles);
end

end