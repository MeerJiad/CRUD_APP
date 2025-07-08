import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:untitled8/app.dart';
import 'package:untitled8/ui/screens/product_list_screen.dart';

import '../../models/product_model.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    super.key,
    required this.product,
  });

  final Product product;
  static String name = '/editProductScreen';

//If we keep the name here,then we can just call the name,so we don't have to write it as a string when we wil navigate screens
//A global variable or function exists outside of any class and can be accessed from anywhere
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEController =
      TextEditingController(); //'TE' = Text Editing
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _qtyTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  bool _updateProductProgressIndicator = false;

  @override
  void initState() {
    _nameTEController.text = _safeProductName();
    _codeTEController.text = _safeProductCode();
    _imageTEController.text = _safeProductImage();
    _unitPriceTEController.text = _safeUnitPrice();
    _qtyTEController.text = _safeQuantity();
    _totalPriceTEController.text = _safeTotalPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Visibility(
        visible: _updateProductProgressIndicator == false,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              _buildProductForm(), //We can easily extract widgets/method,by right click then 'refactor' then 'ExtractMethod' because we are extracting it as a method not as a widget.
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    //this method returns widget
    //we haven't did widget extraction because we have build Method here,so we can't create another class and take it out,that's why we did method extraction here.
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameTEController,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty == true) {
                  return 'Enter product name';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  hintText: 'Enter product name',
                  labelText: 'Product Name',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: CRUDApp.appThemeColor))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _codeTEController,
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  //'?.' It's a logical OR operator,Called "null-aware access",It safely calls a method or property only if the variable is not null.So,it will Only call .trim() if value is not null.
                  return 'Enter product code';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  hintText: 'Enter product code',
                  labelText: 'Product Code',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(
                        color: CRUDApp.appThemeColor,
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _imageTEController,
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter image url';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  hintText: 'Enter image url',
                  labelText: 'Image',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(
                        color: CRUDApp.appThemeColor,
                      ))),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _unitPriceTEController,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter unit price';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        hintText: 'unit price',
                        labelText: 'Unit Price',
                        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              color: CRUDApp.appThemeColor,
                            ))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _qtyTEController,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter qty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        hintText: 'product qty',
                        labelText: 'Qty',
                        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              color: CRUDApp.appThemeColor,
                            ))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _totalPriceTEController,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter total price';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        hintText: 'total price',
                        labelText: 'Total Price',
                        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              color: CRUDApp.appThemeColor,
                            ))),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProductApiCall();
                  }
                },
                child: const Text('Save')),
          )
        ],
      ),
    );
  }

  Future<void> _updateProductApiCall() async {
    _updateProductProgressIndicator = true;
    setState(() {});
    try {
      Uri uri = Uri.parse(
          'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');
      Map<String, dynamic> body = {
        "Img": _imageTEController.text.trim(),
        "ProductCode": _codeTEController.text.trim(),
        "ProductName": _nameTEController.text.trim(),
        "Qty": _qtyTEController.text.trim(),
        "TotalPrice": _totalPriceTEController.text.trim(),
        "UnitPrice": _unitPriceTEController.text.trim(),
      };
      Response response = await post(uri,
          body: jsonEncode(body),
          headers: {'Content-type': 'application/json'});
      if (response.statusCode == 200) {
        _updateProductProgressIndicator = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Product Updated!!')));
        Navigator.pushNamedAndRemoveUntil(
            context, ProductListScreen.name, (routePredicate) => false);
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error!!${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error!!Check your network connection!')));
    }
  }

  String _safeProductCode() {
    //returning safeText to prevent null and isEmpty problems.
    if (widget.product.productCode?.trim().isEmpty ?? true) {
      return 'Unknown';
    } else {
      return widget.product.productCode!;
    }
  }

  //Here we defined Edge Case at first,then if theres no problem,we will just return the main one.

  String _safeProductImage() {
    if (widget.product.img?.trim().isEmpty ?? true) {
      return 'https://apollobattery.com.au/wp-content/uploads/2022/08/default-product-image.png';
    } else {
      return widget.product.img!;
    }
  }

  String _safeProductName() {
    if (widget.product.productName?.trim().isEmpty ?? true) {
      return 'Unknown';
    } else {
      return widget.product.productName!;
    }
  }

  String _safeQuantity() {
    if (widget.product.qty?.trim().isEmpty ?? true) {
      return 'Unknown';
    } else {
      return widget.product.qty!;
    }
  }

  String _safeUnitPrice() {
    if (widget.product.unitPrice?.trim().isEmpty ?? true) {
      return '0';
    } else {
      return widget.product.unitPrice!;
    }
  }

  String _safeTotalPrice() {
    if (widget.product.totalPrice?.trim().isEmpty ?? true) {
      return '0';
    } else {
      return widget.product.totalPrice!;
    }
  }

  @override
  void dispose() {
    //dispose() is the final method called in a widget’s lifecycle — used to clean up before the widget dies.
    _totalPriceTEController.dispose();
    _qtyTEController.dispose();
    _unitPriceTEController.dispose();
    _imageTEController.dispose();
    _codeTEController.dispose();
    _nameTEController.dispose();
    super.dispose();
  }
}
