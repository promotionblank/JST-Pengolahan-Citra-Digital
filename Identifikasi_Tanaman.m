function varargout = Identifikasi_Tanaman(varargin)
% IDENTIFIKASI_TANAMAN MATLAB code for Identifikasi_Tanaman.fig
%      IDENTIFIKASI_TANAMAN, by itself, creates a new IDENTIFIKASI_TANAMAN or raises the existing
%      singleton*.
%
%      H = IDENTIFIKASI_TANAMAN returns the handle to a new IDENTIFIKASI_TANAMAN or the handle to
%      the existing singleton*.
%
%      IDENTIFIKASI_TANAMAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IDENTIFIKASI_TANAMAN.M with the given input arguments.
%
%      IDENTIFIKASI_TANAMAN('Property','Value',...) creates a new IDENTIFIKASI_TANAMAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Identifikasi_Tanaman_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Identifikasi_Tanaman_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Identifikasi_Tanaman

% Last Modified by GUIDE v2.5 04-Nov-2020 15:53:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Identifikasi_Tanaman_OpeningFcn, ...
                   'gui_OutputFcn',  @Identifikasi_Tanaman_OutputFcn, ...
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


% --- Executes just before Identifikasi_Tanaman is made visible.
function Identifikasi_Tanaman_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Identifikasi_Tanaman (see VARARGIN)

% Choose default command line output for Identifikasi_Tanaman
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Identifikasi_Tanaman wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Identifikasi_Tanaman_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [nama_file,nama_path] = uigetfile({'*.*'});
     
    if ~isequal(nama_file,0)
        Img = imread(fullfile(nama_path,nama_file));
        axes(handles.axes1)
        imshow(Img)
        handles.Img = Img;
        guidata(hObject,handles)
         
        axes(handles.axes2)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        axes(handles.axes3)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        axes(handles.axes4)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        axes(handles.axes5)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        set(handles.uitable1,'Data',[])
        set(handles.edit1,'String','')
    else
        return
    end
catch
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    Img = im2double(handles.Img);
     
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
     
    Red = cat(3,R,G*0,B*0);
    Green = cat(3,R*0,G,B*0);
    Blue = cat(3,R*0,G*0,B);
     
    axes(handles.axes2)
    imshow(Red)
    title('Red')
     
    axes(handles.axes3)
    imshow(Green)
    title('Green')
     
    axes(handles.axes4)
    imshow(Blue)
    title('Blue')
     
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
     
    % Ekstraksi Ciri Tekstur Filter Gabor
    I = (rgb2gray(Img));
    wavelength = 4;
    orientation = 90;
    [mag,~] = imgaborfilt(I,wavelength,orientation);
     
    axes(handles.axes5)
    imshow(mag,[])
    title('Magnitude')
     
    H = imhist(mag)';
    H = H/sum(H);
    I = [0:255]/255;
     
    CiriMEAN = mean2(mag);
    CiriENT = -H*log2(H+eps)';
    CiriVAR = (I-CiriMEAN).^2*H';
     
     
    data2 = cell(6,2);
    data2{1,1} = 'Red';
    data2{2,1} = 'Green';
    data2{3,1} = 'Blue';
    data2{4,1} = 'Mean';
    data2{5,1} = 'Entropy';
    data2{6,1} = 'Varians';
    data2{1,2} = CiriR;
    data2{2,2} = CiriG;
    data2{3,2} = CiriB;
    data2{4,2} = CiriMEAN;
    data2{5,2} = CiriENT;
    data2{6,2} = CiriVAR;
     
    set(handles.uitable1,'Data',data2,'ForegroundColor',[0 0 0])
     
    ciri_tanaman = [CiriR; CiriG; CiriB; CiriMEAN; CiriENT; CiriVAR];
     
    handles.ciri_tanaman = ciri_tanaman;
    guidata(hObject, handles)
     
    set(handles.edit1,'String','')
catch
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes5)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
set(handles.uitable1,'Data',[])
set(handles.edit1,'String','')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    ciri_tanaman = handles.ciri_tanaman;
    load net_keluaran
     
    hasil_uji = round(sim(net_keluaran,ciri_tanaman));
     
    if hasil_uji == 0
        kelas = 'Gingier Plant (Zingiber Officinale)';
    elseif hasil_uji == 1
        kelas = 'Turmeric Plant (Curcuma Longa)';
    else
        kelas = 'Unknown';
    end
     
    set(handles.edit1,'String',kelas);
catch
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
