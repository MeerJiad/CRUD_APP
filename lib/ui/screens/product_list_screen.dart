import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled8/ui/screens/create_product_screen.dart';
import '../../models/product_model.dart';
import '../widgets/products.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  static String name = '/';

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    _getProductList();
    super.initState();
  }

  List<Product> productList = [];
  bool _getProductListProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        //Just a dedicated widget for refresh.
        onRefresh: () async {
          //Its type is 'async'.So need to give it.
          _getProductList(); //As "refresh" means coming to the productListScreen again back,we will call the method again
        },
        child: Visibility(
          visible: _getProductListProgressIndicator == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                return Products(
                  product: productList[index],
                  onDelete: _getProductList,
                ); //We extracted 'Products' into another stateless widget.That's called widget extraction.We can extract widgets in two ways,one is widget extraction means we create another class and another is method extraction means we create a method,we did both in this project.
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateProductScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async{
    productList.clear();
    //its needed for the refresh button,when we refresh the app,it fetches data including the exiting products.
    _getProductListProgressIndicator = true;
    setState(() {});
    try {
      Uri uri = Uri.parse(
          'https://crud.teamrabbil.com/api/v1/ReadProduct'); //We get the 'url' as a 'string' format but dart supports 'uri' format,So we are just simply parsing it.
      Response response = await get(
          uri); //"Response' is a dedicated class of 'http' package with which we can do 'get' request and receive response.

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        for (Map<String, dynamic> x in decodedData['data']) {
          Product product = Product(
            id: x['_id'],
            productName: x['ProductName'],
            productCode: x['ProductCode'],
            img: x['Img'],
            unitPrice: x['UnitPrice'],
            qty: x['Qty'],
            totalPrice: x['TotalPrice'],
            createdDate: x['CreatedDate'],
          );
          productList.add(product);
        }
        _getProductListProgressIndicator = false;
        setState(() {});
      } //Here,We are loading giving ' _getProductListProgressIndicator = true; ' once the api calls and product is added and decoding the data from json,if the request is successful.After decoding we are playing a loop to get data from the 'data' key by seeing postman.Then we are just simply create a 'Product' object and adding it into List.
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error!!${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error!!Check your network connection!'),
        duration: Duration(seconds: 5),
      ));
    }
    //As we know, the work of 'try-catch',it will execute the 'try' block at first if it works or gives any responseStatus,then it will show that but if it doesn't works i means there could be some exception like 'no internet' then api can't be called,then it will execute the catch block.it means if any exception happens then it will execute 'catch' block.Otherwise, it will execute 'try' block.
  }
}
