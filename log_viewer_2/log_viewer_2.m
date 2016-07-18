function varargout = log_viewer_2(varargin)
% Last Modified by GUIDE v2.5 18-Jul-2016 14:59:49
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @log_viewer_2_OpeningFcn, ...
                   'gui_OutputFcn',  @log_viewer_2_OutputFcn, ...
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

% --- Executes just before log_viewer_2 is made visible.
function log_viewer_2_OpeningFcn(hObject, eventdata, handles, varargin)
%==========================================================================
% Set the properties of AXES
axes_plot=[handles.log1, handles.log2, handles.log3,handles.litho1,...
    handles.litho2, handles.litho3];
set(axes_plot,'box','on','XTickLabel',{});

%==========================================================================
% Set property of LEGEND AXES, set the pan and zoom off
axes_legend=[handles.legend1_1, handles.legend1_2, handles.legend1_3,...
    handles.legend2_1,handles.legend2_2,handles.legend2_3,...
    handles.legend3_1, handles.legend3_2, handles.legend3_3];
set(axes_legend,'visible','off');
z=zoom;
setAllowAxesZoom(z,axes_legend,false);
p=pan;
setAllowAxesPan(p,axes_legend,false);

%==========================================================================
% Set the properties of POP-UP MENU
% set([handles.popupmenu1,handles.popupmenu5,handles.popupmenu7],...
%     'String',{'Well 15/5-7 A','Well 15/6-11 S','Well 15/6-9 S'});
set([handles.popupmenu1,handles.popupmenu5,handles.popupmenu7],...
    'String',{'Well 15/5-7 A','Well 15/6-9 S','Well 15/6-11 S','Well 15/6-12'});
set([handles.popupmenu2,handles.popupmenu6,handles.popupmenu8],...
    'String',{'GR - Caliper - Bit Size','Density - Neutron',...
    'Resistivity','Sonic'});
%==========================================================================
% Load MAT or DATA

% handles.data2=importdata('w15_6_11s.mat');
% handles.data1=importdata('w15_6_10.mat');
% handles.data2=importdata('w15_6_11a.mat');
% handles.data3=importdata('w15_9_19a.mat');
handles.data1=importdata('w15_5_7a.mat');
handles.data2=importdata('w15_6_9s.mat');
handles.data3=importdata('w15_6_11s.mat');
handles.data4=importdata('w15_6_12.mat');

[~,~,handles.data1.formation]=xlsread('data 15_5_7a.xlsx');
[~,~,handles.data2.formation]=xlsread('data 15_6_9s.xlsx');
[~,~,handles.data3.formation]=xlsread('data 15_6_11s.xlsx');
[~,~,handles.data4.formation]=xlsread('data 15_6_12.xlsx');

[~,~,handles.data1.casing]=xlsread('15_5_7a.xlsx');
[~,~,handles.data2.casing]=xlsread('15_6_9s.xlsx');
[~,~,handles.data3.casing]=xlsread('15_6_11s.xlsx');
[~,~,handles.data4.casing]=xlsread('15_6_12.xlsx');


linkaxes([handles.litho1, handles.log1],'y');
linkaxes([handles.litho2, handles.log2],'y');
linkaxes([handles.litho3, handles.log3],'y');
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = log_viewer_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
log_type = get(handles.popupmenu2, 'Value');
well =get(handles.popupmenu1,'Value');
axes(handles.log1);
legend = [handles.legend1_1,handles.legend1_2,handles.legend1_3];
log_process (legend,well,log_type,handles, handles.litho1);
linkaxes([handles.log1, handles.log2, handles.log3],'y');

% --- Executes on button press in pushbutton13.
function pushbutton11_Callback(hObject, eventdata, handles)
well=get(handles.popupmenu5,'Value');
log_type = get(handles.popupmenu6, 'Value');
axes(handles.log2);
legend = [handles.legend2_1,handles.legend2_2,handles.legend2_3];
log_process (legend,well,log_type,handles, handles.litho2);
linkaxes([handles.log1, handles.log2, handles.log3],'y');

% --- Executes on button press in pushbutton11.
function pushbutton13_Callback(hObject, eventdata, handles)
well=get(handles.popupmenu7,'Value');
log_type = get(handles.popupmenu8, 'Value');
axes(handles.log3);
legend = [handles.legend3_1,handles.legend3_2,handles.legend3_3];
log_process (legend,well,log_type,handles, handles.litho3);
linkaxes([handles.log1, handles.log2, handles.log3],'y');


function x = find_data(name, data, data_name)
for i=1:length(data_name);
    curve_pos = find(strcmp(data_name{i},name(:,3)));
    if isempty(curve_pos)==1
        if strcmp(data_name{i},'BS')==1
            curve_pos = find(strcmp('BIT',name(:,3)));
        else if strcmp(data_name{i},'RMIC')==1 ;
                curve_pos = find(strcmp('RS',name(:,3)));
            end
        end
        x(:,i) = NaN;
    else if isempty(curve_pos)==0
            x(:,i) = data(:,curve_pos);
        end
    end
end

function log_process (legend, well, log_type, handles, litho_axes)
cla(gca,'reset'); cla(litho_axes,'reset');
hold off
set(legend,'Visible','off','Xscale','linear');
xlabel(legend(1),''); xlabel(legend(2),'');xlabel(legend(3),'');
color_order = get(gca,'Colororder'); color_order(3,:)= [1 0 1];
color_order(2,:)= [0.4 0.8 0];
set(gca,'YLim',[0 5000],'XLim',[0 1],'YDir','reverse',...
     'Xgrid','on','XTick',[0:0.2:1],'XTickLabel',{},'XScale','linear',...
     'box','on','fontsize',8,'Colororder',color_order);
 
 if well==1
     data = handles.data1.curves;  name = handles.data1.curve_info;
     casing = handles.data1.casing; formation = handles.data1.formation;
 else if well==2
         data = handles.data2.curves;  name = handles.data2.curve_info;
         casing = handles.data2.casing; formation = handles.data2.formation;
     else if well==3
             data = handles.data3.curves;  name = handles.data3.curve_info;
             casing = handles.data3.casing; formation = handles.data3.formation;
         else if well==4
                 data = handles.data4.curves;  name = handles.data4.curve_info;
                 casing = handles.data4.casing; formation = handles.data4.formation;
             end
         end
     end
 end
y = data(:,1);

if log_type==1    
    data_name = {'GR','CALI','BS'};
    x = find_data(name,data,data_name);
    title = {'Gamma Ray (GAPI)','Caliper (inch)','Bit Size (inch)'};
    max_limit =[200, 40, 40];
    min_limit =[0,0,0];
    plotting (x, y, title, max_limit, min_limit, legend, handles,log_type)
else if log_type==2
        data_name = {'DEN','NEU'};
        x = find_data(name,data,data_name);  
        title = {'Density (g/cc)','Neutron (v/v)'};
        max_limit = [2.95, 0.15];
        min_limit = [1.95, -0.45];
        plotting (x, y, title, max_limit, min_limit, legend, handles, log_type)
    else if log_type==3
            data_name = {'RDEP','RMED','RMIC'};
            x = find_data(name,data,data_name);
            title = {'Deep Res (ohmm)','Med Res (ohmm)','Micro Res (ohmm)'};
            plotting_res(x,y,title,legend);
        else if log_type==4
                data_name = {'AC'};
                x = find_data(name,data,data_name);
                title = {'Sonic (delta t)'};
                max_limit = 240;
                min_limit = 40;
                plotting (x, y, title, max_limit, min_limit, legend, handles, log_type)
            end
        end
    end
end
linkaxes([gca,legend],'x');
set(gca,'fontsize',8);
ylabel(gca,'Depth (m)','fontsize',8,'units','normalized',...
    'position',[0.1 0.5 0]);
plotting_formation_casing (formation, casing, litho_axes);

function plotting (x, y, title, max_limit, min_limit, legend, handles, log_type)
for i=1:length(title)
    xnorm=(x(:,i)-min_limit(:,i))./(max_limit(:,i)-min_limit(:,i));
    color = get(gca,'ColorOrder');
    log_line = line(xnorm(~isnan(xnorm)),y(~isnan(xnorm)),'Color',color(i,:),'Linewidth',1);
    set(log_line,'Tag',char(title(:,i)),'UserData',[max_limit(:,i),...
        min_limit(:,i)],'ButtonDownFcn',@buttonDownCallback);
%========================= PLOT LEGEND BELOW =============================    
    xlabel(legend(:,i),title(:,i),'fontsize',8);
    label_tick=strtrim(cellstr(num2str((get(gca,'XTick')*...
        (max_limit(:,i)-min_limit(:,i))+min_limit(:,i))')));    
    if (log_type==2)&&(i==2)
        label_tick=strtrim(cellstr(num2str(-(get(gca,'XTick')*...
        (max_limit(:,i)-min_limit(:,i))+min_limit(:,i))')));
    end
    set(legend(:,i),'YTick',[],'XTickLabel',label_tick,...
        'Color','none','box','off','XAxisLocation','bottom',...
        'XLim',[0 1],'XTick',get(gca,'XTick'),'fontsize',8,...
        'Visible','on','YColor','none','XColor',color(i,:));
end

function plotting_formation_casing (formation, casing, litho_axes)
% plotting the formation group
formation(1,:)=[];
line_formation(formation);
x = 0.8; w = 0.2;
top = cell2mat(formation(1,3)); bottom = cell2mat(formation(1,4));

axes(litho_axes)
for i=2:(length(formation)) 
    if strcmp(formation(i,1),formation(i-1,1))==1
        if top>cell2mat(formation(i,3))
            top=cell2mat(formation(i,3));
        else if cell2mat(formation(i,4))>bottom
                bottom = cell2mat(formation(i,4));
            end
        end
    end
    
    if strcmp(formation(i,1),formation(i-1,1))==0
        title   = formation(i-1,1);
        square  = rectangle('Position',[x,top,w,(bottom-top)],'FaceColor','w');
        data    = {top,bottom,title};
        set(square,'ButtonDownFcn',@LithoCallback,'Userdata',data);
        if (bottom-top)>500
            text((x+w/2),(top+(bottom-top)/2),title,'HorizontalAlignment','center',...
                'Rotation',-90,'fontsize',7,'Clipping','on','ButtonDownFcn',@LithoCallback,'Userdata',data);
        end       
        top=cell2mat(formation(i,3)); bottom=cell2mat(formation(i,4));
    end
    
    if i==length(formation)
        title   = formation(i,1);
        square  = rectangle('Position',[x, top,w,(bottom-top)],'FaceColor','w');
        data    = {top,bottom,title};
        set(square,'ButtonDownFcn',@LithoCallback,'Userdata',data);
        if (bottom-top)>500
             text((x+w/2),(top+(bottom-top)/2),title,'HorizontalAlignment','center',...
                 'Rotation',-90,'fontsize',7,'Clipping','on','ButtonDownFcn',@LithoCallback,'Userdata',data);
        end
    end
end
hold on

x = 0.6;
for i=1:length(formation)
    top = cell2mat(formation(i,3));   bottom = cell2mat(formation(i,4));
    litho_zone=rectangle('Position',[x,top,w,(bottom-top)]);
    data= [top,bottom,formation(i,2),formation(i,5)];    
    set(litho_zone,'ButtonDownFcn',@LithoCallback,'Userdata',data);

% Checking litholohy type, set color based on lithology    
    if strcmp(formation(i,5),'Sandstone')==1
        set(litho_zone,'FaceColor','y');
    else if strcmp(formation(i,5),'Shale')==1
        set(litho_zone,'FaceColor','g');
        else if strcmp(formation(i,5),'Chalk')==1
                set(litho_zone,'FaceColor',[0.2 0.2 0.6]);
            else if strcmp(formation(i,5),'Carbonate')==1
                    set(litho_zone,'FaceColor',[0.301 0.745 0.933]);
                end
            end
        end
    end
end

% ============================ PLOT CASING ===============================
casing(1:2,:)=[];
[a,~] = size(casing); seawater = cell2mat(formation(1,3));

for i=1:a
    x = [(0.55-0.45/a*i),(0.55-0.45/a*i)];
    y = [seawater, cell2mat(casing(i,5))];
    the_line=line(x,y,'Linewidth',3,'Color','b');
    set(the_line,'ButtonDownFcn',@CasingCallback,'Userdata',casing(i,:));
end

set(litho_axes,'ydir','reverse','YTick',[],'XTick',[],'XLim',[0 1],'YLim',...
    [0 5000],'YColor','none','XColor','none','Color',[0.933 0.933 0.933]);
hold off

function LithoCallback(o,e)
pos = get(gca,'CurrentPoint'); pos = pos(1,1:2);
prev = findobj(gca,'Type','text','-and','Tag','pop_note'); delete(prev);
data = get(gco,'Userdata');
str2=strcat('Top = ',num2str(cell2mat(data(1))),' mMD');
str3=strcat('Bottom = ',num2str(cell2mat(data(2))),' mMD');
if length(data)==4
    str4=strcat('Lithology = ',char(data(4)));
    text(pos(1)-0.6,pos(2),{data{3},str2,str3,str4},'FontSIze',7.5,...
        'Backgroundcolor',[1 1 0.7],'Clipping','on','Tag','pop_note','EdgeColor','r');
else
    text(pos(1)-0.7,pos(2),{char(data{3}),str2,str3},'FontSize',7.5,...
        'Backgroundcolor',[1 1 0.7],'Clipping','on','Tag','pop_note','EdgeColor','r');
end

function line_formation(formation)
for i=1: length(formation)
    x = [ 0 500];
    y = [cell2mat(formation(i,3)),cell2mat(formation(i,3))];
    line(x,y,'LineStyle',':','Linewidth',0.2,'Color',[0.4 0.4 0.6]);
end

function CasingCallback(o,e)
pos = get(gca,'CurrentPoint'); pos = pos(1,1:2);
prev = findobj(gca,'Type','text','-and','Tag','pop_note'); delete(prev);
data = get(gco,'Userdata');
str1=char(data(3));
if isnan(cell2mat(data(2)))==1
    str2=strcat('Size = -');
else
    str2=strcat('Size = ',char(data(2)));
end
str3=strcat('Shoe = ',num2str(cell2mat(data(5))),' mMD');
text(pos(1),pos(2),{str1,str2,str3},'FontSize',7.5,...
    'Backgroundcolor',[1 1 0.7],'Clipping','off','Tag','pop_note','EdgeColor','r');

function buttonDownCallback(obj,event)
pos = get(gca,'CurrentPoint'); pos = pos(1,1:2);
color = get(gco,'Color');
prev = findobj(gca,'Type','text'); delete(prev);
max_limit = max(get(gco,'UserData')); min_limit = min(get(gco,'UserData'));
x = min_limit + (max_limit-min_limit)*pos(1);
text(pos(1),pos(2),{get(gco,'Tag'),num2str(x),num2str(pos(2))},...
    'EdgeColor',color,'FontSIze',8,'Backgroundcolor','w','Clipping','on');
    
function plotting_res(x,y, title, legend)
    for i=1:length(title)
        color = get(gca,'ColorOrder');
        if all(isnan(x(:,i)))==0 % check whether the reisitivity is empty or not
            data_x = x(:,i);
            semilogx(data_x(~isnan(data_x)),y(~isnan(data_x)),'Color',color(i,:),'Linewidth',1);
            hold on
            xlabel(legend(:,i),title(:,i),'fontsize',8);
            label_tick=strtrim(cellstr(num2str((get(gca,'XTick')'))));
            set(legend(:,i),'YTick',[],'XTickLabel',label_tick,...
                'Color','none','box','off','XAxisLocation','bottom',...
                'XLim',[0.01 100],'XTick',[10^-2, 10^-1, 1,10 ,100],'fontsize',8,...
                'Visible','on','YColor','none','XColor',color(i,:),'XScale','log');
        end
    end
    set(gca,'YLim',[0 5000],'XLim',[0.01,100],'YDir','reverse','Xgrid','on','XMinorGrid',...
        'on','XTick',[10^-2, 10^-1, 1,10 ,100],'XTickLabel',{},'XScale','log');
    
