function varargout = BT1(varargin)
% BT1 MATLAB code for BT1.fig
%      BT1, by itself, creates a new BT1 or raises the existing
%      singleton*.
%
%      H = BT1 returns the handle to a new BT1 or the handle to
%      the existing singleton*.
%
%      BT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BT1.M with the given input arguments.
%
%      BT1('Property','Value',...) creates a new BT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BT1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BT1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BT1

% Last Modified by GUIDE v2.5 21-Oct-2018 10:48:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BT1_OpeningFcn, ...
                   'gui_OutputFcn',  @BT1_OutputFcn, ...
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


% --- Executes just before BT1 is made visible.
function BT1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BT1 (see VARARGIN)

% Choose default command line output for BT1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BT1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BT1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in drawUpdateBtn.
function drawUpdateBtn_Callback(hObject, eventdata, handles)
% hObject    handle to drawUpdateBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if any(ismember(fields(handles),'isImported'))
    if handles.isImported == true
        %ax = axes(handles.axes1);
        x = [0:0.5:10]; % x axis
        
        % Get data from handles(guidata)
        diemTongKet = handles.diemTongKet;
        diemGK = handles.diemGK;
        diemCK = handles.diemCK;
        result = handles.result;
                      
        % Selection
        label = {'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9','9,5','10'};
        switch(handles.btnGroupFlag)
            case 1
                y = diemTongKet;
            case 2
                y = diemGK;
            case 3
                y = diemCK;
            case 4
                y = result;
                label = {'Rot','Dau'};
        end
        
        % Graphical form
        switch(handles.popUpFlag)
            case 1
                h = hist(y,x);
                plot(h,x);
                bar(x,h);
                if(handles.btnGroupFlag ~= 4)
                    xlim([-0.2 10.2]);
                    xlabel('Diem');
                    ylabel('So luong');
                    
                    set(gca,'XTick',0:0.5:10);
                else
                    xlim([-0.5 1.5]);
                    set(gca,'XTick',0:1:1);
                    set(gca,'XTickLabel',{'Rot','Dau'});
                end
                
            case 2
                if(handles.btnGroupFlag == 4)
                    x = [0 1];
                end
                h = hist(y,x);
                pie(h,label);
        end
        
        
    else
        
    end
else
    msgbox('Need to import Excel file first!');
end
    

% --- Executes on button press in excelExportBtn.
function excelExportBtn_Callback(hObject, eventdata, handles)
% hObject    handle to excelExportBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if any(ismember(fields(handles),'isImported'))
    if handles.isImported == true
        excelFileNameStr = handles.excelFileNameStr;

        diemTongKet = handles.diemTongKet;
        result = handles.result;
        

        % Save to Excel file
        xlDiemTongKetRange = strcat('E2:E',int2str(length(diemTongKet) + 1)); 

        xlswrite(excelFileNameStr,diemTongKet,xlDiemTongKetRange);

        xlXepLoaiRange = strcat('F2:F',int2str(length(result) + 1));

        xlswrite(excelFileNameStr,result,xlXepLoaiRange);
        
        msgbox('Exported successfully');
    end
else
        msgbox('Need to import Excel file first!');
end
        

% --- Executes on button press in excelImportBtn.
function excelImportBtn_Callback(hObject, eventdata, handles)
% hObject    handle to excelImportBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Read from Excel file
excelFileNameStr = get(handles.excelFileNameEditText,'String');


if isempty(excelFileNameStr)
    handles.isImported = false;
    guidata(hObject,handles);
    msgbox('Filename is not empty');
else
    if exist(excelFileNameStr,'file')
        data = xlsread(excelFileNameStr,'B:D');
        MSSV = data(:,1);
        diemGK = data(:,2);
        diemCK = data(:,3);                
        handles.excelFileNameStr = excelFileNameStr;
        handles.MSSV = MSSV;
        handles.diemGK = diemGK;
        handles.diemCK = diemCK;
        
        
        diemTongKet = diemGK.*0.3 + diemCK.*0.7;

        % Round to 0.5 & save to handles
        handles.diemTongKet = round(diemTongKet/0.5)*0.5;
        
        
        % Determine the results
        result = zeros(size(diemTongKet));

        for i = 1 : length(diemTongKet)
            if ((diemTongKet(i) >= 5) && (diemGK(i) >= 5) && (diemCK(i) >= 4.5))
                result(i) = 1;
            else
                result(i) = 0;
            end
        end
        
        handles.result = result;
        
        handles.isImported = true;

        guidata(hObject,handles);
        
        msgbox('File imported');
    else
        handles.isImported = false;
        
        guidata(hObject,handles);
        msgbox('File does not exist');
    end
end


function excelFileNameEditText_Callback(hObject, eventdata, handles)
% hObject    handle to excelFileNameEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excelFileNameEditText as text
%        str2double(get(hObject,'String')) returns contents of excelFileNameEditText as a double


% --- Executes during object creation, after setting all properties.
function excelFileNameEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excelFileNameEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zEditText_Callback(hObject, eventdata, handles)
% hObject    handle to zEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zEditText as text
%        str2double(get(hObject,'String')) returns contents of zEditText as a double


% --- Executes during object creation, after setting all properties.
function zEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xEditText_Callback(hObject, eventdata, handles)
% hObject    handle to xEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xEditText as text
%        str2double(get(hObject,'String')) returns contents of xEditText as a double


% --- Executes during object creation, after setting all properties.
function xEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yEditText_Callback(hObject, eventdata, handles)
% hObject    handle to yEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yEditText as text
%        str2double(get(hObject,'String')) returns contents of yEditText as a double


% --- Executes during object creation, after setting all properties.
function yEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in figureStylePopup.
function figureStylePopup_Callback(hObject, eventdata, handles)
% hObject    handle to figureStylePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns figureStylePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from figureStylePopup
       
% Determine the selected data set
str = get(hObject,'String');
val = get(hObject,'Value');

% Set current data to the selected data set
switch(str{val})
    case 'Pho diem'
        flag = 1;
    case 'Pie'
        flag = 2;
end

handles.popUpFlag = flag;
guidata(hObject,handles);
    

% --- Executes during object creation, after setting all properties.
function figureStylePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figureStylePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.popUpFlag = 1;
guidata(hObject,handles);



function studentIDEditText_Callback(hObject, eventdata, handles)
% hObject    handle to studentIDEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of studentIDEditText as text
%        str2double(get(hObject,'String')) returns contents of studentIDEditText as a double


% --- Executes during object creation, after setting all properties.
function studentIDEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studentIDEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function midTermEditText_Callback(hObject, eventdata, handles)
% hObject    handle to midTermEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of midTermEditText as text
%        str2double(get(hObject,'String')) returns contents of midTermEditText as a double


% --- Executes during object creation, after setting all properties.
function midTermEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to midTermEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endTermEditText_Callback(hObject, eventdata, handles)
% hObject    handle to endTermEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endTermEditText as text
%        str2double(get(hObject,'String')) returns contents of endTermEditText as a double


% --- Executes during object creation, after setting all properties.
function endTermEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endTermEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in studentAddBtn.
function studentAddBtn_Callback(hObject, eventdata, handles)
% hObject    handle to studentAddBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if any(ismember(fields(handles),'isImported'))
    if handles.isImported == true
        excelFileNameStr = handles.excelFileNameStr;

        % Read ADD student form
        studentID = get(handles.studentIDEditText,'String');
        diemGK = get(handles.midTermEditText,'String');
        diemCK = get(handles.endTermEditText,'String');

        if (numberCheck(studentID) == false) || (numberCheck(diemGK) == false) || (numberCheck(diemCK) == false)
            msgbox('The information entered is incorrect');
        else
            % Add to Excel File
            STT = xlsread(excelFileNameStr,'A:A');
            lastestSTT = STT(end);

            cellIndex = strcat('A',int2str(lastestSTT +2),':D',int2str(lastestSTT+2));

            cellData = [(lastestSTT+1) str2double(studentID) str2double(diemGK) str2double(diemCK)];

            xlswrite(excelFileNameStr,cellData,cellIndex); 
            
            msgbox('Added successfully\nPlease re-import file');
        end
    end
else
        msgbox('Need to import Excel file first!');
end




function flag = numberCheck(str)
% This function will return false if String is not a numeric character
if all(ismember(str,'1234567890.'))
    flag = true;
else
    flag = false;
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --------------------------------------------------------------------
function uibuttongroup1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(handles.uibuttongroup1,'SelectedObject');
selection = get(str,'Tag');

switch selection
    case 'finalRadio'
        val = 1;
    case 'midRadio'
        val = 2;
    case 'endRadio'
        val = 3;
    case 'resultRadio'
        val = 4;
end
handles.btnGroupFlag = val;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.btnGroupFlag = 1;
guidata(hObject,handles);
