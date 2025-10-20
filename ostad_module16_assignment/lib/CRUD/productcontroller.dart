import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ostad_module16_assignment/CRUD/utils/urls.dart';

import 'model/product_model.dart';

class ProductController {
  List<Data> products = [];

  //get
  Future fetchProduct() async {
    final response = await http.get(Uri.parse(Urls.readProduct));


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ProductModel model = ProductModel.fromJson(data);
      products = model.data ?? [];
      // print(products);
    }
  }

  //Create
  Future<bool> createProduct(String name,String img,int qty,int unitprice,int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.createProduct),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(
        {
          "ProductName": name,
          "ProductCode": DateTime.now().microsecondsSinceEpoch,
          "Img": img,
          "Qty": qty,
          "UnitPrice": unitprice,
          "TotalPrice": totalPrice,
        }
    )
    );

    print(response.statusCode);
    print(response.body);

    if(response.statusCode==200){
      await fetchProduct();
      return true;
    }else{
      return false;
    }

  }

  //update
  Future<bool> UpdateProduct(String productId,String name,String img,int qty,int unitprice,int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.updateProduct(productId)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {
              "ProductName": name,
              "ProductCode": DateTime.now().microsecondsSinceEpoch,
              "Img": img,
              "Qty": qty,
              "UnitPrice": unitprice,
              "TotalPrice": totalPrice,
            }
        )
    );

    print(response.statusCode);
    print(response.body);

    if(response.statusCode==200){
      await fetchProduct();
      return true;
    }else{
      return false;
    }

  }

  //delete
  Future <bool> DeleteProduct(String productId) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(productId)));


    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }


  }
}
