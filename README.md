# hubot-dropbox-notifier

hubot-dropbox-notifier adds a Dropbox notifier plugin to hubot that reports
whenever a file gets removed or updated (new upload or new version).

## Installation

Edit the `package.json` for your hubot and add the hubot-dropbox-notifier
dependency.

```javascript
"dependencies": {
  "hubot-dropbox-notifier": ">= 0.0.1",
  ...
}
```

## Configuration

The following variables are required to let the script work:

* `HUBOT_DROPBOX_NOTIFIER_ROOMS`, comma separated list of rooms where incoming
updates should be posted
* `HUBOT_DROPBOX_NOTIFIER_KEY`, Dropbox app key
* `HUBOT_DROPBOX_NOTIFIER_SECRET`, Dropbox app secret
* `HUBOT_DROPBOX_NOTIFIER_TOKEN`, Dropbox authenticated user token
* `HUBOT_DROPBOX_TOKEN_SECRET`, Dropbox authenticated user token secret

The following variables are optional:

* `HUBOT_DROPBOX_NOTIFIER_REFRESH_INTERVAL`, refresh interval in seconds,
default to 60 seconds.