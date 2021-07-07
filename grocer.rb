def find_item_by_name_in_collection(name, collection)
    i = 0
    while i < collection.length do
        if collection[i][:item] == name
          return collection[i]
        end
        i += 1
    end
nil
end

def consolidate_cart(cart)

  new_cart = []
  i = 0

  while i < cart.length do

    if !find_item_by_name_in_collection(cart[i][:item], new_cart)

      new_cart << {
        :item => cart[i][:item],
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1
      }

    else

      new_cart_i = 0
      while new_cart_i < new_cart.length do

        if new_cart[new_cart_i][:item] == cart[i][:item]

          new_cart[new_cart_i][:count] += 1

        end

        new_cart_i += 1

      end
    end

    i += 1
  end

new_cart
end

def apply_coupons(cart, coupons)

  applied_coupons = []
  i = 0

  while i < cart.length do

    coupon = find_item_by_name_in_collection(cart[i][:item], coupons)

    if !coupon

      applied_coupons << cart[i]

    else

      current_item = cart[i]

      while current_item[:count] >= coupon[:num] do

        applied_coupons << {

        :item => "#{cart[i][:item]} W/COUPON",
        :price => coupon[:cost] / coupon[:num],
        :clearance => cart[i][:clearance],
        :count => coupon[:num]

        }

        current_item[:count] -= coupon[:num]

      end

      applied_coupons << current_item

    end

    i += 1

  end

  applied_coupons

end

def apply_clearance(cart)

  clearance_cart = []
  i = 0

  while i < cart.length do

    if !cart[i][:clearance]

      clearance_cart << cart[i]

    else

      new_price = cart[i][:price] * 0.8

      clearance_cart << {

        :item => cart[i][:item],
        :price => new_price.round(2),
        :clearance => cart[i][:clearance],
        :count => cart[i][:count]

      }

    end

    i += 1

  end

clearance_cart

end

def checkout(cart, coupons)

  consolidated_cart = consolidate_cart(cart)

  applied_coupons = apply_coupons(consolidated_cart, coupons)

  clearanced_cart = apply_clearance(applied_coupons)

  total = 0
  i = 0

  while i < clearanced_cart.length do

    total += clearanced_cart[i][:price] * clearanced_cart[i][:count]

    i += 1
  end

 if total > 100

   return total * 0.9.round(2)

 end

 total
end
