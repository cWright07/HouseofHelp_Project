import 'package:flutter/material.dart';

void main() => runApp(const HelpMeFastApp());

// ─── App Root ───────────────────────────────────────────────────────────────

class HelpMeFastApp extends StatelessWidget {
  const HelpMeFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpMeFast',
      theme: _buildTheme(),
      home: const LandingPage(),
    );
  }

  ThemeData _buildTheme() {
    const seedColor = Colors.green;
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      useMaterial3: true,
     cardTheme: CardThemeData(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
),
    );
  }
}

// ─── Landing Page ────────────────────────────────────────────────────────────

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Menu items defined as data, not hardcoded in the build tree
  static const List<_MenuItemData> _menuItems = [
    _MenuItemData(Icons.person_add,  'New Client',     Colors.blue,   'Register a new client'),
    _MenuItemData(Icons.history,     'Recent Visits',  Colors.orange, 'View latest check-ins'),
    _MenuItemData(Icons.inventory,   'Stock Level',    Colors.green,  'Check pantry inventory'),
    _MenuItemData(Icons.assessment,  'Reports',        Colors.purple, 'Generate activity reports'),
  ];

  @override
  void dispose() {
    _searchController.dispose(); // Prevent memory leaks
    super.dispose();
  }

  void _onSearch(String value) => setState(() => _searchQuery = value);

  void _onMenuTap(_MenuItemData item) {
    // TODO(Sprint 2): Navigate to each section
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${item.label}…'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text('HelpMeFast | House of Help'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () {}, // TODO(Sprint 2)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeBanner(searchQuery: _searchQuery),
            const SizedBox(height: 20),
            _SearchBar(
              controller: _searchController,
              onChanged: _onSearch,
            ),
            const SizedBox(height: 30),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _MenuGrid(
                items: _menuItems,
                onTap: _onMenuTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

/// Greeting banner — reacts to live search feedback
class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.searchQuery});
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Volunteer Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Searching for "$searchQuery"',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
      ],
    );
  }
}

/// Extracted search bar — single responsibility
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search clients by name or ID…',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear',
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Extracted grid — easier to unit-test and reuse
class _MenuGrid extends StatelessWidget {
  const _MenuGrid({required this.items, required this.onTap});
  final List<_MenuItemData> items;
  final ValueChanged<_MenuItemData> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _MenuCard(item: items[i], onTap: onTap),
    );
  }
}

/// Individual card — self-contained
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item, required this.onTap});
  final _MenuItemData item;
  final ValueChanged<_MenuItemData> onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => onTap(item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: item.color.withValues(alpha: 0.15),
                child: Icon(item.icon, size: 28, color: item.color),
              ),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

/// Immutable value object — keeps UI and data separate
class _MenuItemData {
  const _MenuItemData(this.icon, this.label, this.color, this.subtitle);
  final IconData icon;
  final String label;
  final Color color;
  final String subtitle;
}