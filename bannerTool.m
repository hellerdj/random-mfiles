function htxt = bannerTool(txtstring,fontsize)% makes or modifies a banner title % called by newLIPfig.m in lipgui.m% bannerTool(txtstring) makes the banner using the txtstring argument% bannerTool  without an argument uses the global TXTSTRING variable from% lipgui. The function returns a handle to the text object.% 5/15/97 mns added the arguments% 7/7/99 only call globalLipgui if there is no argument if nargin == 0  globalLipguiHdr  txtstring = TXTSTRING;elseif ~ischar(txtstring)  error('bannerTool: input arg should be string. type help bannerTool')endif nargin < 2  fontsize = 18endax = get(gcf,'CurrentAxes');		% store the current axesh = axes('position',[0,0,1,1],'Visible','off')set(gcf,'CurrentAxes',h)htxt = text(.5,.95,txtstring,'HorizontalAlignment','center',...    'VerticalAlignment','middle','FontSize',fontsize)set(gcf,'CurrentAxes',ax);