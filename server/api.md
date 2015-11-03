#Api table
[Home page](https://damp-retreat-5682.herokuapp.com/)

/register:

method: post<br />
request body: email(required),password(required)<br />
detail: this url is used to register for the user

/local/login:

method: post<br />
request body: email(required),password(required)<br />
detail: this url is used to get Access_Token from the server

/event:

method: get<br />
request body: NULL<br />
detail: this url is used get all events of the user with token

method: post<br />
request body: title(required),detail(required),starttime,endtime,share<br />
detail: this url is used to post new event with token

/event/:eventid:

method: get<br />
request body: NULL<br />
detail: this url is used get event with token and eventid

method: post<br />
request body: title,detail,starttime,endtime,share<br />
detail: this url is used to edit event with token and eventid

method: delete<br />
request body: NULL<br />
detail: this url is used to delete event with token and eventid

/profile

method: get<br />
request body: NULL<br />
detail: get profile with token

method: post<br />
request body: firstname, lastname<br />
detail: edit profile with token











don't use this part!!!



/friendRequest

method: post<br />
request body: taker(required)<br />
detail: send friend request with token

/getMail

method: get<br />
request body: null<br />
detail: get email list in mailbox with token

/acceptFriendRequest

method: post<br />
request body: mailid(required)<br />
detail: accept friend request with token

/rejectFriendRequest

method: post<br />
request body: mailid(required)<br />
detail: reject friend request with token

/getFriends

method: get<br />
request body: null<br />
detail: get friend list (relationship list) with token
