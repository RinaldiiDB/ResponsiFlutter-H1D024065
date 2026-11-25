import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSelectLocation(LocationModel location) {
    context.read<WeatherViewModel>().selectLocation(location);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Lokasi',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer2<SearchViewModel, WeatherViewModel>(
        builder: (context, searchVm, weatherVm, child) {
          final hasResults = searchVm.searchResults.isNotEmpty;
          final isQueryNotEmpty = _searchController.text.trim().isNotEmpty;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(fontSize: 14),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      searchVm.searchLocations(value.trim());
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari kota (contoh: Bandung, Tokyo)...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: isQueryNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              searchVm.clearResults();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isQueryNotEmpty && !searchVm.isSearching
                        ? () {
                            _focusNode.unfocus();
                            searchVm.searchLocations(_searchController.text.trim());
                          }
                        : null,
                    icon: searchVm.isSearching
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search_rounded, size: 20),
                    label: Text(
                      searchVm.isSearching ? 'Mencari...' : 'Cari Lokasi',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (searchVm.isSearching) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Mencari kota di Open-Meteo...',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }

                    if (searchVm.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                searchVm.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  searchVm.searchLocations(
                                      _searchController.text.trim());
                                },
                                child: const Text(
                                  'Coba Lagi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (hasResults) {
                      return _buildSearchResults(
                        searchVm.searchResults,
                        weatherVm,
                        isDark,
                      );
                    }

                    if (isQueryNotEmpty &&
                        searchVm.lastQuery.isNotEmpty &&
                        !hasResults) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off_rounded,
                              size: 56,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ditemukan lokasi untuk "${searchVm.lastQuery}"',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Coba periksa ejaan atau cari nama kota lain.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildDefaultView(
                      context,
                      searchVm,
                      weatherVm,
                      isDark,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(
    List<LocationModel> results,
    WeatherViewModel weatherVm,
    bool isDark,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final location = results[index];
        final isFav = weatherVm.favorites.any((loc) =>
            loc.name == location.name &&
            (loc.latitude - location.latitude).abs() < 0.01 &&
            (loc.longitude - location.longitude).abs() < 0.01);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFEFF6FF),
              child: const Icon(
                Icons.location_city_rounded,
                color: Color(0xFF2563EB),
              ),
            ),
            title: Text(
              location.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              '${location.displayName}\nKoordinat: ${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: isFav ? 'Hapus favorit' : 'Simpan favorit',
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.redAccent : null,
              ),
              onPressed: () => weatherVm.toggleFavorite(location),
            ),
            onTap: () => _onSelectLocation(location),
          ),
        );
      },
    );
  }

  Widget _buildDefaultView(
    BuildContext context,
    SearchViewModel searchVm,
    WeatherViewModel weatherVm,
    bool isDark,
  ) {
    final favorites = weatherVm.favorites;
    final history = searchVm.searchHistory;

    if (favorites.isEmpty && history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Ketik nama kota untuk mencari cuaca',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Lokasi favorit dan riwayat pencarian akan tampil di sini.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        if (favorites.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Lokasi Favorit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...favorites.map((fav) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 24,
                  ),
                  title: Text(
                    fav.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    fav.displayName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () => weatherVm.toggleFavorite(fav),
                  ),
                  onTap: () => _onSelectLocation(fav),
                ),
              )),
          const SizedBox(height: 16),
        ],

        if (history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.history_rounded, color: Color(0xFF2563EB), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Riwayat Pencarian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => searchVm.clearHistory(),
                child: const Text(
                  'Hapus Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: history.map((item) {
              return InputChip(
                label: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                avatar: const Icon(Icons.history_rounded, size: 16),
                onDeleted: () => searchVm.removeFromHistory(item),
                onPressed: () {
                  _searchController.text = item;
                  _focusNode.unfocus();
                  searchVm.searchLocations(item);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
