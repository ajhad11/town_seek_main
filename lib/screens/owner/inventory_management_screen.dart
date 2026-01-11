import 'package:flutter/material.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/models/product.dart';
import 'package:town_seek/models/service.dart';
import 'package:town_seek/models/doctor.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/utils/ui_utils.dart';

class InventoryManagementScreen extends StatefulWidget {
  final Business business;
  const InventoryManagementScreen({super.key, required this.business});

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Product> _products = [];
  List<Service> _services = [];
  List<Doctor> _doctors = [];
  
  bool _isLoading = true;
  bool get _isHospital => widget.business.category?.toLowerCase().contains('hospital') ?? false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _isHospital ? 3 : 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final products = await SupabaseService.getProducts(widget.business.id);
      final services = await SupabaseService.getServices(widget.business.id);
      List<Doctor> doctors = [];
      if (_isHospital) {
        doctors = await SupabaseService.getDoctors(widget.business.id);
      }

      if (mounted) {
        setState(() {
          _products = products;
          _services = services;
          _doctors = doctors;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, 'Error loading inventory: $e', isError: true);
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isHospital ? 'Medical Management' : 'Inventory Management'),
        backgroundColor: const Color(0xFF2962FF),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: 'Products'),
            const Tab(text: 'Services'),
            if (_isHospital) const Tab(text: 'Doctors'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2962FF),
        onPressed: () => _showAddItemSheet(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [
              _buildProductList(),
              _buildServiceList(),
              if (_isHospital) _buildDoctorList(),
            ],
          ),
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) return _buildEmptyState('No items found');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          child: ListTile(
            leading: product.imageUrl != null 
              ? Image.network(product.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.shopping_bag, size: 40),
            title: Text(product.name),
            subtitle: Text('\$${product.price} • Stock: ${product.stockQuantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: product.isAvailable,
                  onChanged: (val) => _toggleProductAvailability(product, val),
                ),
                PopupMenuButton(
                  onSelected: (val) {
                    if (val == 'edit') _showProductDialog(product: product);
                    if (val == 'delete') _deleteProduct(product.id);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceList() {
    if (_services.isEmpty) return _buildEmptyState('No services found');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.design_services, size: 40, color: Colors.blue),
            title: Text(service.name),
            subtitle: Text('\$${service.price} • ${service.durationMinutes} min'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: service.isAvailable, 
                  onChanged: (val) => _toggleServiceAvailability(service, val)
                ),
                PopupMenuButton(
                  onSelected: (val) {
                     if (val == 'edit') _showServiceDialog(service: service);
                     if (val == 'delete') _deleteService(service.id);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorList() {
    if (_doctors.isEmpty) return _buildEmptyState('No doctors found');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _doctors.length,
      itemBuilder: (context, index) {
        final doctor = _doctors[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(doctor.name),
            subtitle: Text(doctor.specialization),
            trailing: PopupMenuButton(
              onSelected: (val) {
                 if (val == 'edit') _showDoctorDialog(doctor: doctor);
                 if (val == 'delete') _deleteDoctor(doctor.id);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- CRUD Operations ---

  void _showAddItemSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: const Icon(Icons.shopping_bag), title: const Text('Add Product'), onTap: () { Navigator.pop(context); _showProductDialog(); }),
          ListTile(leading: const Icon(Icons.design_services), title: const Text('Add Service'), onTap: () { Navigator.pop(context); _showServiceDialog(); }),
          if (_isHospital)
            ListTile(leading: const Icon(Icons.person_add), title: const Text('Add Doctor'), onTap: () { Navigator.pop(context); _showDoctorDialog(); }),
        ],
      ),
    );
  }

  void _showProductDialog({Product? product}) {
    final nameCtrl = TextEditingController(text: product?.name);
    final priceCtrl = TextEditingController(text: product?.price.toString());
    final stockCtrl = TextEditingController(text: product?.stockQuantity.toString() ?? '0');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final newProduct = Product(
                  id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  businessId: widget.business.id,
                  name: nameCtrl.text,
                  price: double.tryParse(priceCtrl.text) ?? 0.0,
                  stockQuantity: int.tryParse(stockCtrl.text) ?? 0,
                  description: product?.description ?? '',
                  imageUrl: product?.imageUrl,
                  category: product?.category ?? 'General',
                  isAvailable: product?.isAvailable ?? true,
                  createdAt: product?.createdAt ?? DateTime.now(),
                );
                
                if (product == null) {
                  await SupabaseService.addProduct(newProduct);
                } else {
                  await SupabaseService.updateProduct(newProduct);
                }
                _loadData(); // This is async fire-and-forget
                if (context.mounted) Navigator.pop(context); // Use context.mounted
              } catch (e) {
                // error
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleProductAvailability(Product product, bool val) async {
    final updated = Product(
      id: product.id, businessId: product.businessId, name: product.name,
      description: product.description, price: product.price,
      imageUrl: product.imageUrl, category: product.category, stockQuantity: product.stockQuantity,
      isAvailable: val, createdAt: product.createdAt
    );
    await SupabaseService.updateProduct(updated);
    _loadData();
  }

  Future<void> _deleteProduct(String id) async {
    await SupabaseService.deleteProduct(id);
    _loadData();
  }

  void _showServiceDialog({Service? service}) {
    final nameCtrl = TextEditingController(text: service?.name);
    final priceCtrl = TextEditingController(text: service?.price.toString());
    final durationCtrl = TextEditingController(text: service?.durationMinutes.toString());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(service == null ? 'Add Service' : 'Edit Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: durationCtrl, decoration: const InputDecoration(labelText: 'Duration (min)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
               final newService = Service(
                 id: service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                 businessId: widget.business.id,
                 name: nameCtrl.text,
                 price: double.tryParse(priceCtrl.text) ?? 0.0,
                 durationMinutes: int.tryParse(durationCtrl.text) ?? 30,
                 description: service?.description ?? '',
                 imageUrl: service?.imageUrl,
                 isAvailable: service?.isAvailable ?? true,
                 createdAt: service?.createdAt ?? DateTime.now(),
               );
               if (service == null) {
                 await SupabaseService.addService(newService);
               } else {
                 await SupabaseService.updateService(newService);
               }
               _loadData();
               if(dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleServiceAvailability(Service service, bool val) async {
      final updated = Service(
        id: service.id, businessId: service.businessId, name: service.name, description: service.description,
        price: service.price, durationMinutes: service.durationMinutes, imageUrl: service.imageUrl,
        isAvailable: val, createdAt: service.createdAt
      );
      await SupabaseService.updateService(updated);
      _loadData();
  }

  Future<void> _deleteService(String id) async {
    await SupabaseService.deleteService(id);
    _loadData();
  }

  Future<void> _deleteDoctor(String id) async {
    await SupabaseService.deleteDoctor(id);
    _loadData();
  }

  void _showDoctorDialog({Doctor? doctor}) {
    final nameCtrl = TextEditingController(text: doctor?.name);
    final specCtrl = TextEditingController(text: doctor?.specialization);
    final hoursCtrl = TextEditingController(text: doctor?.availability?['hours']);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(doctor == null ? 'Add Doctor' : 'Edit Doctor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: specCtrl, decoration: const InputDecoration(labelText: 'Specialization')),
            TextField(controller: hoursCtrl, decoration: const InputDecoration(labelText: 'Hours')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newDoctor = Doctor(
                id: doctor?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                hospitalId: widget.business.id,
                name: nameCtrl.text,
                specialization: specCtrl.text,
                availability: {'hours': hoursCtrl.text},
                createdAt: doctor?.createdAt ?? DateTime.now(),
              );
              await SupabaseService.addDoctor(newDoctor);
              _loadData();
              if(dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text(msg, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
