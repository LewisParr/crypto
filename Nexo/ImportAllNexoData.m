function nexooutput = ImportAllNexoData()
%IMPORTALLNEXODATA Summary of this function goes here

% Import each nexo file
nexooutput202107 = ImportNexoOutput('2021','07');
nexooutput202108 = ImportNexoOutput('2021','08');

% Aggregate all nexo files
nexooutput = [ ...
    nexooutput202107; ...
    nexooutput202108];

% Set the time format
nexooutput.DateTime.Format = 'yyyy-MM-dd HH:mm:ss';

return
end

