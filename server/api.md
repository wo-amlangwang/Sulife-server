#Api table
[Home page](https://damp-retreat-5682.herokuapp.com/)

/register:

method: post
request body: email(required),password(required)
detail: this url is used to register for the user

/local/login:

method: post
request body: email(required),password(required)
detail: this url is used to get Access_Token from the server

/event:

method: get
request body: NULL
detail: this url is used get all events of the user with token

method: post
request body: title(required),detail(required),starttime,endtime,share
detail: this url is used to post new event with token

/event/:eventid:

method: get
request body: NULL
detail: this url is used get event with token and eventid

method: post
request body: title,detail,starttime,endtime,share
detail: this url is used to edit event with token and eventid

method: delete
request body: NULL
detail: this url is used to delete event with token and eventid
