function varargout = diffure_gui(varargin)
% DIFFURE_GUI MATLAB code for diffure_gui.fig
%      DIFFURE_GUI, by itself, creates a new DIFFURE_GUI or raises the existing
%      singleton*.
%
%      H = DIFFURE_GUI returns the handle to a new DIFFURE_GUI or the handle to
%      the existing singleton*.
%
%      DIFFURE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIFFURE_GUI.M with the given input arguments.
%
%      DIFFURE_GUI('Property','Value',...) creates a new DIFFURE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before diffure_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to diffure_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help diffure_gui

% Last Modified by GUIDE v2.5 06-Oct-2013 18:16:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @diffure_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @diffure_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before diffure_gui is made visible.
function diffure_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to diffure_gui (see VARARGIN)
set(hObject,'Resize','on');
set(hObject,'Units','normalized');


handles.str = ['@(x)' 'x'];

handles.dumbass = 1;

handles.maxN = 1000;

handles.shape = 1;

handles.radio = 0;

handles.K = 1;

handles.numX = 100; 
set(handles.edit6,'String', handles.numX);
set(handles.slider7,'Value',handles.numX/handles.maxN);

handles.numY = 100;
set(handles.edit7,'String', handles.numY);
set(handles.slider6,'Value',handles.numY/handles.maxN);

handles.numT = 1000;
set(handles.edit8,'String', handles.numT);
set(handles.slider5,'Value',handles.numT/100000);

dx = 1/(handles.numX + 1);
dy = 1/(handles.numY + 1);

handles.dt = .000005;
set(handles.edit9,'String', handles.dt);
set(handles.slider8,'Value',handles.dt/.1);

handles.T = 10000;
set(handles.edit2,'String', handles.T);
set(handles.slider1,'Value',handles.T/10000);

handles.X = 50;
set(handles.edit3,'String', handles.X);
set(handles.slider2,'Value',handles.X/handles.numX);

handles.Y = 50;
set(handles.edit4,'String', handles.Y);
set(handles.slider3,'Value',handles.Y/handles.numY);

handles.R = 20;
set(handles.edit5,'String', handles.R);
set(handles.slider4,'Value',handles.R/handles.numX);

handles.pause = .00000001;
set(handles.edit10,'String', handles.pause);
set(handles.slider9,'Value',handles.pause/.01);



mem = handles.numX*handles.numY*handles.numT*64/8e9;
mem = [num2str(mem) ' GB'];
set(handles.text10,'String',mem);


mem = ['T = ' '1'];
set(handles.text11,'String',mem);
% Choose default command line output for diffure_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initial(hObject, eventdata, handles)

% UIWAIT makes diffure_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = diffure_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))
    textValue = round(str2double(stringValue));
    
    if (textValue > -1 && textValue < 10000 + 1)
        handles.T = textValue;
        set(handles.slider1,'Value',textValue/10000);
        initial(hObject, eventdata, handles);
    else
        msg = ['Out Of Range: 0 - ' num2str(10000)];
        msgbox(msg);
    end    

else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', num2str(handles.T));
    
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))

    textValue = round(str2double(stringValue));
    if (textValue > -1 && textValue < handles.numX + 1)
        handles.X = textValue;
        set(handles.slider2,'Value',textValue/handles.numX);
        initial(hObject, eventdata, handles);
    else
        msg = ['Out Of Range: 0 - ' num2str(handles.numX)];
        msgbox(msg);
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', num2str(handles.numX));
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))
    
    textValue = round(str2double(stringValue));
    if (textValue > 0 && textValue < handles.numY + 1)
        handles.Y = textValue;
        set(handles.slider3,'Value',textValue/handles.numY);
        initial(hObject, eventdata, handles);
    else
        msg = ['Out Of Range: 0 - ' num2str(handles.numY)];
        msgbox(msg);        
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.Y);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))
    
    textValue = round(str2double(stringValue));
    if (textValue > 0 && textValue < handles.numX + 1)
        handles.R = textValue;
        set(handles.slider4,'Value',textValue/handles.numX);
        initial(hObject, eventdata, handles);
    else
        msg = ['Out Of Range: 0 - ' num2str(handles.numX)];
        msgbox(msg);        
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.R);

end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))

    textValue = round(str2double(stringValue));
    if (textValue > 9 && textValue < handles.maxN + 1)
 
        temp = textValue;
        mem = temp*handles.numY*handles.numT*64/8e9;
        
        if mem > 6
            memWarn = ['This will allocate ' num2str(mem) ' GB of RAM. You sure?']; 
            memWarning = questdlg(memWarn,'Oh shit');
        else
            memWarning = 'Yes';
        end
            
        
        if strcmp(memWarning,'Yes')
            handles.numX = textValue; 
            mem = handles.numX*handles.numY*handles.numT*64/8e9;
            
            set(handles.slider7,'Value',(textValue)/handles.maxN);

            mem = [num2str(mem) ' GB'];
            set(handles.text10,'String',mem)

           ratX = get(handles.slider2,'Value');
           handles.X = round(ratX*handles.numX);
           set(handles.edit3, 'String', handles.X);       

           ratR = get(handles.slider4,'Value');

           handles.R = round(ratR*handles.numX);
           set(handles.edit5, 'String', handles.R);

           initial(hObject, eventdata, handles);
           
        else
            set(hObject, 'String', num2str(handles.numX));
        end
        
    else
        msg = ['Out Of Range: 0 - 1000'];
        msgbox(msg); 
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.numX);    
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))
    textValue = round(str2double(stringValue));
    if (textValue > 9 && textValue < 1001)
        
        temp = textValue;
        mem = handles.numX*temp*handles.numT*64/8e9;
        
        if mem > 6
            memWarn = ['This will allocate ' num2str(mem) ' GB or RAM. You sure?']; 
            memWarning = questdlg(memWarn,'OOh shit');        
        else 
            memWarning = 'Yes';
        end
        
        if strcmp(memWarning,'Yes')
        
            handles.numY = textValue;
            mem = handles.numX*handles.numY*handles.numT*64/8e9;
            mem = [num2str(mem) ' GB'];
            set(handles.text10,'String',mem)        

            set(handles.slider6,'Value',(textValue)/1000);

            ratY = get(handles.slider3,'Value');
            handles.Y = round(ratY*handles.numY);
            set(handles.edit4,'String',handles.Y);
            initial(hObject, eventdata, handles);
        else
            set(hObject,'String', num2str(handles.numY));
        end
        
    else
        msg = ['Out Of Range: 0 - 1000'];
        msgbox(msg); 
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.numY);    
end
% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))

    textValue = round(str2double(stringValue));
    if (textValue > 99 && textValue < 1000001)
        
        temp = textValue;
        
        mem = handles.numX*handles.numY*temp*64/8e9;
        
        if mem > 6
            memWarn = ['This will allocate ' num2str(mem) ' GB or RAM. You sure?']; 
            memWarning = questdlg(memWarn,'OOh shit');        
        else 
            memWarning = 'Yes';
        end
        
        if strcmp(memWarning,'Yes')  
            
            handles.numT = textValue;
            mem = handles.numX*handles.numY*handles.numT*64/8e9;
            
            mem = [num2str(mem) ' GB'];
            set(handles.text10,'String',mem)
            set(handles.slider5,'Value',(textValue)/1000000);
            initial(hObject, eventdata, handles);
        else
            set(hObject, 'String', num2str(handles.numT));
        end
    else
        msg = ['Out Of Range: 0 - 1e6'];
        msgbox(msg); 
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.numT);    
end
% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stringValue = get(hObject,'String');
if ~isnan(str2double(stringValue))
    
    textValue = (str2double(stringValue));
    if (textValue > 0.0000000001 && textValue < 0.01)
        handles.dt = textValue;
        set(handles.slider8,'Value',(textValue)/.01);
        initial(hObject, eventdata, handles);
    else
        msg = ['Out Of Range: 1e-10 - 1e-2'];
        msgbox(msg); 
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.dt);    
end
% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
stringValue = get(hObject,'String');

if ~isnan(str2double(stringValue))
    textValue = (str2double(stringValue));
    if (textValue > .99e-30 && textValue < .11)
        handles.pause = textValue;
        set(handles.slider9,'Value',(textValue)/.1);
        initial(hObject, eventdata, handles);
    else
        msg = ['Out Of Range: 1e-30 - 1e-1'];
        msgbox(msg); 
    end
else
    insult(hObject, eventdata, handles);
    set(hObject, 'String', handles.pause);    
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(10000*get(hObject,'Value'));
handles.T = num;
sliderValue = num2str( num );
set(handles.edit2,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(handles.numX*(get(hObject,'Value')));
handles.X = num;
sliderValue = num2str( num );
set(handles.edit3,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(handles.numY*get(hObject,'Value'));
handles.Y = num;
sliderValue = num2str( num );
set(handles.edit4,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(handles.numX*get(hObject,'Value'));
handles.R = num;
sliderValue = num2str( num );
set(handles.edit5,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(100000*get(hObject,'Value'));
handles.numT = num;
sliderValue = num2str( num );

        mem = handles.numX*handles.numY*handles.numT*64/8e9;
        mem = [num2str(mem) ' GB'];
        set(handles.text10,'String',mem)

set(handles.edit8,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(998*get(hObject,'Value')+1.5);
handles.numY = num;
sliderValue = num2str( num );

        mem = handles.numX*handles.numY*handles.numT*64/8e9;
        mem = [num2str(mem) ' GB'];
        set(handles.text10,'String',mem)

ratY = get(handles.slider3,'Value');
handles.Y = round(ratY*handles.numY);
set(handles.edit4, 'String', handles.Y);
        
set(handles.edit7,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = round(998*get(hObject,'Value')+1.5);
handles.numX = num;
sliderValue = num2str( num );

        mem = handles.numX*handles.numY*handles.numT*64/8e9;
        mem = [num2str(mem) ' GB'];
        set(handles.text10,'String',mem)

set(handles.edit6,'String', sliderValue)

ratX = get(handles.slider2,'Value');
handles.X = round(ratX * handles.numX);
set(handles.edit3, 'String', handles.X);

ratR = get(handles.slider4,'Value')
handles.R = round(ratR * handles.numX + .5);
set(handles.edit5, 'String', handles.R);



initial(hObject, eventdata, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, ~, ~)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = (.005*get(hObject,'Value'));
handles.dt = num;
sliderValue = num2str( num );
set(handles.edit9,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = (.01*get(hObject,'Value'));
handles.pause = num;
sliderValue = num2str( num );
set(handles.edit10,'String', sliderValue)

initial(hObject, eventdata, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, ~, ~)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initial(hObject, eventdata, handles)

dt = handles.dt;
dx = 1/(handles.numX + 1);
dy = 1/(handles.numY + 1);
numX = handles.numX;
numY = handles.numY;
T = handles.T;
 K = handles.K;
 
% X diffusion matrix
lineX = [K*(dt/(dx^2)).*[1 , -2, 1], zeros(1, numX-2)]
coefX = toeplitz([dt/(dx^2) zeros(1,numX)], lineX);
coefX = coefX(1:end-1, 2:end);
% Y diffusion matrix
lineY = [K*(dt/(dy^2)).*[1, - 2, 1], zeros(1, numY-2)]; 
coefY = toeplitz([dt/(dy^2) zeros(1,numY)], lineY);
coefY = coefY(1:end-1, 2:end);


for i = 2:handles.numT
    handles.C = handles.C + coefX*handles.C + handles.C*coefY;
    surf(handles.C, 'EdgeColor', 'none');
    axis([0 numX 0 numY 0 T+.1*T]);
    
    mem = ['T = ' num2str(i)];
    set(handles.text11,'String',num2str(mem));
    
    pause(handles.pause);
end


% for k = 1:handles.numT
%    for i = 2:handles.numX-1
%       for j = 2:handles.numY-1
%          handles.C(i,j,k+1)  = handles.C(i,j,k) + ...
%          handles.dt*((handles.C(i+1,j,k) - 2*handles.C(i,j,k) + handles.C(i-1,j,k))/(dx^2)...
%            + (handles.C(i,j+1,k) - 2*handles.C(i,j,k) + handles.C(i,j-1,k))/(dy^2)); 
%       end
%    end
% end
% 
% surf(handles.C(:,:,1),'EdgeColor', 'none');
% axis([0 handles.numX 0 handles.numY 0 handles.T+.1*handles.T]);
% 
% 
% [az el] = view;
% for i = 2:handles.numT
%     [az el] = view;
%     surf(handles.C(:,:,i),'EdgeColor', 'none');
%     mem = ['T = ' num2str(i)];
%     set(handles.text11,'String',num2str(mem));
%     view(az, el);
%     axis([0 handles.numX 0 handles.numY 0 handles.T+.1*handles.T]);
% %     drawnow expose update; 
%     pause(handles.pause)
% end


function initial(hObject, eventdata, handles)
% handles.C = zeros(handles.numX, handles.numY, handles.numT);


handles.C(1,:) = 0;
handles.C(handles.numX,:)= 0;

handles.C(:,1) = 0;
handles.C(:,handles.numY)= 0;



switch handles.shape
       
case 2

    if ~handles.radio;
    for i = 2:handles.numX-1
        for j = 2:handles.numY-1
            handles.C(i,j) = handles.T*( exp(-((i-handles.X)/handles.R)^2 ... 
                - ((j-handles.Y)/handles.R)^2));
        end
    end
    else
    for i = 2:handles.numX-1
        for j = 2:handles.numY-1
            handles.C(i,j) = handles.T*(1 - exp(-((i-handles.X)/handles.R)^2 ... 
                - ((j-handles.Y)/handles.R)^2));
        end
    end
    end

case 1
    if ~handles.radio;
        for i = 2:handles.numX-1
            for j = 2:handles.numY-1
                handles.C(i,j) = handles.T*( (((i-handles.X)/handles.R)^2 ... 
                    + ((j-handles.Y)/handles.R)^2) < 1);
            end
        end
    else
        for i = 2:handles.numX-1
            for j = 2:handles.numY-1
                handles.C(i,j) = handles.T*( (((i-handles.X)/handles.R)^2 ... 
                    + ((j-handles.Y)/handles.R)^2) > 1);
            end
        end
    end
end


guidata(hObject, handles);

surf(handles.C(:,:,1),'EdgeColor', 'none');




% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.radio = get(hObject,'Value');

initial(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1





% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
handles.shape = get(hObject,'value');
initial(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function insult(hObject, eventdata, handles)



num = handles.dumbass;


switch num    
    case 1
        msgbox('Invalid Input'); 
    case 2 
        msgbox('Still Wrong');
    case 3
        msgbox('Wrong Again');
    case 4
        msgbox('Thats enough');        
    case 5
        msgbox('Sigh');
    case 6 
        msgbox('Ah! Just stop');     
    case 7
        msgbox('Nope,stop');        
    case 8
        msgbox('Please! Just give up');
    case 9
        msgbox('Step away from the keyboard');        
    case 10
        msgbox('Ah! Such a dick');        
    case 11
        msgbox('Is there any intelligence there?!');   
    case 12
        msgbox('Fuck you guy!');        
    case 13
        msgbox('OH YOU WANNA MESS WITH ME?');   
    case 14
        msgbox('WHY DONT YOU GO FUCK YOURSELF!');    
        close(diffure_gui);
end

handles.dumbass = handles.dumbass + 1;
guidata(hObject, handles);        
        



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

str = get(hObject,'string')
% handles.str = strcat('@(x)', str);
handles.str = ['@(x)' str{1}];

guidata(hObject, handles);        

handles.C(1,:) = 0;
handles.C(handles.numX,:)= 0;

handles.C(:,1) = 0;
handles.C(:,handles.numY)= 0;

fh = str2func(handles.str);


for i = 2:handles.numX-1
    for j = 2:handles.numY-1
        handles.C(i,j) = handles.T*(((i - fh(j- handles.Y) - handles.X)>0)...
                                    -(i + fh(j- handles.Y) - handles.X)>0);
    end
end


guidata(hObject, handles);

surf(handles.C(:,:,1),'EdgeColor', 'none');



% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
