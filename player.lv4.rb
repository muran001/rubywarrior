
class Player

  attr_accessor :before_health, :directions
  attr_accessor :near_enemy_count, :near_captive_count
  attr_accessor :enemy_max_power, :enough_life
 
  def initialize()
    @directions = [ :forward, :backward, :left, :right ]
    @enemy_max_power = 3
    @enough_life = 17
  end

  def play_turn(warrior)
   
    encount_enemy = encount_target(warrior,"enemy")
    encount_captive = encount_target(warrior,"captive")

    if encount_enemy > 0
      target = get_target_direction(warrior,"enemy")
      if encount_enemy == 1
        if low_life?(warrior)
          warrior.bind! target
        else
          warrior.attack! target
        end
      else
        warrior.bind! target
      end
   
    elsif not_enough_life?(warrior)
      warrior.rest!

    elsif encount_captive > 0
      target = get_target_direction(warrior,"captive")
      warrior.rescue! target

    elsif enemy_direction = get_far_target_direction(warrior,"enemy")
      warrior.walk! enemy_direction

    elsif captive_direction = get_far_target_direction(warrior,"captive")
      warrior.walk! captive_direction

    else
      warrior.walk! warrior.direction_of_stairs
    end
   
   
  end
 
  def encount_target(warrior, target)
    encount = 0
    @directions.each do |direction|
      feeling = warrior.feel direction
      encount += 1 if feeling.send(target+"?")
    end    
    return encount
  end
 
  def get_target_direction(warrior, target)
    @directions.each do |direction|
      feeling = warrior.feel direction
      return direction if feeling.send(target+"?")
    end
    return nil
  end

  def get_far_target_direction(warrior, target)
    warrior.listen.each do |space|
      if space.send(target+"?")
        return warrior.direction_of space
      end
    end
    return nil
  end

 
  def not_enough_life?(warrior)
    return @enough_life.to_i > warrior.health
  end
 
  def low_life?(warrior)
    return @enemy_max_power.to_i > warrior.health
  end
 

end
