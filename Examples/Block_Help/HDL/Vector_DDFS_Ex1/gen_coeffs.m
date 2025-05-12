%% Basic coefficient parameters
num_chan   = 8;  % Number of second-stage channels
taps_per_phase = 16; % Number of taps per phase. More taps are possible when internal FIR units are cascaded, this shows the simplest example. 
proto_num_taps = num_chan*(taps_per_phase-1)+1;

%% Generate prototype filter coefficients
prototype_fir   = fir1(proto_num_taps-1, ...        % Order i.e. num taps - 1
    1/num_chan, ...              % Cutoff (between 0 and 1)
    'low', ...                       % Type i.e. lowpass
    blackmanharris(proto_num_taps)); % Window
prototype_fir   = circshift(prototype_fir, 5);
prototype_fir   = prototype_fir/max(prototype_fir);

%% Generate coefficients for each channel
config.mode = 0; % channelizer
config.fir_coeff_type = 0; % real coefficients
config.max_asym_fir_len = taps_per_phase;
coeff_matrix = squeeze(coeffs_for_fir_units(prototype_fir, config))';

%% Generate signals to load channelizer coefficients
% First Coefficient Set Write Data Format (TDATA - SX0)
SX0 = 0; % bits [2:0] = shift value, [23:3] = reserved
% Second Coefficient Set Write Data Format (TDATA - SX0)
SX1 = 4*2^-17; % bits [2:0] number of sub-delay lines active on each channel
         % [13:3] reserved
         % [14] use_odd_num_tap
         % [15] is_symmetric
         % [23:16] reserved

% Coefficient Programming for a Single FIR Unit
% Ref: PG446 Versal RF Series Channelizer v1.0 LogiCORE IP Product Guide,
% pg. 53
coeff_tdata_sample = [0 0 0];
coeff_tvalid = [0 0 0];
coeff_tlast = [0 0 0];
coeff_tuser_select_coeff_written = [0 0 0];
coeff_tuser_select_gain_written = [0 0 0];
coeff_tuser_select_data_destination = [0 0 0];
coeff_tuser_select_cascade_address = [0 0 0];
ctrl_0 = [0 0 0]; 
for ii = 1:num_chan
    coeff_tdata_sample = [coeff_tdata_sample SX0 SX1];
    coeff_tvalid = [coeff_tvalid 1 1];
    coeff_tlast = [coeff_tlast 0 0];
    coeff_tuser_select_coeff_written = [coeff_tuser_select_coeff_written ii-1 ii-1];
    coeff_tuser_select_gain_written = [coeff_tuser_select_gain_written 0 0];
    coeff_tuser_select_data_destination = [coeff_tuser_select_data_destination 1 1];
    coeff_tuser_select_cascade_address =[coeff_tuser_select_cascade_address 0 0];
    ctrl_0 = [ctrl_0 0 0];
    for jj = 1:taps_per_phase
        coeff_tdata_sample = [coeff_tdata_sample coeff_matrix(jj, 1)];
        coeff_tvalid = [coeff_tvalid 1];
        if mod(jj,4) == 0 % num_active_units=4 so load 4 coefficients at a time
            coeff_tlast = [coeff_tlast 1];
        else
            coeff_tlast = [coeff_tlast 0];
        end
        coeff_tuser_select_coeff_written = [coeff_tuser_select_coeff_written ii-1];
        coeff_tuser_select_gain_written = [coeff_tuser_select_gain_written 0];
        coeff_tuser_select_data_destination = [coeff_tuser_select_data_destination 1];
        coeff_tuser_select_cascade_address =[coeff_tuser_select_cascade_address 0];
        ctrl_0 = [ctrl_0 0];
    end
    coeff_tdata_sample = [coeff_tdata_sample 0 0];
    coeff_tvalid = [coeff_tvalid 0 0];
    coeff_tlast = [coeff_tlast 0 0];
    coeff_tuser_select_coeff_written = [coeff_tuser_select_coeff_written 0 0];
    coeff_tuser_select_gain_written = [coeff_tuser_select_gain_written 0 0];
    coeff_tuser_select_data_destination = [coeff_tuser_select_data_destination 0 0];
    coeff_tuser_select_cascade_address =[coeff_tuser_select_cascade_address 0 0];
    ctrl_0 = [ctrl_0 2 0];
end

%% Generate signals to drive channelizer
load input_signal.mat

% One Sample Input Per Clock Cycle Per Instance
% Ref: PG446 Versal RF Series Channelizer v1.0 LogiCORE IP Product Guide,
% pg. 46
din_tdata_sample_0_imag = [zeros(1,length(ctrl_0)) 0 0 0];
din_tdata_sample_0_real = [zeros(1,length(ctrl_0)) 0 0 0];
din_tvalid = [zeros(1,length(ctrl_0)) 0 0 0];
din_tlast = [zeros(1,length(ctrl_0)) 0 0 0];
din_tid = [zeros(1,length(ctrl_0)) 0 0 0];
din_tuser_keep_sample_0 = [zeros(1,length(ctrl_0)) 0 0 0];
din_tuser_gain_set_0 = [zeros(1,length(ctrl_0)) 0 0 0];
din_tuser_complex_coeff_set_0 = [zeros(1,length(ctrl_0)) 0 0 0];
din_tuser_real_coeff_set_0 = [zeros(1,length(ctrl_0)) 0 0 0];
for jj = 1:length(x)
    for ii = 1:num_chan
        din_tdata_sample_0_imag = [din_tdata_sample_0_imag imag(x(jj))];
        din_tdata_sample_0_real = [din_tdata_sample_0_real real(x(jj))];
        din_tvalid = [din_tvalid 1];
        if ii == num_chan
            din_tlast = [din_tlast 1];
        else
            din_tlast = [din_tlast 0];
        end
        din_tid = [din_tid ii-1];
        din_tuser_keep_sample_0 = [din_tuser_keep_sample_0 1];
        din_tuser_gain_set_0 = [din_tuser_gain_set_0 0];
        din_tuser_complex_coeff_set_0 = [din_tuser_complex_coeff_set_0 ii-1];
        din_tuser_real_coeff_set_0 = [din_tuser_real_coeff_set_0 ii-1];
    end
end
din_tdata_sample_0_imag = [din_tdata_sample_0_imag 0];
din_tdata_sample_0_real = [din_tdata_sample_0_real 0];
din_tvalid = [din_tvalid 0];
din_tlast = [din_tlast 0];
din_tid = [din_tid 0];
din_tuser_keep_sample_0 = [din_tuser_keep_sample_0 0];
din_tuser_gain_set_0 = [din_tuser_gain_set_0 0];
din_tuser_complex_coeff_set_0 = [din_tuser_complex_coeff_set_0 0];
din_tuser_real_coeff_set_0 = [din_tuser_real_coeff_set_0 0];