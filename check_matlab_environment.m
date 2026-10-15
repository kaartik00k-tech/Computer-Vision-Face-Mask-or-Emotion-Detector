function check_matlab_environment
    % Checks required MATLAB toolboxes and whether MATLAB Compiler is installed
    fprintf('Checking MATLAB environment...\n\n');

    v = ver;
    installed = {v.Name};

    required = {'Image Processing Toolbox', 'Computer Vision Toolbox'};
    missing = {};
    for i = 1:numel(required)
        if ~any(strcmp(installed, required{i}))
            missing{end + 1} = required{i};
        end
    end

    if isempty(missing)
        fprintf('Required toolboxes are installed.\n');
    else
        fprintf('Missing required toolboxes:\n');
        for i = 1:numel(missing)
            fprintf('  - %s\n', missing{i});
        end
    end

    compilerInstalled = any(strcmp(installed, 'MATLAB Compiler')) || ...
        any(strcmp(installed, 'MATLAB Compiler SDK'));

    fprintf('\nMATLAB Compiler installed: %d\n', compilerInstalled);

    [status, output] = system('mcc -h');
    if status == 0
        fprintf('mcc is available on the system PATH.\n');
        fprintf('mcc help output preview:\n');
        fprintf('%s\n', output(1:min(length(output), 300))); 
    else
        fprintf('mcc is not available on the system PATH.\n');
        fprintf('This usually means MATLAB Compiler is not installed or not on PATH.\n');
    end

    fprintf('\nInstalled MathWorks products in this MATLAB session:\n');
    for i = 1:numel(installed)
        fprintf('  - %s\n', installed{i});
    end
end
