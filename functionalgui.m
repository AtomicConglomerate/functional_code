function varargout = functionalgui(varargin)
% FUNCTIONALGUI MATLAB code for functionalgui.fig
%      FUNCTIONALGUI, by itself, creates a new FUNCTIONALGUI or raises the existing
%      singleton*.
%
%      H = FUNCTIONALGUI returns the handle to a new FUNCTIONALGUI or the handle to
%      the existing singleton*.
%
%      FUNCTIONALGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUNCTIONALGUI.M with the given input arguments.
%
%      FUNCTIONALGUI('Property','Value',...) creates a new FUNCTIONALGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before functionalgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to functionalgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help functionalgui

% Last Modified by GUIDE v2.5 17-Mar-2016 18:45:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @functionalgui_OpeningFcn, ...
                   'gui_OutputFcn',  @functionalgui_OutputFcn, ...
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


% --- Executes just before functionalgui is made visible.
function functionalgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to functionalgui (see VARARGIN)

% Store inputs in handles
handles.im_stack=varargin{1};
handles.p_cube=varargin{2};
handles.f=varargin{3};
handles.fps=varargin{4};


% Set slider frequency range
set(handles.frequency,'max',size(handles.p_cube,3));
set(handles.frequency,'min',1);
set(handles.frequency,'value',1);
guidata(hObject, handles);

% Data cursor mode
 handles.dcm_obj = datacursormode(hObject);
 set(handles.dcm_obj,'Enable','on','UpdateFcn',{@myupdatefcn,hObject});

% Display power image of first slice
axes(handles.power_image);
imshow(handles.p_cube(:,:,1)/max(max(handles.p_cube(:,:,1))))
set(handles.freq_disp, 'FontSize',20);
set(handles.freq_disp, 'String','0');
set(handles.toggle, 'String', 'Freq');

% Choose default command line output for functionalgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes functionalgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = functionalgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode=get(handles.toggle,'String');
if mode=='Freq'
    freq_ind=round(get(handles.frequency,'Value'));
    imshow(handles.p_cube(:,:,freq_ind)/max(max(handles.p_cube(:,:,freq_ind))),'Parent',handles.power_image)
    set(handles.freq_disp, 'String',num2str(handles.f(freq_ind)));
    
elseif mode=='Time'
    time_ind=round(get(handles.frequency,'Value'));
    imshow(handles.im_stack(:,:,time_ind),'Parent',handles.power_image);
    set(handles.freq_disp, 'String',num2str(time_ind/handles.fps));
end
    

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function txt = myupdatefcn(~,event_obj,hFigure)
 % Load handles
 handles=guidata(hFigure);
 
 % Check in which axes the click was registered
 hAxesParent  = get(get(event_obj,'Target'),'Parent');
 
 % Get position of data cursor
 pos = get(event_obj,'Position');
 
 if hAxesParent==handles.power_image
    txt='';
    % Plot FFT
    plot(handles.FFT,handles.f,squeeze(handles.p_cube(pos(2),pos(1),:)));
    
    % Plot FFT zoom
    plot(handles.FFT_zoom,handles.f,squeeze(handles.p_cube(pos(2),pos(1),:)));
    xlim(handles.FFT_zoom,[0 0.05]);
    
    % Plot time course
    plot(handles.time_course,squeeze(handles.im_stack(pos(2),pos(1),:)));
 
 elseif hAxesParent==handles.FFT
    txt=pos(1);
    freq_ind=find(abs(handles.f-pos(1))==min(abs(handles.f-pos(1))));
    imshow(handles.p_cube(:,:,freq_ind)/max(max(handles.p_cube(:,:,freq_ind))),'Parent',handles.power_image)
    set(handles.freq_disp,'String',num2str(handles.f(freq_ind)));
    set(handles.frequency,'Value',freq_ind);
    
 elseif hAxesParent==handles.time_course
    txt=pos(1);
    time_ind=round(pos(1));
    imshow(handles.im_stack(:,:,time_ind),'Parent',handles.power_image)
    set(handles.freq_disp,'String',num2str(time_ind/handles.fps));
    set(handles.frequency,'Value',time_ind);
 
 elseif hAxesParent==handles.FFT_zoom
    txt=pos(1);
    freq_ind=find(abs(handles.f-pos(1))==min(abs(handles.f-pos(1))));
    imshow(handles.p_cube(:,:,freq_ind)/max(max(handles.p_cube(:,:,freq_ind))),'Parent',handles.power_image)
    set(handles.freq_disp,'String',num2str(handles.f(freq_ind)));
    set(handles.frequency,'Value',freq_ind);
    
 end
 

% --- Executes on button press in toggle.
function toggle_Callback(hObject, eventdata, handles)
% hObject    handle to toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mode=get(handles.toggle, 'String');

if mode=='Freq'
    set(handles.toggle,'String','Time');
    set(handles.frequency,'max',size(handles.im_stack,3));
    set(handles.frequency,'SliderStep', [1/size(handles.im_stack,3) , 10/size(handles.im_stack,3) ]);
    time_ind=round(get(handles.frequency,'Value'));
    imshow(handles.im_stack(:,:,time_ind),'Parent',handles.power_image)
    
elseif mode=='Time'
    set(handles.toggle,'String','Freq');
    set(handles.frequency,'max',size(handles.p_cube,3));
    set(handles.frequency,'SliderStep', [1/size(handles.p_cube,3) , 10/size(handles.p_cube,3) ]);
    freq_ind=round(get(handles.frequency,'Value'));
    imshow(handles.p_cube(:,:,freq_ind)/max(max(handles.p_cube(:,:,freq_ind))),'Parent',handles.power_image)
end

    

% Hint: get(hObject,'Value') returns toggle state of toggle
