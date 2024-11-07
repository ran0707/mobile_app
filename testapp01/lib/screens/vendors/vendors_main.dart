import 'package:flutter/material.dart';

class Vendor {
  final String name;
  final String imageUrl;
  final String description;
  final double rating;

  Vendor({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });
}

class VendorMain extends StatefulWidget {
  final List<Vendor> vendors;

  const VendorMain({super.key, required this.vendors});

  @override
  State<VendorMain> createState() => _VendorMainState();
}

class _VendorMainState extends State<VendorMain> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Trigger a rebuild when the search text changes
    });
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
        automaticallyImplyLeading: false,
        title: !_isSearching
            ? const Text('Green shop')
            : TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search..',
            fillColor: Color(0xffe0e0e0),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              borderSide: BorderSide.none,
            ),
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xff8e8e8e),
            ),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSearching
            ? _buildSearchResults(widget.vendors)
            : _buildVendorList(widget.vendors),
      ),
    );
  }

  Widget _buildVendorList(List<Vendor> vendors) {
    return ListView.builder(
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return _VendorCard(vendor: vendor);
      },
    );
  }

  Widget _buildSearchResults(List<Vendor> vendors) {
    final searchText = _searchController.text.toLowerCase();
    final filteredVendors = vendors.where((vendor) {
      return vendor.name.toLowerCase().contains(searchText) ||
          vendor.description.toLowerCase().contains(searchText);
    }).toList();

    return filteredVendors.isEmpty
        ? const Center(child: Text('No result found'))
        : _buildVendorList(filteredVendors);
  }
}

class _VendorCard extends StatelessWidget {
  final Vendor vendor;

  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: const Color(0xffd7ecfd),
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    vendor.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50.0,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16.0), // Space between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.name,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      vendor.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0, color: Color(0xff434242)),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[400],
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          vendor.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
