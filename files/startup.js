var conn;
try
{
    conn = new Mongo("127.0.0.1:27017");
}
catch(Error)
{
    //print(Error);
}
while(conn===undefined)
{
    try
    {
        conn = new Mongo("127.0.0.1:27017");
    }
    catch(Error)
    {
        //print(Error);
    }
    sleep(100);
}
DB = conn.getDB("test");
Result = DB.runCommand('buildInfo');
print(Result.version);