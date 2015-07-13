/*

> use chat
switched to db chat
> db.chat.find()_
2015-07-13T22:57:11.109+0300 E QUERY    SyntaxError: Unexpected identifier
> db.chat.find()
> var x = {}
> x.username = "petar"
petar
> x.fullname = "Petar Georgiev"
Petar Georgiev
> x.website = "http:\\georgiev.wordpress.com"
http:\georgiev.wordpress.com
> var y = "nick"
> var y = {}
> y
{ }
> y.username = "nick"
nick
> y.fullname = "Nick Genov"
Nick Genov
> y.website = "http:\\genov.wordpress.com"
http:\genov.wordpress.com
> db.chat.users.insert(x)
WriteResult({ "nInserted" : 1 })
> db.chat.users.insert(y)
WriteResult({ "nInserted" : 1 })
> db.chat.users.find().pretty()
{
        "_id" : ObjectId("55a418badce282a93efbf672"),
        "username" : "petar",
        "fullname" : "Petar Georgiev",
        "website" : "http:\\georgiev.wordpress.com"
}
{
        "_id" : ObjectId("55a418c4dce282a93efbf673"),
        "username" : "nick",
        "fullname" : "Nick Genov",
        "website" : "http:\\genov.wordpress.com"
}
> var a = {}
> a.text = "exam results are out"
exam results are out
> a.date = "12.07.2015"
12.07.2015
> a.isread = "false"
false
> a.user = x
{
        "username" : "petar",
        "fullname" : "Petar Georgiev",
        "website" : "http:\\georgiev.wordpress.com"
}
> var b = {}
> b.text = "your application was approved"
your application was approved
> b.date = "11.07.2015"
11.07.2015
> b.isread = "true"
true
> b.user = y
{
        "username" : "nick",
        "fullname" : "Nick Genov",
        "website" : "http:\\genov.wordpress.com"
}
> db.chat.messages.insert(a)
WriteResult({ "nInserted" : 1 })
> db.chat.messages.insert(b)
WriteResult({ "nInserted" : 1 })
> db.chat.messages.find().pretty()
{
        "_id" : ObjectId("55a41974dce282a93efbf674"),
        "text" : "exam results are out",
        "date" : "12.07.2015",
        "isread" : "false",
        "user" : {
                "username" : "petar",
                "fullname" : "Petar Georgiev",
                "website" : "http:\\georgiev.wordpress.com"
        }
}
{
        "_id" : ObjectId("55a4197edce282a93efbf675"),
        "text" : "your application was approved",
        "date" : "11.07.2015",
        "isread" : "true",
        "user" : {
                "username" : "nick",
                "fullname" : "Nick Genov",
                "website" : "http:\\genov.wordpress.com"
        }
}
>




