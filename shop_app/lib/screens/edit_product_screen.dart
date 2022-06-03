import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_providers.dart';
import 'package:shop_app/util/helper.dart';
import 'package:shop_app/widgets/loading_state.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({Key? key}) : super(key: key);

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _descriptionNode = FocusNode();
  final _priceNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late ProductProvider _productProvider;
  var _initState = true;
  var _initialFormState = {
    "title": "",
    "description": "",
    "price": "",
    "image": ""
  };
  var _product =
      Product(id: "", image: "", description: "", price: 0.00, title: "");
  bool _loadingState = false;

  @override
  void initState() {
    _imageNode.addListener(updateImage);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _imageNode.removeListener(updateImage);
    _descriptionNode.dispose();
    _priceNode.dispose();
    _imageController.dispose();
    _imageNode.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!_imageNode.hasFocus) setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != null) {
        _product = _productProvider.findById(productId);
        _initialFormState = {
          "title": _product.title,
          "description": _product.description,
          "price": _product.price.toString(),
          "image": ""
        };
        _imageController.text = _product.image;
      }
    }
    _initState = false;
    super.didChangeDependencies();
  }

  void onSubmitForm(BuildContext context) async {
    var isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState?.save();
    if (_product.id == "") {
      setState(() {
        _loadingState = true;
      });
      var state = await _productProvider.addProduct(_product, context);
      if (state) {
        showToast(
          context,
          "Product Added",
        );
        setState(() {
          _loadingState = false;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _loadingState = false;
        });
        showToast(context, "Product Not Found Try Again",
            iconColor: Colors.redAccent, icon: Icons.cancel_rounded);
      }
    } else {
      setState(() {
        _loadingState = true;
      });
      var state = await _productProvider.updateProducts(_product);
      if (state) {
        showToast(
          context,
          "Product Edited",
        );
        setState(() {
          _loadingState = false;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _loadingState = false;
        });
        showToast(context, "Product Not Found Try Again",
            iconColor: Colors.redAccent, icon: Icons.cancel_rounded);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Edit Page"),
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      initialValue: _initialFormState["title"],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _product = Product(
                          image: _product.image,
                          description: _product.description,
                          price: _product.price,
                          title: value.toString(),
                          isFavourite: _product.isFavourite,
                          id: _product.id,
                        );
                      },
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter a title";
                        }
                        return null;
                      },
                    )),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                        initialValue: _initialFormState["description"],
                        focusNode: _descriptionNode,
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _product = Product(
                            image: _product.image,
                            description: value.toString(),
                            price: _product.price,
                            title: _product.title,
                            isFavourite: _product.isFavourite,
                            id: _product.id,
                          );
                        },
                        validator: (value) {
                          if (!value!.isNotEmpty) {
                            return "Enter a Description";
                          }
                          if (value.length < 10) {
                            return "Description Should be atleast 10 character";
                          }
                          return null;
                        })),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                        initialValue: _initialFormState["price"],
                        focusNode: _priceNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Price",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _product = Product(
                            image: _product.image,
                            description: _product.description,
                            price: double.tryParse(value!)!,
                            title: _product.title,
                            isFavourite: _product.isFavourite,
                            id: _product.id,
                          );
                        },
                        validator: (value) {
                          if (double.tryParse(value!) == null) {
                            return "Enter a Valid Price";
                          }
                          if (double.tryParse(value)! < 0) {
                            return "Price should be atleast greater then zero";
                          }
                          return null;
                        })),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: 100,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black12,
                          ),
                        ),
                        child: _imageController.text.isNotEmpty
                            ? Image.network(_imageController.text,
                                fit: BoxFit.cover)
                            : const Text("Enter a valid url"),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              labelText: "Image Url",
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: _imageController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (value) {
                              _product = Product(
                                image: value.toString(),
                                description: _product.description,
                                price: _product.price,
                                title: _product.title,
                                isFavourite: _product.isFavourite,
                                id: _product.id,
                              );
                            },
                            validator: (value) {
                              if (!value!.isNotEmpty) {
                                return "Enter a Image Url";
                              }
                              if (!value.startsWith("http") ||
                                  !value.startsWith("https")) {
                                return "Enter a valid Image url";
                              }
                              return null;
                            }))
                  ],
                ),
                _loadingState
                    ? const LoadingState()
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                          ),
                          child: _product.id != ""
                              ? const Text("Edit")
                              : const Text("Add"),
                          onPressed: () {
                            onSubmitForm(context);
                          },
                        ),
                      )
              ],
            )),
          )),
    );
  }
}
