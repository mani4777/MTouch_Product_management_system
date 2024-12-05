import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:product_management_system/constants.dart';
import 'package:product_management_system/controller/product_controller.dart';
import 'package:product_management_system/models/cart_model.dart';
import 'package:product_management_system/models/product_model.dart';
import 'package:product_management_system/screens/add_or_edit_product.dart';
import 'package:product_management_system/screens/product_details.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Consumer<ProductController>(
        builder: (context, ProductController controller, _) {
      List<ProductModel> allProducts = controller.products;
      List<CartModel> cart = controller.cart;
      List<ProductModel> products = [];
      if (searchController.text.isNotEmpty) {
        products = allProducts
            .where((element) => element.productName
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      } else {
        products = allProducts;
      }
      log(products.toString());
      return Scaffold(
        appBar: AppBar(
          title: const Text("Product Management System"),
          actions: [
            if (cart.isNotEmpty)
              Badge(
                isLabelVisible: true,
                alignment: AlignmentDirectional.topEnd,
                label: Text(cart.length.toString()),
                child: IconButton(
                  onPressed: () {
                    if (cart.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                    }
                  },
                  icon: const Icon(Icons.card_travel),
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                customTextField(
                  onChanged: (value) {
                    setState(() {});
                    return null;
                  },
                  controller: searchController,
                  hintText: "Search Product",
                  validator: (value) {
                    return null;
                  },
                  isNumber: false,
                  labelText: "Search",
                ),
                if (products.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: maxHeight * 0.35),
                    child: const Center(
                      child: Text(
                        "No Products yet!",
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      CartModel? currentCart;
                      if (cart.any(
                          (element) => element.product == products[index])) {
                        currentCart = cart
                            .where(
                                (element) => element.product == products[index])
                            .first;
                      }
                      return productTile(
                        maxWidth: maxWidth,
                        products: products,
                        index: index,
                        cart: cart,
                        currentCart: currentCart,
                        controller: controller,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddOrEditProduct(
                  isEdit: false,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Widget productTile({
    required double maxWidth,
    required List<ProductModel> products,
    required int index,
    required List<CartModel> cart,
    required CartModel? currentCart,
    required ProductController controller,
  }) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetails(
                  product: products[index],
                ),
              ),
            );
          },
          child: Container(
            height: maxWidth,
            width: maxWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: FlutterCarousel(
              options: FlutterCarouselOptions(
                aspectRatio: 3 / 3,
                viewportFraction: 1,
              ),
              items: products[index]
                  .images
                  .map(
                    (e) => Image.file(
                      e,
                      height: maxWidth,
                      width: maxWidth,
                      fit: BoxFit.fill,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: currentCart != null
                    ? products[index].quantity - currentCart.quantity != 0
                        ? Container(
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              (products[index].quantity - currentCart.quantity)
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox()
                    : Container(
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          (products[index].quantity).toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products[index].productName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        if (currentCart != null)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    int cartIndex = cart.indexOf(currentCart);
                                    controller.decreaseCount(
                                        index: cartIndex,
                                        value: currentCart.quantity - 1);
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
                                  currentCart.quantity.toString(),
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
                                  onPressed: currentCart.quantity ==
                                          products[index].quantity
                                      ? null
                                      : () {
                                          int cartIndex =
                                              cart.indexOf(currentCart);
                                          controller.increaseCount(
                                              index: cartIndex,
                                              value: currentCart.quantity + 1);
                                        },
                                  color: Colors.white,
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              CartModel tempCart = CartModel(products[index], 1,
                                  products[index].offerPrice * 1);
                              controller.addToCart(tempCart);
                            },
                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      products[index].productDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 10,
          child: RichText(
            text: TextSpan(
                text: " ₹${products[index].offerPrice}  ",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "₹${products[index].originalPrice}",
                    style: const TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
                ]),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    controller.deleteProduct(index: index);
                    if (currentCart != null) {
                      controller.deleteFromCart(value: currentCart);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddOrEditProduct(
                              isEdit: true,
                              product: products[index],
                              index: index,
                            )));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
