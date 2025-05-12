% Method to generate channelizer coefficients based on given config
function coeff_matrix = coeffs_for_fir_units(prototype_fir,config)
    % Taken from PG446
    % --------------------------------------------------------------------------
    % Inputs:
    % prototype_fir: Prototype Filter (1d vector)
    % config: Configuration Structure:
    % config.MODE: Sets the mode the core will operate in. 7 options:
    % 'chan' : 8-Channel Analysis Channelizer
    % 'inv_chan' : 8-Channel Synthesis Inverse Channelizer
    % '4_sample_chan' : 8-Channel 2 GSPS Analysis Channelizer
    % '4_sample_inv_chan' : 8-Channel 2 GSPS Synthesis Inverse Channelizer
    % 'over_chan' : 8-Channel 2x Oversampled Analysis Channelizer
    % 'over_inv_chan' : 8-Channel 2x Oversampled Synthesis Inverse
    % Channelizer
    % 'fir_filt' : Up-to-8 channel FIR filter (FFT bypass)
    % config.FIR_COEFF_TYPE: 'real' or 'complex' FIR coefficients
    % config.MAX_ASYM_FIR_LEN: Maximum asymmetric FIR length:
    % 8 (only in complex mode), 16, 32, 64 (only in real mode)
    %
    % Outputs:
    % coeff_matrix: 3D array holding what should be loaded into each FIR unit:
    % (No. of Active FIR Units) x (No. of Coefficient Sets) x (No. of Taps)
    %
    % This relates to the following in the Logicore:
    % S_AXIS_coeff interface x TUSER select coefficient written x TDATA order
    %---------------------------------------------------------------------------
    % CONSTANTS
    % Default number of asymmetric fir_taps per channel per FIR unit
    default_num_asym_taps = 16;
    % Default number of channels
    default_num_chan = 8;
    % COEFF MATRIX SIZE
    % Determine how many FIR units are necessary
    if config.fir_coeff_type == 1   % complex
        fir_taps = default_num_asym_taps/2;
    else
        fir_taps = default_num_asym_taps;
    end
    cascade_num = config.max_asym_fir_len/fir_taps;
    switch config.mode
        case 0  %'chan' rx
            is_inve = 0;
            num_fir_units = cascade_num;
            decimation_factor = default_num_chan;
        case 1  %'inv_chan' tx
            is_inve = 1;
            num_fir_units = cascade_num;
            decimation_factor = default_num_chan;
        case 3  %'over_chan'
            is_inve = 0;
            num_fir_units = 2*cascade_num;
            decimation_factor = default_num_chan/2;
        case 4  %'over_inv_chan'
            is_inve = 1;
            num_fir_units = 2*cascade_num;
            decimation_factor = default_num_chan/2;
        case 6  %'4_sample_chan'
            is_inve = 0;
            num_fir_units = 2*cascade_num;
            decimation_factor = default_num_chan;
        case 5  %'4_sample_inv_chan'
            is_inve = 1;
            num_fir_units = 2*cascade_num;
            decimation_factor = default_num_chan;
        case 2  %'fir_filt'
            error(['This script only generates coefficient matrices ' ...
                'for channelization (not FIR Filter mode). For ' ...
                'FIR filter mode load each channel of the FIR ' ...
                'filter independently.'])
        otherwise
            error('Unsupported Logicore mode')
    end
    coeff_matrix = zeros([num_fir_units, default_num_chan, fir_taps]);
    % RESHAPE
    % Create a polyphase coefficient matrix
    % Different config implementations have different starting points and
    % rotations for the commutator providing the data to the polyphase filter.
    % This Logicore implementation has the commutator always start at Phase 0
    % and rotate clock-wise in all modes (i.e. cycle through phases 0,1,...7)
    % When a Channelizer (Analysis) and Inverse Channelizer (Synthesis) are
    % used in sequence, the commutator rotations must be compatible.
    % A typical implementation is one where:
    % 1) The Analysis Channelizer (Inverse Channelizer) starts at phase
    % 0 and rotates clock-wise
    % 2) The Synthesis Channelizer (Channelizer) starts at phase 0 and
    % rotates counter-clock-wise
    % The example below shows how such a scenario can be implemented by
    % accordingly padding and flipping the prototype filter matrix.
    casc_phase_taps = fir_taps*cascade_num;
    assert(numel(prototype_fir) == (casc_phase_taps-1)*default_num_chan+1, ...
        ['This script only supports prototype filter lengths of ' ...
        '((TAPS_PER_PHASE - 1) * NUMBER_OF_CHANNELS) + 1.']);
    if(is_inve)
        % Starts at phase 0 and rotates clock-wise
        proto_pad = [prototype_fir zeros(1, default_num_chan-1)];
        % Polyphase Partition
        pfb = reshape(proto_pad, default_num_chan, casc_phase_taps);
    else
        % Starts at phase 0 and rotates counter-clock-wise
        proto_pad = [zeros(1, decimation_factor-1) prototype_fir];
        exp_num_taps = casc_phase_taps*default_num_chan;
        proto_pad = [proto_pad zeros(1, exp_num_taps - numel(proto_pad))];
        % Polyphase Partition
        pfb = reshape(proto_pad, default_num_chan, casc_phase_taps);
        % Commutator goes counter-clockwise
        pfb = flipud(pfb);
    end
    % SPLIT AMONG UNITS
    % Split the polyphase filter matrix among the (up-to) 4 available FIR units
    for k = 1:cascade_num
        switch config.mode
            case {0, 1}   % {'chan', 'inv_chan'}
                coeff_matrix(k,:,:) = ...
                    pfb(:,fir_taps*(k-1)+1 : fir_taps*k);
            case {3,4,6,5}    % {'over_chan', 'over_inv_chan', '4_sample_chan', '4_sample_inv_chan'}
                % Same FIRs for Top & Bottom
                coeff_matrix(2*(k-1)+1,:,:) = ...
                    pfb(:,fir_taps*(k-1)+1 : fir_taps*k);
                coeff_matrix(2*k,:,:) = ...
                    pfb(:,fir_taps*(k-1)+1 : fir_taps*k);
        end
    end
end
