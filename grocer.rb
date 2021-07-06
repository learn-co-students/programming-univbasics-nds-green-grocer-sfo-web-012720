def find_item_by_name_in_collection(name, collection)
  count = 0
  while count < collection.length
    if collection[count][:item] == name
      return collection[count]
    end
    count += 1
  end
end

def consolidate_cart(cart)
  cart_arr = []
  count = 0
  while count < cart.length
    new_cart_item = find_item_by_name_in_collection(cart[count][:item], cart_arr)
    if new_cart_item 
      new_cart_item[:count] += 1
    else
      new_cart_item = {
        :item => cart[count][:item],
        :price => cart[count][:price],
        :clearance => cart[count][:clearance],
        :count => 1
      }
      cart_arr << new_cart_item
    end
    count += 1
  end
  cart_arr
end

def apply_coupons(cart, coupons)
  count = 0
  while count < coupons.length
    item_in_cart = find_item_by_name_in_collection(coupons[count][:item], cart)
    couponed_item = "#{coupons[count][:item]} W/COUPON"
    cart_item_w_coupon = find_item_by_name_in_collection(couponed_item, cart)
    if item_in_cart && item_in_cart[:count] >= coupons[count][:num]
      if cart_item_w_coupon
        cart_item_w_coupon[:count] += coupons[count][:num]
        item_in_cart[:count] -= coupons[count][:num]
      else
        cart_item_w_coupon = {
          :item => couponed_item,
          :price => coupons[count][:cost] / coupons[count][:num],
          :count => coupons[count][:num],
          :clearance => item_in_cart[:clearance]
        }
        cart << cart_item_w_coupon
        item_in_cart[:count] -= coupons[count][:num]
      end
    end
    count += 1
  end
  cart
end

def apply_clearance(cart)
  count = 0
  while count < cart.length
    if cart[count][:clearance]
      cart[count][:price] = (cart[count][:price] - (cart[count][:price] * 0.2)).round(2) 
    end
  count += 1
  end
  cart
end

def checkout(cart, coupons)
  conlidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(conlidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  
  total = 0
  count = 0
  while count < final_cart.length
    total += final_cart[count][:price] * final_cart[count][:count]
    count += 1
  end
  if total > 100
    total -= (total * 0.1)
  end
  total
end
