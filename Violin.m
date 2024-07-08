classdef Violin < handle
    % Violin creates violin plots for some data
    %   A violin plot is an easy to read substitute for a box plot
    %   that replaces the box shape with a kernel density estimate of
    %   the data, and optionally overlays the data points itself.
    %   It is also possible to provide two sets of data which are supposed
    %   to be compared by plotting each column of the two datasets together
    %   on each side of the violin.
    %
    %   Additional constructor parameters include the width of the
    %   plot, the bandwidth of the kernel density estimation, the
    %   X-axis position of the violin plot, and the categories.
    %
    %   Use <a href="matlab:help('violinplot')">violinplot</a> for a
    %   <a href="matlab:help('boxplot')">boxplot</a>-like wrapper for
    %   interactive plotting.
    %
    %   See for more information on Violin Plots:
    %   J. L. Hintze and R. D. Nelson, "Violin plots: a box
    %   plot-density trace synergism," The American Statistician, vol.
    %   52, no. 2, pp. 181-184, 1998.
    %
    % Violin Properties:
    %    ViolinColor    - Fill color of the violin area and data points.
    %                     Can be either a matrix nx3 or an array of up to two
    %                     cells containing nx3 matrices.
    %                     Defaults to the next default color cycle.
    %    ViolinAlpha    - Transparency of the violin area and data points.
    %                     Can be either a single scalar value or an array of
    %                     up to two cells containing scalar values.
    %                     Defaults to 0.3.
    %    EdgeColor      - Color of the violin area outline.
    %                     Defaults to [0.5 0.5 0.5]
    %    BoxColor       - Color of the box, whiskers, and the outlines of
    %                     the median point and the notch indicators.
    %                     Defaults to [0.5 0.5 0.5]
    %    MedianColor    - Fill color of the median and notch indicators.
    %                     Defaults to [1 1 1]
    %    ShowData       - Whether to show data points.
    %                     Defaults to true
    %    ShowNotches    - Whether to show notch indicators.
    %                     Defaults to false
    %    ShowMean       - Whether to show mean indicator.
    %                     Defaults to false
    %    ShowBox        - Whether to show the box.
    %                     Defaults to true
    %    ShowMedian     - Whether to show the median indicator.
    %                     Defaults to true
    %    ShowWhiskers   - Whether to show the whiskers
    %                     Defaults to true
    %    HalfViolin     - Whether to do a half violin(left, right side) or
    %                     full. Defaults to full.
    %    QuartileStyle - Option on how to display quartiles, with a
    %                     boxplot, shadow or none. Defaults to boxplot.
    %    DataStyle      - Defines the style to show the data points. Opts: 
    %                     'scatter', 'histogram' or 'none'. Default is 'scatter'.
    %    Orientation    - Defines the orientation of the violin plot. Opts: 
    %                     'vertical', 'horizontal'. Default is 'vertical'.
    %    Parent         - The parent axis of the violin plot.
    %
    %
    % Violin Children:
    %    ScatterPlot    - <a href="matlab:help('scatter')">scatter</a> plot of the data points
    %    ScatterPlot2   - <a href="matlab:help('scatter')">scatter</a> second plot of the data points
    %    ViolinPlot     - <a href="matlab:help('fill')">fill</a> plot of the kernel density estimate
    %    ViolinPlot2    - <a href="matlab:help('fill')">fill</a> second plot of the kernel density estimate
    %    BoxPlot        - <a href="matlab:help('fill')">fill</a> plot of the box between the quartiles
    %    WhiskerPlot    - line <a href="matlab:help('plot')">plot</a> between the whisker ends
    %    MedianPlot     - <a href="matlab:help('scatter')">scatter</a> plot of the median (one point)
    %    NotchPlots     - <a href="matlab:help('scatter')">scatter</a> plots for the notch indicators
    %    MeanPlot       - line <a href="matlab:help('plot')">plot</a> at mean value
    
    
    % Copyright (c) 2016, Bastian Bechtold
    % This code is released under the terms of the BSD 3-clause license
    
    properties (Access=public)
        ScatterPlot     % scatter plot of the data points
        ScatterPlot2    % comparison scatter plot of the data points
        ViolinPlot      % fill plot of the kernel density estimate
        ViolinPlot2     % comparison fill plot of the kernel density estimate
        BoxPlot         % fill plot of the box between the quartiles
        WhiskerPlot     % line plot between the whisker ends
        MedianPlot      % scatter plot of the median (one point)
        NotchPlots      % scatter plots for the notch indicators
        MeanPlot        % line plot of the mean (horizontal line)
        HistogramPlot   % histogram of the data
        ViolinPlotQ     % fill plot of the Quartiles as shadow
        Parent          % parent axis
    end

    properties (SetAccess=protected, GetAccess=public)
        Orientation     % 'horizontal' or 'vertical'
    end
    
    properties (Dependent=true)
        ViolinColor         % fill color of the violin area and data points
        ViolinAlpha         % transparency of the violin area and data points
        MarkerSize          % marker size for the data dots
        MedianMarkerSize    % marker size for the median dot
        LineWidth           % linewidth of the median plot
        EdgeColor           % color of the violin area outline
        BoxColor            % color of box, whiskers, and median/notch edges
        BoxWidth            % width of box between the quartiles in axis space (default 10% of Violin plot width, 0.03)
        MedianColor         % fill color of median and notches
        ShowData            % whether to show data points
        ShowNotches         % whether to show notch indicators
        ShowMean            % whether to show mean indicator
        ShowBox             % whether to show the box
        ShowMedian          % whether to show the median line
        ShowWhiskers        % whether to show the whiskers
        HalfViolin          % whether to do a half violin(left, right side) or full
    end
    
    methods
        function obj = Violin(data, pos, varargin)
            %Violin plots a violin plot of some data at pos
            %   VIOLIN(DATA, POS) plots a violin at x-position POS for
            %   a vector of DATA points.
            %
            %   VIOLIN(..., 'PARAM1', val1, 'PARAM2', val2, ...)
            %   specifies optional name/value pairs:
            %     'Width'        Width of the violin in axis space.
            %                    Defaults to 0.3
            %     'Bandwidth'    Bandwidth of the kernel density
            %                    estimate. Should be between 10% and
            %                    40% of the data range.
            %     'ViolinColor'  Fill color of the violin area
            %                    and data points.Can be either a matrix
            %                    nx3 or an array of up to two cells
            %                    containing nx3 matrices.
            %     'ViolinAlpha'  Transparency of the violin area and data
            %                    points. Can be either a single scalar
            %                    value or an array of up to two cells
            %                    containing scalar values. Defaults to 0.3.
            %     'MarkerSize'   Size of the data points, if shown.
            %                    Defaults to 24
            % 'MedianMarkerSize' Size of the median indicator, if shown.
            %                    Defaults to 36
            %     'EdgeColor'    Color of the violin area outline.
            %                    Defaults to [0.5 0.5 0.5]
            %     'BoxColor'     Color of the box, whiskers, and the
            %                    outlines of the median point and the
            %                    notch indicators. Defaults to
            %                    [0.5 0.5 0.5]
            %     'MedianColor'  Fill color of the median and notch
            %                    indicators. Defaults to [1 1 1]
            %     'ShowData'     Whether to show data points.
            %                    Defaults to true
            %     'ShowNotches'  Whether to show notch indicators.
            %                    Defaults to false
            %     'ShowMean'     Whether to show mean indicator.
            %                    Defaults to false
            %     'ShowBox'      Whether to show the box
            %                    Defaults to true
            %     'ShowMedian'   Whether to show the median line
            %                    Defaults to true
            %     'ShowWhiskers' Whether to show the whiskers
            %                    Defaults to true
            %     'HalfViolin'   Whether to do a half violin(left, right side) or
            %                    full. Defaults to full.
            %   'QuartileStyle'  Option on how to display quartiles, with a
            %                    boxplot or as a shadow. Defaults to boxplot.
            %     'DataStyle'    Defines the style to show the data points. Opts:
            %                    'scatter', 'histogram' or 'none'. Default is 'Scatter'.
            %    'Orientation'   Defines the orientation of the violin plot. Opts:
            %                    'vertical', 'horizontal'. Default is 'vertical'.
            %    'Parent'        The parent axis of the violin plot.
            
            st = dbstack; % get the calling function for reporting errors
            namefun = st.name;
            args = obj.checkInputs(data, pos, varargin{:});
            obj.Orientation = args.Orientation;
            obj.Parent = args.Parent;
            
            if length(data)==1
                data2 = [];
                data = data{1};
                
            else
                data2 = data{2};
                data = data{1};
            end
            
            if isempty(args.ViolinColor)
                Release= strsplit(version('-release'), {'a','b'}); %Check release
                if str2num(Release{1})> 2019 || strcmp(version('-release'), '2019b')  
                     C = colororder;
                else
                     C = lines;
                end
                
                if pos > length(C)
                    C = lines;
                end
                args.ViolinColor = {repmat(C,ceil(size(data,2)/length(C)),1)};
            end
            
            data = data(not(isnan(data)));
            data2 = data2(not(isnan(data2)));
            if numel(data) == 1
                [x, y] = obj.swapOrientationMaybe(pos, data);
                obj.MedianPlot = scatter(x, y, 'filled', 'Parent', obj.Parent);
                obj.MedianColor = args.MedianColor;
                obj.MedianPlot.MarkerEdgeColor = args.EdgeColor;
                return
            end
            
            hold(obj.Parent, 'on');
            

            %% Calculate kernel density estimation for the violin
            [density, value, width] = obj.calcKernelDensity(data, args.Bandwidth, args.Width);
            
            % also calculate the kernel density of the comparison data if
            % provided
            if ~isempty(data2)
                [densityC, valueC, widthC] = obj.calcKernelDensity(data2, args.Bandwidth, args.Width);
            end
            
            %% Plot the data points within the violin area
            if length(density) > 1
                [~, unique_idx] = unique(value);
                jitterstrength = interp1(value(unique_idx), density(unique_idx)*width, data, 'linear','extrap');               
            else % all data is identical:
                jitterstrength = density*width;
            end
            if isempty(data2) % if no comparison data
                jitter = 2*(rand(size(data))-0.5); % both sides
            else
                jitter = rand(size(data)); % only right side
            end
            switch args.HalfViolin % this is more modular
                case 'left'
                    jitter = -1*(rand(size(data))); %left
                case 'right'
                    jitter = 1*(rand(size(data))); %right
                case 'full'
                    jitter = 2*(rand(size(data))-0.5);
            end
            % Make scatter plot
            switch args.DataStyle
                case 'scatter'
                    if ~isempty(data2)
                        jitter = 1*(rand(size(data))); %right
                        [x, y] = obj.swapOrientationMaybe(pos + jitter.*jitterstrength, data);
                        obj.ScatterPlot = ...
                            scatter(x, y, args.MarkerSize, 'filled', 'Parent', obj.Parent);
                        % plot the data points within the violin area
                        if length(densityC) > 1
                            jitterstrength = interp1(valueC, densityC*widthC, data2);
                        else % all data is identical:
                            jitterstrength = densityC*widthC;
                        end
                        jitter = -1*rand(size(data2));% left
                        [x, y] = obj.swapOrientationMaybe(pos + jitter.*jitterstrength, data2);
                        obj.ScatterPlot2 = ...
                            scatter(x, y, args.MarkerSize, 'filled', 'Parent', obj.Parent);
                    else
                        [x, y] = obj.swapOrientationMaybe(pos + jitter.*jitterstrength, data);
                        obj.ScatterPlot = ...
                            scatter(x, y, args.MarkerSize, 'filled', 'Parent', obj.Parent);

                    end
                case 'histogram'
                    [counts,edges] = histcounts(data, size(unique(data),1));
                    switch args.HalfViolin
                        case 'right'
                            [x, y] = obj.swapOrientationMaybe([pos-((counts')/max(counts))*max(jitterstrength)*2, pos*ones(size(counts,2),1)]', ...
                                        [edges(1:end-1)+max(diff(edges))/2; edges(1:end-1)+max(diff(edges))/2]);
                            obj.HistogramPlot = plot(x,y,'-','LineWidth',1, 'Color', 'k', 'Parent', obj.Parent);
                        case 'left'
                            [x, y] = obj.swapOrientationMaybe([pos*ones(size(counts,2),1), pos+((counts')/max(counts))*max(jitterstrength)*2]', ...
                                        [edges(1:end-1)+max(diff(edges))/2; edges(1:end-1)+max(diff(edges))/2]);
                            obj.HistogramPlot = plot(x,y,'-','LineWidth',1, 'Color', 'k', 'Parent', obj.Parent);
                        otherwise
                            fprintf([namefun, ' No histogram/bar plot option available for full violins, as it would look overcrowded.\n'])
                    end
                case 'none'
            end
                
            %% Plot the violin
            halfViol= ones(1, size(density,2));
            if isempty(data2) % if no comparison data
                switch args.HalfViolin
                    case 'right'
                        [x,y ] = obj.swapOrientationMaybe([pos+density*width halfViol*pos], ...
                                    [value value(end:-1:1)]);
                        obj.ViolinPlot = fill(x,y, [1 1 1], 'Parent', obj.Parent); % plot color will be overwritten later
                    case 'left'
                        [x,y] = obj.swapOrientationMaybe([halfViol*pos pos-density(end:-1:1)*width], ...
                                    [value value(end:-1:1)]);
                        obj.ViolinPlot = fill(x,y, [1 1 1], 'Parent', obj.Parent); % plot color will be overwritten later
                    case 'full'
                        [x, y] = obj.swapOrientationMaybe([pos+density*width pos-density(end:-1:1)*width], ...
                                    [value value(end:-1:1)]);
                        obj.ViolinPlot = fill(x,y, [1 1 1], 'Parent', obj.Parent); % plot color will be overwritten later
                end
            else
                % plot right half of the violin
                [x, y] = obj.swapOrientationMaybe([pos+density*width pos-density(1)*width], [value value(1)]);
                obj.ViolinPlot = fill(x ,y, [1 1 1], 'Parent', obj.Parent);
                % plot left half of the violin
                [x, y] = obj.swapOrientationMaybe([pos-densityC(end)*widthC pos-densityC(end:-1:1)*widthC], ...
                            [valueC(end) valueC(end:-1:1)]);
                obj.ViolinPlot2 = fill(x, y, [1 1 1], 'Parent', obj.Parent);
            end
                
            %% Plot the quartiles within the violin
            quartiles = quantile(data, [0.25, 0.5, 0.75]);
            flat= [halfViol*pos halfViol*pos];
            switch args.QuartileStyle
                case 'shadow'
                    switch args.HalfViolin
                        case 'right'
                            w = [pos+density*width halfViol*pos];
                            h = [value value(end:-1:1)];
                        case 'left'
                            w = [halfViol*pos pos-density(end:-1:1)*width];
                            h = [value value(end:-1:1)];
                        case 'full'
                            w = [pos+density*width pos-density(end:-1:1)*width];
                            h = [value value(end:-1:1)];
                    end
                    indices = h >= quartiles(1) & h <= quartiles(3);
                    [x, y] = obj.swapOrientationMaybe(w(indices), h(indices));
                    obj.ViolinPlotQ = fill(x, y, [1 1 1], 'Parent', obj.Parent); % plot color will be overwritten later
                case 'boxplot'
                    [x, y] = obj.swapOrientationMaybe(pos+[-1,1,1,-1]*args.BoxWidth, ...
                                [quartiles(1) quartiles(1) quartiles(3) quartiles(3)]);
                    obj.BoxPlot = fill(x, y, [1 1 1], 'Parent', obj.Parent); % plot color will be overwritten later
                case 'none'
            end
                
            %% Plot the data mean
            meanValue = mean(data);
            if length(density) > 1
                [~, unique_idx] = unique(value);
                meanDensityWidth = interp1(value(unique_idx), density(unique_idx), meanValue, 'linear','extrap')*width;
            else % all data is identical:
                meanDensityWidth = density*width;
            end
            if meanDensityWidth<args.BoxWidth/2
                meanDensityWidth=args.BoxWidth/2;
            end
            switch args.HalfViolin
                case 'right'
                    [x, y] = obj.swapOrientationMaybe(pos+[0,1].*meanDensityWidth, [meanValue, meanValue]);
                    obj.MeanPlot = plot(x, y, 'Parent', obj.Parent);
                case 'left'
                    [x, y] = obj.swapOrientationMaybe(pos+[-1,0].*meanDensityWidth, [meanValue, meanValue]);
                    obj.MeanPlot = plot(x, y, 'Parent', obj.Parent);
                case 'full'
                    [x, y] = obj.swapOrientationMaybe(pos+[-1,1].*meanDensityWidth, [meanValue, meanValue]);
                    obj.MeanPlot = plot(x, y, 'Parent', obj.Parent);
            end
            obj.MeanPlot.LineWidth = 1;
                
            %% Plot the median, notch, and whiskers
            IQR = quartiles(3) - quartiles(1);
            lowhisker = quartiles(1) - 1.5*IQR;
            lowhisker = max(lowhisker, min(data(data > lowhisker)));
            hiwhisker = quartiles(3) + 1.5*IQR;
            hiwhisker = min(hiwhisker, max(data(data < hiwhisker)));
            if ~isempty(lowhisker) && ~isempty(hiwhisker)
                [x, y] = obj.swapOrientationMaybe([pos pos], [lowhisker hiwhisker]);
                obj.WhiskerPlot = plot(x, y, 'Parent', obj.Parent);
            end
                
            % Median
            [x, y] = obj.swapOrientationMaybe(pos, quartiles(2));
            obj.MedianPlot = scatter(x, y, ...
                                args.MedianMarkerSize, [1 1 1], 'filled', 'Parent', obj.Parent);
                
            % Notches
            [x, y] = obj.swapOrientationMaybe(pos, quartiles(2)-1.57*IQR/sqrt(length(data)));
            obj.NotchPlots = scatter(x, y, [], [1 1 1], 'filled', '^', 'Parent', obj.Parent);
            [x, y] = obj.swapOrientationMaybe(pos, quartiles(2)+1.57*IQR/sqrt(length(data)));
            obj.NotchPlots(2) = scatter(x, y, [], [1 1 1], 'filled', 'v', 'Parent', obj.Parent);
                
            %% Set graphical preferences
            obj.EdgeColor = args.EdgeColor;
            obj.MedianPlot.LineWidth = args.LineWidth;
            obj.BoxColor = args.BoxColor;
            obj.BoxWidth = args.BoxWidth;
            obj.MedianColor = args.MedianColor;
            obj.ShowData = args.ShowData;
            obj.ShowNotches = args.ShowNotches;
            obj.ShowMean = args.ShowMean;
            obj.ShowBox = args.ShowBox;
            obj.ShowMedian = args.ShowMedian;
            obj.ShowWhiskers = args.ShowWhiskers;
                
            if not(isempty(args.ViolinColor))
                if size(args.ViolinColor{1},1) > 1
                    ViolinColor{1} = args.ViolinColor{1}(pos,:);
                else
                    ViolinColor{1} = args.ViolinColor{1};
                end
                if length(args.ViolinColor)==2
                    if size(args.ViolinColor{2},1) > 1
                        ViolinColor{2} = args.ViolinColor{2}(pos,:);
                    else
                        ViolinColor{2} = args.ViolinColor{2};
                    end
                else
                    ViolinColor{2} = ViolinColor{1};
                end
            else
                % defaults
                if args.scpltBool
                    ViolinColor{1} = obj.ScatterPlot.CData;
                else
                    ViolinColor{1} = [0 0 0];
                end
                ViolinColor{2} = [0 0 0];
            end
            obj.ViolinColor = ViolinColor;
                
                
            if not(isempty(args.ViolinAlpha))
                if length(args.ViolinAlpha{1})>1
                    error('Only scalar values are accepted for the alpha color channel');
                else
                    ViolinAlpha{1} = args.ViolinAlpha{1};
                end
                if length(args.ViolinAlpha)==2
                    if length(args.ViolinAlpha{2})>1
                        error('Only scalar values are accepted for the alpha color channel');
                    else
                        ViolinAlpha{2} = args.ViolinAlpha{2};
                    end
                else
                    ViolinAlpha{2} = ViolinAlpha{1}/2;  % default unless specified
                end
            else
                % default
                ViolinAlpha = {1,1};
            end
            obj.ViolinAlpha = ViolinAlpha;
                
                
            set(obj.ViolinPlot, 'Marker', 'none', 'LineStyle', '-');
            set(obj.ViolinPlot2, 'Marker', 'none', 'LineStyle', '-');
        end
            
        %% SET METHODS
        function set.EdgeColor(obj, color)
            if ~isempty(obj.ViolinPlot)
                obj.ViolinPlot.EdgeColor = color;
                obj.ViolinPlotQ.EdgeColor = color;
                if ~isempty(obj.ViolinPlot2)
                    obj.ViolinPlot2.EdgeColor = color;
                end
            end
        end
            
        function color = get.EdgeColor(obj)
            if ~isempty(obj.ViolinPlot)
                color = obj.ViolinPlot.EdgeColor;
            end
        end
            
            
        function set.MedianColor(obj, color)
            obj.MedianPlot.MarkerFaceColor = color;
            if ~isempty(obj.NotchPlots)
                obj.NotchPlots(1).MarkerFaceColor = color;
                obj.NotchPlots(2).MarkerFaceColor = color;
            end
        end
            
        function color = get.MedianColor(obj)
            color = obj.MedianPlot.MarkerFaceColor;
        end
            
            
        function set.BoxColor(obj, color)
            if ~isempty(obj.BoxPlot)
                obj.BoxPlot.FaceColor = color;
                obj.BoxPlot.EdgeColor = color;
                obj.WhiskerPlot.Color = color;
                obj.MedianPlot.MarkerEdgeColor = color;
                obj.NotchPlots(1).MarkerFaceColor = color;
                obj.NotchPlots(2).MarkerFaceColor = color;
            elseif  ~isempty(obj.ViolinPlotQ)
                obj.WhiskerPlot.Color = color;
                obj.MedianPlot.MarkerEdgeColor = color;
                obj.NotchPlots(1).MarkerFaceColor = color;
                obj.NotchPlots(2).MarkerFaceColor = color;
            end
        end
            
        function color = get.BoxColor(obj)
            if ~isempty(obj.BoxPlot)
                color = obj.BoxPlot.FaceColor;
            end
        end
            
            
        function set.BoxWidth(obj,width)
            if ~isempty(obj.BoxPlot)
                pos=mean(obj.BoxPlot.XData);
                obj.BoxPlot.XData=pos+[-1,1,1,-1]*width;
            end
        end
            
        function width = get.BoxWidth(obj)
            width=max(obj.BoxPlot.XData)-min(obj.BoxPlot.XData);
        end
            
            
        function set.ViolinColor(obj, color)
            obj.ViolinPlot.FaceColor = color{1};
            obj.ScatterPlot.MarkerFaceColor = color{1};
            obj.MeanPlot.Color = color{1};
            if ~isempty(obj.ViolinPlot2)
                obj.ViolinPlot2.FaceColor = color{2};
                obj.ScatterPlot2.MarkerFaceColor = color{2};
            end
            if  ~isempty(obj.ViolinPlotQ)
                obj.ViolinPlotQ.FaceColor = color{1};
            end
            for idx = 1: size(obj.HistogramPlot,1)
                obj.HistogramPlot(idx).Color = color{1};
            end
        end
                
        function color = get.ViolinColor(obj)
            color{1} = obj.ViolinPlot.FaceColor;
            if ~isempty(obj.ViolinPlot2)
                color{2} = obj.ViolinPlot2.FaceColor;
            end
        end
                
                
        function set.ViolinAlpha(obj, alpha)
            obj.ViolinPlotQ.FaceAlpha = .65;
            obj.ViolinPlot.FaceAlpha = alpha{1};
            obj.ScatterPlot.MarkerFaceAlpha = 1;
            if ~isempty(obj.ViolinPlot2)
                obj.ViolinPlot2.FaceAlpha = alpha{2};
                obj.ScatterPlot2.MarkerFaceAlpha = 1;
            end
        end
                
        function alpha = get.ViolinAlpha(obj)
            alpha{1} = obj.ViolinPlot.FaceAlpha;
            if ~isempty(obj.ViolinPlot2)
                alpha{2} = obj.ViolinPlot2.FaceAlpha;
            end
        end
                
                
        function set.ShowData(obj, yesno)
            if yesno
                obj.ScatterPlot.Visible = 'on';
                for idx = 1: size(obj.HistogramPlot,1)
                    obj.HistogramPlot(idx).Visible = 'on';
                end
            else
                obj.ScatterPlot.Visible = 'off';
                for idx = 1: size(obj.HistogramPlot,1)
                    obj.HistogramPlot(idx).Visible = 'off';
                end
            end
            if ~isempty(obj.ScatterPlot2)
                obj.ScatterPlot2.Visible = obj.ScatterPlot.Visible;
            end
            
        end
                
        function yesno = get.ShowData(obj)
            if ~isempty(obj.ScatterPlot)
                yesno = strcmp(obj.ScatterPlot.Visible, 'on');
            end
        end
                
                
        function set.ShowNotches(obj, yesno)
            if ~isempty(obj.NotchPlots)
                if yesno
                    obj.NotchPlots(1).Visible = 'on';
                    obj.NotchPlots(2).Visible = 'on';
                else
                    obj.NotchPlots(1).Visible = 'off';
                    obj.NotchPlots(2).Visible = 'off';
                end
            end
        end
                
        function yesno = get.ShowNotches(obj)
            if ~isempty(obj.NotchPlots)
                yesno = strcmp(obj.NotchPlots(1).Visible, 'on');
            end
        end
                
                
        function set.ShowMean(obj, yesno)
            if ~isempty(obj.MeanPlot)
                if yesno
                    obj.MeanPlot.Visible = 'on';
                else
                    obj.MeanPlot.Visible = 'off';
                end
            end
        end
                
        function yesno = get.ShowMean(obj)
            if ~isempty(obj.BoxPlot)
                yesno = strcmp(obj.BoxPlot.Visible, 'on');
            end
        end
                
                
        function set.ShowBox(obj, yesno)
            if ~isempty(obj.BoxPlot)
                if yesno
                    obj.BoxPlot.Visible = 'on';
                else
                    obj.BoxPlot.Visible = 'off';
                end
            end
        end
                
        function yesno = get.ShowBox(obj)
            if ~isempty(obj.BoxPlot)
                yesno = strcmp(obj.BoxPlot.Visible, 'on');
            end
        end
                
                
        function set.ShowMedian(obj, yesno)
            if ~isempty(obj.MedianPlot)
                if yesno
                    obj.MedianPlot.Visible = 'on';
                else
                    obj.MedianPlot.Visible = 'off';
                end
            end
        end
                
        function yesno = get.ShowMedian(obj)
            if ~isempty(obj.MedianPlot)
                yesno = strcmp(obj.MedianPlot.Visible, 'on');
            end
        end
                
                
        function set.ShowWhiskers(obj, yesno)
            if ~isempty(obj.WhiskerPlot)
                if yesno
                    obj.WhiskerPlot.Visible = 'on';
                else
                    obj.WhiskerPlot.Visible = 'off';
                end
            end
        end
                
        function yesno = get.ShowWhiskers(obj)
            if ~isempty(obj.WhiskerPlot)
                yesno = strcmp(obj.WhiskerPlot.Visible, 'on');
            end
        end

    end
            
    methods (Access=private)
        function results = checkInputs(~, data, pos, varargin)
            isscalarnumber = @(x) (isnumeric(x) & isscalar(x));
            p = inputParser();
            p.addRequired('Data', @(x)isnumeric(vertcat(x{:})));
            p.addRequired('Pos', isscalarnumber);
            p.addParameter('Width', 0.3, isscalarnumber);
            p.addParameter('Bandwidth', [], isscalarnumber);
            iscolor = @(x) (isnumeric(x) & size(x,2) == 3);
            p.addParameter('ViolinColor', [], @(x)iscolor(vertcat(x{:})));
            p.addParameter('MarkerSize', 24, @isnumeric);
            p.addParameter('MedianMarkerSize', 36, @isnumeric);
            p.addParameter('LineWidth', 0.75, @isnumeric);
            p.addParameter('BoxColor', [0.5 0.5 0.5], iscolor);
            p.addParameter('BoxWidth', 0.01, isscalarnumber);
            p.addParameter('EdgeColor', [0.5 0.5 0.5], iscolor);
            p.addParameter('MedianColor', [1 1 1], iscolor);
            p.addParameter('ViolinAlpha', {0.3,0.15}, @(x)isnumeric(vertcat(x{:})));
            isscalarlogical = @(x) (islogical(x) & isscalar(x));
            p.addParameter('ShowData', true, isscalarlogical);
            p.addParameter('ShowNotches', false, isscalarlogical);
            p.addParameter('ShowMean', false, isscalarlogical);
            p.addParameter('ShowBox', true, isscalarlogical);
            p.addParameter('ShowMedian', true, isscalarlogical);
            p.addParameter('ShowWhiskers', true, isscalarlogical);
            validSides={'full', 'right', 'left'};
            checkSide = @(x) any(validatestring(x, validSides));
            p.addParameter('HalfViolin', 'full', checkSide);
            validQuartileStyles={'boxplot', 'shadow', 'none'};
            checkQuartile = @(x)any(validatestring(x, validQuartileStyles));
            p.addParameter('QuartileStyle', 'boxplot', checkQuartile);
            validDataStyles = {'scatter', 'histogram', 'none'};
            checkStyle = @(x)any(validatestring(x, validDataStyles));
            p.addParameter('DataStyle', 'scatter', checkStyle);
            p.addParameter('Orientation', 'vertical', @(x) ismember(x, {'vertical', 'horizontal'}));
            p.addParameter('Parent', gca, @(x) isa(x,'matlab.graphics.axis.Axes'));

            p.parse(data, pos, varargin{:});
            results = p.Results;
        end

        function [x, y] = swapOrientationMaybe(obj, x, y)
            %swapOrientationMaybe swaps the two variables x and y
            % if Violin.Orientation property set to horizontal.
            % If orientation is vertical, it returns x and y as is.
            if strcmp(obj.Orientation, 'horizontal')
                tmp = x;
                x = y;
                y = tmp;
            end
        end
    end
        
    methods (Static)
        function [density, value, width] = calcKernelDensity(data, bandwidth, width)
            if isempty(data)
                error('Empty input data');
            end
            [density, value] = ksdensity(data, 'bandwidth', bandwidth);
            density = density(value >= min(data) & value <= max(data));
            value = value(value >= min(data) & value <= max(data));
            value(1) = min(data);
            value(end) = max(data);
            value = [value(1)*(1-1E-5), value, value(end)*(1+1E-5)];
            density = [0, density, 0];
            
            % all data is identical
            if min(data) == max(data)
                density = 1;
                value= mean(value);
            end
            
            width = width/max(density);
        end
    end
end

