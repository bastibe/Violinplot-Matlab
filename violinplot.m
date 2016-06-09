function violins = violinplot(data, cats, varargin)

    hascategories = exist('cats') && not(isempty(cats));

    % tabular data
    if isa(data, 'dataset') || isstruct(data) || istable(data)
        if isa(data, 'dataset')
            colnames = data.Properties.VarNames;
        elseif istable(data)
            colnames = data.Properties.VariableNames;
        elseif isstruct(data)
            colnames = fieldnames(data);
        end
        catnames = {};
        for n=1:length(colnames)
            if isnumeric(data.(colnames{n}))
                catnames = [catnames colnames{n}];
            end
        end
        for n=1:length(catnames)
            thisData = data.(catnames{n});
            violins(n) = Violin(thisData, n);
        end
        set(gca, 'xtick', 1:length(catnames), 'xticklabels', catnames);

    % 1D data, one category for each data point
    elseif hascategories && length(data) == length(cats)
        cats = categorical(cats);
        catnames = categories(cats);
        for n=1:length(catnames)
            thisCat = catnames{n};
            thisData = data(cats == thisCat);
            violins(n) = Violin(thisData, n, varargin{:});
        end
        set(gca, 'xtick', 1:length(catnames), 'xticklabels', catnames);

    % 1D data, no categories
    elseif not(hascategories) && isvector(data)
        violins = Violin(data, 1);
        set(gca, 'xtick', 1);

    % 2D data with or without categories
    elseif ismatrix(data)
        for n=1:size(data, 2)
            thisData = data(:, n);
            violins(n) = Violin(thisData, n);
        end
        set(gca, 'xtick', 1:size(data, 2));
        if hascategories && length(cats) == size(data, 2)
            set(gca, 'xticklabels', cats);
        end

    end

end
