set CITIES;
set VOTERS;

param num_cities;
param approval{ i in VOTERS, j in CITIES }, binary; /* Does voter i like city j? */
param time;
param distance{ i in CITIES, j in CITIES };

var is_visited{ j in CITIES }, binary; /* Is a city visited */
var get_city{ i in VOTERS, j in 1..num_cities }, binary; /* Does voter i get at least j cities? */
var connect_city{ i in CITIES, j in CITIES }, binary; /* Is there a connection from city i to city j? */
var number{ j in CITIES }; /* arbitrary number */
var is_start{i in CITIES},binary; /* start from a city */


/* Objective: pick a tour (visit as many cities as possible) using PAV, with time and distance constraint */

maximize utility: sum{ i in VOTERS, j in 1..num_cities } 1/j*get_city[i,j];


s.t. one_start:  sum{ j in CITIES } is_start[j]<=1; /* start and end at one city */
s.t. exit{ i in CITIES }: sum{ j in CITIES } connect_city[i,j] <= 1; /* at most one tour exit each city */
s.t. enter{ j in CITIES }: sum{ i in CITIES } connect_city[i,j] <= 1; /* at most one tour enter each city */
s.t. flow{ i in CITIES }: sum { j in CITIES } connect_city[i,j] = sum { j in CITIES } connect_city[j,i]; /*all inflows should be equal to all outflows from a node (enter and exit) */
s.t. no_subtour{ i in CITIES, j in CITIES }: number[i] - number[j] + (num_cities)*connect_city[i,j] <= num_cities - 1 + num_cities*is_start[j]; /* prevent suboptimal tours, start/end at same node */
s.t. num_get_visited{ i in VOTERS }: sum{ j in 1..num_cities } get_city[i,j] <= sum{ j in CITIES } approval[i,j]*is_visited[j]; /* the cities voter i gets are at most the ones he likes and visited */
s.t. at_least{ i in VOTERS, j in 1..num_cities-1 }: get_city[i,j] >= get_city[i,j+1]; /*If a voter gets 2 cities, then he must get at least 1 city */
s.t. visit_constraint{ i in CITIES}: is_visited[i] <= sum{j in CITIES} connect_city[i,j]; /* an out-connecting city should be visited */
s.t. time_contraint: sum{ i in CITIES, j in CITIES } distance[i,j]*connect_city[i,j] <= time; /* visitng cities' distance should satisfies the constraint */

data;

set CITIES:= London Paris Zurich Venice Prague Berlin;
set VOTERS:= A B C D;

param num_cities:= 6;
param approval: London Paris Zurich Venice Prague Berlin:=
A                    0     0     1     0     1     0 
B                    0     1     0     1     0     1
C                    0     0     0     1     1     1
D                    1     1     1     0     0     0;
param time:= 10;
param distance: London Paris Zurich Venice Prague Berlin:=
London               0     2     5     7     6     6 
Paris                2     0     3     5     6     6
Zurich               5     3     0     2     3     4
Venice               7     5     2     0     3     5
Prague               6     6     3     3     0     2
Berlin               6     6     4     5     2     0;

end;

/* optimal: Paris, Venice, Zurich */
/* optimal tour: Paris -> Venice -> Zurich -> Paris */

/* another possible optimal: Zurich, Prague, Berlin */
/* another possible optimal tour: Zurich -> Berlin -> Prague -> Zurich */
