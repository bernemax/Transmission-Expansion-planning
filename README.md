# Static-Transmission-Expansion-planning 
## Topic: Garvers 6-node model
### Two objectives are inplemented into the model:

**1) Total cost minimization**
- amount of investment into lines: 130 

**2) Investment-costs minimization**
- amount of investment into lines: 70


## Content
* There is an existing "Model-base" which is about the so-called "Transmission extension problem".
* A little networt structure was taken from the Garvers 6 node structure (see picture below).
* Based on this, several models, aiming for different objectives, will be added.

## Network
![](https://github.com/bernemax/bernemax-s-doings/blob/Garvers/pictures/Garvers%206%20node.jpg)

## Bus data
![](https://github.com/bernemax/bernemax-s-doings/blob/Garvers/pictures/bus%20data.jpg)

## Line data
![](https://github.com/bernemax/bernemax-s-doings/blob/Garvers/pictures/Line%20Data.jpg)

## Generator Data
![](https://github.com/bernemax/bernemax-s-doings/blob/Garvers/pictures/Garvers%20Gen%20Data.jpg)

# Dynamic-Transmission-Expansion-planning 
## Topic: IEEE 24 node system
### Two objectives are inplemented into the model:

**1) Total cost minimization**
- amount of investment into lines: xxx

**2) Investment-costs minimization**
- amount of investment into lines: xxx


## Content
* There is an existing "Model-base" which is about the so-called "Transmission extension problem".
* A little networt structure was taken from the IEEE 24 (test case system) node structure (see picture below).
* In this repository the option of node expansion with corresponding generators is included.
* The model solves a muliperiodic problem represented by 24 representative hours in a year (three years in total). The different total load in each hour is distributed due to the specific share of each node.
* The load changes with the corresponding year. 
* The model can decide in with hour t and in which year the best transmission and node expension plan/choise is done.
* Important remark: A building decision in period t in a sepcific year remains in the following periods and years.

## Network
![](https://github.com/bernemax/bernemax-s-doings/blob/IEEE-24-node-system/pictures/24%20IEEE%20node%20system.jpg)

## Bus data
In the .xlsx file

## Line data
In the .xlsx file
