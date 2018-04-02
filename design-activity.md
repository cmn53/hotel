###### What classes does each implementation include? Are the lists the same?
Both implementations include CartEntry, ShoppingCart, and Order classes.

###### Write down a sentence to describe each class.
Implementation A:
* CartEntry stores the unit price and quantity for each item in a cart.
* ShoppingCart stores a list of the items in a cart.
* Order calculates the subtotal of all items in a cart, the sales tax, and the total.

Implementation B:
* CartEntry stores the unit price and quantity for each item in a cart and calculates the price of that item.
* ShoppingCart stores a list of the items in a cart and calculates the subtotal for all items in the cart.
* Order calculates the sales tax and total for the cart.

###### How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
Implementation A: CartEntry and ShoppingCart are not dependent on any other class. Order is dependent on both ShoppingCart (to provide the list of items) and CartEntry (to provide the unit prices and quantities for each item).

Implementation B: CartEntry is not dependent on any other class. ShoppingCart is dependent on CartEntry to provide prices for the items in the cart. Order is dependent on ShoppingCart to provide a list of items in the cart and the cart subtotal.

###### What data does each class store? How (if at all) does this differ between the two implementations?
In both implementations CartEntry stores unit prices and quantities, Shopping Cart stores the list of items entered in the cart, and Order stores an instance of ShoppingCart.

###### What methods does each class have? How (if at all) does this differ between the two implementations?
In Implementation A, CartEntry and ShoppingCart have only initialization methods, and Order has an initialization method and method to calculate the total price of the order.

In Implementation B, CartEntry, ShoppingCart, and Order all have initialization methods and methods to calculate the price of an item, the subtotal for items in a shopping cart, and the total price of an order, respectively.

###### Consider the Order#total_price method. In each implementation:
* **Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?**
In Implementation A, the logic to compute the total price is all retained in the Order class. In Implementation B, the logic is delegated to the 'lower level' ShoppingCart and CartEntry classes.

* **Does total_price directly manipulate the instance variables of other classes?**
I'm a little confused by what is meant by 'manipulation' -- to my mind, manipulation implies that the value assigned to an instance variable is modified. The total_price method does not modify the value of another classes' instance variable in either implementation. However, in Implementation A, the total_price method reads the values of the CartEntry classes' instance variables. In Implementation B, the total_price method does not directly read the values of other classes' instance variables.

###### If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
If items are cheaper if bought in bulk, we would need to modify the code to include a unit price that is dependent on the quantity. It would be easier to make the modification in Implementation B because the unit price could be altered within the existing CartEntry#price method (or alternatively, in a new CartEntry instance method), and no other changes to ShoppingCart or Order would be necessary. In Implementation A, a new instance method would probably be added to CartEntry to calculate the unit price based on the quantity, and the Order#total_price method would have to be modified to call that method rather than reading the value of CartEntry's unit price instance variable.

###### Which implementation better adheres to the single responsibility principle?
Implementation B better adheres to the single responsibility principle because the purpose of each class is better encapsulated (more wholly contained) within that class than in Implementation A.

###### Which implementation is more loosely coupled?
Implementation B is more loosely coupled.
<!--  -->
