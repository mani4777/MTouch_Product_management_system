import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_management_system/constants.dart';
import 'package:product_management_system/controller/product_controller.dart';
import 'package:product_management_system/models/product_model.dart';
import 'package:provider/provider.dart';

class AddOrEditProduct extends StatefulWidget {
  final bool isEdit;
  final ProductModel? product;
  final int? index;
  const AddOrEditProduct(
      {required this.isEdit, this.product, this.index, super.key});

  @override
  State<AddOrEditProduct> createState() => _AddOrEditProductState();
}

class _AddOrEditProductState extends State<AddOrEditProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productOfferPriceController = TextEditingController();
  TextEditingController productOriginalPriceController =
      TextEditingController();
  List<File> images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      productNameController =
          TextEditingController(text: widget.product?.productName);
      productDescriptionController =
          TextEditingController(text: widget.product?.productDescription);
      productQuantityController =
          TextEditingController(text: widget.product?.quantity.toString());
      productOfferPriceController =
          TextEditingController(text: widget.product?.offerPrice.toString());
      productOriginalPriceController =
          TextEditingController(text: widget.product?.originalPrice.toString());
      images = widget.product?.images ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdit ? "Edit" : "Add"} Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              customTextField(
                labelText: "Product Name",
                isNumber: false,
                hintText: "Product Name",
                controller: productNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Product Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              customTextField(
                labelText: "Product Description",
                isNumber: false,
                maxLines: 3,
                hintText: "Product Description",
                controller: productDescriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Product Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Images",
                  ),
                  TextButton(
                    onPressed: () async {
                      ImagePicker picker = ImagePicker();
                      List<XFile> tempImages = await picker.pickMultiImage();
                      images
                          .addAll(tempImages.map((e) => File(e.path)).toList());
                      setState(() {});
                    },
                    child: const Text("Add Images"),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: images.isEmpty ? 0 : 200,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.file(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            height: 30,
                            width: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              style: IconButton.styleFrom(),
                              onPressed: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              iconSize: 16,
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: images.length,
                  padding: const EdgeInsets.only(right: 16),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: customTextField(
                      labelText: "Price",
                      isNumber: true,
                      controller: productOriginalPriceController,
                      hintText: "Price",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Price";
                        }
                        if (int.parse(value) <= 0) {
                          return "Enter a valid Price";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: customTextField(
                      labelText: "Offer Price",
                      isNumber: true,
                      controller: productOfferPriceController,
                      hintText: "Offer Price",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Offer Price";
                        }
                        if (int.parse(value) <= 0) {
                          return "Enter a valid Price";
                        }
                        if (int.parse(productOriginalPriceController.text) <=
                            int.parse(value)) {
                          return "Offer price should be less than Price";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              customTextField(
                labelText: "Quantity",
                isNumber: true,
                controller: productQuantityController,
                hintText: "Quantity",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Quantity";
                  }
                  return null;
                },
              ),
              const Spacer(),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(56),
                ),
                minWidth: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (!widget.isEdit) {
                      ProductModel product = ProductModel(
                          productNameController.text,
                          productDescriptionController.text,
                          int.parse(productOriginalPriceController.text),
                          int.parse(productOfferPriceController.text),
                          images,
                          int.parse(productQuantityController.text));
                      bool status =
                          Provider.of<ProductController>(context, listen: false)
                              .addProduct(product);
                      if (status) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      ProductModel tempProduct = ProductModel(
                          productNameController.text,
                          productDescriptionController.text,
                          int.parse(productOriginalPriceController.text),
                          int.parse(productOfferPriceController.text),
                          images,
                          int.parse(productQuantityController.text));
                      Provider.of<ProductController>(context, listen: false)
                          .editProduct(widget.index!, tempProduct);
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text("${widget.isEdit ? "Edit" : "Add"} Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
