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

set CITIES:= C1 C2 C3 C4;
set VOTERS:= V1 V2 V3;

param num_cities:= 4;
param approval: C1 C2 C3 C4:=
V1               1  0  1  1 
V2               0  1  0  0
V3               1  1  0  1;
param time:= 6;
param distance:  C1  C2  C3  C4:=
C1               10   1   3   4
C2                1  10   2   3
C3                3   2  10   1
C4                4   3   1  10;

end;

/* optimal: C1, C2, C3 */
/* optimal tour: C1 -> C3 -> C2 -> C1 */
