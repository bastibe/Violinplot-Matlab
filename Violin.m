classdef Violin < handle
    properties
        ScatterPlot
        ViolinPlot
        BoxPlot
        WhiskerPlot
        MedianPlot
        NotchPlots
    end

    properties (Dependent=true)
        ViolinColor
        ViolinAlpha
        EdgeColor
        BoxColor
        MedianColor
        ShowData
        ShowNotches
    end

    methods
        function obj = Violin(data, pos, varargin)
            args = obj.checkInputs(data, pos, varargin{:});
            data = data(not(isnan(data)));
            if numel(data) == 1
                obj.MedianPlot = scatter(pos, data, 'filled');
                obj.MedianColor = args.MedianColor;
                obj.MedianPlot.MarkerEdgeColor = args.EdgeColor;
                return
            end

            hold('on');

            % calculate kernel density estimation for the violin
            [density, value] = ksdensity(data, 'bandwidth', args.Bandwidth);
            density = density(value >= min(data) & value <= max(data));
            value = value(value >= min(data) & value <= max(data));
            value(1) = min(data);
            value(end) = max(data);

            if isempty(args.Width)
                width = 0.3/max(density);
            else
                width = args.Width;
            end

            % plot the data points within the violin area
            jitterstrength = interp1(value, density*width, data);
            jitter = 2*(rand(size(data))-0.5);
            obj.ScatterPlot = ...
                scatter(pos + jitter.*jitterstrength, data, 'filled');

            % plot the violin
            obj.ViolinPlot =  ... % plot color will be overwritten later
                fill([pos+density*width pos-density(end:-1:1)*width], ...
                     [value value(end:-1:1)], [1 1 1]);

            % plot the mini-boxplot within the violin
            quartiles = quantile(data, [0.25, 0.5, 0.75]);
            obj.BoxPlot = ... % plot color will be overwritten later
                fill([pos-0.01 pos+0.01 pos+0.01 pos-0.01], ...
                     [quartiles(1) quartiles(1) quartiles(3) quartiles(3)], ...
                     [1 1 1]);
            IQR = quartiles(3) - quartiles(1);
            lowhisker = quartiles(1) - 1.5*IQR;
            lowhisker = max(lowhisker, min(data));
            hiwhisker = quartiles(3) + 1.5*IQR;
            hiwhisker = min(hiwhisker, max(data));
            obj.WhiskerPlot = plot([pos pos], [lowhisker hiwhisker]);
            obj.MedianPlot = scatter(pos, quartiles(2), [], [1 1 1], 'filled');

            obj.NotchPlots = ...
                 scatter(pos, quartiles(2)-1.57*IQR/sqrt(length(data)), ...
                         [], [1 1 1], 'filled', '^');
            obj.NotchPlots(2) = ...
                 scatter(pos, quartiles(2)+1.57*IQR/sqrt(length(data)), ...
                         [], [1 1 1], 'filled', 'v');

            obj.EdgeColor = args.EdgeColor;
            obj.BoxColor = args.BoxColor;
            obj.MedianColor = args.MedianColor;
            if not(isempty(args.ViolinColor))
                obj.ViolinColor = args.ViolinColor;
            else
                obj.ViolinColor = obj.ScatterPlot.CData;
            end
            obj.ViolinAlpha = args.ViolinAlpha;
            obj.ShowData = args.ShowData;
            obj.ShowNotches = args.ShowNotches;
        end

        function set.EdgeColor(obj, color)
            obj.ViolinPlot.EdgeColor = color;
        end

        function color = get.EdgeColor(obj)
            color = obj.ViolinPlot.EdgeColor;
        end

        function set.MedianColor(obj, color)
            obj.MedianPlot.MarkerFaceColor = color;
            if not(isempty(obj.NotchPlots))
                obj.NotchPlots(1).MarkerFaceColor = color;
                obj.NotchPlots(2).MarkerFaceColor = color;
            end
        end

        function color = get.MedianColor(obj)
            color = obj.MedianPlot.MarkerFaceColor;
        end

        function set.BoxColor(obj, color)
            obj.BoxPlot.FaceColor = color;
            obj.BoxPlot.EdgeColor = color;
            obj.WhiskerPlot.Color = color;
            obj.MedianPlot.MarkerEdgeColor = color;
            obj.NotchPlots(1).MarkerEdgeColor = color;
            obj.NotchPlots(2).MarkerEdgeColor = color;
        end

        function color = get.BoxColor(obj)
            color = obj.BoxPlot.FaceColor;
        end

        function set.ViolinColor(obj, color)
            obj.ViolinPlot.FaceColor = color;
            obj.ScatterPlot.MarkerFaceColor = color;
        end

        function color = get.ViolinColor(obj)
            color = obj.ViolinPlot.FaceColor;
        end

        function set.ViolinAlpha(obj, alpha)
            obj.ScatterPlot.MarkerFaceAlpha = alpha;
            obj.ViolinPlot.FaceAlpha = alpha;
        end

        function alpha = get.ViolinAlpha(obj)
            alpha = obj.ViolinPlot.FaceAlpha;
        end

        function set.ShowData(obj, yesno)
            if yesno
                obj.ScatterPlot.Visible = 'on';
            else
                obj.ScatterPlot.Visible = 'off';
            end
        end

        function yesno = get.ShowData(obj)
            yesno = logical(strcmp(obj.NotchPlots(1).Visible, 'on'));
        end

        function set.ShowNotches(obj, yesno)
            if yesno
                obj.NotchPlots(1).Visible = 'on';
                obj.NotchPlots(2).Visible = 'on';
            else
                obj.NotchPlots(1).Visible = 'off';
                obj.NotchPlots(2).Visible = 'off';
            end
        end

        function yesno = get.ShowNotches(obj)
            yesno = logical(strcmp(obj.ScatterPlot.Visible, 'on'));
        end
    end

    methods (Access=private)
        function results = checkInputs(obj, data, pos, varargin)
            isscalarnumber = @(x) (isnumeric(x) & isscalar(x));
            p = inputParser();
            p.addRequired('Data', @isnumeric);
            p.addRequired('Pos', isscalarnumber);
            p.addParameter('Width', [], isscalarnumber);
            p.addParameter('Bandwidth', [], isscalarnumber);
            iscolor = @(x) (isnumeric(x) & length(x) == 3);
            p.addParameter('ViolinColor', [], iscolor);
            p.addParameter('BoxColor', [0.5 0.5 0.5], iscolor);
            p.addParameter('EdgeColor', [0.5 0.5 0.5], iscolor);
            p.addParameter('MedianColor', [1 1 1], iscolor);
            p.addParameter('ViolinAlpha', 0.3, isscalarnumber);
            isscalarlogical = @(x) (islogical(x) & isscalar(x));
            p.addParameter('ShowData', true, isscalarlogical);
            p.addParameter('ShowNotches', false, isscalarlogical);

            p.parse(data, pos, varargin{:});
            results = p.Results;
        end
    end
end
