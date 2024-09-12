// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<dynamic> dataList = [];

  List<dynamic> users = ['']; //criando uma lista para colocar os dados do http

  // método assíncrono para consumir informações de uma api
  Future<void> fetchData() async {
    // realiza a requisição
    final response =
        await http.get(Uri.parse('http://demo6189819.mockable.io/data'));

    // verifica êxito da requisição
    if (response.statusCode == 200) {
      // converte resposta em objeto json
      final jsonResponse = json.decode(response.body);
      // atualiza state
      setState(() {
        dataList = jsonResponse['data'];
      });
    } else {
      // erro na requisição
      print('Request failed with status: ${response.statusCode}.');
    }

    final responseUsuario =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (responseUsuario.statusCode == 200) {
      // converte resposta em objeto json
      // atualiza state
      setState(() {
        users = jsonDecode(responseUsuario.body);
      });

      //confirmando que está recebendo as informações corretamente
      users.forEach((user) {
        print('Name: ${user['name']}');
        print('Email: ${user['email']}');
        print('Company: ${user['company']['name']}');
        print('City: ${user['address']['city']}');
        print('Geo Lat: ${user['address']['geo']['lat']}');
        print('---');
      });
    } else {
      // erro na requisição
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('API Response Demo'),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            final item = users[index]; //deixando item como um usuario da lista 

            return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: item['id'] % 2 == 0 // trocar cor do fundo baseado no id do usuario
                      ? const Color.fromARGB(61, 119, 119, 236)
                      : const Color.fromARGB(
                          47, 34, 34, 34), // Cor de fundo do retângulo
                  borderRadius: BorderRadius.circular(10.0), // Raio
                ),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${item['name']}', //mostrando o nome do usuario como um título para cada item
                      style: TextStyle(color: Colors.black, fontSize: 26),
                    ),
                  ),
                  subtitle: DefaultTextStyle(
                    style:
                        TextStyle(color: const Color.fromARGB(255, 60, 60, 61)),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Row(// usando um Row para separar os itens em 2 grupos esquerda e direita
                            children: [
                              const Icon(
                                Icons.badge_outlined,
                                size: 100,
                              ),
                              Flexible( //usando flexible para não ter overflow em telas pequenas
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, //usando o clomun para deixar o texto um em baixo do outro começando pela esquerda
                                      children: [
                                    Text(
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        "Personal"),  //usando decorações para fazer um subtitulo dentro da lista
                                    Text('Username: ${item['username']}'),
                                    Text('Email: ${item['email']}'),
                                    Text('Phone: ${item['phone']}'),
                                    Text('Site: ${item['website']}'),
                                  ]))
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cottage_outlined,
                                size: 100,
                              ),
                              Flexible(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        "Adress"),
                                    Text(
                                        'Street: ${item['address']['street']}'),
                                    Text('Suite: ${item['address']['suite']}'),
                                    Text('City: ${item['address']['city']}'),
                                    Text(
                                        'Zipcode: ${item['address']['zipcode']}'),
                                    Text(
                                        'Coordinate: Lat: ${item['address']['geo']['lat']} | Lon: ${item['address']['geo']['lng']}'),
                                  ]))
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.apartment_outlined,
                                size: 100,
                              ),
                              Flexible(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(''),
                                    Text(
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        "Company"),
                                    Text('Nome: ${item['company']['name']}'),
                                    Text(
                                      'CatchPhrase: ${item['company']['catchPhrase']}',
                                      
                                    ),
                                    Text(
                                      'BS: ${item['company']['bs']}',
                                      
                                    )
                                  ]))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
