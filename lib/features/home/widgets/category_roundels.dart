import 'package:flutter/material.dart';

class CategoryRoundels extends StatelessWidget {
  CategoryRoundels({super.key});

  final lista_categorias = [
    {'nome': 'Eletrônico', 'filtro': "Eletronico", 'icone': Icons.devices},
    {'nome': 'Moda', 'filtro': "Moda", 'icone': Icons.checkroom},
    {'nome': 'Casa', 'filtro': "Casa", 'icone': Icons.home_work},
    {'nome': 'Esporte', 'filtro': "Esporte", 'icone': Icons.sports},
    {'nome': 'Beleza', 'filtro': "Beleza", 'icone': Icons.face},
    {'nome': 'Acessórios', 'filtro': "Acessorios", 'icone': Icons.watch},
    {'nome': 'Games', 'filtro': "Games", 'icone': Icons.sports_esports},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Pesquise por categoria",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lista_categorias.length,
            itemBuilder: (context, index) {
              final categoria = lista_categorias[index];
              final nomeCategoria = categoria['nome']!;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    // TODO: implementar navegação com filtro de categoria.
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(categoria['icone'] as IconData?),
                      ),
                      SizedBox(height: 8),
                      Text(
                        nomeCategoria.toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
