import 'package:flutter/material.dart';
import 'package:news_flash/data/getIt/init_get_it.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool temaEscuro = false;
  bool notificacoesAtivadas = true;
  List<String> categorias = [
    'Tecnologia',
    'Esportes',
    'Saúde',
    'Negócios',
    'Entretenimento',
  ];
  List<String> categoriasSelecionadas = ['Tecnologia', 'Esportes'];
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: temaEscuro ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: temaEscuro ? Colors.blue[800] : Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor:
                    temaEscuro ? Colors.blue[300] : Colors.blue[100],
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=8',
                  ),
                ),
              ),

              SizedBox(height: 16),

              Text(
                'Nome do Usuário',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: temaEscuro ? Colors.white : Colors.black87,
                ),
              ),

              SizedBox(height: 4),

              Text(
                'usuario@email.com',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: temaEscuro ? Colors.grey[400] : Colors.grey[700],
                ),
              ),

              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileActionButton(
                    icon: Icons.edit,
                    label: 'Editar Perfil',
                    onTap: () {},
                    color: Colors.blueAccent,
                    temaEscuro: temaEscuro,
                  ),
                  _ProfileActionButton(
                    icon: Icons.lock,
                    label: 'Alterar Senha',
                    onTap: () {},
                    color: Colors.blueAccent,
                    temaEscuro: temaEscuro,
                  ),
                ],
              ),

              SizedBox(height: 32),

        

              _buildSectionTitle('Preferências de Notícias'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    categorias.map((categoria) {
                      final selecionado = categoriasSelecionadas.contains(
                        categoria,
                      );
                      return FilterChip(
                        label: Text(categoria),
                        selected: selecionado,
                        selectedColor: Colors.blueAccent.shade200,
                        showCheckmark: true,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              categoriasSelecionadas.add(categoria);
                            } else {
                              categoriasSelecionadas.remove(categoria);
                            }
                          });
                        },
                        backgroundColor:
                            temaEscuro ? Colors.grey[800] : Colors.grey[200],
                        labelStyle: TextStyle(
                          color:
                              selecionado
                                  ? Colors.white
                                  : (temaEscuro
                                      ? Colors.grey[300]
                                      : Colors.black87),
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
              ),

              SizedBox(height: 32),

              _buildSectionTitle('Configurações de Notificações'),
              SwitchListTile.adaptive(
                title: Text('Ativar Notificações'),
                value: notificacoesAtivadas,
                activeColor: Colors.blueAccent,
                onChanged: (val) {
                  setState(() {
                    notificacoesAtivadas = val;
                  });
                },
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Sair da Conta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // lógica para logout
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool temaEscuro;

  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.temaEscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: temaEscuro ? Colors.blue[300] : color,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
