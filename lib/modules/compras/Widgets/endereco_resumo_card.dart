import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:flutter/material.dart';

class EnderecoResumoCard extends StatelessWidget {
  final EnderecoModel endereco;

  const EnderecoResumoCard({
    super.key,
    required this.endereco,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  endereco.rua,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${endereco.numero}${endereco.complemento.isNotEmpty ? ' - ${endereco.complemento}' : ''}',
                ),
                Text('${endereco.bairro}'),
                Text('${endereco.cidade} - ${endereco.uf}'),
                Text('CEP: ${endereco.cep}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
