Helper = require('hubot-test-helper')
chai = require 'chai'
listFixture = require './fixtures/list'

expect = chai.expect

helper = new Helper('../src/fass-reservation.coffee')

describe 'hubot-fass-reservation', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to fass <salon id> rsv', ->
    @room.user.say('sugarshin', 'hubot fass futakotamagawarisesc rsv').then =>
      expect(@room.messages).to.eql [
        ['sugarshin', 'hubot fass futakotamagawarisesc rsv']
        ['hubot', 'No implemention yet.']
      ]

  it 'responds to fass ls', ->
    @room.user.say('sugarshin', 'hubot fass ls').then =>
      expect(@room.messages).to.eql [
        ['sugarshin', 'hubot fass ls']
        ['hubot', listFixture]
      ]

  it 'responds to fass <dummy> w', ->
    @room.user.say('sugarshin', 'hubot fass foo w').then =>
      expect(@room.messages).to.eql [
        ['sugarshin', 'hubot fass foo w']
        ['hubot', "I don't know such a salon: `foo`. You can check with `hubot fass list`"]
      ]

  it 'responds to fass <salon id> w', ->
    @room.user.say('sugarshin', 'hubot fass futakotamagawarisesc w').then =>
      expect(@room.messages).to.eql [
        ['sugarshin', 'hubot fass futakotamagawarisesc w']
      ]

  it 'responds to fass <salon id> w 100', ->
    @room.user.say('sugarshin', 'hubot fass futakotamagawarisesc w 100').then =>
      expect(@room.messages).to.eql [
        ['sugarshin', 'hubot fass futakotamagawarisesc w 100']
      ]
