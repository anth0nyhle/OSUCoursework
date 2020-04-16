% draw_maze(maze)
% By Jeremy Kubica, 2003
% Modifed by Yang Gu, 2006
% Modified by Geoff Hollinger, 2015
% Input (maze): Maze structure
% Input (cur): Current robot location
% Input (values): values to label cells. Could be rewards or value
% function, etc. Defaults to rewards if not provided.
function draw_maze(maze, cur, values)

if nargin < 3
    values = maze.reward;
end

h1 = figure(1);
set(h1,'DoubleBuffer','on')

hold off;
clf;
hold on;

% determine the size of the maze and set the figure accordingly
R = maze.R;
C = maze.C;
%axis([0 C 0 R+2]);
axis([0 C 0 R]);

% draw the grid
ind = 1;
for i = 1:C
   for j = 1:R
      
      % Label the cell with reward
      text(i-0.5,(R-j+.5),num2str(values(ind)));
      %text(i-0.5,(R-j+.5),num2str(ind));
      
      % Draw the northern border
      %HN = line([(i-1) (i)],[(R-j+3) (R-j+3)]);
      HN = line([(i-1) (i)],[(R-j+1) (R-j+1)]);
      if(maze.adjacent(ind,1) == 1)
         set(HN,'Color',[0.6 0.6 0.6]);
         set(HN,'LineStyle',':');
      else
         set(HN,'Color',[0 0 0]);
         set(HN,'LineStyle','-');
      end
      
      % Draw the southern border
      %HS = line([(i-1) (i)],[(R-j+2) (R-j+2)]);
      HS = line([(i-1) (i)],[(R-j) (R-j)]);
      if(maze.adjacent(ind,3) == 1)
         set(HS,'Color',[0.6 0.6 0.6]);
         set(HS,'LineStyle',':');
      else
         set(HS,'Color',[0 0 0]);
         set(HS,'LineStyle','-');
      end
      
      % Draw the eastern border
      %HE = line([(i) (i)],[(R-j+3) (R-j+2)]);
      HE = line([(i) (i)],[(R-j+1) (R-j)]);
      if(maze.adjacent(ind,2) == 1)
         set(HE,'Color',[0.6 0.6 0.6]);
         set(HE,'LineStyle',':');
      else
         set(HE,'Color',[0 0 0]);
         set(HE,'LineStyle','-');
      end  
      
      % Draw the western border
      %HW = line([(i-1) (i-1)],[(R-j+3) (R-j+2)]);
      HW = line([(i-1) (i-1)],[(R-j+1) (R-j)]);
      if(maze.adjacent(ind,4) == 1)
         set(HW,'Color',[0.6 0.6 0.6]);
         set(HW,'LineStyle',':');
      else
         set(HW,'Color',[0 0 0]);
         set(HW,'LineStyle','-');
      end  
      
      ind = ind + 1;
   end
end

%draw current location
[X,Y] = maze_XY_from_index(maze, cur);
%viscircles([X-0.5 R-Y+0.5], 0.5);
rectangle('Position',[X-0.75 R-Y+0.25 0.5 0.5],'EdgeColor','r');

hold off;