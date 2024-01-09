import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:projet_flutter/cubit/commande_cubit/commande_cubit.dart';
import 'package:projet_flutter/screens/home.dart';

class DetailsProduits extends StatefulWidget {
  const DetailsProduits(
      {super.key,
      required this.name,
      required this.price,
      required this.description,
      required this.imageUrl});
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  @override
  State<DetailsProduits> createState() => _DetailsProduitsState();
}

class _DetailsProduitsState extends State<DetailsProduits> {
  int quantity = 1;
  double somme = 0;
  bool isloading = false;
  @override
  void initState() {
    somme = widget.price;
    super.initState();
  }

  void _handleMinus() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        somme = quantity * widget.price;
      }
    });
  }

  void _handlePlus() {
    setState(() {
      quantity++;
      somme = quantity * widget.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails produit'),
        leading: SizedBox(),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              SizedBox(
                  height: Get.size.height * 0.3,
                  width: Get.size.width * 0.4,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    imageBuilder: (context, imageProvioder) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: imageProvioder, fit: BoxFit.contain),
                        ),
                      );
                    },
                    placeholder: (context, url) => const SizedBox(
                      height: 250,
                      width: 164,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Text(widget.name.toString()),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _handleMinus(),
                  ),
                  SizedBox(width: 10),
                  Text('$quantity'),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _handlePlus(),
                  ),
                ],
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Text("Total :${somme.toString()}"),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Text("price :${widget.price.toString()}"),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              SizedBox(
                  width: Get.size.width * 0.8,
                  child: Text(widget.description.toString())),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              BlocConsumer<CommandeCubit, CommandeState>(
                listener: (context, state) {
                  if (state is CommandeLoading) {
                    isloading = true;
                  } else if (state is CommandeSuccess) {
                    isloading = false;
                    Get.to(Home());
                  } else if (state is CommandeFailure) {
                    Get.snackbar(
                      "error",
                      state.error.toString(),
                      backgroundColor: Colors.red.withOpacity(0.2),
                      snackPosition: SnackPosition.TOP,
                    );
                    isloading = false;
                  }
                },
                builder: (context, state) {
                  return isloading == true
                      ? SizedBox(
                          height: Get.size.height * 0.2,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                    color: Color.fromRGBO(112, 74, 209, 1)),
                              ],
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            context.read<CommandeCubit>().addCommande(
                                widget.name,
                                widget.imageUrl,
                                somme.toString(),
                                quantity.toString(),
                                widget.price.toString());
                          },
                          child: Text("passer une commande "));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
