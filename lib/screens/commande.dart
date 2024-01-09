import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:projet_flutter/cubit/commande_cubit/commande_cubit.dart';
import 'package:projet_flutter/cubit/produit/produit_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projet_flutter/screens/deatils_produit.dart';
import 'package:intl/intl.dart';

class Commande extends StatefulWidget {
  const Commande({super.key});

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  bool isloading = false;
  List<Map<String, dynamic>> commandes = [];
  @override
  void initState() {
    BlocProvider.of<CommandeCubit>(context).getcommande();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Commande'),
        centerTitle: true,
      ),
      body: BlocConsumer<CommandeCubit, CommandeState>(
        listener: (context, state) {
          if (state is GetCommandeLoading) {
            isloading = true;
          } else if (state is GetCommandeSuccess) {
            isloading = false;
            commandes = state.commandes;
          } else if (state is GetCommandeFailure) {
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
                            InkWell(child: Text("Mes commandes")),
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
                              "Tous Les commandes ",
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
                            itemCount: commandes.length,
                            itemBuilder: (context, index) {
                              DateTime dateTime =
                                  commandes[index]['date'].toDate();
                              return Container(
                                width: Get.size.width * 0.9,
                                height: Get.size.height * 0.16,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(246, 246, 246, 1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromRGBO(47, 47, 47, 0.2),
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
                                            imageUrl: commandes[index]
                                                ['imgUrl'],
                                            imageBuilder:
                                                (context, imageProvioder) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                            Text(commandes[index]['product'],
                                                style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        112, 74, 209, 1),
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                SizedBox(
                                                  width: Get.size.width * 0.5,
                                                  child: Text(
                                                    " Date : ${DateFormat('dd/MM/yy hh:mm').format(dateTime)}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  " price : ${commandes[index]['price']} dt"
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  " quantité : ${commandes[index]['quantity']} "
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  " Total : ${commandes[index]['somme']} "
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
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
      ),
    );
  }
}
