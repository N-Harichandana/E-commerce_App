import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products.dart';
import '/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = "/edit_product";
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusNode = FocusNode();
  final _descriptionfocusnode = FocusNode();
  final _imageurlController = TextEditingController();
  final _urlContoller = TextEditingController();
  final _imageurlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Products(id: " ", title: " ", description: " ", price: 0, imageurl: " ");
  var _InitValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageurl": "",
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageurlfocusnode.addListener(_updateImageurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        final productid = arguments as String;
        _editedProduct = Provider.of<Products_provider>(context, listen: false)
            .findbyid(productid);
        print(_editedProduct.imageurl);
        _InitValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageurl": "",
        };
        _imageurlController.text = _editedProduct.imageurl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pricefocusNode.dispose();
    _descriptionfocusnode.dispose();
    _imageurlController.dispose();
    _urlContoller.dispose();
    _imageurlfocusnode.dispose();
    _imageurlfocusnode.removeListener(_updateImageurl);
    super.dispose();
  }

  void _onSave() async {
    final isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final edit = Provider.of<Products_provider>(context, listen: false);
    if (_editedProduct.id != " ") {
      await edit.updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await edit.addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("An error Occured"),
                  content: Text("OOps!! Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _updateImageurl() {
    if (!_imageurlfocusnode.hasFocus) {
      final enteredImageUrl = _imageurlController.text;
      if ((!enteredImageUrl.startsWith("http") &&
              !enteredImageUrl.startsWith("https")) ||
          (!enteredImageUrl.endsWith(".jpg") &&
              !enteredImageUrl.endsWith(".png") &&
              !enteredImageUrl.endsWith(".jpeg"))) {
        return; // URL doesn't match the expected pattern
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _urlContoller.text = _editedProduct.imageurl;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _onSave, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _InitValues['title'],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide the value";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Products(
                              isfavourite: _editedProduct.isfavourite,
                              id: _editedProduct.id,
                              title: newValue ?? "",
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageurl: _editedProduct.imageurl);
                        },
                      ),
                      TextFormField(
                        initialValue: _InitValues['price'],
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionfocusnode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a number greater than zero";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          final double newPrice = newValue != null
                              ? double.tryParse(newValue) ?? 0.0
                              : 0.0;
                          _editedProduct = Products(
                              isfavourite: _editedProduct.isfavourite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: newPrice,
                              imageurl: _editedProduct.imageurl);
                        },
                      ),
                      TextFormField(
                        initialValue: _InitValues['description'],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionfocusnode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the Description";
                          }
                          if (value.length < 10) {
                            return "Should be atleast 10 cahracters long";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Products(
                              isfavourite: _editedProduct.isfavourite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: newValue ?? "",
                              price: _editedProduct.price,
                              imageurl: _editedProduct.imageurl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageurlController.text.isEmpty
                                ? Text("Enter the URL")
                                : FittedBox(
                                    child: Image.network(
                                        _imageurlController.text, errorBuilder:
                                            (context, error, stackTrace) {
                                      return Text("Invalid");
                                    }),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                _onSave();
                              },
                              controller: _urlContoller,
                              validator: (value) {
                                value = value ?? value!.trim();
                                if (value.isEmpty) {
                                  return "Please enter the Url";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Enter valid url";
                                }
                                if (!value.endsWith(".jpg") &&
                                    !value.endsWith(".png") &&
                                    !value.endsWith(".jpeg")) {
                                  return "please enter valid image Url";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Products(
                                    isfavourite: _editedProduct.isfavourite,
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageurl: newValue ?? "");
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
