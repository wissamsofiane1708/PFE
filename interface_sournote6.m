function varargout = interface_sournote6(varargin)
% INTERFACE_SOURNOTE6 M-file for interface_sournote6.fig
%      INTERFACE_SOURNOTE6, by itself, creates a new INTERFACE_SOURNOTE6 or raises the existing
%      singleton*.
%
%      H = INTERFACE_SOURNOTE6 returns the handle to a new INTERFACE_SOURNOTE6 or the handle to
%      the existing singleton*.
%
%      INTERFACE_SOURNOTE6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_SOURNOTE6.M with the given input arguments.
%
%      INTERFACE_SOURNOTE6('Property','Value',...) creates a new INTERFACE_SOURNOTE6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_melos5_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_sournote6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_sournote6

% Last Modified by GUIDE v2.5 18-Sep-2021 00:50:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_sournote6_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_sournote6_OutputFcn, ...
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


% --- Executes just before interface_sournote6 is made visible.
function interface_sournote6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_sournote6 (see VARARGIN)

% Choose default command line output for interface_sournote6
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_sournote6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_sournote6_OutputFcn(hObject, eventdata, handles)
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
sournote6(action);

% --- Executes on button press in BoutonDebut.
function BoutonDebut_Callback(hObject, eventdata, handles)
% hObject    handle to BoutonDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
poignee = handles;
sournote6('debut_bloc_essais', poignee);

% --- Executes on button press in Bouton1.
function Bouton1_Callback(hObject, eventdata, handles)
% hObject    handle to Bouton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action = 'reponse_1';
sournote6(action);

% --- Executes on button press in Bouton2.
function Bouton2_Callback(hObject, eventdata, handles)
% hObject    handle to Bouton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action = 'reponse_2';
sournote6(action);
