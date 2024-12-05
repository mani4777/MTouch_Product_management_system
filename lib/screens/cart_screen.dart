import 'package:flutter/material.dart';
import 'package:product_management_system/controller/product_controller.dart';
import 'package:product_management_system/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
        builder: (context, ProductController controller, _) {
      List<CartModel> cart = controller.cart;
      int total = 0;
      for (var e in cart) {
        total += e.totalPrice;
      }
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: cart[index].product.images.isNotEmpty
                              ? Image.file(
                                  cart[index].product.images.first,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart[index].product.productName,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.decreaseCount(
                                            index: index,
                                            value: cart[index].quantity - 1);
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      cart[index].quantity.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      disabledColor: Colors.grey,
                                      onPressed: cart[index].quantity ==
                                              cart[index].product.quantity
                                          ? null
                                          : () {
                                              controller.increaseCount(
                                                  index: index,
                                                  value:
                                                      cart[index].quantity + 1);
                                            },
                                      color: Colors.white,
                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Text("₹${cart[index].totalPrice}"),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: cart.length,
              ),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  "₹$total",
                  style: const TextStyle(fontSize: 24),
                ),
              ]),
            ],
          ),
        ),
      );
    });
  }
}
