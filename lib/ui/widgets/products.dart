import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:untitled8/models/product_model.dart';
import 'package:untitled8/ui/screens/edit_product_screen.dart';

class Products extends StatelessWidget {
  Products({super.key, required this.product, required this.onDelete});

  final Product product;
  final Function onDelete;

  //Very simple,When any screen/widget will use that 'StatelessWidget',It have to give 'product' and 'onDelete' function means what he wants to do when the product will be deleted.
  bool _deleteProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {},
        titleAlignment: ListTileTitleAlignment.center,
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Image.network(
            _safeProductImage(),
            width: 60,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                  'https://rakanonline.com/wp-content/uploads/2022/08/default-product-image.png');
            }, //if user's provided link is invalid or somehow the image can't load then it will be shown.
          ),
        ),
        title: Text(_safeProductName()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Code: ${_safeProductCode()}'),
            Text('Quantity: ${_safeQuantity()}'),
            Text('Unit Price: ${_safeUnitPrice()}'),
            Text('Total Price: ${(_safeTotalPrice())}')
          ],
        ),
        trailing: Wrap(
          //wrap takes that much space which is needed Automatically moves items to the next line if they don't fit.
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          //We can use 'StatefulBuilder' for rebuilding a small portion of 'Stateless Widget'
                          return Visibility(
                            visible: _deleteProgressIndicator == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: _buildAlertDialog(context, setState),
                          );
                        });
                      });
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProductScreen.name,
                      arguments: product);
                },
                icon: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }

  AlertDialog _buildAlertDialog(BuildContext context, StateSetter setState) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('Delete Product?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            _deleteProgressIndicator = true;
            setState(() {});
            await _productDeleteApiCall(context);
            Navigator.pop(context);
            onDelete();
          },
          child: const Text(
            'Yes',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Future<void> _productDeleteApiCall(BuildContext context) async {
    try {
      Uri uri = Uri.parse(
          'https://crud.teamrabbil.com/api/v1/DeleteProduct/${product.id}');
      Response response = await get(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Product Deleted')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error!!${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error!!Check your internet connection!')));
    }
  }

  String _safeProductCode() {
    //returning safeText to prevent null and isEmpty problems.
    if (product.productCode?.trim().isEmpty ?? true) {
      return 'Unknown';
    } else {
      return product.productCode!;
    }
  }

  //Here we defined Edge Case at first,then if theres no problem,we will just return the main one.
  String _safeProductImage() {
    if (product.img?.trim().isEmpty ?? true) {
      return 'https://rakanonline.com/wp-content/uploads/2022/08/default-product-image.png';
    } else {
      return product.img!;
    }
  }

  String _safeProductName() {
    if (product.productName?.trim().isEmpty ?? true) {
      return 'Unknown';
    } else {
      return product.productName!;
    }
  }

  String _safeQuantity() {
    if (product.qty?.trim().isEmpty ?? true) {
      return 'Unknown';
    } else {
      return product.qty!;
    }
  }

  String _safeUnitPrice() {
    if (product.unitPrice?.trim().isEmpty ?? true) {
      return '0';
    } else {
      return product.unitPrice!;
    }
  }

  String _safeTotalPrice() {
    if (product.totalPrice?.trim().isEmpty ?? true) {
      return '0';
    } else {
      return product.totalPrice!;
    }
  }
}
