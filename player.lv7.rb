
class Player

  attr_accessor :before_health, :directions
  attr_accessor :near_enemy_count, :near_captive_count
  attr_accessor :enemy_max_power, :enough_life
  attr_accessor :predirection
 
  def initialize()
    @directions = [ :forward, :backward, :left, :right ]
    @bind_order = [ :backward, :left, :right, :forward ]
    @enemy_max_power = 3
    @enough_life = 17
  end

  def play_turn(warrior)
   
    encount_enemy = encount_target(warrior,"enemy")
    encount_captive = encount_target(warrior,"captive")

    if bomb_direction = get_far_target_direction(warrior, "ticking")
      if target = get_target_direction(warrior,"ticking")
        warrior.rescue! target
        return 0
      else
        if !warrior.feel(bomb_direction).empty?
          bomb_direction = get_empty_direction(warrior)
        end
        if bomb_direction
          @predirection = bomb_direction
          warrior.walk! bomb_direction
          return 0
        end
      end
    end
    if encount_enemy > 0
      if encount_enemy == 1 && !low_life?(warrior)
        target = get_target_direction(warrior,"enemy")
        warrior.attack! target
      else
        target = get_target_direction(warrior,"enemy",@bind_order)
        warrior.bind! target
      end
   
    elsif not_enough_life?(warrior)
      warrior.rest!

    elsif encount_captive > 0
      target = get_target_direction(warrior,"captive")
      warrior.rescue! target

    elsif enemy_direction = get_far_target_direction(warrior,"enemy")
      if warrior.feel(enemy_direction).stairs?
        enemy_direction = get_empty_direction(warrior)
      end
      @predirection = enemy_direction
      warrior.walk! enemy_direction
    elsif captive_direction = get_far_target_direction(warrior,"captive")
      if warrior.feel(captive_direction).stairs?
        captive_direction = get_empty_direction(warrior)
      end
      @predirection = captive_direction
      warrior.walk! captive_direction
    else
      warrior.walk! warrior.direction_of_stairs
    end
   
  end


  def get_empty_direction(warrior)
    @directions.each do |direction|
      next_space = warrior.feel direction
      if next_space.empty? && !next_space.stairs? && direction != get_opposite_direction(@predirection)
        return direction
      end
    end
    return nil
  end

  def get_opposite_direction(direction)
    opposite_direction = nil
    case direction
    when :forward
      opposite_direction = :backward
    when :backward
      opposite_direction = :forward
    when :left
      opposite_direction = :right
    when :right
      opposite_direction = :left
    end
    return opposite_direction
  end
 
  def encount_target(warrior, target)
    encount = 0
    @directions.each do |direction|
      feeling = warrior.feel direction
      encount += 1 if feeling.send(target+"?")
    end    
    return encount
  end
 
  def get_target_direction(warrior, target, directions = @directions)
    directions.each do |direction|
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
  
