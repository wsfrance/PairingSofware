% EXAMPLE_LINKBRUSH_HISTOGRAM  - example linking a histogram
%
% A Histogram example of linked data and brushing
%  
%  plot and corresponding hist of data
% 
%  Data can be brushed in the XvY plot or the hist plot and the selected
%   data will highlight in both plots.
%
%  see also mbrush, mlink, mEvent, matpigui, example_linkBrush_02, example_linkBrush_01
%
%  Copyright Robert Cumming @ Matpi Ltd.
%  www.matpi.com
%  $Id: example_linkBrush_Histogram.m 266 2016-02-03 08:43:25Z robertcumming $
classdef example_linkBrush_Histogram < handle
  properties ( SetAccess = private )
    hTab          % The parent figure
    link          % The link class
    hBrush        % the brush object
    Histogram01   % handle to the top x v y plot
    hHistogram    % handle to the frequency histogram
    hHistogramX   % handle to the x histogram
    hHistogramY   % handle to the y histogram
    hHistogramZ   % hangle to the z histogram
  end
  methods % Constructor
    function obj = example_linkBrush_Histogram ()
      % Create a figure
      hFig = dialog ( 'position', [100 100 1000 800], 'windowStyle', 'normal', 'name', 'Brush & Link Data example - www.matpi.com', 'resize', 'on' );
      
      % Create a matpigui object -> which will contain pages.
      obj.hTab = matpigui ( hFig );
      
      % Create 2 pages where plots will be created
      obj.hTab.addPage ( 'Histogram'  );

      % add the axes
      obj.hTab.addAxes ( 'Histogram', 'axes1', 'position', [0.05 0.37 0.45 0.26] ); 
      obj.hTab.addAxes ( 'Histogram', 'axes2', 'position', [0.05 0.69 0.9 0.26] ); 
      obj.hTab.addAxes ( 'Histogram', 'axes3', 'position', [0.55 0.37 0.45 0.26] ); 
      obj.hTab.addAxes ( 'Histogram', 'axes4', 'position', [0.05 0.03 0.45 0.26] ); 
      obj.hTab.addAxes ( 'Histogram', 'axes5', 'position', [0.55 0.03 0.45 0.26] ); 
      obj.hTab.addUIC ( 'Histogram', 'check', 'pushbutton', 'Position', [0.0 0.97 0.2 0.03], 'String', 'Brushed Data Info:', 'Callback', @(a,b)obj.reportSelection() );
      
      % initialise a toolbar for the gui (this creates a page selection
      obj.hTab.toolbar ( 'init' );      
      
      % Import some random data
      obj.dataset1();

      %% Histogram
      % Get some dta
      x = obj.hTab.getData ( 'data1.X' );
      y = obj.hTab.getData ( 'data1.Y' );
      z = obj.hTab.getData ( 'data1.Z' );
      % Get the axes handle
      ax2 = obj.hTab.hUIC.Histogram.axes2;
      % plot the Histogram data
      obj.Histogram01 = plot ( ax2, x, y, 'k.' );
      title ( ax2, 'Y v X' );
      grid ( ax2, 'on' );
      
      % create a Histogram plot
      freq = obj.hTab.getData ( 'data1.Freq' );
      histogram ( obj.hTab.hUIC.Histogram.axes1, freq, 'normalization', 'count' );
      obj.hHistogram = obj.hTab.hUIC.Histogram.axes1.Children(end);
      title ( obj.hTab.hUIC.Histogram.axes1, 'Freq Histogram' );
      
      % plot the Histogram data
      histogram ( obj.hTab.hUIC.Histogram.axes3, x );
      obj.hHistogramX = obj.hTab.hUIC.Histogram.axes3.Children(end);
      title ( obj.hTab.hUIC.Histogram.axes3, 'X Histogram' );

      histogram ( obj.hTab.hUIC.Histogram.axes4, y );
      obj.hHistogramY = obj.hTab.hUIC.Histogram.axes4.Children(end);
      title ( obj.hTab.hUIC.Histogram.axes4, 'Y Histogram' );
      
      histogram ( obj.hTab.hUIC.Histogram.axes5, z, 'Orientation', 'Horizontal' );
      obj.hHistogramZ = obj.hTab.hUIC.Histogram.axes5.Children(end);
      title ( obj.hTab.hUIC.Histogram.axes5, 'Z Histogram' );
      
      
      % create the brush object
      obj.hBrush = mbrush( ax2 );
      obj.hBrush.groupHistFormat{1}.FaceColor = [0 1 0];
      % add the plots and Histogramogram
      obj.hBrush.addPlotsToBrush ( obj.Histogram01 );
      obj.hBrush.addHistogramToBrush ( obj.hHistogram, freq );
      obj.hBrush.addHistogramToBrush ( obj.hHistogramX, x );
      obj.hBrush.addHistogramToBrush ( obj.hHistogramY, y );
      obj.hBrush.addHistogramToBrush ( obj.hHistogramZ, z );

      obj.hTab.hUIC.Histogram.axes1.XLim = [-50 150];
      % Create a link to a data object.
      obj.link = mlink ( obj.hTab );
      obj.link.addChildLink ( obj.Histogram01, { 'data1.X' 'data1.Y' } ); 
      obj.link.addChildLink ( obj.hHistogram, { [] 'data1.Freq' } ); 
      obj.link.addChildLink ( obj.hHistogramX, { [] 'data1.X' } ); 
      obj.link.addChildLink ( obj.hHistogramY, { [] 'data1.Y' } ); 
      obj.link.addChildLink ( obj.hHistogramZ, { [] 'data1.Z' } ); 

      % Add the toggle option for to show all brushed data.
      obj.hBrush.incOriginalSelectionInToolbar = true;
      % Update the toolbar
      obj.hBrush.add2ToolBar( hFig );
      
      % allow Ctrl-C to copy the figure to the clipboard.
      obj.hTab.setCopyFigure ( true );
      centerfig ( hFig );
    end % Constructor
  end
  methods ( Access=private )
    function obj = dataset1 ( obj )
      temp = rand(3,1000);
      data.X = temp(1,:);
      data.Y = temp(2,:).^2;
      data.Z = temp(3,:).^2;
      data.Freq = randi(10,size(temp,2),1).^2;
      vars = { 'X' 'Y' 'Z' 'Freq'};
      for ii=1:length(vars)
        obj.hTab.addData ( sprintf ( 'data1.%s', vars{ii}), data.(vars{ii}) );
      end
    end
    function obj = reportSelection ( obj )
%%       index = length(find(children(ii).UserData.mbrush.index==1)==1)
      if isfield ( obj.Histogram01.UserData, 'mbrush' )
        index = obj.Histogram01.UserData.mbrush.index;
        X = obj.hTab.data.data1.X(index);
        Y = obj.hTab.data.data1.Y(index);
        Z = obj.hTab.data.data1.Z(index);
        freq = obj.hTab.data.data1.Freq(index);
        str = sprintf ( 'nPoints selected = %i\nmin X = %f max X = %f\nmin Y = %f max Y = %f\nmin Z = %f max Z = %f\nmin Freq = %f max Freq = %f', length(find(index==1)), min(X), max(X), min(Y), max(Y), min(Z), max(Z), min(freq), max(freq) );
        msgbox ( str );
      end
%       hHistogram
%       hHistogramX
%       hHistogramY
%       hHistogramZ
      
    end
  end
end