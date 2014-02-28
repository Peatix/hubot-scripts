# Description:
#   Give, Take and List Zabuton (座布団), a la 笑点
#   https://en.wikipedia.org/wiki/Sh%C5%8Dten
#
#  More fun if you use "--alias yamadakun" to run hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Todo:
#   Special prize for 10 zabuton
#   Make text more accurate with respect to the show
#   Handle full-width numbers (全角数字)
#   
# Special Thanks:
#   brettlangdon, who build points.coffee, on which this module is (99%) based
#  
# Commands:
#   hubot give <number> zabuton to <username> - award <number> zabuton to <username>
#   hubot give <username> <number> zabuton - award <number> zabuton to <username>
#   hubot take <number> zabuton from <username> - take away <number> zabuton from <username>
#   hubot how many zabuton does <username> have? - list how many zabuton <username> has
#   hubot take all zabuton from <username> - removes all zabuton from <username>
#
#   # 座布団 =~ (座布団|ざぶとん|ザブトン)
#   hubot <username>に座布団<number>枚 - award <number> zabuton to <username>
#   hubot <username>から座布団<number>枚 - take away <number> zabuton from <username>
#   hubot <username>は座布団何枚 - list how many zabuton <username> has
#   hubot <username>から座布団全部 - removes all zabuton from <username>
#
# Author:
#   nheinric
#

points = {}

award_points = (msg, username, pts) ->
    points[username] ?= 0
    points[username] += parseInt(pts)
    msg.send pts + ' Awarded To ' + username

award_points_ja = (msg, username, pts) ->
    points[username] ?= 0
    points[username] += parseInt(pts)
    msg.send username + 'に座布団' + pts + 'やった'

save = (robot) ->
    robot.brain.data.zabuton = points

module.exports = (robot) ->
    robot.brain.on 'loaded', ->
        points = robot.brain.data.zabuton or {}

    robot.respond /give (\d+) zabuton to (.*?)\s?$/i, (msg) ->
        award_points(msg, msg.match[2], msg.match[1])
        save(robot)

    robot.respond /give (.*?) (\d+) zabuton/i, (msg) ->
        award_points(msg, msg.match[1], msg.match[2])
        save(robot)
    
    robot.respond /take all zabuton from (.*?)\s?$/i, (msg) ->
        username = msg.match[1]
        points[username] = 0
        msg.send username + ' WHAT DID YOU DO?!'
        save(robot)

    robot.respond /take (\d+) zabuton from (.*?)\s?$/i, (msg) ->
         pts = msg.match[1]
         username = msg.match[2]
         points[username] ?= 0
         
         if points[username] is 0
             msg.send username + ' Does Not Have Any Zabuton To Take Away'
         else
             points[username] -= parseInt(pts)
             msg.send pts + ' Zabuton Taken Away From ' + username

         save(robot)

    robot.respond /how many zabuton does (.*?) have\??/i, (msg) ->
        username = msg.match[1]
        points[username] ?= 0

        msg.send username + ' Has ' + points[username] + ' Zabuton'

    robot.respond /(.+)に(座布団|ざぶとん|ザブトン)(\d+)枚/, (msg) ->
        award_points_ja(msg, msg.match[1], msg.match[3])
        save(robot)

    robot.respond /(.+)から(座布団|ざぶとん|ザブトン)全部/, (msg) ->
        username = msg.match[1]
        points[username] = 0
        msg.send username + 'よ、何しとってん?!'
        save(robot)

    robot.respond /(.+)から(座布団|ざぶとん|ザブトン)(\d+)枚/, (msg) ->
         pts = msg.match[3]
         username = msg.match[1]
         points[username] ?= 0
         
         if points[username] is 0
             msg.send username + 'じゃ座布団1枚も無い!'
         else
             points[username] -= parseInt(pts)
             msg.send username + 'から座布団' + pts + '枚取っといた'

         save(robot)

    robot.respond /(.+)は(座布団|ざぶとん|ザブトン)何枚/, (msg) ->
        username = msg.match[1]
        points[username] ?= 0

        msg.send username + 'じゃ座布団' + points[username] + '枚持っとる'
