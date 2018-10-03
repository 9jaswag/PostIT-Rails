[![Build Status](https://travis-ci.org/9jaswag/PostIT-Rails.svg?branch=develop)](https://travis-ci.org/9jaswag/PostIT-Rails)

## PostIt
PostIt is a simple application that allows friends and colleagues create groups for notifications. Users can post broadcast messages to groups and other group members will get notification based on the message priority.

## Features
PostIt allows users to do the following.
* Register and log into their accounts.
* Create broadcast groups and add other users to the groups
* Post messages to a group with message priority
  * Group members get in-app notifications for ```normal``` messages.
  * Group members get in-app and email notifications for ```urgent``` messages.
  * Group members get in-app, email and SMS notifications for ```critical``` messages.
* Retrieve all the messages posted to groups they belong to based on their ```read``` status when they are signed in.
---

## Technology Stack
* Ruby on Rails

## Get Started
1. Clone the repository, navigate to the folder and run ```bundle install``` to install dependencies.
2. Ensure you have PostgreSQL installed. Click [here] to find out how.(http://www.techrepublic.com/blog/diy-it-guy/diy-a-postgresql-database-server-setup-anyone-can-handle/)
3. Run `rails s` to serve the app.

## Contributing
Fork it!
* Create your feature branch: ```git checkout -b awesome-feature```
* Commit your changes: ```git commit -m 'Add my awesome feature'```
* Push your branch online: ```git push origin awesome-feature```
* Submit a pull request to ```development``` branch :smile:

## Author
* Chuks Opia

## License
* This project is licensed under the terms of the MIT [License.](https://github.com/9jaswag/PostIt/blob/chore/implement-feedback/LICENSE)
