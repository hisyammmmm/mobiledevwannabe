import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/site_model.dart';

class SitusRekomendasiPage extends StatefulWidget {
  const SitusRekomendasiPage({super.key});

  @override
  State<SitusRekomendasiPage> createState() => _SitusRekomendasiPageState();
}

class _SitusRekomendasiPageState extends State<SitusRekomendasiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SiteModel> allSites = List.from(siteRecommendations);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void toggleFavorite(SiteModel site) {
    setState(() {
      site.toggleFavorite();
    });
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka $url')),
      );
    }
  }

  Widget buildSiteCard(SiteModel site) {
    // Warna tema Mocha Cream
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige
    const Color cardColor = Color(0xFFFFFFFF); // White for card
    const Color iconColor = Color(0xFFA47148); // Mocha for icons

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: cardColor,
      child: ListTile(
        leading: Image.network(
          site.imageUrl,
          width: 40,
          height: 40,
          errorBuilder: (_, __, ___) => const Icon(Icons.language),
        ),
        title: Text(
          site.name,
          style: TextStyle(color: iconColor),
        ),
        subtitle: Text(site.url),
        trailing: IconButton(
          icon: Icon(
            site.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: site.isFavorite ? Colors.red : iconColor,
          ),
          onPressed: () => toggleFavorite(site),
        ),
        onTap: () => _launchURL(site.url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSites = allSites.where((site) => site.isFavorite).toList();

    // Warna tema Mocha Cream
    const Color appBarColor = Color(0xFFA47148); // Mocha for AppBar
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige for background

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Situs Rekomendasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.language), text: 'Semua'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorit'),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            children: allSites.map(buildSiteCard).toList(),
          ),
          favoriteSites.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Belum ada situs favorit.'),
            ),
          )
              : ListView(
            children: favoriteSites.map(buildSiteCard).toList(),
          ),
        ],
      ),
    );
  }
}
