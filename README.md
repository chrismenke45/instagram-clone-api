# Instagram Clone API
This is the backend of the [instagram clone](https://chrismenke45.github.io/instagram-clone-client) I built with Ruby on Rails.
<br />
![desktop](https://user-images.githubusercontent.com/86500980/226732356-9a93c9bb-ad56-4168-964f-ba982706ce05.png)
## How it's made:
Tech used: Ruby on Rails, PostgreSQL
<br />
This backend works with the [clone's frontend.](https://github.com/chrismenke45/instagram-clone-client) It utilizes JWTs for user authentication.
## Optimizations
I would like to impliment another layer of image validation on the backend before sending them to the image store. I am not currently doing this because I have a limited amount of outbound data transfer for free and don't want to add image files to that. It's easier to just upload the image to firestore from the front end and then just save the url to the backend.
## Lessons learned
This api forced me to learn about advanced SQL topics. In my queries I have used aggregate functions, CASE expressions, UNION operators, and numerous joins to ensure I return the necessary data (and nothing else) to the front end.
