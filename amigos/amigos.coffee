require "timeout"

NAMES = ["Drugged Assassin","Enraged Elephant"]
COLOURS = ["red","green","blue"]

Object.new = -> new constructor.apply({},arguments)

class Game
  SPAWN = 10
  attr_accessor :enemies, :amigos, :balance
  initialize: ->
    @enemies ||= []
    @amigos = [Amigo.new(1,3,0,0), Amigo.new(2,0,3,0), Amigo.new(3,0,0,3)]
    @balance = 0
  move: ->
    @enemies.each {|e| e.distance -= e.speed }
    attackers, queued = @enemies.partition {|e| e.distance <= 0 }
    @enemies = queued
    if @enemies.length < SPAWN
      @enemies.push Enemy.new(NAMES.sample,COLOURS.sample,(1..10).to_a.sample,10,(1..4).to_a.sample)
    attack = {}
    attackers.each do |attacker|
      attack[attacker.colour] = (attack[attacker.colour] || 0) + attacker.strength
    defence = {}
    @amigos.each do |defender|
      ["red","green","blue"].each do |colour|
        defence[colour] = defender.send colour
    result = {}
    attack.each do |colour, strength|
      result[colour] = defence[colour] - strength
    result.each do |colour, value|
      if value < 0
        puts "Lost #{colour} to the tune of #{value}"
        self.balance += value
      else
        puts "Fought off #{colour} for #{value}" 
    if balance < -10
      abort "All is lost!"
    elsif balance > 10
      abort "Victory!"
  cmd: (amigo, r, g, b) -> 
    amg = @amigos[amigo]
    amg.red = r
    amg.green = g
    amg.blue = b

class Enemy
  to_s: -> "#{name} #{strength}:#{colour} #{distance}m"
class Amigo
  to_s: -> "#{id} r#{red} g#{green} b#{blue}"

require "ruport"
require "pp"
game = Game.new
time = 5
loop do
  end_at = Time.now + time
  puts "You have #{time} seconds to make a move!"
  puts "Your amigos:"
  puts Table(game.amigos.each(&:to_a)).to_s
  unless game.enemies.empty?
    puts "Foes:"
    puts Table(game.enemies.each(&:to_a)).to_s
  while Time.now <= end_at
    begin
      Timeout::timeout(end_at - Time.now) do
        print "$ "
        cmd = gets.strip.split(" ").map(&:to_i)
        game.cmd *cmd if cmd.length == 4
        puts Table(game.amigos.each(&:to_a)).to_s
    rescue Timeout::Error => error
      puts "Oh no, too late!"
  game.move

