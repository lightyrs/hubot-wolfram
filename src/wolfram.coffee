# Description:
#   Allows hubot to answer almost any question by asking Wolfram Alpha
#
# Dependencies:
#   "wolfram": "0.2.2"
#
# Configuration:
#   HUBOT_WOLFRAM_APPID - your AppID
#
# Commands:
#   hubot question <question> - Searches Wolfram Alpha for the answer to the question
#
# Author:
#   dhorrigan

Wolfram = require('wolfram').createClient(process.env.HUBOT_WOLFRAM_APPID)

module.exports = (robot) ->
  robot.respond /(question|wfa|wolfram) (.*)$/i, (msg) ->
    Wolfram.query msg.match[2], (e, result) ->
      if result and result.length > 0
        messages = getMessages(result)
        for message in messages
          msg.send message
      else
        msg.send 'Hmm...not sure'

getMessages = (result) ->
  console.log result
  answers = []
  for resultItem in result
    answer = []
    answer.push('*' + resultItem.title.trim() + '*') if resultItem.title
    for subpod in resultItem.subpods
      answer.push(subpod.title.trim()) if subpod.title
      answer.push(subpod.value.trim()) if subpod.value
      answer.push(subpod.image.trim()) if subpod.image
    answers.push(answer.join('\n'));
  answers