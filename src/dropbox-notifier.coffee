Dropbox = require "dropbox"

config =
  rooms: (process.env.HUBOT_DROPBOX_NOTIFIER_ROOMS or "").split(",")
  key: process.env.HUBOT_DROPBOX_NOTIFIER_KEY
  secret: process.env.HUBOT_DROPBOX_NOTIFIER_SECRET
  token: process.env.HUBOT_DROPBOX_NOTIFIER_TOKEN
  tokenSecret: process.env.HUBOT_DROPBOX_TOKEN_SECRET
  refreshInterval: process.env.HUBOT_DROPBOX_NOTIFIER_REFRESH_INTERVAL

module.exports = (robot) ->
  unless config.rooms[0].length > 0
    robot.logger.error "Please set the HUBOT_DROPBOX_NOTIFIER_ROOMS environment variable."
    return

  unless config.key
    robot.logger.error "Please set the HUBOT_DROPBOX_NOTIFIER_KEY environment variable."
    return

  unless config.secret
    robot.logger.error "Please set the HUBOT_DROPBOX_NOTIFIER_SECRET environment variable."
    return

  unless config.token
    robot.logger.error "Please set the HUBOT_DROPBOX_NOTIFIER_TOKEN environment variable."
    return

  unless config.tokenSecret
    robot.logger.error "Please set the HUBOT_DROPBOX_NOTIFIER_TOKEN_SECRET environment variable."
    return

  unless config.refreshInterval
    config.refreshInterval = 60

  dropbox = new Dropbox.Client config
  user = null

  fetchUpdates = (cursorTag) ->
    dropbox.delta cursorTag, (err, res) ->
      message = "New changes in #{user.name}'s Dropbox:"

      if err
        robot.logger.error "hubot-dropbox-notifier error", err
        return

      if cursorTag and res.changes and res.changes.length > 0
        robot.logger.info cursorTag
        for change in res.changes
          message += "\n#{change.path}"
          message += if change.wasRemoved then " was removed" else " was updated"
        
        for room in config.rooms
          robot.messageRoom room, message

      setTimeout (->
        fetchUpdates res.cursorTag
      ), config.refreshInterval * 1000

  dropbox.getUserInfo (err, res) ->
    if err
      robot.logger.error "hubot-dropbox-notifier error", err
      return

    user = res

    robot.logger.info "hubot-dropbox-notifier connected to #{user.name}'s Dropbox"

    fetchUpdates null