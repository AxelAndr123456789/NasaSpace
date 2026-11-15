import 'package:flutter/material.dart';

import 'atenciones_page.dart';
import 'historial_page.dart';
import 'inicio_page.dart';
import 'perfil_page.dart';

/// Shell principal: muestra las 4 secciones en la barra inferior.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const List<String> _titulos = [
    'En vivo',
    'Atenciones',
    'Historial',
    'Perfil',
  ];

  static const List<IconData> _iconos = [
    Icons.home_rounded,
    Icons.support_agent_rounded,
    Icons.history_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                'lib/images/aura.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(_titulos[_currentIndex]),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          InicioPage(),
          AtencionesPage(),
          HistorialPage(),
          PerfilPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          for (int i = 0; i < _titulos.length; i++)
            NavigationDestination(
              icon: Icon(_iconos[i]),
              selectedIcon: Icon(_iconos[i]),
              label: _titulos[i],
            ),
        ],
      ),
    );
  }
}
