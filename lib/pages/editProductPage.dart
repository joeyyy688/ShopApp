import 'package:flutter/material.dart';
import 'package:shopapp/constants/colors.dart';
import 'package:shopapp/providers/productsModels.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() {
    var isFormValid = formKey.currentState.validate();

    if (isFormValid) {
      formKey.currentState.save();
      print(editedProducts.description);
      print(editedProducts.id);
      print(editedProducts.imageUrl);
      print(editedProducts.price);
      print(editedProducts.title);
    }
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
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
              key: formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (newValue) {
                      setState(() {
                        editedProducts = Product(
                            title: newValue,
                            description: editedProducts.description,
                            id: editedProducts.id,
                            imageUrl: editedProducts.imageUrl,
                            price: editedProducts.price);
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
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (newValue) {
                      setState(() {
                        editedProducts = Product(
                            title: editedProducts.title,
                            description: editedProducts.description,
                            id: editedProducts.id,
                            imageUrl: editedProducts.imageUrl,
                            price: double.parse(newValue));
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (newValue) {
                      setState(() {
                        editedProducts = Product(
                            title: editedProducts.title,
                            description: newValue,
                            id: editedProducts.id,
                            imageUrl: editedProducts.imageUrl,
                            price: editedProducts.price);
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
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (newValue) {
                              setState(() {
                                editedProducts = Product(
                                    title: editedProducts.title,
                                    description: editedProducts.description,
                                    id: editedProducts.id,
                                    imageUrl: newValue,
                                    price: editedProducts.price);
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
