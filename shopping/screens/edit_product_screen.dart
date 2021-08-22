import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import '../provider/products.dart';

class EditProductScrreen extends StatefulWidget {
  static const routeName = '\edit';
  @override
  _EditProductScrreenState createState() => _EditProductScrreenState();
}

class _EditProductScrreenState extends State<EditProductScrreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _globalKeyForm = GlobalKey<FormState>();
  bool _isLoading = false;
  var initvalue = {
    'id': '',
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };
  Product _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  @override
  void initState() {
    _imageUrlFocus.addListener(updListener);
    super.initState();
  }

  void updListener() {
    setState(() {});
  }

  bool isinit = true;

  @override
  void didChangeDependencies() {
    if (isinit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;

      // ignore: unnecessary_null_comparison
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initvalue = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageUrl': '',
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    final isValid = _globalKeyForm.currentState!.validate();

    if (!isValid) {
      return;
    }
    _globalKeyForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // ignore: unnecessary_null_comparison
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text('An error Occured!'),
                  content: Text('Oops something went wrong'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ]);
            });
      }
      //   finally {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     Navigator.of(context).pop();
      //   }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _globalKeyForm,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initvalue['title'],
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          labelText: 'Title',
                          filled: true,
                          fillColor: Colors.grey[200]),
                      style: TextStyle(color: Colors.black),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value.toString());
                      },
                      // keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                        initialValue: initvalue['Price'],
                        decoration: InputDecoration(
                            labelText: 'Price',
                            filled: true,
                            fillColor: Colors.grey.shade200),
                        style: TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              price: double.parse(value!),
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title);
                        }),
                    TextFormField(
                        initialValue: initvalue['Description'],
                        decoration: InputDecoration(
                            labelText: 'Description',
                            filled: true,
                            fillColor: Colors.grey.shade200),
                        style: TextStyle(color: Colors.black),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          if (value.length < 10) {
                            return 'Should be atleat 10 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              price: _editedProduct.price,
                              description: value.toString(),
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title);
                        }),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a url')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                            child: TextFormField(
                                //cannot have both controlller and initialValue
                                // initialValue: initvalue['imageUrl'],
                                decoration:
                                    InputDecoration(labelText: 'Inage Url'),
                                style: TextStyle(color: Colors.black),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocus,
                                onFieldSubmitted: (_) => _saveForm(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a image url';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid url';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid image url';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      price: _editedProduct.price,
                                      description: _editedProduct.description,
                                      imageUrl: value.toString(),
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite,
                                      title: _editedProduct.title);
                                })),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
