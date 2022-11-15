function varargout = interface_sournote2(varargin)
% INTERFACE_SOURNOTE2 M-file for interface_sournote2.fig
%      INTERFACE_SOURNOTE2, by itself, creates a new INTERFACE_SOURNOTE2 or raises the existing
%      singleton*.
%
%      H = INTERFACE_SOURNOTE2 returns the handle to a new INTERFACE_SOURNOTE2 or the handle to
%      the existing singleton*.
%
%      INTERFACE_SOURNOTE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_SOURNOTE2.M with the given input arguments.
%
%      INTERFACE_SOURNOTE2('Property','Value',...) creates a new INTERFACE_SOURNOTE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_melos5_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_sournote2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_sournote2

% Last Modified by GUIDE v2.5 18-Jan-2021 21:47:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_sournote2_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_sournote2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interface_sournote2 is made visible.
function interface_sournote2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_sournote2 (see VARARGIN)

% Choose default command line output for interface_sournote2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_sournote2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_sournote2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BoutonCalibration.
function BoutonCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to BoutonCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action = 'calibration';
sournote2(action);

% --- Executes on button press in BoutonDebut.
function BoutonDebut_Callback(hObject, eventdata, handles)
% hObject    handle to BoutonDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
poignee = handles;
sournote2('debut_bloc_essais', poignee);

% --- Executes on button press in Bouton1.
function Bouton1_Callback(hObject, eventdata, handles)
% hObject    handle to Bouton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action = 'reponse_1';
sournote2(action);

% --- Executes on button press in Bouton2.
function Bouton2_Callback(hObject, eventdata, handles)
% hObject    handle to Bouton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action = 'reponse_2';
sournote2(action);
