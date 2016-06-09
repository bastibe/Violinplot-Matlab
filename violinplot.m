function violins = violinplot(data, cats, varargin)
    % d = 1xN, c = []; violin without name
    % d = 1xN, c = 1xn; violins with names
    % d = NxM, c = 1xn; violins with names
    % d = NxM, c = []; violins without names
    % d = table; violins with names
    cats = categorical(cats);
    catnames = categories(cats);
    for n=1:length(catnames)
        thisCat = catnames{n};
        thisData = data(cats == thisCat);
        violins(n) = Violin(thisData, n, varargin{:});
    end
end
