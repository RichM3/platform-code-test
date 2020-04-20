require 'award'

def update_quality(awards)

  awards.each do |award|

    case award.name
    when 'Blue Star'
      blue_star(award)
    when 'Blue First'
      blue_first(award)
    when 'Blue Compare'
      blue_compare(award)
    when 'Blue Distinction Plus'
      blue_dist_plus(award)
    else
      other_award(award)
    end

  end

  #Sorting the output to ensure the "Blue Star" awards appear on top of the array - then sort by the expiration date
  #"Blue Star" awarded providers near the top of the results - impact should be smaller the longer it has been from the grant date
  bl_stars = awards.select { |award| award.name == "Blue Star" }
  sorted_bl_stars = bl_stars.sort { |a,b| a.expires_in <=> b.expires_in }
  not_stars = awards.select { |award| award.name != "Blue Star" }

  return sorted_bl_stars + not_stars

end



###########################################################################################
#Blue Star specific logic
###########################################################################################
def blue_star(award)

  # test past expiration date -- Note "Blue Star" awards should lose quality value twice as fast as normal awards.
  if award.expires_in <= 0
    award.quality = award.quality - 4
  else
    award.quality = award.quality - 2
  end

  #ensure quality is not less than zero
  if award.quality < 0
    award.quality = 0
  end

  award.expires_in -= 1
  return award
end



###########################################################################################
#Blue First specific logic
###########################################################################################
def blue_first(award)

  #"Blue First" awards actually increase in quality the older they get - The quality of an award is never more than 50 (except Blue Distinction Plus = 80)
  if award.quality < 50
    award.quality += 1
  end

  #Once the expiration date has passed, quality score degrades twice as fast
  if award.expires_in <= 0
    if award.quality < 50
      award.quality += 1
    end
  end

  award.expires_in -= 1
  return award
end



###########################################################################################
#Blue Compare specific logic
###########################################################################################
def blue_compare(award)

  #The quality of an award is never more than 50 (except Blue Distinction Plus = 80)
  if award.quality < 50
    award.quality += 1

    #Blue Compare - Quality increases by 2 when there are 10 days or less left
    if award.expires_in < 11
      award.quality += 1
    end

    #Blue Compare - Quality increases by 3 where there are 5 days or less left
    if award.expires_in < 6
      award.quality += 1
    end

  end

  #Blue Compare - Quality value drops to 0 after the expiration date
  if award.expires_in <= 0
    award.quality = 0
  end

  award.expires_in -= 1
  return award
end



###########################################################################################
#Blue Distinction Plus specific logic
###########################################################################################
def blue_dist_plus(award)
  #No specific logic at this time...
    # could add code to hardcode quality for BDP awards 
    # award.quality = 80
  return award
end



###########################################################################################
#Other award specific logic
###########################################################################################
def other_award(award)

  #The quality of an award is never negative
  if award.quality > 0
      award.quality -= 1
  end

  #Once the expiration date has passed, quality score degrades twice as fast
  if award.expires_in <= 0
    if award.quality > 0
      award.quality -= 1
    end
  end

  award.expires_in -= 1
  return award
end










################################################################################
# Legacy code for reference
################################################################################
# def update_quality(awards)
#   awards.each do |award|
#     if award.name != 'Blue First' && award.name != 'Blue Compare'
#       if award.quality > 0
#         if award.name != 'Blue Distinction Plus'
#           award.quality -= 1
#         end
#       end
#     else
#       if award.quality < 50
#         award.quality += 1
#         if award.name == 'Blue Compare'
#           if award.expires_in < 11
#             if award.quality < 50
#               award.quality += 1
#             end
#           end
#           if award.expires_in < 6
#             if award.quality < 50
#               award.quality += 1
#             end
#           end
#         end
#       end
#     end
#     if award.name != 'Blue Distinction Plus'
#       award.expires_in -= 1
#     end
#     if award.expires_in < 0
#       if award.name != 'Blue First'
#         if award.name != 'Blue Compare'
#           if award.quality > 0
#             if award.name != 'Blue Distinction Plus'
#               award.quality -= 1
#             end
#           end
#         else
#           award.quality = award.quality - award.quality
#         end
#       else
#         if award.quality < 50
#           award.quality += 1
#         end
#       end
#     end
#   end
# end
