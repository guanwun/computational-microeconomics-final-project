set CITIES;
set VOTERS;

param num_cities;
param approval{ i in VOTERS, j in CITIES }, binary; /* Does voter i like city j? */

var is_visited{ j in CITIES }, binary; /* Is a city visited */
var get_city{ i in VOTERS, j in 1..num_cities }, binary; /* Does voter i get at least j cities? */

/* Objective: pick top 3 cities using PAV */

maximize utility: sum{ i in VOTERS, j in 1..3 } 1/j*get_city[i,j];

s.t. num_get_visited{ i in VOTERS }: sum{ j in 1..num_cities } get_city[i,j] <= sum{ j in CITIES } approval[i,j]*is_visited[j]; /* the cities voter i gets are at most the ones he likes and visited */
s.t. at_least{ i in VOTERS, j in 1..num_cities-1 }: get_city[i,j] >= get_city[i,j+1]; /*If a voter gets 2 cities, then he must get at least 1 city */
s.t. visit_k_cities: sum{ j in CITIES } is_visited[j] <= 3;

data;

set CITIES:= C1 C2 C3 C4;
set VOTERS:= V1 V2 V3;

param num_cities:= 4;
param approval: C1 C2 C3 C4:=
V1               1  0  1  1 
V2               0  1  0  0
V3               1  1  0  1;

end;

/* optimal: C1, C2, C4 */
