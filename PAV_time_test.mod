set CITIES;
set VOTERS;

param num_cities;
param approval{ i in VOTERS, j in CITIES }, binary; /* Does voter i like city j? */
param time;
param distance{ i in 1..num_cities, j in 1..num_cities };

var is_visited{ j in CITIES }, binary; /* Is a city visited */
var get_city{ i in VOTERS, j in 1..num_cities }, binary; /* Does voter i get at least j cities? */
var connect_city{ i in 0..num_cities, j in 0..num_cities }, binary; /* Is there a connection from city i to city j?  start and end at 0 */
var number{ j in 1..num_cities }; /* arbitrary number */

/* Objective: pick top 3 cities using PAV, with additional time and distance constraint */

maximize utility: sum{ i in VOTERS, j in 1..num_cities, k in 1..3 } 1/k*get_city[i,j] - (sum{ i in 1..num_cities, j in 1..num_cities } distance[i,j]*connect_city[i,j]);

s.t. exit_0: sum{ j in 1..num_cities } connect_city[0,j] = 1; /* exit from 0 */
s.t. enter_0: sum{ i in 1..num_cities } connect_city[1,0] = 1; /* enter to 0 */
s.t. exit{ i in 1..num_cities }: sum{ j in 1..num_cities } connect_city[i,j] <= 1; /* at most one tour exit each city */
s.t. enter{ j in 1..num_cities }: sum{ i in 1..num_cities } connect_city[i,j] <= 1; /* at most one tour enter each city */
s.t. no_subtour{ i in 1..num_cities, j in 1..num_cities }: number[i] - number[j] + (num_cities)*connect_city[i,j] <= num_cities - 1; /* prevent suboptimal tours */
s.t. num_get_visited{ i in VOTERS }: sum{ j in 1..num_cities } get_city[i,j] <= sum{ j in CITIES } approval[i,j]*is_visited[j]; /* the cities voter i gets are at most the ones he likes and visited */
s.t. at_least{ i in VOTERS, j in 1..num_cities-1 }: get_city[i,j] >= get_city[i,j+1]; /*If a voter gets 2 cities, then he must get at least 1 city */
s.t. visit_k_cities: sum{ j in CITIES } is_visited[j] <= 3;
s.t. time_contraint: sum{ i in 1..num_cities, j in 1..num_cities } distance[i,j]*connect_city[i,j] <= time;

data;

set CITIES:= C1 C2 C3 C4;
set VOTERS:= V1 V2 V3;

param num_cities:= 4;
param approval: C1 C2 C3 C4:=
V1               1  0  1  1 
V2               0  1  0  0
V3               1  1  0  1;
param time:= 4;
param distance:  1  2  3  4:=
1                0  1  3  4
2                1  0  2  3
3                3  2  0  1
4                4  3  1  0;

end;
