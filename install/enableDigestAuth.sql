--
def U=&1
--
def P=&2
--
alter user &U identified by &P account unlock HTTP DIGEST ENABLE 
/
--