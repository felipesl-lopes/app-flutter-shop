import 'package:flutter/material.dart';

class CategoriaIconHelper {
  static IconData getIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'eletrônico':
        return Icons.devices;
      case 'moda':
        return Icons.checkroom;
      case 'casa':
        return Icons.home_work;
      case 'esporte':
        return Icons.sports;
      case 'beleza':
        return Icons.face;
      case 'acessórios':
        return Icons.watch;
      case 'games':
        return Icons.sports_esports;
      case 'jogos':
        return Icons.videogame_asset;
      case 'informática':
        return Icons.computer;
      case 'celulares':
        return Icons.mobile_screen_share;
      case 'eletrodomésticos':
        return Icons.kitchen;
      case 'móveis':
        return Icons.chair;
      case 'automotivo':
        return Icons.car_repair;
      case 'saúde':
        return Icons.heart_broken;
      default:
        return Icons.category;
    }
  }
}
