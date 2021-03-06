%% Author: Rodrigo de Barros Vimieiro
% Date: April, 2018
% rodrigo.vimieiro@gmail.com
% =========================================================================
%{
% -------------------------------------------------------------------------
%                    dataPreprocess(data,parameter)
% -------------------------------------------------------------------------
%     DESCRIPTION:
%     This function pre process the projection images.
%  
%  
%     INPUT:
% 
%     - data = Projections.
%     - parameter = Parameters.
% 
%     OUTPUT:
% 
%     - data_mod = Modified image.
%     - parameter_mod = Modified parameters.
% 
%     ---------------------------------------------------------------------
%     Copyright (C) <2018>  <Rodrigo de Barros Vimieiro>
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%}
% =========================================================================
function [data_mod,parameter_mod] = dataPreprocess(data,parameter)

global noise

parameter_mod = parameter;

%% Segmentation
Gap = 20;

vertProj = sum(abs(((2^14-1)-data(:,:,5))));
[~,Ind] = max(diff(vertProj));
Ind = Ind-Gap; % Max positive derivative 

% Modifies parameters based on segmentation
parameter_mod.nu = size(vertProj(Ind:end),2);  % Number of pixels (columns)
parameter_mod.su = parameter.nu.*parameter.du;	
parameter_mod.us = (parameter_mod.nu-1:-1:0)*parameter_mod.du;

data_mod = data(:,Ind:end,:);

%% Insert noise in virtual projections
if(noise)
    data_mod = insertNoise(data_mod,parameter_mod); % Insert noise in projs
end

%% Transform intensity image in attenuation coefficients
data_mod = -log(data_mod./single(2^parameter_mod.bitDepth-1));

end
