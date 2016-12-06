% An event object which contains extra infromation (var + data)
%
%  see also mbrush, mlink, exampleDataObj
%
%  Copyright Robert Cumming @ Matpi Ltd.
%  www.matpi.com
%  $Id: mEvent.m 267 2016-02-03 09:55:00Z Bob $
classdef mEvent < event.EventData
  properties ( SetAccess=private )
    data % Any arg pairs passed in on construction are stored here.
  end
  methods
    function obj = mEvent(varargin)
      % obj = mEvent ( 'arg1', value1, arg2, value2, ...., argN, valN );
      %
      %  You can pass any arg pairs in the the class these are stored
      %   in the event and passed to any listener.
    end
  end
end
