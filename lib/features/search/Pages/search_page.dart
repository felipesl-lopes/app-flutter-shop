import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  void _searchProduct() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    print(query);
    FocusScope.of(context).unfocus();
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final query = ModalRoute.of(context)?.settings.arguments as String?;

      if (query != null && query.isNotEmpty) {
        _searchController.text = query;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: false,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "Buscar produto",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              onPressed: _searchProduct,
              icon: Icon(Icons.search),
            ),
          ),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.tune,
                color: Colors.white,
              )),
        ],
      ),
      body: _searchController.text.isNotEmpty
          ? Text(
              "Exibindo resultado de pesquisa para: ${_searchController.text.toString()}",
            )
          : Column(
              children: [
                // TODO: caso não haja um filtro, exibir uma lista padrão de produtos.
                // ProductGrid(
                //   list_products: visibleProducts,
                //   quantityGrid: 6,
                //   title: "Produtos para você",
                // ),
              ],
            ),
    );
  }
}
