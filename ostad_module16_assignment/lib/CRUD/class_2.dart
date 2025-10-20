
import 'package:flutter/material.dart';
import 'package:ostad_module16_assignment/CRUD/productcontroller.dart';
import 'package:ostad_module16_assignment/CRUD/widget/ProductCard.dart';

//view file
class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  ProductController productController = ProductController();

  Future fetchData() async {
    await productController.fetchProduct();
    setState(() {});
  }

  productDialog({
    String? id,
    String? name,
    String? img,
    int? qty,
    int? uniprice,
    int? totalPrice,
    required bool isupdate,
  }) {
    TextEditingController productNameController = TextEditingController(
      text: name,
    );
    TextEditingController productImageController = TextEditingController(
      text: img,
    );
    TextEditingController productQtyController = TextEditingController(
      text: qty != null ? qty.toString() : '',
    );
    TextEditingController productUnipriceController = TextEditingController(
      text: uniprice != null ? uniprice.toString() : '',
    );
    TextEditingController productTotalPriceController = TextEditingController(
      text: totalPrice != null ? totalPrice.toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isupdate ? "Update Product" : "Add Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: productImageController,
              decoration: InputDecoration(labelText: "Product Image"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: productQtyController,

              decoration: InputDecoration(labelText: "Product Quantity"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: productUnipriceController,
              decoration: InputDecoration(labelText: "Product unit Price"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: productTotalPriceController,
              decoration: InputDecoration(labelText: "Product total price"),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // isupdate
                    //     ?
                    if (isupdate) {
                      bool updated = await productController.UpdateProduct(
                        id.toString(),
                        productNameController.text,
                        productImageController.text,
                        int.parse(productQtyController.text),
                        int.parse(productUnipriceController.text),
                        int.parse(productTotalPriceController.text),
                      );
                      if (updated) {
                        await fetchData();
                      }
                    } else {
                      bool created = await productController.createProduct(
                        productNameController.text,
                        productImageController.text,
                        int.parse(productQtyController.text),
                        int.parse(productUnipriceController.text),
                        int.parse(productTotalPriceController.text),
                      );
                      if (created) {
                        await fetchData();
                      }
                    }

                    Navigator.pop(context);

                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product CRUD'),
        backgroundColor: Colors.orange,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: productController.products.length,
        itemBuilder: (context, index) {
          var product = productController.products[index];
          return ProductCard(
            product: product,
            onDelete: () async {

             // productController.DeleteProduct(product.sId.toString()).then((value,) async {
              bool value = await productController.DeleteProduct(product.sId.toString());

              if (value) {
                 // await productController.fetchProduct();
                  await fetchData();
                  setState(() {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Product Deleted")));
                  });
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Something Wrong")),
                  );
                }

            },
            onEdit: () {

              productDialog(
                name: product.productName,
                img: product.img,
                id: product.sId,
                qty: product.qty,
                uniprice: product.unitPrice,
                totalPrice: product.totalPrice,
                isupdate: true,
              );

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productDialog(isupdate: false);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
