# Port melt to python datatable - GSOC 2021

Following are the qualification test for the "melt() in datatable" project under The R Project for Statistical computing. 

- Project Goals : Implement melt() functionality in the datatable python package
- Project Link : https://github.com/rstats-gsoc/gsoc2021/wiki/Port-melt-to-python-datatable

## Easy Test
Goal is to implement melting functionality and demonstrate that it works by adding the relevant unit tests. I'll be demonstrating how melt() function works in the datatable R package. 

- Let's create a dummy df using the data.table package.
```
> df_wide <- data.table(
+   city = c("Mum", "Del", "Kol", "Chn"),
+   mayor = c("A", "B", "C", "D"),
+   kids = c(43,54,65,76),
+   teens = c(20,30,40,50),
+   adults = c(23,44,55,66)
+ )
> df_wide
   city mayor kids teens adults
1:  Mum     A   43    20     23
2:  Del     B   54    30     44
3:  Kol     C   65    40     55
4:  Chn     D   76    50     66
```
- Set "city" and "mayor" as  identifier columns, we'll melt the rest of the columns into two columns - one for value and the other for variable names 
```
>   df_melted <- melt(data = df_wide, 
+                     id.vars = c("city", "mayor"),
+                     variable.name = "age_group",
+                     value.name = "population")
> df_melted
    city mayor age_group population
 1:  Mum     A      kids         43
 2:  Del     B      kids         54
 3:  Kol     C      kids         65
 4:  Chn     D      kids         76
 5:  Mum     A     teens         20
 6:  Del     B     teens         30
 7:  Kol     C     teens         40
 8:  Chn     D     teens         50
 9:  Mum     A    adults         23
10:  Del     B    adults         44
11:  Kol     C    adults         55
12:  Chn     D    adults         66
```
The sub-categories of kids, teens and adults representing population of the cities has been melted into two columns - age_group representing the variable names and population representing the values.

- melt() also takes in an additional paramter called "measure.vars" to specify the columns to be melted
```
>   df_melted <- melt(data = df_wide, 
+                     id.vars = c("city"),
+                     measure.vars = c("kids", "teens"),
+                     variable.name = "age_group",
+                     value.name = "population")
> df_melted
   city age_group population
1:  Mum      kids         43
2:  Del      kids         54
3:  Kol      kids         65
4:  Chn      kids         76
5:  Mum     teens         20
6:  Del     teens         30
7:  Kol     teens         40
8:  Chn     teens         50
```

- If we do not specify any "measure.vars", all the columns that aren't identifier columns("id.vars") get stacked into each other.
```
> df_melted <- melt(data = df_wide, 
+                   id.vars = c("city"),
+                   variable.name = "age_group",
+                   value.name = "population")
Warning message:
In melt.data.table(data = df_wide, id.vars = c("city"), variable.name = "age_group",  :
  'measure.vars' [mayor, kids, teens, adults, ...] are not all of the same type. By order of hierarchy, the molten data value column will be of type 'character'. All measure variables not of type 'character' will be coerced too. Check DETAILS in ?melt.data.table for more on coercion.
> df_melted
    city age_group population
 1:  Mum     mayor          A
 2:  Del     mayor          B
 3:  Kol     mayor          C
 4:  Chn     mayor          D
 5:  Mum      kids         43
 6:  Del      kids         54
 7:  Kol      kids         65
 8:  Chn      kids         76
 9:  Mum     teens         20
10:  Del     teens         30
11:  Kol     teens         40
12:  Chn     teens         50
13:  Mum    adults         23
14:  Del    adults         44
15:  Kol    adults         55
16:  Chn    adults         66
```
We also notice that there's a warning message notifying that all the non character values have been coerced to character due to mismatch between the types of the values of the different columns.


These are the types of edge cases that need to be considered when porting R data.table's melt() to the Python package. 
I've converted these codes into unit tests included in the "tests" folder which can be run with the following command. Since the project is not an R package, I'll be using test_dir() from testthat to run the unit tests.
```
testthat::test_dir("./tests")
```
Test result -
![test_result](https://github.com/theadityasam/datatabletest/blob/main/images/test_results.png)

-**We can also implement melt using the "gather()" function in "tidyr" package**
```
> df_wide <- data.table(
+   city = c("Mum", "Del", "Kol", "Chn"),
+   mayor = c("A", "B", "C", "D"),
+   kids = c(43,54,65,76),
+   teens = c(20,30,40,50),
+   adults = c(23,44,55,66)
+ )
> df_melted <- df_wide%>%gather(age_group, population, -c(city, mayor))
> df_melted
   city mayor age_group population
1   Mum     A      kids         43
2   Del     B      kids         54
3   Kol     C      kids         65
4   Chn     D      kids         76
5   Mum     A     teens         20
6   Del     B     teens         30
7   Kol     C     teens         40
8   Chn     D     teens         50
9   Mum     A    adults         23
10  Del     B    adults         44
11  Kol     C    adults         55
12  Chn     D    adults         66
```

## Medium Test

melt() is datatable's wide to long reshaping tool. You can melt the columns into one the following way
```
melt(columns)
```
- Let's assume we've a datatable as shown below
```
DT = dt.Frame(A=['a','b','c'], B=[1,3,5], C=[2,4,6])
```
- We can convert this DT to long format the following way 
We could accomplish this using melt() by specifying id.vars and measure.vars arguments as follows:
```
> DT[:, [f.A, melt(f["B":"C"])]]
   | A   variable  value
-- + --  --------  -----
 0 | a   B             1
 1 | a   C             2
 2 | b   B             3
 3 | b   C             4
 4 | c   B             5
 5 | c   C             6
```
