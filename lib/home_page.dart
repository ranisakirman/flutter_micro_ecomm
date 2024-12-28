import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProductDetailPage.dart';
import 'product_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.startPolling(); 
    });
  }

  @override
  void dispose() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.stopPolling(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          "Daftar Produk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (productProvider.products.isEmpty) {
            return Center(
              child: Text(
                'No products available',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.builder(
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return Card(
                elevation: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(64, 75, 96, .9),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.white70),
                        ),
                      ),
                      child: Icon(Icons.shopping_cart, color: Colors.white),
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Rp ${product.price}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: product.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}