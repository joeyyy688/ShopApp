import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/constants/colors.dart';
import 'package:shopapp/providers/productsModels.dart';
import 'package:shopapp/providers/products_provider.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = '/editProductPage';
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  TextEditingController imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var editedProducts = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var isInit = true;
  var initValue = {'title': '', 'description': '', 'price': '', 'imageURL': ''};
  var isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    imageUrlController.dispose();
    //_imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      //if (editedProducts )
      if (productId != null) {
        editedProducts = Provider.of<ProductsProvider>(context, listen: false)
            .searchItemByID(productId);
        initValue = {
          'title': editedProducts.title,
          'description': editedProducts.description,
          'price': editedProducts.price.toString(),
          'imageURL': ''
        };
        imageUrlController.text = editedProducts.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('.png') &&
              !imageUrlController.text.endsWith('.jpg') &&
              !imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    var isFormValid = formKey.currentState.validate();
    if (!isFormValid) {
      return;
    }
    formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editedProducts.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(editedProducts.id, editedProducts);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(editedProducts);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: initValue['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (newValue) {
                            setState(() {
                              editedProducts = Product(
                                  title: newValue,
                                  description: editedProducts.description,
                                  id: editedProducts.id,
                                  imageUrl: editedProducts.imageUrl,
                                  price: editedProducts.price,
                                  isFavourite: editedProducts.isFavourite);
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: initValue['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field is required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Enter a number greater than zero';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              editedProducts = Product(
                                  title: editedProducts.title,
                                  description: editedProducts.description,
                                  id: editedProducts.id,
                                  imageUrl: editedProducts.imageUrl,
                                  price: double.parse(newValue),
                                  isFavourite: editedProducts.isFavourite);
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: initValue['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field is required';
                            }
                            if (value.length < 5) {
                              return 'Must be at least 5 characters long';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              editedProducts = Product(
                                  title: editedProducts.title,
                                  description: newValue,
                                  id: editedProducts.id,
                                  imageUrl: editedProducts.imageUrl,
                                  price: editedProducts.price,
                                  isFavourite: editedProducts.isFavourite);
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(top: 8, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  width: 1,
                                  color: greyColor,
                                )),
                                child: Container(
                                  child: imageUrlController.text.isEmpty
                                      ? Text("Enter a URL")
                                      : FittedBox(
                                          child: Image.network(
                                          imageUrlController.text,
                                          fit: BoxFit.cover,
                                        )),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: imageUrlController,
                                  focusNode: _imageUrlFocusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    if (!value.startsWith('http') &&
                                        !value.startsWith('https')) {
                                      return 'Enter a valid URL';
                                    }
                                    if (!value.endsWith('.jpg') &&
                                        !value.endsWith('.png') &&
                                        !value.endsWith('..jpeg')) {
                                      return 'Enter a valid URL';
                                    }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    setState(() {
                                      editedProducts = Product(
                                          title: editedProducts.title,
                                          description:
                                              editedProducts.description,
                                          id: editedProducts.id,
                                          imageUrl: newValue,
                                          price: editedProducts.price,
                                          isFavourite:
                                              editedProducts.isFavourite);
                                    });
                                  },
                                  onFieldSubmitted: (value) => saveForm(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
    );
  }
}
