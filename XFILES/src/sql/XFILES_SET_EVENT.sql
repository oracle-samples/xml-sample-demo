--
def EVENT_NUMBER = &1
--
def EVENT_LEVEL = &2
--
ALTER SESSION SET EVENTS='&EVENT_NUMBER trace name context forever, level &EVENT_LEVEL'
/
--