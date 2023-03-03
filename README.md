# Honeybadger Demo Project

This is a demo project created for applying for a Software Engineer position at Honeybadger

To run the tests: `bundle exec rspec`

To run the project you just have to start the server: `rails s`
The you can make a post request with Postman or any similar tool with the following details:
- url: localhost:3000/api/v1/notifications/check-spam
- body with spam:
  ```json
  {
      "notification": {
          "RecordType": "Bounce",
          "Type": "SpamNotification",
          "TypeCode": 512,
          "Name": "Spam notification",
          "Tag": "",
          "MessageStream": "outbound",
          "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
          "Email": "zaphod@example.com",
          "From": "notifications@honeybadger.io",
          "BouncedAt": "2023-02-27T21:41:30Z"
      }
  }
  ```
- body without spam: 
  ```json
  {
      "notification": {
          "RecordType": "Bounce",
          "MessageStream": "outbound",
          "Type": "HardBounce",
          "TypeCode": 1,
          "Name": "Hard bounce",
          "Tag": "Test",
          "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
          "Email": "arthur@example.com",
          "From": "notifications@honeybadger.io",
          "BouncedAt": "2019-11-05T16:33:54.9070259Z"
      }
  }
  ```

I also created a Slack workspace and channel for the purpose of this project. You can sign up for it here to see the actual spam Slack notifications: https://honeybadgertestgroup.slack.com/archives/C04SXV3GE56

