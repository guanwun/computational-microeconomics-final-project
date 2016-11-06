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
end;

/* optimal for 1: Paris */
/* maximum utility: 16 */

/* optimal for 2: Paris, Venice */
/* maximum utility: 23.5 */

/* optimal for 3: London, Paris, Venice */
/* maximum utility: 29 */

/* optimal for 4: London, Paris, Berlin, Venice */
/* maximum utility: 32.91667 */

