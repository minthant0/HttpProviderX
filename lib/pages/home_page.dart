import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:provider_rest_api/providers/network_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final provider = Provider.of<PetsProvider>(context, listen: false);
    provider.getDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? getLoadingUI()
          : provider.error.isNotEmpty
              ? getErrorUI(provider.error)
              : getBodyUI(),
    );
  }

  Widget getLoadingUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SpinKitFadingCircle(
            color: Colors.black,
            size: 80,
          ),
        ],
      ),
    );
  }

  Widget getErrorUI(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 22),
      ),
    );
  }

  Widget getBodyUI() {
    final provider = Provider.of<PetsProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              provider.search(value);
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.black),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, PetsProvider petsProvider, child) =>
                ListView.builder(
              itemCount: petsProvider.serachedPets.data.length,
              itemBuilder: (context, index) => Container(
                height: 120,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 30, backgroundImage: NetworkImage(petsProvider.serachedPets.data[index].petImage), backgroundColor: Colors.blue,),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(petsProvider.serachedPets.data[index].userName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
