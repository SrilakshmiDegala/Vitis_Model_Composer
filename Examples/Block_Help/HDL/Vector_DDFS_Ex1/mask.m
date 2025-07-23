classdef mask
    methods(Static)
        function MaskInitialization(maskInitContext)
            % Access the mask workspace
            ws = maskInitContext.MaskWorkspace;

            % Retrieve parameter values from the mask workspace
            sample_rate = ws.get('sample_rate');
            fft_max_point_size_temp = ws.get('fft_max_point_size_temp');

            % Set parameters on the internal block
            set_param([gcb, '/mask_level_wrapper/Versal RF FFT/Versal RF FFT'], 'sample_rate', sample_rate, 'fft_max_point_size_temp', fft_max_point_size_temp);
        end

        %function sample_rate(callbackContext)
            %blkhandle = callbackContext.BlockHandle;
            %maskObj = simulink.Mask.get(blkhandle);
            %parameterObj = callbackContext.ParameterObject;

            %Add some code here to potentially autoroute the signals - need
            %to think about the lower SSR values tho
            
        %end
    end
end
