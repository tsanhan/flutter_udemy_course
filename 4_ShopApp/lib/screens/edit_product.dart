import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  final String authToken;
  EditProductScreen(this.authToken);

  @override
  _EditProductState createState() => _EditProductState();
}


class _EditProductState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;
  var product =
      Product( description: '', id: '', imageUrl: '', price: 0, title: '');

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updagteImageUrl);
  }

  void _updagteImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http")) ||
          (!_imageUrlController.text.endsWith(".png")) &&
              !_imageUrlController.text.endsWith(".jpeg") &&
              !_imageUrlController.text.endsWith(".jpg")) return;
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      this.product = product ?? this.product;
      _imageUrlController.text = this.product.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updagteImageUrl);
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid =
        _formKey.currentState.validate(); // invoking validate on fields
    if (!isValid) return;

    _formKey.currentState.save(); // involing onSave in the fields

    setState(() {
      _isLoading = true;
    });
    if (product.id.isEmpty) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(product);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occored"),
                  content: Text("Something went wrong"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okey"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
      }
    } else {
      await Provider.of<ProductsProvider>(context, listen: false)
          .editProduct(product);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                // can be replaced by SingleChildScrollView + Column if there are many inputs
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) {
                        product = Product(
                            description: product.description,
                            id: product.id,
                            imageUrl: product.imageUrl,
                            price: product.price,
                            title: value,
                            isFavorite: product.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) return "Prease provide a value";
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: product.price.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) {
                        product = Product(
                            description: product.description,
                            id: product.id,
                            imageUrl: product.imageUrl,
                            price: double.parse(value),
                            title: product.title,
                            isFavorite: product.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) return "Prease enter a price";
                        if (double.tryParse(value) == null)
                          return "Prease enter a valid number";
                        if (double.parse(value) <= 0)
                          return "Prease enter a number greater then zero";
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: product.description,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: 'Description'),
                      focusNode: _descriptionFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_imageUrlFocusNode),
                      onSaved: (value) {
                        product = Product(
                            description: value,
                            id: product.id,
                            imageUrl: product.imageUrl,
                            price: product.price,
                            title: product.title,
                            isFavorite: product.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) return "Prease enter a desciption";
                        if (value.length < 10)
                          return "Shoult be at leat 10 characteres long";
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter a URL")
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              product = Product(
                                  description: product.description,
                                  id: product.id,
                                  imageUrl: value,
                                  price: product.price,
                                  title: product.title,
                                  isFavorite: product.isFavorite);
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Prease enter an Image URL";
                              if (!value.startsWith("http")) {
                                return "please enter a valid url";
                              }
                              if (!value.endsWith(".png") &&
                                  !value.endsWith(".jpeg") &&
                                  !value.endsWith(".jpg")) {
                                return "please enter a valid image URL";
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
