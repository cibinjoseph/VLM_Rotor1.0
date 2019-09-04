% Program to convert camber geometry in *.m degenGeom file 
% generated by OpenVSP to Plot3D format

function [X,Y,Z] = degen2plot3d(degenGeomFile)

% Remove .m extension if present in degenGeomFile
if (degenGeomFile(end-1:end) == '.m')
  commandName = degenGeomFile(1:end-2);
else
  commandName = degenGeomFile;
end

% Run degenGeom matlab file to get dataset
run(commandName);

% Check no. of geometries
nGeo = size(degenGeom,2);

% Extract camber surface coordinates of right wing
Xright = degenGeom(1).plate.x;
Yright = degenGeom(1).plate.y;
Zright = degenGeom(1).plate.zCamber;

% Transpose to make rows chordwise and columns spanwise
Xright = Xright';
Yright = Yright';
Zright = Zright';

% Flip order of X coordinates of right wing
Xright = flip(Xright,1);
Zright = flip(Zright,1);

X = Xright;
Y = Yright;
Z = Zright;

if (nGeo == 2)
   % Extract camber surface coordinates of left wing
   Xleft = degenGeom(2).plate.x;
   Yleft = degenGeom(2).plate.y;
   Zleft = degenGeom(2).plate.zCamber;

   % Transpose to make rows chordwise and columns spanwise
   Xleft = Xleft';
   Yleft = Yleft';
   Zleft = Zleft';

   % Flip order of X coordinates of left wing
   Xleft = flip(Xleft,1);
   Zleft = flip(Zleft,1);

   %   % Flip order of Y coordinates of left wing
   Yleft = flip(Yleft,2);
   Xleft = flip(Xleft,2);
   Zleft = flip(Zleft,2);

   X = [Xleft(:,1:end-1) X];
   Y = [Yleft(:,1:end-1) Y];
   Z = [Zleft(:,1:end-1) Z];

 end

 nx = size(X,1);
 ny = size(X,2);
 nz = 1;

 % Write to PLOT3D format
 fileID = fopen([commandName '.xyz'],'w');
 fprintf(fileID,'%u %u %u\n',nx,ny,nz)
 fprintf(fileID,'%15.7f',X)
 fprintf(fileID,'%15.7f',Y)
 fprintf(fileID,'%15.7f',Z)
 fclose(fileID);

 return;
