nuke;
test = [1 2 3 2 3 4; 4 5 6 4 3 2; 7 8 10 4 3 2 ; 1 2 3 4 1 3; 3 1 4 3 1 2; 1 2 4 5 6 7];
test2=flip(test,2);
test3=diag(test2,1);
test5=diag(test3,1);
test6=flip(test5,2);


test7=max(test6);
