require 'pp'

def find_item_by_name_in_collection(name, collection)
  
  object = nil
  
  for element in collection do
  
    if element[:item] == name
    
    object = element
    
    end
    
  end
  
  object
  
end



def consolidate_cart(cart)
  
  output = []
  countDict = {}
  
  for element in cart
    
    item = element[:item]
    
    if !countDict[item]
      
      countDict[item] = 1
      
    else
      
      countDict[item] += 1
      
    end
    
  end
  
  for element in countDict
  
    name  = element[0]
    count = element[1]
    
    item = find_item_by_name_in_collection(name, cart)
    item[:count] = count
    
    output.push(item)
    
  end
  
  output
  
end



def apply_coupons(cart, coupons)
  
  output = cart.clone
  
  for coupon in coupons
    
    for items in cart
    
      if items[:item] == coupon[:item]
        
        itemCount = items[:count]
        coupCount = coupon[:num]
        discCount = itemCount / coupCount
        remaCount = itemCount % coupCount
        
        discItem = items.clone
        discItem[:count] = itemCount - remaCount
        discItem[:item]  = discItem[:item] + " W/COUPON"
        discItem[:price] = coupon[:cost] / coupon[:num]
        items[:count]    = remaCount
        
        output.push(discItem)
        
      end
    
    end
  
  end
  
  output
  
end



def apply_clearance(cart)

  for item in cart

    if item[:clearance]
      
      price = item[:price]
      price = (price * 0.8).round(2) 
      item[:price] = price
      
    end  
  
  end
  
  cart

end



def checkout(cart, coupons)

  output = consolidate_cart(cart)
  output = apply_coupons(output, coupons)
  output = apply_clearance(output)
  total  = 0
  
  for item in output
    
    total += item[:price] * item[:count]
    
  end
  
  if total >= 100
    
    total = (total * 0.9).round(2)
    
  end
  
  total

end
