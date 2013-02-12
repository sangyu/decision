function varargout = behViewer(varargin)
% BEHVIEWER MATLAB code for behViewer.fig
%      BEHVIEWER, by itself, creates a new BEHVIEWER or raises the existing
%      singleton*.
%
%      H = BEHVIEWER returns the handle to a new BEHVIEWER or the handle to
%      the existing singleton*.
%
%      BEHVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEHVIEWER.M with the given input arguments.
%
%      BEHVIEWER('Property','Value',...) creates a new BEHVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before behViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to behViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help behViewer

% Last Modified by GUIDE v2.5 14-Dec-2011 01:10:11

% Begin initialization code - DO NOT EDIT
global delayChoice;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @behViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @behViewer_OutputFcn, ...
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

% --- Executes just before behViewer is made visible.
function behViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to behViewer (see VARARGIN)

% Choose default command line output for behViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% This sets up the initial plot - only do when we are invisible
% so window can get raised using behViewer.


% UIWAIT makes behViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = behViewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    directoryName = uigetdir;
    load_listbox(directoryName, handles);

function load_listbox(directoryName, handles)
        cd(directoryName);
try
    delete('.DS_Store')
catch ME
end
dir_struct = dir(directoryName);
dir_struct = dir_struct(3:end);
        cla;

[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.listbox1,'String',handles.file_names,...
	'Value',1)
        cla;


% --- Executes on selection change in listbox1.
function [delayChoice]=listbox1_Callback(hObject, eventdata, handles)

% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(handles.figure1,'SelectionType');
% If double click
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    % Item selected in list box
    filename = file_list{index_selected}
    % If folder
    if  handles.is_dir(handles.sorted_index(index_selected))
        cd (filename)
        % Load list box with new folder.
        load_listbox(pwd,handles)
    else
        [path,name,ext] = fileparts(filename);
        switch ext
            
            case '.csv'
                [e, a]=extractOlfData(filename);
                axes(handles.axes1);
                plot(2*a.side(:, 1)-1, 'o');
%                 ylim([-2, 2])
%                 xlim([0 55])
%                 
                if length(a)>100;
                    xlim([0 100])
                end
                legend('+1>R -1>L')
               
                axes(handles.axes2);
                delay=a.rewardDelay;
                delayedInd=find(delay>0.1);
                smallInd=find(delay<0.1);
                
                plot(delayedInd, delay(delayedInd), '.')

                
                if length(a)>100;
                    xlim([0 100])
                end
                legend('rewardDelay')
                axes(handles.axes7);
                plot(a.travelTime)
%                 ylim([0 5])
%                 xlim([0 55]) 
                
                if length(a)>100;
                    xlim([0 100])
                end
                legend('travelTime')
                axes(handles.axes8);
                plot(a.ITI)
%                 ylim([0 100])
%                 xlim([0 55])
                
                if length(a)>100;
                    xlim([0 100])
                end
                legend('ITI')                
                axes(handles.axes4);
                b=bar([mean(a.side(:, 1)), mean(a.side(:, 2))])    ;   
                ylim([0 1])
                set(b, 'FaceColor', [.9, .6, .8])
                
                legend('% L R')
                axes(handles.axes5);
                plot([ones(length(delayedInd), 1); 2*ones(length(smallInd), 1)], [delay(delayedInd); delay(smallInd)], '.')
                hold on
                plot([1; 2], [mean(delay(delayedInd)); mean(delay(smallInd))], 'r*', 'MarkerSize', 20)
                hold off
                legend('D - L R')
                xlim([0 3])
                ylim([0 20])
                axes(handles.axes6);
                hold on
                plot( mean(delay(delayedInd)), mean(a.side(:, 1)),'.') %, 'Color', [.6, 1/(str2num(e.mouseID(end))+1), 1-1/(str2num(e.mouseID(end))+1)])
                if isempty(delayedInd)==1;
                plot( 0, mean(a.side(:, 1)), '.')%,  'Color', [.6, 1/(str2num(e.mouseID(end))+1), 1-1/(str2num(e.mouseID(end))+1)])
                end
                hold off
                xlim([-1 20])
                ylim([0 1])
                axes(handles.axes10);               
                hist(a.rewardDelay(find(a.rewardDelay>0.2)))
                ylim([0 40])
                xlim([0 10])
                meanNextState=zeros(17, 2);
                axes(handles.axes12);
                try
                for i=[.5:.5:20]
                    ind=find(a.rewardDelay==i);
                    ind(end)=[];
                    trans=a.side(2:end);
                    nextState=trans(ind);
                    meanNextState(i*2+1, [1:3])=[i, mean(nextState), length(nextState)]
                    hold on
                    plot(i, mean(nextState), 'b.', 'MarkerSize', 5*length(nextState))
                    hold off
                end
                catch me
                end
                
                
                try
                for i=[0:.5:20]
                    ind=find(a.rewardDelay==i);
                    ind(end-1:end)=[];
                    trans=a.side(3:end);
                    next2State=trans(ind);
                    meanNext2State(i*2+1, [1:2])=[i, mean(next2State)];
                end
                catch me
                end
%                 hold on
                
                plot([0 20], [.5 .5])
%                 plot(meanNext2State(:, 1), meanNext2State(:, 2), 'r.')
                hold off
                xlim([0 10])
                ylim([0 1])
            otherwise
                try
                    % Use open for other file types.
                    open(filename)
                catch ex
                    errordlg(...
                      ex.getReport('basic'),'File Type Error','modal')
                end
        end

end

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1




% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
