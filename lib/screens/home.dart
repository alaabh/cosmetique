import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:projet_flutter/cubit/login_cubit/login_cubit.dart';
import 'package:projet_flutter/cubit/produit/produit_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projet_flutter/screens/commande.dart';
import 'package:projet_flutter/screens/deatils_produit.dart';
import 'package:projet_flutter/screens/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = false;
  List<Map<String, dynamic>> produits = [];
  @override
  void initState() {
    BlocProvider.of<ProduitCubit>(context).getProduit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Back'),
        leading: SizedBox(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Use your preferred disconnect icon
            onPressed: () {
              BlocProvider.of<LoginCubit>(context).signOut();
              print("Disconnecting...");
            },
          )
        ],
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LogoutLoading) {
            isloading = true;
          } else if (state is LogoutSuccess) {
            isloading = false;
            Get.to(Login());
          } else if (state is LogoutFailure) {
            Get.snackbar(
              "error",
              "Fail",
              backgroundColor: Colors.red.withOpacity(0.2),
              snackPosition: SnackPosition.TOP,
            );
            isloading = false;
          }
        },
        builder: (context, state) {
          return BlocConsumer<ProduitCubit, ProduitState>(
            listener: (context, state) {
              if (state is ProduitLoading) {
                isloading = true;
              } else if (state is ProduitSuccess) {
                isloading = false;
                produits = state.produits;
              } else if (state is ProduitFailure) {
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.size.height * 0.01,
                          ),
                          SizedBox(
                            width: Get.size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Text("Mes commandes"),
                                  onTap: () {
                                    Get.to(Commande());
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Get.size.height * 0.05,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                child: const Text(
                                  "Tous Les produits ",
                                  style: TextStyle(
                                    color: Color.fromRGBO(112, 74, 209, 1),
                                    fontFamily: 'Montserrat',
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.size.height * 0.05,
                          ),
                          SizedBox(
                            height: Get.size.height * 0.75,
                            child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: produits.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: Get.size.width * 0.9,
                                    height: Get.size.height * 0.16,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          246, 246, 246, 1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color: const Color.fromRGBO(
                                            47, 47, 47, 0.2),
                                      ),
                                    ),
                                    child: SizedBox(
                                      width: Get.size.width * 0.8,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 12),
                                          SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: CachedNetworkImage(
                                                imageUrl: produits[index]
                                                    ['imgUrl'],
                                                imageBuilder:
                                                    (context, imageProvioder) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      image: DecorationImage(
                                                          image: imageProvioder,
                                                          fit: BoxFit.contain),
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    const SizedBox(
                                                  height: 250,
                                                  width: 164,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(produits[index]['name'],
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromRGBO(
                                                            112, 74, 209, 1),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 10),
                                                    SizedBox(
                                                      width:
                                                          Get.size.width * 0.5,
                                                      child: Text(
                                                        produits[index]
                                                            ['description'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily:
                                                              'Montserrat',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      " ${produits[index]['price']} dt"
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 250,
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          Get.to(DetailsProduits(
                                                              name: produits[index]
                                                                  ['name'],
                                                              price: double.parse(
                                                                  produits[index]
                                                                          [
                                                                          'price']
                                                                      .toString()),
                                                              description:
                                                                  produits[index]
                                                                      [
                                                                      'description'],
                                                              imageUrl: produits[
                                                                      index]
                                                                  ['imgUrl']));
                                                        },
                                                        child: Container(
                                                          child:
                                                              Text("Voir plus"),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
