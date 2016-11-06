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

set CITIES:= London Paris Prague Berlin Zurich Venice;
set VOTERS:= A B C D E F G H I J K L M N O P Q R S;

param num_cities:= 6;
param approval: London Paris Prague Berlin Zurich Venice:=
A                    1     1     1     1     1     1 
B                    0     0     0     0     0     0
C                    1     1     1     0     1     0
D                    0     1     0     1     0     1
E                    1     1     1     1     1     0
F                    1     0     0     1     1     0
G                    1     1     1     1     0     1
H                    1     1     0     0     1     1
I                    1     1     1     1     0     0
J                    0     1     1     1     0     1
K                    1     1     0     0     0     1
L                    0     1     1     0     0     1
M                    1     1     0     1     0     1
N                    1     1     0     0     0     1
O                    0     0     1     1     1     1
P                    1     1     1     0     1     1
Q                    1     1     1     1     1     1
R                    1     1     0     1     1     1
S                    0     1     1     1     0     1;

param time:= 10;
/* non-stop flight hours */
param distance: London Paris Prague Berlin Zurich Venice:=
London               0  1.25  1.92  1.83   1.67    2.33
Paris             1.25     0  1.67  1.67   1.17    1.58
Prague            1.92  1.67     0  0.92   1.25    1.67
Berlin            1.83  1.67  0.92     0   1.50    1.67
Zurich            1.67  1.17  1.25  1.50      0    1.08
Venice            2.33  1.58  1.67  1.67   1.08       0;
end;

/* time = 1 */
/* optimal: Paris */
/* maximum utility: 16 */
/* optimal tour: (staying in) Paris */

/* time = 2 */
/* optimal: Prague, Berlin */
/* maximum utility: 19 */
/* optimal tour: Prague -> Berlin -> Prague */

/* time = 3 */
/* optimal:  London, Paris*/
/* maximum utility: 23 */
/* optimal tour:  London -> Paris -> London */

/* time = 4 */
/* optimal: Paris, Zurich, Venice */
/* maximum utility: 27.66667 */
/* optimal tour: Zurich -> Paris -> Venice -> Zurich */

/* time = 5 */
/* optimal:  Prague, Belin, Zurich, Venice */
/* maximum utility: 29.75 */
/* optimal tour: Berlin -> Prague -> Zurich -> Venice -> Berlin  */

/* time = 6 */
/* optimal: Paris, Prague, Berlin, Venice */
/* maximum utility: 32.08333 */
/* optimal tour: Prague -> Berline -> Paris -> Venice -> Prague */

/* time = 7 */
/* optimal: London, Paris, Berlin, Zurich, Venice */
/* maximum utility: 35.26667 */
/* optimal tour: Berlin -> London -> Paris -> Zurich -> Venice -> Berlin */

/* time = 8 */
/* optimal: London, Paris, Prague, Berlin, Zurich, Venice */
/* maximum utility: 37.78333 */
/* optimal tour: Zurich -> Venice -> Paris -> London -> Berlin -> Prague -> Zurich */

/* time = 9 */
/* optimal: London, Paris, Prague, Berlin, Zurich, Venice */
/* maximum utility: 37.78333 */
/* optimal tour: Zurich -> Prague -> Berlin -> Paris -> London -> Venice -> Zurich */

/* time = 10 */
/* optimal: London, Paris, Prague, Berlin, Zurich, Venice */
/* maximum utility: 37.78333 */
/* optimal tour: Zurich -> Prague -> Berlin -> Paris -> London -> Venice -> Zurich */

/* in the output, another possible tour for time = 10 is Zurich -> London -> Paris -> Berlin -> Prague -> Venice -> Zurich */
