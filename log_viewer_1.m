%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 ALL FUNCTIONS FROM GUI GO BELOW HERE              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = log_viewer_1(varargin)
% LOG_VIEWER_1 MATLAB code for log_viewer_1.fig
%      LOG_VIEWER_1, by itself, creates a new LOG_VIEWER_1 or raises the existing
%      singleton*.
%
%      H = LOG_VIEWER_1 returns the handle to a new LOG_VIEWER_1 or the handle to
%      the existing singleton*.
%
%      LOG_VIEWER_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOG_VIEWER_1.M with the given input arguments.
%
%      LOG_VIEWER_1('Property','Value',...) creates a new LOG_VIEWER_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before log_viewer_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to log_viewer_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help log_viewer_1

% Last Modified by GUIDE v2.5 18-Jul-2016 14:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @log_viewer_1_OpeningFcn, ...
                   'gui_OutputFcn',  @log_viewer_1_OutputFcn, ...
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

% --- Executes just before log_viewer_1 is made visible.
function log_viewer_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to log_viewer_1 (see VARARGIN)

%==========================================================================
% Set the properties of AXES 1-5. Set the visibilty to off
axes_plot=[handles.log_plot1,handles.log_plot2,handles.log_plot3,handles.log_plot4,...
    handles.log_plot5, handles.log_plot6];
set(axes_plot,'box','on','xtick',[],'ytick',[],'Visible','off');
set(handles.uipanel10,'HighlightColor',[128/255 0 0]);

% linkaxes is for linking the x- and y- axes between several axes
linkaxes(axes_plot,'y');

%==========================================================================
% Set property of LEGEND AXES, set the pan and zoom off
axes_legend=[handles.legend1,handles.legend2,handles.legend3,...
    handles.legend4,handles.legend7,handles.legend5, handles.legend6];

set(axes_legend,'box','on','xtick',[],'ytick',[],'Visible','off');
set(handles.legend7,'Color',[250/255 243/255 238/255],'XColor','none',...
    'YColor','none','ZColor','none','Visible','on');
z=zoom;
setAllowAxesZoom(z,axes_legend,false);
p=pan;
setAllowAxesPan(p,axes_legend,false);

%==========================================================================
% Set the properties of LISTBOX
set(handles.listbox1,'String',{'Block Position','Bit Depth'},'Max',2,'Min',0);
set(handles.listbox2,'String',{'Flow Rate','Stand Pipe Pressure'},'Max',2,'Min',0);
set(handles.listbox3,'String',{'RPM','Torque'},'Max',2,'Min',0);
set(handles.listbox4,'String',{'Hookload','Weight on Bit'},'Max',2,'Min',0);
set(handles.listbox5,'String',{'GR_RAB_RT','GRM'},'Max',2,'Min',0);
set(handles.listbox6,'String',{'Res Deep','Res Shallow'},'Max',2,'Min',0);

%==========================================================================
% LOAD DATA
% log1=dlmread('F:\My Document\02 Master NTNU\03 Semester 3\Project 2015\Data\6.46m_1810.89m_Erdpress 24.las','',41);
log2=dlmread('D:\01 My Documents\08 Master NTNU\03 Semester 3\Specialization Project\Data\538.12m_1811.73m_Erdpress 24.las','',162);
log3=dlmread('D:\01 My Documents\08 Master NTNU\03 Semester 3\Specialization Project\Data\552m_1811.03m_Erdpress 24.las','',49);
[num,txt,raw]=xlsread('D:\01 My Documents\08 Master NTNU\03 Semester 3\Specialization Project\Data\Mappe1.xlsx','A2:D1145');

%=========================================================================
% LOG DATA
% fix log 2
j=1;
dummylog=log2;
clear log2;
log2(1,1)=dummylog(1,1);
for i=1:(length(dummylog)/18)
    k=2;
    log2(i,1)=dummylog(j,1);
    j=j+1;
    for j=j:(i*18)
        log2(i,k:k+7)=dummylog(j,:);
        k=k+8;
    end
    j=j+1;
end
clear dummylog;
log2(:,129:131)=log2(:,130:132);
log2(:,132:137)=[];
clear ('i','j','k');

%==========================================================================
% Remove -999.25 and change it with NaN
log2=renew(log2);
log3=renew(log3);
a=length(log2);
b=length(log3);
log3(b+1:a,:)=NaN;

%==========================================================================
% Set all the log data and save  in variable 'data'.
% data is a struct which consist of log, lim, and str.
% data.log consist of logging data
% data.lim consists of axes limit for each log parameter
% data.str consists of the name of log parameter and its units
% data=struct('log',zeros(a,8),'lim',zeros(2,8));
%-----------------------------------------------------------------------
% data.str{1,:} = {'DEPTH','BPOS','BIT_DEPTH','TFLO','SPPA','RPM','TQA',...
%     'HKLD','WOB','GR','RES'};
% data.str{2,:} = {'M','FT','FT','CUBICCM/HOUR','PSI','DEG/HOUR',...
%     '1000 FT.LBF','1000 LBF','1000 LBF','GR API', 'M.OHM'};

data.str{1,:} = {'DEPTH','BPOS','BIT DEPTH','TFLO','SPPA','RPM','TQA',...
    'HKLD','WOB','GR RAB RT','GRM','RES DEEP','RES SHALLOW'};
data.str{2,:} = {'M','FT','FT','CUBICCM/HOUR','PSI','DEG/HOUR',...
    '1000 FT.LBF','1000 LBF','1000 LBF','GR API', 'GR API','M.OHM','M.OHM'};
%-----------------------------------------------------------------------
data.log(:,1)   = log2(:,1);      % depth in m
% data.log(:,2)   = log2(:,11);     % block position in ft
% data.log(:,3)   = log2(:,9);      % bit depth in ft
% data.log(:,4)   = log2(:,124);    % flow rate in cm3/hour
% data.log(:,5)   = log2(:,110);    % SPP in psi
% data.log(:,6)   = log2(:,97);     % RPM in Ddeg/hour
% data.log(:,7)   = log2(:,125);    % Torque in 1000 ft.lbf
% data.log(:,8)   = log2(:,51);     % Hookload in 1000 lbf
% data.log(:,9)   = log2(:,114);    % WOB in 1000 lbf
data.log(:,2)   = log3(:,17);       % block position in m
data.log(:,3)   = log2(:,9);        % bit depth in ft
data.log(:,4)   = log3(:,4);        % flow rate in lpm
data.log(:,5)   = log3(:,7);        % SPP in psi

data.log(:,6)   = log2(:,97);       % RPM in Ddeg/hour

data.log(:,7)   = log3(:,2);        % Torque in 1000 ft.lbf
data.log(:,8)   = log3(:,13);       % Hookload in N
data.log(:,9)   = log3(:,5);        % WOB in N

data.log(:,10)   = log2(:,43);      % GR_RAB_RT in GAPI
data.log(:,11)   = log2(:,44);      % GRM1 in GAPI

data.log(:,12)   = log2(:,74);      % Resistivity Deep in mOhm
data.log(:,13)  = log2(:,81);       % Resitivity Shallow in MOHM

data.log(:,14)  = log3(:,1);        % Depth from log3
%------------------------------------------------------------------------
data.lim(:,1)   =[0 2000]';     %depth
% data.lim(:,2)   =[0 100]';      %block position
% data.lim(:,3)   =[5500 5800]';  %bit depth
% data.lim(:,4) = [0 2e+8]';      %flow rate 
% data.lim(:,5) = [0 2000]';      %SPP 
% data.lim(:,6) = [0 3e+6]';      %RPM    
% data.lim(:,7) = [0 2E+8]';      %Torque   
% data.lim(:,8) = [0 2E+2]';      %Hookload   
% data.lim(:,9) = [0 4E+6]';      %WOB
% data.lim(:,10)= [0 200]';       %GR
% data.lim(:,11) = [0 15]';       %Resistivity

data.lim(:,2)   =[0 20]';       %block position
data.lim(:,3)   =[5500 5800]';  %bit depth
data.lim(:,4) = [0 4000]';      %flow rate 
data.lim(:,5) = [0 3000]';      %SPP 
data.lim(:,6) = [0 3e+6]';      %RPM    
data.lim(:,7) = [0 12E+3]';     %Torque   
data.lim(:,8) = [0 8e+11]';     %Hookload   
data.lim(:,9) = [0 2E+11]';     %WOB
data.lim(:,10)= [0 200]';       %GR
data.lim(:,11)= [0 200]';       %GR
data.lim(:,12) = [1 100]';      %Resistivity Deep
data.lim(:,13) = [1 100]';      %Resistivity Shallow
data.lim(:,14)   =[0 2000]';    %depth

%=========================================================================
% PROCESSING LITHOLOGY DATA
litho.depth=num;
litho.name=txt(:,2);
%------------------------------------------------------------------------
% Check lithology string
group.none=strcmp(litho.name,'No Sample');
group.clay=strcmp(litho.name,'Claystone');
group.silt=strcmp(litho.name,'Siltstone');
group.sand=strcmp(litho.name,'Sandstone');
group.claysand=strcmp(litho.name,'Clay (Sandy)');
group.sandsilt=strcmp(litho.name,'Sandstone (Silty)');
group.coal=strcmp(litho.name,'Coal');
group.conglomerate=strcmp(litho.name,'Conglomerate');
%------------------------------------------------------------------------
% Saving lithology colour
colour_lithology = [[1 1 1];[0 205/255 0];[255/255 218/255 185/255];...
    [1 254/255 106/255];[205/255 173/255 0];[255/255 127/255 0];[0 0 0];...
    [0.502 0.502 0.502]];
for j=1:length(litho.name)
    if group.none(j)==1
        litho.color(j,:)=colour_lithology(1,:);
    elseif group.clay(j)==1
        litho.color(j,:)=colour_lithology(2,:);
        %disp('Claystone')
    elseif group.silt(j)==1
        litho.color(j,:)=colour_lithology(3,:);
        %disp('Siltstone')
    elseif group.sand(j)==1
        litho.color(j,:)=colour_lithology(4,:);
        %disp('Sandstone')
    elseif group.claysand(j)==1
        litho.color(j,:)=colour_lithology(5,:);
        % disp('Claystone (Sandy)')
    elseif group.sandsilt(j)==1
        litho.color(j,:)=colour_lithology(6,:);
        %disp('Sandstone (Silty)')
    elseif group.coal(j)==1
        litho.color(j,:)=colour_lithology(7,:);
    elseif group.conglomerate(j)==1
        litho.color(j,:)=colour_lithology(8,:);
    end
end
%------------------------------------------------------------------------
% Plotting the lithology and save it in a varible.
% Saving the plot can reduce the memory. Showing the plot is performed by
% setting the visibility in 'parent'.
plot_litho=plotlitho(litho.depth(:,1),litho.depth(:,2),litho.color);
set(plot_litho,'Visible','off','Parent',[]);
set(gca,'Visible','off');

%==========================================================================
% Create legend of the lithology
axes(handles.legend7)
name_lithology={'No Sample', 'Claystone','Siltstone','Sandstone',...
    'Clay (Sandy)','Sandstone(Silty)','Coal','Conglomerate'};
for i=1:8
    x=[0.05,0.05,0.15,0.15];
    y=[i,i+0.2,i+0.2,i];
    patch(x,y,colour_lithology(i,:));
    
    xtext =0.18;
    ytext=i+0.1;
    text(xtext,ytext,name_lithology{i},'FontSize',9);
    hold on 
    
end
xlim([0 1]);
ylim([0.5 8.5]);
hold off
 
%==========================================================================
% CREATE HANDLES
% Save all the data as handles, so data can be access from other function
handles.datalog = data;
handles.color = ['r','b','g','m','k'];
handles.plot=plot_litho;
%------------------------------------------------------------------------
% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = log_viewer_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%======================= CLEAR BUTTON CALLBACK 1-5 =======================
% Executes when user press in clear button. This function contains command
% to clear the axes for log plot and legend, and also used to clear the
% saved UserData
function clear_button1_Callback(hObject, eventdata, handles)
cla(handles.log_plot1);
set(handles.log_plot1,'Visible','off');
cla(handles.legend1);
set(handles.legend1,'Visible','off');
set(handles.legend1,'UserData',[]);

% --- Executes on button press in clear_button2.
function clear_button2_Callback(hObject, eventdata, handles)
cla(handles.log_plot2);
set(handles.log_plot2,'Visible','off');
cla(handles.legend2);
set(handles.legend2,'Visible','off');
set(handles.legend2,'UserData',[]);

% --- Executes on button press in clear_button3.
function clear_button3_Callback(hObject, eventdata, handles)
cla(handles.log_plot3);
set(handles.log_plot3,'Visible','off');
cla(handles.legend3);
set(handles.legend3,'Visible','off');
set(handles.legend3,'UserData',[]);

% --- Executes on button press in clear_button4.
function clear_button4_Callback(hObject, eventdata, handles)
cla(handles.log_plot4);
set(handles.log_plot4,'Visible','off');
cla(handles.legend4);
set(handles.legend4,'Visible','off');
set(handles.legend4,'UserData',[]);

% --- Executes on button press in clear_button5.
function clear_button5_Callback(hObject, eventdata, handles)
cla(handles.log_plot5);
cla(handles.legend5);
set(handles.log_plot5,'Visible','off');
set(handles.legend5,'Visible','off');
set(handles.legend5,'UserData',[]);

% --- Executes on button press in clear_button6.
function clear_button6_Callback(hObject, eventdata, handles)
cla(handles.log_plot6);
cla(handles.legend6);
set(handles.log_plot6,'Visible','off');
set(handles.legend6,'Visible','off');
set(handles.legend6,'UserData',[]);

%=========================PLOTTING BUTTON CALLBACK========================
% Below here is a set of plotting button callback from log track 1-5.
% Generally the process is the same from one to others. The only difference
% is which log is assigned to be items in the list box

% --- Executes on button press in plot_button1.
function plot_button1_Callback(hObject, eventdata, handles)
% load data and header from listbox and save it in a new variable 'data'
data=handles.datalog;

%data for plot 1: depth, BPOS, and Bit depth
datalog=struct('log',data.log(:,2:3),'lim',data.lim(:,2:3));
depthlog.lim=data.lim(:,1);
depthlog1=data.log(:,14);
depthlog2=data.log(:,1);
dataname=data.str{1}(:,2:3);
dataunit=data.str{2}(:,2:3);

% get the value from list box (indicates which option in list box is
% selected by user)
val = get(handles.listbox1,'Value');
axeslim=[0 1];

% create plot in Axes 1
axes(handles.log_plot1);
for i=1:length(val)
    m=val(i);
    if m==1
        normal_plot(datalog.log(:,m),depthlog1,datalog.lim(:,m),handles.color(m));
    else
        normal_plot(datalog.log(:,m),depthlog2,datalog.lim(:,m),handles.color(m));
    end
    ylim( [0 max(depthlog.lim)]);
    datalegend.name{i}=dataname{m};
    datalegend.unit{i}=dataunit{m};
    datalegend.lim(:,i)=datalog.lim(:,m);
    datalegend.col(i)=handles.color(m);
    hold on
end
set(handles.log_plot1,'Visible','on')
set(gca,'fontsize',9)
ylabel('Depth (m)','FontSize',9);
hold off

% create legend
axes(handles.legend1);
plot_legend(datalegend.name,datalegend.unit,datalegend.lim,axeslim,datalegend.col);
set(handles.legend1,'Visible','on')
hold off

% save the output and assign the legend data to be saved in UserData
handles.output=hObject;
set(handles.legend1,'UserData',datalegend);
guidata(hObject,handles);    

% --- Executes on button press in plot_button2.
function plot_button2_Callback(hObject, eventdata, handles)
data=handles.datalog;

%data for plot 2: depth, TFLO, and SPPA
datalog=struct('log',data.log(:,4:5),'lim',data.lim(:,4:5));
depthlog=struct('log',data.log(:,14),'lim',data.lim(:,14));
dataname=data.str{1}(:,4:5);
dataunit=data.str{2}(:,4:5);
val = get(handles.listbox2,'Value');
axeslim=[0 1];

% create plot in Axes 2
axes(handles.log_plot2);
for i=1:length(val)
    m=val(i);
    normal_plot(datalog.log(:,m),depthlog.log,datalog.lim(:,m),handles.color(m));
    ylim( [0 max(depthlog.lim)]);
    datalegend.name{i}=dataname{m};
    datalegend.unit{i}=dataunit{m};
    datalegend.lim(:,i)=datalog.lim(:,m);
    datalegend.col(i)=handles.color(m);
    hold on
end
set(handles.log_plot2,'Visible','on')
set(gca,'fontsize',9)
ylabel('Depth (m)','FontSize',9);
hold off

% create legend
axes(handles.legend2);
plot_legend(datalegend.name,datalegend.unit,datalegend.lim,axeslim,datalegend.col);
set(handles.legend2,'Visible','on')
hold off

% save the output
handles.output=hObject;
set(handles.legend2,'UserData',datalegend);
guidata(hObject,handles); 

% --- Executes on button press in plot_button3.
function plot_button3_Callback(hObject, eventdata, handles)
data=handles.datalog;

%data for plot 3: depth, RPM, and Torque
datalog=struct('log',data.log(:,6:7),'lim',data.lim(:,6:7));
depthlog1=data.log(:,1);
depthlog2=data.log(:,14);
depthlog.lim=data.lim(:,1);
dataname=data.str{1}(:,6:7);
dataunit=data.str{2}(:,6:7);
val = get(handles.listbox3,'Value');
axeslim=[0 1];

% create plot in Axes 3
axes(handles.log_plot3);
for i=1:length(val)
    m=val(i);
    if m==1
        normal_plot(datalog.log(:,m),depthlog1,datalog.lim(:,m),handles.color(m));
    else
        normal_plot(datalog.log(:,m),depthlog2,datalog.lim(:,m),handles.color(m));
    end
    ylim( [0 max(depthlog.lim)]);
    datalegend.name{i}=dataname{m};
    datalegend.unit{i}=dataunit{m};
    datalegend.lim(:,i)=datalog.lim(:,m);
    datalegend.col(i)=handles.color(m);
    hold on
end
set(handles.log_plot3,'Visible','on')
set(gca,'fontsize',9)
ylabel('Depth (m)','FontSize',9);
hold off

% create legend
axes(handles.legend3);
plot_legend(datalegend.name,datalegend.unit,datalegend.lim,axeslim,datalegend.col);
set(handles.legend3,'Visible','on')
hold off

% save the output
handles.output=hObject;
set(handles.legend3,'UserData',datalegend);
guidata(hObject,handles);

% --- Executes on button press in plot_button4.
function plot_button4_Callback(hObject, eventdata, handles)
data=handles.datalog;

%data for plot 4: depth, WOB, and Hookload
datalog=struct('log',data.log(:,8:9),'lim',data.lim(:,8:9));
depthlog=struct('log',data.log(:,14),'lim',data.lim(:,14));
dataname=data.str{1}(:,8:9);
dataunit=data.str{2}(:,8:9);
val = get(handles.listbox4,'Value');
axeslim=[0 1];

% create plot in Axes 4
axes(handles.log_plot4);
for i=1:length(val)
    m=val(i);
    normal_plot(datalog.log(:,m),depthlog.log,datalog.lim(:,m),handles.color(m));
    ylim( [0 max(depthlog.lim)]);
    datalegend.name{i}=dataname{m};
    datalegend.unit{i}=dataunit{m};
    datalegend.lim(:,i)=datalog.lim(:,m);
    datalegend.col(i)=handles.color(m);
    hold on
end
set(handles.log_plot4,'Visible','on')
set(gca,'fontsize',9)
ylabel('Depth (m)','FontSize',9);
hold off

% create legend
axes(handles.legend4);
plot_legend(datalegend.name,datalegend.unit,datalegend.lim,axeslim,datalegend.col);
set(handles.legend4,'Visible','on')
hold off

% save the output
handles.output=hObject;
set(handles.legend4,'UserData',datalegend);
guidata(hObject,handles);

% --- Executes on button press in plot_button5.
function plot_button5_Callback(hObject, eventdata, handles)
% data for plot 5: depth, Gamma Ray
data=handles.datalog;
datalog=struct('log',data.log(:,10:11),'lim',data.lim(:,10:11));
depthlog=struct('log',data.log(:,1),'lim',data.lim(:,1));
dataname=data.str{1}(:,10:11);
dataunit=data.str{2}(:,10:11);

% create plot in Axes 5
val = get(handles.listbox5,'Value');
axeslim=[0 1];

axes(handles.log_plot5);
for i=1:length(val)
    m=val(i);
    normal_plot(datalog.log(:,m),depthlog.log,datalog.lim(:,m),handles.color(m));
    ylim( [0 max(depthlog.lim)]);
    datalegend.name{i}=dataname{m};
    datalegend.unit{i}=dataunit{m};
    datalegend.lim(:,i)=datalog.lim(:,m);
    datalegend.col(i)=handles.color(m);
    hold on
end   
set(handles.log_plot5,'Visible','on')
set(gca,'fontsize',9)
ylabel('Depth (m)','FontSize',9);
hold off

% create legend
axes(handles.legend5);
plot_legend(datalegend.name,datalegend.unit,datalegend.lim,axeslim,datalegend.col);
set(handles.legend5,'Visible','on')
hold off  

% save the output
handles.output=hObject;
set(handles.legend5,'UserData',datalegend);
guidata(hObject,handles);

% --- Executes on button press in plot_button6.
function plot_button6_Callback(hObject, eventdata, handles)
% data for plot 6: depth and Resistivity
data=handles.datalog;
datalog=struct('log',data.log(:,12:13),'lim',data.lim(:,12:13));
depthlog=struct('log',data.log(:,1),'lim',data.lim(:,1));
dataname=data.str{1}(:,12:13);
dataunit=data.str{2}(:,12:13);

% create plot in Axes 6
val = get(handles.listbox6,'Value');
axeslim=[0 1];
axes(handles.log_plot6);
for i=1:length(val)
    m=val(i);
    j=1;
    for k=1:length(datalog.log(:,m))
        if isnan(datalog.log(k,m))==0&&datalog.log(k,m)>0
            X(j)=datalog.log(k,m);
            Y(j)=depthlog.log(k,1);
            j=j+1;
        end
    end
    semilogx(X,Y,'color',handles.color(m));
    ylim( [0 max(depthlog.lim)]);
    datalegend.name{i}=dataname{m};
    datalegend.unit{i}=dataunit{m};
    datalegend.lim(:,i)=datalog.lim(:,m);
    datalegend.col(i)=handles.color(m);
    hold on
end   
xlim( [min(datalog.lim(:,1)) max(datalog.lim(:,1))]);
set(gca,'YDir','reverse','xticklabel',[],'xgrid','on','ygrid','on');
set(handles.log_plot6,'Visible','on')
set(gca,'fontsize',9,'xscale','log')
ylabel('Depth (m)','FontSize',9);
hold off

% create legend
axes(handles.legend6);
plot_legend(datalegend.name,datalegend.unit,datalegend.lim,axeslim,datalegend.col);
set(handles.legend6,'Visible','on')
hold off  

% save the output
handles.output=hObject;
set(handles.legend6,'UserData',datalegend);
guidata(hObject,handles);

%========================CHECK BOX CALLBACK===============================
% Below here is a set of callbacks for check box which is used to show the
% lithology plot on the axes. Detailed information of the process under
% callback explained in checkbox1 only. The rest has similar process in
% general.

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% Get value of check box. Value=1 showing the check box is checked
value=get(hObject,'Value');

if value==0
    % If returned value is zero, the lithology plot will be deleted from
    % axes. The lithology plot can be searched using findobj
    get_patch=findobj(handles.log_plot1,'Type','Patch');
    delete(get_patch);
else
    % If returned value is 1, the plot which is saved in handles earlier
    % will be copied. By changing the parent of the lithology plot, the
    % plot will be displayed in the preferred axes.
    lit=copyobj(handles.plot,handles.log_plot1);
    set(lit,'Parent',handles.log_plot1);
    set(lit,'Visible','On');
    set(handles.log_plot1,'Layer','top');
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
if value==0
    get_patch=findobj(handles.log_plot2,'Type','Patch');
    delete(get_patch);
else
    lit=copyobj(handles.plot,handles.log_plot2);
    set(lit,'Parent',handles.log_plot2);
    set(lit,'Visible','On');
    set(handles.log_plot2,'Layer','top');
end

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
if value==0
    get_patch=findobj(handles.log_plot3,'Type','Patch');
    delete(get_patch);
else
    lit=copyobj(handles.plot,handles.log_plot3);
    set(lit,'Parent',handles.log_plot3);
    set(lit,'Visible','On');
    set(handles.log_plot3,'Layer','top');
end

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
if value==0
    get_patch=findobj(handles.log_plot4,'Type','Patch');
    delete(get_patch);
else
    lit=copyobj(handles.plot,handles.log_plot4);
    set(lit,'Parent',handles.log_plot4);
    set(lit,'Visible','On');
    set(handles.log_plot4,'Layer','top');
end

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
if value==0
    get_patch=findobj(handles.log_plot5,'Type','Patch');
    delete(get_patch);
else
    lit=copyobj(handles.plot,handles.log_plot5);
    set(lit,'Parent',handles.log_plot5);
    set(lit,'Visible','On');
    set(handles.log_plot5,'Layer','top');
end

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
if value==0
    get_patch=findobj(handles.log_plot6,'Type','Patch');
    delete(get_patch);
else
    lit=copyobj(handles.plot,handles.log_plot6);
    set(lit,'XData',[0.001 1000 1000 0.001],'Parent',handles.log_plot6);
    set(lit,'Visible','On');
    set(handles.log_plot6,'Layer','top');
end

%=======================RADIO BUTTON CALLBACK==============================
% Below is a set of the callback of radio button which is utilized to
% constraint the action of zooming and panning.

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% Get value from the radio button
value=get(hObject,'Value');
axes_plot=[handles.log_plot1,handles.log_plot2,handles.log_plot3,...
    handles.log_plot4,handles.log_plot5,handles.log_plot6];
if value==1
    % If the returned value is 1, then we constraint zooming and panning
    % action in both direction (horizontal and vertical)
    z=zoom;
    set(z,'ActionPostCallback',@getaxis);
    setAxesZoomMotion(z,axes_plot,'both');
    
    p=pan;
    set(p,'ActionPostCallback',@getaxis);
    setAxesPanMotion(p,axes_plot,'both');
end

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
axes_plot=[handles.log_plot1,handles.log_plot2,handles.log_plot3,...
    handles.log_plot4,handles.log_plot5,handles.log_plot6];
if value==1
    % If the returned value is 1, then we constraint zooming and panning
    % action in vertical direction
    z=zoom;
    set(z,'ActionPostCallback',@getaxis);
    setAxesZoomMotion(z,axes_plot,'vertical');
    
    p=pan;
    set(p,'ActionPostCallback',@getaxis);
    setAxesPanMotion(p,axes_plot,'vertical');
end

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
value=get(hObject,'Value');
axes_plot=[handles.log_plot1,handles.log_plot2,handles.log_plot3,...
    handles.log_plot4,handles.log_plot5handles.log_plot6];
if value==1
    % If the returned value is 1, then we constraint zooming and panning
    % action in horizontal direction
    z=zoom;
    set(z,'ActionPostCallback',@getaxis);
    setAxesZoomMotion(z,axes_plot,'horizontal');
    
    p=pan;
    set(p,'ActionPostCallback',@getaxis);
    setAxesPanMotion(p,axes_plot,'horizontal');
end    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         ALL FUNCTIONS CREATED BY DEVELOPER GOES BELOW HERE             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function normal_plot(x,y,limit,colour)
% Normalization of the log data thus data are able plotted in the same axes
% The inputs are:
% X         = data on x-axes
% Y         = data on y-axes
% limit     = true x-axes limit
% colour    = the color of the plot line

xnorm=(x-min(limit))./(max(limit)-min(limit));

% Remove NaN and bad data and save it in a new variable
j=1;
for i=1:length(x)
    if isnan(xnorm(i))==0&&xnorm(i)>0
       X(j)=xnorm(i);
       Y(j)=y(i);
       j=j+1;
    end
end

% Plotting the normalized data
plot(X,Y,colour,'LineWidth',1);
box on
xlim( [0 1] );
set(gca,'YDir','reverse','xticklabel',[],'xgrid','on','ygrid','on');

function [A] = renew(A)
% This function is used to remove data contains value -999.25 with NaN
[row,column]=size(A);
for i=1:row
    for j=1:column
        if A(i,j)==-999.250000000000
            A(i,j)=NaN;
        end
    end
end

function result=plotlitho(depth_top,depth_bottom,color)
% This function is used to plot lithology data
for i=1:length(depth_top)
    x = [0 1];
    % Creating coordinates of a rectangle (4 coordinates) which indicate
    % the formation
    y1=[depth_top(i) depth_top(i)];
    y2= [depth_bottom(i) depth_bottom(i)];
    X=[x,fliplr(x)];
    Y=[y1,fliplr(y2)];
    % The rectangle will be filled with color which already set
    result(i)=fill(X,Y,color(i,:),'EdgeColor','none');
    hold on
end

function [] = plot_legend(dataname,dataunit,datalim,axislim,colour)
% This function is used to plot the legend on legend axes.
% dataname      = name of the log
% dataunit      = unit of the log
% datalim       = true x-axes limit of the log
% axislim       = current x-axes limit of the log axes (false limit)

for i=1:length(dataname)    
    name=dataname{i};
    unit=dataunit{i};
    limit=datalim(:,i);
    
    % creating a straight line indicating the log
    x=[0 1];
    y=[3 3]*i;
    plot(x,y,colour(i),'LineWidth',1.5);
    
    %creating title
    text(0.5,3*i,name,'HorizontalAlignment','center','VerticalAlignment','bottom','Fontsize',8);
    text(0.5,3*i,['(',unit,')',],'HorizontalAlignment','center','VerticalAlignment','top','Fontsize',8);
        
    % calculate minimum and maximum value value
    minval=axislim(1)*(max(limit)-min(limit))+min(limit);
    text(0,3*i,num2str(minval,'%3.0e'),'HorizontalAlignment','left','VerticalAlignment','top','Fontsize',8);
    
    % calculate minimum and maximum value value
    maxval=axislim(2)*(max(limit)-min(limit))+min(limit);
    text(1,3*i,num2str(maxval,'%3.0e'),'HorizontalAlignment','right','VerticalAlignment','top','Fontsize',8);
    hold on

end
set(gca,'ytick',[],'xtick',[]);
xlim ([0 1]);
ylim([1 3*i+2]);
hold off

function getaxis(hObject,event)
% get the current x-axes limit (false x-axes limit)
newLim=get(event.Axes,'XLim');
handles=guidata(hObject);
hlegend=[handles.legend1, handles.legend2, handles.legend3,...
    handles.legend4, handles.legend5];
for i=1:length(hlegend)
    data=get(hlegend(i),'UserData');
    if isempty(data)==0
        % Checking the UserData is empty or not. Empty UserData indicates
        % that the log data is not plotted, thus the legend also won't be
        % plotted.
        axes(hlegend(i));
        plot_legend(data.name,data.unit,data.lim,newLim,data.col); 
        set(hlegend(i),'UserData',data);
        guidata(hlegend(i),handles);
    end
end
