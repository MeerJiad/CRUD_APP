import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled8/app.dart';
import 'package:http/http.dart';
import 'package:untitled8/ui/screens/product_list_screen.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  static String name = '/createProductScreen';

//If we keep the name here,then we can just call the name,so we don't have to write it as a string when we wil navigate screens
//A global variable or function exists outside of any class and can be accessed from anywhere
  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEController =
      TextEditingController(); //'TE' = Text Editing
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _qtyTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  bool _postProductInProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
      ),
      body: Visibility(
        visible: _postProductInProgressIndicator == false,
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
                    _postProduct();
                  }
                },
                child: const Text('Save')),
          )
        ],
      ),
    );
  }

  _postProduct() async {
    _postProductInProgressIndicator = true;
    setState(() {});
   try{ Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');
    Response response = await post(
      uri,
      headers: {'Content-type': 'application/json'},
      //We don't need to pass anything in header,we have seen in postman but we need to say always that in which format,we are passing the data and we are passing the data in JSON format by as you can see that we are using 'double quotation' and object is starting and ending with '{}'
      body: jsonEncode({
        "Img": _imageTEController.text.trim(),
        "ProductCode": _codeTEController.text.trim(),
        "ProductName": _nameTEController.text.trim(),
        "Qty": _qtyTEController.text.trim(),
        "TotalPrice": _totalPriceTEController.text.trim(),
        "UnitPrice": _unitPriceTEController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      _postProductInProgressIndicator = false;
      setState(() {});
      Navigator.pushNamedAndRemoveUntil(
          context, ProductListScreen.name, (routePredicate) => false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product Created'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error!!${response.statusCode}')));
    }}catch(e){
     ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Error!!Check your internet connection!')));
   }
  }

  @override
  void dispose() {
    //dispose is the synonym of 'kill'
    // dispose() is a Flutter lifecycle method called when a StatefulWidget is removed, used to clean up resources like controllers or streams,to free up memory
    _totalPriceTEController.dispose();
    _qtyTEController.dispose();
    _unitPriceTEController.dispose();
    _imageTEController.dispose();
    _codeTEController.dispose();
    _nameTEController.dispose();

    //TextEditingControllers uses heavy memory resources,so as we created them,also we are disposing them after the screen or code is dead/removed
    super.dispose();
  }
}
